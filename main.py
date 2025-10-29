# main.py
from typing import List, Dict
from fastmcp import FastMCP
from pydantic import BaseModel
from database.connection import describe_db, execute_sql, get_engine


# ------------------------
# 🔹 MODELO DE ENTRADA FLEXIBLE
# ------------------------
class ExecuteQueryInput(BaseModel):
    query: str

    class Config:
        # Ignora cualquier campo adicional que mande n8n (toolCallId, tool, etc.)
        extra = "ignore"


# ------------------------
# 🔹 CONFIGURACIÓN DEL SERVIDOR MCP
# ------------------------
mcp = FastMCP(
    "DBAgentServer",
    version="0.1.0",
)


# ------------------------
# 🔹 TOOLS
# ------------------------
@mcp.tool
def execute_query(input: ExecuteQueryInput | str | dict) -> list[dict]:
    """
    Ejecuta un query SQL y retorna los resultados en formato lista de diccionarios.
    Tolera entradas tipo string, dict o modelo Pydantic.
    """
    # 🧩 Normaliza el input
    if isinstance(input, str):
        query = input
    elif isinstance(input, dict):
        query = input.get("query", "")
    else:
        query = input.query

    print("**" * 25)
    print("Consulta recibida:", query)
    print("Tipo:", type(input))
    print("**" * 25)

    # Validación básica
    lowered = query.strip().lower()
    if any(keyword in lowered for keyword in ["drop", "delete", "update", "insert", "alter", "truncate"]):
        return [{"error": "Solo se permiten consultas SELECT seguras"}]

    try:
        return execute_sql(query)
    except Exception as e:
        return [{"error": str(e)}]


@mcp.tool
def describe_tables() -> Dict:
    """
    Devuelve la estructura de la base de datos (tablas y columnas).
    """
    print("--" * 25)
    print("describe_tables invocado")
    print("--" * 25)
    return describe_db()


@mcp.tool
def health_check() -> Dict[str, object]:
    """
    Verifica que el servidor esté corriendo correctamente.
    """
    print("*-" * 25)
    print("health_check invocado")
    print("*-" * 25)
    return {"status": "ok", "message": "MCP server activo"}


# ------------------------
# 🔹 START
# ------------------------
if __name__ == "__main__":
    engine = get_engine()
    print("✅ Conectado a la base de datos:", engine.url)
    mcp.run()
