# Dockerfile para MCP Server
FROM python:3.13-slim

# Instalar dependencias del sistema necesarias para PostgreSQL
RUN apt-get update && apt-get install -y \
    libpq-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Establecer directorio de trabajo
WORKDIR /app

# Copiar archivos de dependencias
COPY requirements.txt .
COPY pyproject.toml .

# Instalar dependencias de Python
RUN pip install --no-cache-dir -r requirements.txt

# Copiar el código fuente
COPY . .

# Exponer puerto (FastMCP suele usar puerto 8000 por defecto)
EXPOSE 80

# Comando para ejecutar la aplicación
CMD ["fastmcp", "run", "main.py"]