-- ==================================================
-- UTILIDADES Y MANTENIMIENTO: ilc_predio
-- Base de datos: predios
-- Descripción: Scripts de utilidades, backup y mantenimiento
-- ==================================================

-- ==================================================
-- 1. FUNCIONES DE UTILIDAD
-- ==================================================

-- Función para obtener estadísticas rápidas de la tabla
CREATE OR REPLACE FUNCTION get_predio_stats()
RETURNS TABLE (
    concepto TEXT,
    valor TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 'Total de predios'::TEXT, COUNT(*)::TEXT
    FROM ilc_predio
    UNION ALL
    SELECT 'Predios privados'::TEXT, COUNT(*)::TEXT
    FROM ilc_predio WHERE tipo = 'Privado'
    UNION ALL
    SELECT 'Predios públicos'::TEXT, COUNT(*)::TEXT
    FROM ilc_predio WHERE tipo != 'Privado' OR tipo IS NULL
    UNION ALL
    SELECT 'Área total (m²)'::TEXT, COALESCE(ROUND(SUM(area_registral_m2), 2), 0)::TEXT
    FROM ilc_predio WHERE area_registral_m2 > 0
    UNION ALL
    SELECT 'Área promedio (m²)'::TEXT, COALESCE(ROUND(AVG(area_registral_m2), 2), 0)::TEXT
    FROM ilc_predio WHERE area_registral_m2 > 0;
END;
$$ LANGUAGE plpgsql;

-- Función para buscar predios por matrícula
CREATE OR REPLACE FUNCTION buscar_predio_por_matricula(matricula_buscar VARCHAR)
RETURNS TABLE (
    objectid INTEGER,
    matricula_inmobiliaria VARCHAR,
    numero_predial_nacional VARCHAR,
    area_registral_m2 NUMERIC,
    tipo VARCHAR,
    condicion_predio VARCHAR,
    municipio VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.objectid,
        p.matricula_inmobiliaria,
        p.numero_predial_nacional,
        p.area_registral_m2,
        p.tipo,
        p.condicion_predio,
        p.municipio
    FROM ilc_predio p
    WHERE p.matricula_inmobiliaria ILIKE '%' || matricula_buscar || '%';
END;
$$ LANGUAGE plpgsql;

-- ==================================================
-- 2. VISTAS ÚTILES
-- ==================================================

-- Vista de predios habitacionales
CREATE OR REPLACE VIEW v_predios_habitacionales AS
SELECT 
    objectid,
    matricula_inmobiliaria,
    numero_predial_nacional,
    area_registral_m2,
    tipo,
    condicion_predio,
    municipio,
    CASE 
        WHEN area_registral_m2 <= 50 THEN 'Pequeño'
        WHEN area_registral_m2 <= 100 THEN 'Mediano'
        WHEN area_registral_m2 <= 500 THEN 'Grande'
        ELSE 'Muy Grande'
    END as tamaño_predio
FROM ilc_predio
WHERE destinacion_economica = 'Habitacional'
AND area_registral_m2 > 0;

-- Vista de resumen por municipio
CREATE OR REPLACE VIEW v_resumen_municipio AS
SELECT 
    municipio,
    COUNT(*) as total_predios,
    COUNT(CASE WHEN tipo = 'Privado' THEN 1 END) as predios_privados,
    COUNT(CASE WHEN destinacion_economica = 'Habitacional' THEN 1 END) as predios_habitacionales,
    ROUND(SUM(CASE WHEN area_registral_m2 > 0 THEN area_registral_m2 ELSE 0 END), 2) as area_total_m2,
    ROUND(AVG(CASE WHEN area_registral_m2 > 0 THEN area_registral_m2 ELSE NULL END), 2) as area_promedio_m2
FROM ilc_predio
GROUP BY municipio
ORDER BY total_predios DESC;

-- ==================================================
-- 3. PROCEDIMIENTOS DE MANTENIMIENTO
-- ==================================================

-- Procedimiento para limpiar datos inconsistentes
CREATE OR REPLACE FUNCTION limpiar_datos_inconsistentes()
RETURNS TEXT AS $$
DECLARE
    registros_afectados INTEGER := 0;
BEGIN
    -- Actualizar áreas negativas a 0
    UPDATE ilc_predio 
    SET area_registral_m2 = 0 
    WHERE area_registral_m2 < 0;
    
    GET DIAGNOSTICS registros_afectados = ROW_COUNT;
    
    -- Actualizar GUIDs vacíos al valor por defecto
    UPDATE ilc_predio 
    SET globalid = '{00000000-0000-0000-0000-000000000000}'
    WHERE globalid IS NULL OR globalid = '';
    
    GET DIAGNOSTICS registros_afectados = registros_afectados + ROW_COUNT;
    
    RETURN 'Limpieza completada. Registros afectados: ' || registros_afectados;
END;
$$ LANGUAGE plpgsql;

-- ==================================================
-- 4. SCRIPTS DE BACKUP
-- ==================================================

-- Crear tabla de respaldo con timestamp
CREATE OR REPLACE FUNCTION crear_backup_predios()
RETURNS TEXT AS $$
DECLARE
    tabla_backup TEXT;
    registros_copiados INTEGER;
BEGIN
    tabla_backup := 'ilc_predio_backup_' || to_char(NOW(), 'YYYY_MM_DD_HH24_MI_SS');
    
    EXECUTE 'CREATE TABLE ' || tabla_backup || ' AS SELECT * FROM ilc_predio';
    
    EXECUTE 'SELECT COUNT(*) FROM ' || tabla_backup INTO registros_copiados;
    
    RETURN 'Backup creado: ' || tabla_backup || ' con ' || registros_copiados || ' registros';
END;
$$ LANGUAGE plpgsql;

-- ==================================================
-- 5. SCRIPTS DE VALIDACIÓN
-- ==================================================

-- Validar integridad de datos
CREATE OR REPLACE FUNCTION validar_integridad_predios()
RETURNS TABLE (
    problema TEXT,
    cantidad INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT 'Predios sin matrícula'::TEXT, COUNT(*)::INTEGER
    FROM ilc_predio 
    WHERE matricula_inmobiliaria IS NULL OR matricula_inmobiliaria = ''
    UNION ALL
    SELECT 'Predios sin número predial'::TEXT, COUNT(*)::INTEGER
    FROM ilc_predio 
    WHERE numero_predial_nacional IS NULL OR numero_predial_nacional = ''
    UNION ALL
    SELECT 'Predios con área negativa'::TEXT, COUNT(*)::INTEGER
    FROM ilc_predio 
    WHERE area_registral_m2 < 0
    UNION ALL
    SELECT 'Predios sin municipio'::TEXT, COUNT(*)::INTEGER
    FROM ilc_predio 
    WHERE municipio IS NULL OR municipio = ''
    UNION ALL
    SELECT 'Matrículas duplicadas'::TEXT, 
           (SELECT COUNT(*) FROM (
               SELECT matricula_inmobiliaria 
               FROM ilc_predio 
               GROUP BY matricula_inmobiliaria 
               HAVING COUNT(*) > 1
           ) duplicados)::INTEGER;
END;
$$ LANGUAGE plpgsql;

-- ==================================================
-- 6. COMANDOS DE MANTENIMIENTO
-- ==================================================

-- Reindexar tabla para optimizar rendimiento
-- REINDEX TABLE ilc_predio;

-- Actualizar estadísticas de la tabla
-- ANALYZE ilc_predio;

-- Verificar tamaño de la tabla
CREATE OR REPLACE FUNCTION obtener_info_tabla()
RETURNS TABLE (
    concepto TEXT,
    valor TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 'Tamaño de tabla'::TEXT, pg_size_pretty(pg_total_relation_size('ilc_predio'))
    UNION ALL
    SELECT 'Número de índices'::TEXT, COUNT(*)::TEXT
    FROM pg_indexes 
    WHERE tablename = 'ilc_predio'
    UNION ALL
    SELECT 'Última actualización'::TEXT, 
           COALESCE(last_analyze::TEXT, 'No disponible')
    FROM pg_stat_user_tables 
    WHERE relname = 'ilc_predio';
END;
$$ LANGUAGE plpgsql;

-- ==================================================
-- 7. EJEMPLOS DE USO
-- ==================================================

/*
-- Ejecutar función de estadísticas
SELECT * FROM get_predio_stats();

-- Buscar predio por matrícula
SELECT * FROM buscar_predio_por_matricula('100591');

-- Ver predios habitacionales
SELECT * FROM v_predios_habitacionales LIMIT 10;

-- Ver resumen por municipio
SELECT * FROM v_resumen_municipio;

-- Validar integridad
SELECT * FROM validar_integridad_predios();

-- Crear backup
SELECT crear_backup_predios();

-- Obtener información de la tabla
SELECT * FROM obtener_info_tabla();

-- Limpiar datos inconsistentes
SELECT limpiar_datos_inconsistentes();
*/