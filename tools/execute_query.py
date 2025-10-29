# tools/execute_query.py
from database.connection import execute_sql
# from database.connection import execute_sql




def execute_query(query: str) -> list[dict]:
    """
    Ejecuta un query SQL y retorna los resultados en formato lista de diccionarios.
    Usa con precaución: solo acepta SELECTs u operaciones seguras.
    """
    # Seguridad básica para evitar operaciones destructivas
    lowered = query.strip().lower()
    if any(keyword in lowered for keyword in ["drop", "delete", "update", "insert", "alter"]):
        return [{"error": "Solo se permiten consultas SELECT seguras"}]
    
    return execute_sql(query)
