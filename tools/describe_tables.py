# tools/describe_tables.py
from fastmcp import tool
from database.connection import describe_db

def describe_tables() -> dict:
    """Devuelve la estructura de la base de datos (tablas y columnas)"""
    return describe_db()
