# database/connection.py
from sqlalchemy import create_engine, inspect, text
#  host="190.146.2.119",
#     port="5432",
#     database="knowledge_db",
#     user="founders",
#     password="f0und3rs-*-"
# 🔧 Ajusta tu cadena de conexión
DB_URL = "postgresql+psycopg2://founders:f0und3rs-*-@192.168.0.104:5432/knowledge_db"

_engine = None

def get_engine():
    global _engine
    if _engine is None:
        _engine = create_engine(DB_URL)
    return _engine

def describe_db():
    engine = get_engine()
    inspector = inspect(engine)
    schema = {}
    for table in inspector.get_table_names():
        columns = inspector.get_columns(table)
        schema[table] = [col["name"] for col in columns]
    return schema

def execute_sql(query: str):
    engine = get_engine()
    with engine.connect() as conn:
        result = conn.execute(text(query))
        rows = [dict(row._mapping) for row in result]
    return rows
