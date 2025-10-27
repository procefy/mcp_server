# tools/health_check.py
from fastmcp import tool

def health_check() -> dict:
    """Verifica que el servidor esté corriendo correctamente."""
    return {"status": "ok", "message": "MCP server activo"}
