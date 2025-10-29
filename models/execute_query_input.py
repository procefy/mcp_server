from pydantic import BaseModel, Extra

class ExecuteQueryInput(BaseModel, extra=Extra.ignore):
    query: str