# tools/health_check.py
from typing import Dict
from fastmcp import tool

def health_check() -> Dict:
    """Verifica que el servidor esté corriendo correctamente."""
    return {"status": "ok", "message": "MCP server activo"}
