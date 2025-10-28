-- ==================================================
-- CONSULTAS ÚTILES PARA LA TABLA ilc_predio
-- Base de datos: predios
-- Descripción: Consultas comunes para análisis de predios
-- ==================================================

-- ==================================================
-- 1. CONSULTAS BÁSICAS DE INFORMACIÓN
-- ==================================================

-- Contar total de predios
SELECT COUNT(*) as total_predios 
FROM ilc_predio;

-- Verificar datos insertados recientemente
SELECT objectid, matricula_inmobiliaria, numero_predial_nacional, area_registral_m2
FROM ilc_predio 
ORDER BY objectid DESC 
LIMIT 10;

-- ==================================================
-- 2. CONSULTAS POR CLASIFICACIÓN
-- ==================================================

-- Distribución por tipo de predio
SELECT 
    tipo,
    COUNT(*) as cantidad,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM ilc_predio), 2) as porcentaje
FROM ilc_predio 
GROUP BY tipo 
ORDER BY cantidad DESC;

-- Distribución por condición del predio
SELECT 
    condicion_predio,
    COUNT(*) as cantidad,
    ROUND(AVG(area_registral_m2), 2) as area_promedio_m2
FROM ilc_predio 
WHERE area_registral_m2 > 0
GROUP BY condicion_predio 
ORDER BY cantidad DESC;

-- Distribución por destinación económica
SELECT 
    destinacion_economica,
    COUNT(*) as cantidad,
    SUM(area_registral_m2) as area_total_m2
FROM ilc_predio 
GROUP BY destinacion_economica 
ORDER BY area_total_m2 DESC;

-- ==================================================
-- 3. ANÁLISIS DE ÁREAS
-- ==================================================

-- Estadísticas de áreas
SELECT 
    COUNT(*) as total_predios,
    ROUND(MIN(area_registral_m2), 2) as area_minima,
    ROUND(MAX(area_registral_m2), 2) as area_maxima,
    ROUND(AVG(area_registral_m2), 2) as area_promedio,
    ROUND(SUM(area_registral_m2), 2) as area_total
FROM ilc_predio 
WHERE area_registral_m2 > 0;

-- Predios por rangos de área
SELECT 
    CASE 
        WHEN area_registral_m2 = 0 THEN '0 m²'
        WHEN area_registral_m2 <= 50 THEN '1-50 m²'
        WHEN area_registral_m2 <= 100 THEN '51-100 m²'
        WHEN area_registral_m2 <= 500 THEN '101-500 m²'
        WHEN area_registral_m2 <= 1000 THEN '501-1000 m²'
        ELSE 'Más de 1000 m²'
    END as rango_area,
    COUNT(*) as cantidad
FROM ilc_predio 
GROUP BY 1
ORDER BY 
    CASE 
        WHEN area_registral_m2 = 0 THEN 1
        WHEN area_registral_m2 <= 50 THEN 2
        WHEN area_registral_m2 <= 100 THEN 3
        WHEN area_registral_m2 <= 500 THEN 4
        WHEN area_registral_m2 <= 1000 THEN 5
        ELSE 6
    END;

-- ==================================================
-- 4. CONSULTAS POR UBICACIÓN
-- ==================================================

-- Predios por municipio
SELECT 
    municipio,
    COUNT(*) as cantidad_predios,
    SUM(area_registral_m2) as area_total_m2
FROM ilc_predio 
GROUP BY municipio 
ORDER BY cantidad_predios DESC;

-- Predios por código ORIP
SELECT 
    codigo_orip,
    COUNT(*) as cantidad_predios
FROM ilc_predio 
GROUP BY codigo_orip 
ORDER BY cantidad_predios DESC;

-- ==================================================
-- 5. BÚSQUEDAS ESPECÍFICAS
-- ==================================================

-- Buscar predio por matrícula inmobiliaria
SELECT *
FROM ilc_predio 
WHERE matricula_inmobiliaria = '100591';

-- Buscar predios por número predial nacional (parcial)
SELECT objectid, matricula_inmobiliaria, numero_predial_nacional, area_registral_m2
FROM ilc_predio 
WHERE numero_predial_nacional LIKE '%50313%'
LIMIT 10;

-- Predios con área registral específica
SELECT objectid, matricula_inmobiliaria, area_registral_m2, condicion_predio
FROM ilc_predio 
WHERE area_registral_m2 = 91.00000000;

-- ==================================================
-- 6. CONSULTAS DE VALIDACIÓN
-- ==================================================

-- Verificar predios sin área registral
SELECT COUNT(*) as predios_sin_area
FROM ilc_predio 
WHERE area_registral_m2 = 0 OR area_registral_m2 IS NULL;

-- Verificar predios duplicados por matrícula
SELECT 
    matricula_inmobiliaria,
    COUNT(*) as ocurrencias
FROM ilc_predio 
GROUP BY matricula_inmobiliaria 
HAVING COUNT(*) > 1
ORDER BY ocurrencias DESC;

-- Verificar integridad de GUIDs
SELECT COUNT(*) as guids_por_defecto
FROM ilc_predio 
WHERE globalid = '{00000000-0000-0000-0000-000000000000}';

-- ==================================================
-- 7. CONSULTAS AVANZADAS
-- ==================================================

-- Top 10 predios más grandes
SELECT 
    objectid,
    matricula_inmobiliaria,
    area_registral_m2,
    tipo,
    condicion_predio,
    destinacion_economica
FROM ilc_predio 
WHERE area_registral_m2 > 0
ORDER BY area_registral_m2 DESC 
LIMIT 10;

-- Predios habitacionales privados
SELECT 
    COUNT(*) as total,
    AVG(area_registral_m2) as area_promedio,
    SUM(area_registral_m2) as area_total
FROM ilc_predio 
WHERE tipo = 'Privado' 
AND destinacion_economica = 'Habitacional'
AND area_registral_m2 > 0;

-- ==================================================
-- 8. CONSULTAS PARA REPORTES
-- ==================================================

-- Resumen ejecutivo de predios
SELECT 
    'Total de predios' as concepto,
    COUNT(*)::text as valor
FROM ilc_predio
UNION ALL
SELECT 
    'Predios privados',
    COUNT(*)::text
FROM ilc_predio WHERE tipo = 'Privado'
UNION ALL
SELECT 
    'Área total registrada (m²)',
    ROUND(SUM(area_registral_m2), 2)::text
FROM ilc_predio WHERE area_registral_m2 > 0
UNION ALL
SELECT 
    'Área promedio (m²)',
    ROUND(AVG(area_registral_m2), 2)::text
FROM ilc_predio WHERE area_registral_m2 > 0;

-- ==================================================
-- 9. CONSULTAS DE MANTENIMIENTO
-- ==================================================

-- Verificar último registro insertado
SELECT MAX(objectid) as ultimo_objectid
FROM ilc_predio;

-- Información de la tabla
SELECT 
    schemaname,
    tablename,
    tableowner,
    hasindexes,
    hasrules,
    hastriggers
FROM pg_tables 
WHERE tablename = 'ilc_predio';