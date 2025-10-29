# main.py
from fastmcp import FastMCP
from models.execute_query_input import ExecuteQueryInput
from database.connection import describe_db, execute_sql, get_engine
# from tools.execute_query import ExecuteQueryRequest

# Crea el servidor FastMCP
mcp = FastMCP("DBAgentServer", version="0.1.0")

# Registra las tools

@mcp.tool
def execute_query(execute: dict) -> list[dict]:
    """
    Ejecuta un query SQL y retorna los resultados en formato lista de diccionarios.
    Usa con precaución: solo acepta SELECTs u operaciones seguras.
    """
    print("**" * 25)
    print("Datos recibidos:", execute.query)
    print("Datos recibidos:", type(execute.query))
    print("**" * 25)
    # Seguridad básica para evitar operaciones destructivas
    lowered = execute.query.strip().lower()
    if any(keyword in lowered for keyword in ["drop", "delete", "update", "insert", "alter"]):
        return [{"error": "Solo se permiten consultas SELECT seguras"}]

@mcp.tool
def describe_tables() -> dict:
    """Devuelve la estructura de la base de datos (tablas y columnas)"""
    print("--" * 25)
    print("Datos recibidos:")
    print("Datos recibidos:")
    print("--" * 25)
    return describe_db()

@mcp.tool
def health_check() -> dict:
    """Verifica que el servidor esté corriendo correctamente."""
    print("*-" * 25)
    print("*-" * 25)
    return {"status": "ok", "message": "MCP server activo"}

if __name__ == "__main__":
    engine = get_engine()
    print("✅ Conectado a la base de datos:", engine.url)
    mcp.run()
