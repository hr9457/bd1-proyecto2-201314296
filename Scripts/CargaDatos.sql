	-- *******************************************************************************
	-- paises = 6 
INSERT INTO pais(pais.nombre_pais)
	SELECT 
		DISTINCT pais 
	FROM temporal;


--  regiones = 7
INSERT INTO region(region.nombre_region, region.id_pais)  
	SELECT 
		DISTINCT temporal.region,
        pais.id_pais
	FROM temporal
		INNER JOIN pais ON pais.nombre_pais = temporal.pais;



-- departamento = 81
INSERT INTO departamento (departamento.nombre_departamento, departamento.id_region)
	SELECT
		DISTINCT temporal.departamento, 
		region.id_region
	FROM temporal
		INNER JOIN region ON region.nombre_region = temporal.region 
        INNER JOIN pais ON pais.nombre_pais = temporal.pais and pais.id_pais = region.id_pais;
    


-- partidos = 18
INSERT INTO partido (partido.nombre_partido, partido.siglas_partido, partido.id_pais)
	SELECT
		DISTINCT temporal.nombre_partido as partido,
		temporal.partido as siglas,
		pais.id_pais as pais
	FROM temporal
		INNER JOIN pais ON pais.nombre_pais = temporal.pais;



--  sexo = 2
INSERT INTO sexo (sexo.nombre_sexo)
	SELECT
		DISTINCT temporal.sexo
	FROM temporal;


-- raza = 3
INSERT INTO raza (raza.nombre_raza)
	SELECT
		DISTINCT temporal.raza
	FROM temporal;


-- eleccion = 2
INSERT INTO eleccion (eleccion.nombre_eleccion, eleccion.anio_eleccion) 
	SELECT
		DISTINCT temporal.nombre_eleccion,
		temporal.anio_eleccion
	FROM temporal;


-- municipios = 1169 
INSERT INTO municipio (municipio.nombre_municipio, municipio.id_departamento)
	SELECT 
		DISTINCT temporal.municipio,
		departamento.id_departamento
	FROM temporal
		INNER JOIN departamento ON departamento.nombre_departamento = temporal.departamento        
        INNER JOIN region ON region.nombre_region = temporal.region and region.id_region = departamento.id_region
        INNER JOIN pais ON  pais.nombre_pais = temporal.pais and pais.id_pais = region.id_pais;



-- votaciones = 20970 
INSERT INTO votacion (votacion.analfabetos, votacion.alfabetos, 
						votacion.primaria, votacion.educacion_media, 
                        votacion.universitario, votacion.id_raza, votacion.id_sexo,
                        votacion.id_municipio, votacion.id_partido, votacion.id_eleccion)
	SELECT
		temporal.analfabeto,
		temporal.alfabeto,
		temporal.primaria,
		temporal.nivel_medio,
		temporal.universitario,
		raza.id_raza,
		sexo.id_sexo,	
		municipio.id_municipio,
		partido.id_partido,
		eleccion.id_eleccion	
	FROM temporal
		INNER JOIN pais ON pais.nombre_pais = temporal.pais 
        INNER JOIN region ON region.nombre_region = temporal.region AND region.id_pais = pais.id_pais
        INNER JOIN departamento ON departamento.nombre_departamento = temporal.departamento AND departamento.id_region = region.id_region
		INNER JOIN municipio ON municipio.nombre_municipio = temporal.municipio  AND municipio.id_departamento = departamento.id_departamento
		INNER JOIN sexo ON sexo.nombre_sexo = temporal.sexo
		INNER JOIN raza ON raza.nombre_raza = temporal.raza
		INNER JOIN eleccion ON eleccion.nombre_eleccion = temporal.nombre_eleccion AND eleccion.anio_eleccion = temporal.anio_eleccion
		INNER JOIN partido ON partido.nombre_partido = temporal.nombre_partido AND partido.id_pais = pais.id_pais;
        
