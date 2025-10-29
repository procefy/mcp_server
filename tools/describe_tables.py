# tools/describe_tables.py
from typing import Dict
from fastmcp import tool
from database.connection import describe_db

def describe_tables() -> Dict:
    """Devuelve la estructura de la base de datos (tablas y columnas)"""
    return describe_db()
