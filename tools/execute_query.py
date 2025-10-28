# tools/execute_query.py
from pydantic import BaseModel, ConfigDict
from database.connection import execute_sql

class ExecuteQueryRequest(BaseModel):
    query: str
    model_config = ConfigDict(extra="ignore")



def execute_query(request: ExecuteQueryRequest) -> list[dict]:
    """
    Ejecuta un query SQL y retorna los resultados en formato lista de diccionarios.
    Usa con precaución: solo acepta SELECTs u operaciones seguras.
    """
    # Seguridad básica para evitar operaciones destructivas
    lowered = request.query.strip().lower()
    if any(keyword in lowered for keyword in ["drop", "delete", "update", "insert", "alter"]):
        return [{"error": "Solo se permiten consultas SELECT seguras"}]
    
    return execute_sql(request.query)
