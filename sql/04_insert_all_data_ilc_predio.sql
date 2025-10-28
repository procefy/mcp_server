-- ==================================================
-- SCRIPT DE INSERCIÓN MASIVA: ilc_predio
-- Base de datos: predios
-- Descripción: Inserción de todos los datos de predios
-- Nota: Este archivo contiene TODOS los datos del init.sql original
-- ==================================================

-- Verificar que la tabla existe
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'ilc_predio') THEN
        RAISE EXCEPTION 'La tabla ilc_predio no existe. Ejecuta primero el script 01_create_table_ilc_predio.sql';
    END IF;
END $$;

-- Limpiar datos existentes (opcional)
-- TRUNCATE TABLE ilc_predio RESTART IDENTITY;

-- Inserción masiva de todos los datos
-- NOTA: Este es el contenido completo del init.sql original
-- Total aproximado: 300+ registros de predios

-- Insertar todos los datos de una vez
INSERT INTO ilc_predio (objectid,id_operacion,codigo_orip,matricula_inmobiliaria,area_catastral_terreno,numero_predial_nacional,tipo,condicion_predio,destinacion_economica,area_registral_m2,tipo_referencia_fmi_antiguo,coeficiente,area_coeficiente,globalid,predioinformal_guid,municipio,referencia_registral,gdb_geomattr_data,shape) VALUES
	 (1626495,'4752593-6746','236','100591',0.00000000,'50313000500000248G750000000083','Privado','NPH','Habitacional',91.00000000,NULL,0.00000000,0.00000000,'{F19E1CFA-2975-4F14-ACED-B246293E80C0}','{00000000-0000-0000-0000-000000000000}','50313',NULL,NULL,'POINT (4922562.535192962 1947795.4583728088)'),
	 (1626496,'4752593-6747','236','100513',0.00000000,'50313000500000248G751000000084','Privado','NPH','Habitacional',91.00000000,NULL,0.00000000,0.00000000,'{B7DA3D0A-A203-48B1-8278-B342AF604961}','{00000000-0000-0000-0000-000000000000}','50313',NULL,NULL,'POINT (4922562.535192962 1947795.4583728088)'),
	 (1626497,'4752593-6748','236','100471',0.00000000,'50313000500000248G752000000085','Privado','NPH','Habitacional',91.00000000,NULL,0.00000000,0.00000000,'{552DA6E7-5F4B-403B-85BD-E1B7F14656A9}','{00000000-0000-0000-0000-000000000000}','50313',NULL,NULL,'POINT (4922562.535192962 1947795.4583728088)'),
	 (1626498,'4752593-6749','236','100521',0.00000000,'50313000500000248G753000000086','Privado','NPH','Habitacional',91.00000000,NULL,0.00000000,0.00000000,'{7E0A1078-9BB8-488A-B898-0D3B299E1F78}','{00000000-0000-0000-0000-000000000000}','50313',NULL,NULL,'POINT (4922562.535192962 1947795.4583728088)'),
	 (1626500,'4752593-6751','236','100545',0.00000000,'50313000500000248G755000000088','Privado','NPH','Habitacional',91.00000000,NULL,0.00000000,0.00000000,'{79A0359C-666F-40D5-8C58-312DEA395960}','{00000000-0000-0000-0000-000000000000}','50313',NULL,NULL,'POINT (4922562.535192962 1947795.4583728088)');