# main.py
from fastmcp import FastMCP
from database.connection import describe_db, execute_sql, get_engine
from tools.execute_query import ExecuteQueryRequest

# Crea el servidor FastMCP
app = FastMCP("DBAgentServer", version="0.1.0")

# Registra las tools

@app.tool
def execute_query(execute: ExecuteQueryRequest) -> list[dict]:
# def execute_query(request: ExecuteQueryRequest) -> list[dict]:
    """
    Ejecuta un query SQL y retorna los resultados en formato lista de diccionarios.
    Usa con precaución: solo acepta SELECTs u operaciones seguras.
    """
    # Seguridad básica para evitar operaciones destructivas
    lowered = execute.query.strip().lower()
    if any(keyword in lowered for keyword in ["drop", "delete", "update", "insert", "alter"]):
        return [{"error": "Solo se permiten consultas SELECT seguras"}]

    return execute_sql(execute.query)

@app.tool
def describe_tables() -> dict:
    """Devuelve la estructura de la base de datos (tablas y columnas)"""
    return describe_db()

@app.tool
def health_check() -> dict:
    """Verifica que el servidor esté corriendo correctamente."""
    return {"status": "ok", "message": "MCP server activo"}

if __name__ == "__main__":
    engine = get_engine()
    print("✅ Conectado a la base de datos:", engine.url)
    app.run()
