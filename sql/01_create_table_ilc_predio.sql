-- ==================================================
-- SCRIPT DE CREACIÓN DE TABLA: ilc_predio
-- Base de datos: predios
-- Descripción: Tabla de predios del sistema catastral
-- ==================================================

-- Eliminar tabla si existe (opcional - descomenta si necesitas recrear)
-- DROP TABLE IF EXISTS ilc_predio CASCADE;

-- Crear tabla ilc_predio
CREATE TABLE ilc_predio (
    -- Campos principales
    objectid INTEGER NOT NULL,
    id_operacion VARCHAR(255),
    codigo_orip VARCHAR(255),
    matricula_inmobiliaria VARCHAR(255),
    
    -- Campos de área y medidas
    area_catastral_terreno NUMERIC(38, 8),
    area_registral_m2 NUMERIC(38, 8),
    coeficiente NUMERIC(38, 8),
    area_coeficiente NUMERIC(38, 8),
    
    -- Identificadores y códigos
    numero_predial_nacional VARCHAR(30),
    municipio VARCHAR(5),
    
    -- Clasificaciones
    tipo VARCHAR(255),
    condicion_predio VARCHAR(255),
    destinacion_economica VARCHAR(255),
    tipo_referencia_fmi_antiguo VARCHAR(255),
    
    -- Referencias
    referencia_registral VARCHAR(255),
    
    -- Identificadores únicos
    globalid VARCHAR(38) DEFAULT '{00000000-0000-0000-0000-000000000000}' NOT NULL,
    predioinformal_guid VARCHAR(38) DEFAULT '{00000000-0000-0000-0000-000000000000}',
    
    -- Datos geoespaciales
    gdb_geomattr_data BYTEA,
    shape TEXT,
    
    -- Restricciones
    CONSTRAINT pk_ilc_predio PRIMARY KEY (objectid),
    CONSTRAINT uk_ilc_predio_globalid UNIQUE (globalid)
);

-- ==================================================
-- ÍNDICES PARA OPTIMIZAR CONSULTAS
-- ==================================================

-- Índice por matrícula inmobiliaria
CREATE INDEX idx_ilc_predio_matricula ON ilc_predio(matricula_inmobiliaria);

-- Índice por número predial nacional
CREATE INDEX idx_ilc_predio_npn ON ilc_predio(numero_predial_nacional);

-- Índice por municipio
CREATE INDEX idx_ilc_predio_municipio ON ilc_predio(municipio);

-- Índice por tipo de predio
CREATE INDEX idx_ilc_predio_tipo ON ilc_predio(tipo);

-- Índice por condición del predio
CREATE INDEX idx_ilc_predio_condicion ON ilc_predio(condicion_predio);

-- Índice por código ORIP
CREATE INDEX idx_ilc_predio_orip ON ilc_predio(codigo_orip);

-- ==================================================
-- COMENTARIOS DE DOCUMENTACIÓN
-- ==================================================

COMMENT ON TABLE ilc_predio IS 'Tabla de predios del sistema catastral colombiano';
COMMENT ON COLUMN ilc_predio.objectid IS 'Identificador único del objeto';
COMMENT ON COLUMN ilc_predio.matricula_inmobiliaria IS 'Número de matrícula inmobiliaria';
COMMENT ON COLUMN ilc_predio.numero_predial_nacional IS 'Código predial nacional único';
COMMENT ON COLUMN ilc_predio.area_catastral_terreno IS 'Área catastral del terreno en metros cuadrados';
COMMENT ON COLUMN ilc_predio.area_registral_m2 IS 'Área registral en metros cuadrados';
COMMENT ON COLUMN ilc_predio.municipio IS 'Código del municipio';
COMMENT ON COLUMN ilc_predio.tipo IS 'Tipo de predio (Privado, Público, etc.)';
COMMENT ON COLUMN ilc_predio.condicion_predio IS 'Condición del predio (NPH, PH_Unidad_Predial, Via, etc.)';
COMMENT ON COLUMN ilc_predio.destinacion_economica IS 'Destinación económica del predio';
COMMENT ON COLUMN ilc_predio.shape IS 'Geometría del predio en formato texto';

-- ==================================================
-- VERIFICACIÓN
-- ==================================================

-- Verificar que la tabla fue creada correctamente
SELECT 
    table_name, 
    column_name, 
    data_type, 
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'ilc_predio' 
ORDER BY ordinal_position;