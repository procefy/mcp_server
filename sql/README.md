# Scripts SQL para Base de Datos de Predios

Esta carpeta contiene todos los scripts SQL organizados y optimizados para la gestión de la base de datos de predios del sistema catastral.

## 📁 Estructura de Archivos

### 1. **01_create_table_ilc_predio.sql**
- **Propósito**: Creación de la tabla `ilc_predio` con todas sus columnas, índices y restricciones
- **Incluye**: 
  - Definición completa de la tabla
  - Índices optimizados para consultas comunes
  - Comentarios de documentación
  - Restricciones de integridad
- **Ejecutar**: Primero, antes que cualquier otro script

### 2. **02_insert_data_ilc_predio_lote1.sql**
- **Propósito**: Inserción de datos de prueba (primer lote)
- **Contenido**: 10 registros de ejemplo
- **Uso**: Para pruebas y desarrollo

### 3. **03_consultas_utiles_ilc_predio.sql**
- **Propósito**: Colección de consultas útiles y reportes
- **Incluye**:
  - Consultas básicas de información
  - Análisis por clasificación
  - Estadísticas de áreas
  - Consultas por ubicación
  - Búsquedas específicas
  - Validaciones de datos
  - Consultas avanzadas
  - Reportes ejecutivos

### 4. **04_insert_all_data_ilc_predio.sql**
- **Propósito**: Inserción masiva de todos los datos
- **Contenido**: 300+ registros completos de predios
- **Uso**: Para ambiente de producción

### 5. **05_utilidades_mantenimiento.sql**
- **Propósito**: Funciones, vistas y procedimientos de utilidad
- **Incluye**:
  - Funciones de estadísticas
  - Vistas especializadas
  - Procedimientos de mantenimiento
  - Scripts de backup
  - Validaciones de integridad

## 🚀 Orden de Ejecución

### Para un entorno nuevo:
```sql
-- 1. Crear la tabla
\i sql/01_create_table_ilc_predio.sql

-- 2. Insertar todos los datos
\i sql/04_insert_all_data_ilc_predio.sql

-- 3. Crear utilidades y mantenimiento
\i sql/05_utilidades_mantenimiento.sql
```

### Para desarrollo y pruebas:
```sql
-- 1. Crear la tabla
\i sql/01_create_table_ilc_predio.sql

-- 2. Insertar datos de prueba
\i sql/02_insert_data_ilc_predio_lote1.sql

-- 3. Crear utilidades
\i sql/05_utilidades_mantenimiento.sql
```

## 📊 Funciones Útiles Disponibles

Una vez ejecutados los scripts, tendrás acceso a:

### Funciones:
- `get_predio_stats()` - Estadísticas rápidas
- `buscar_predio_por_matricula(varchar)` - Búsqueda por matrícula
- `validar_integridad_predios()` - Validación de datos
- `crear_backup_predios()` - Crear respaldo
- `limpiar_datos_inconsistentes()` - Limpieza de datos

### Vistas:
- `v_predios_habitacionales` - Solo predios habitacionales
- `v_resumen_municipio` - Resumen por municipio

## 🔍 Consultas de Ejemplo

```sql
-- Ver estadísticas generales
SELECT * FROM get_predio_stats();

-- Buscar un predio específico
SELECT * FROM buscar_predio_por_matricula('100591');

-- Ver predios habitacionales grandes
SELECT * FROM v_predios_habitacionales 
WHERE tamaño_predio = 'Grande' 
LIMIT 10;

-- Resumen por municipio
SELECT * FROM v_resumen_municipio;

-- Top 10 predios más grandes
SELECT matricula_inmobiliaria, area_registral_m2 
FROM ilc_predio 
WHERE area_registral_m2 > 0 
ORDER BY area_registral_m2 DESC 
LIMIT 10;
```

## 🛠️ Mantenimiento

### Optimización:
```sql
-- Reindexar para mejor rendimiento
REINDEX TABLE ilc_predio;

-- Actualizar estadísticas
ANALYZE ilc_predio;
```

### Backup:
```sql
-- Crear respaldo automático
SELECT crear_backup_predios();
```

### Validación:
```sql
-- Verificar integridad de datos
SELECT * FROM validar_integridad_predios();
```

## 📋 Esquema de la Tabla

La tabla `ilc_predio` contiene los siguientes campos principales:

- **objectid**: Identificador único
- **matricula_inmobiliaria**: Número de matrícula
- **numero_predial_nacional**: Código predial nacional
- **area_registral_m2**: Área en metros cuadrados
- **tipo**: Tipo de predio (Privado, Público, etc.)
- **condicion_predio**: Condición (NPH, PH_Unidad_Predial, Via, etc.)
- **destinacion_economica**: Destinación económica
- **municipio**: Código del municipio
- **shape**: Geometría espacial

## 💡 Consejos de Uso

1. **Siempre ejecuta las consultas de validación** después de insertar datos
2. **Usa las vistas** para consultas comunes en lugar de escribir SQL complejo
3. **Crea backups regulares** usando la función `crear_backup_predios()`
4. **Consulta las estadísticas** regularmente con `get_predio_stats()`
5. **Usa los índices** para optimizar tus consultas personalizadas

## 🔧 Configuración del MCP Server

Estos scripts están diseñados para trabajar con el servidor MCP. La configuración de conexión está en `database/connection.py`:

```python
DB_URL = "postgresql+psycopg2://admin:admin@localhost:5432/predios"
```

## ⚠️ Notas Importantes

- Los scripts están optimizados para PostgreSQL
- Algunos datos geoespaciales están en formato POINT
- Las áreas están en metros cuadrados
- Los GUIDs siguen el formato estándar
- Los índices están optimizados para consultas comunes

## 🆘 Resolución de Problemas

Si encuentras errores:

1. Verifica que PostgreSQL esté ejecutándose
2. Confirma que tienes permisos de creación de tablas
3. Revisa que la base de datos 'predios' exista
4. Ejecuta los scripts en el orden correcto
5. Consulta los logs de PostgreSQL para errores específicos