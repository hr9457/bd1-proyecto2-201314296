-- ************************************
-- 1. 
-- ************************************
SELECT 
	votaciones.municipio AS municipio,
    votaciones.anio AS anio,
	SUM(votaciones.total) AS votos
FROM(
	SELECT
		votacion.analfabetos + votacion.alfabetos AS total,
		municipio.nombre_municipio AS municipio,
		eleccion.anio_eleccion AS anio
	FROM votacion
	INNER JOIN municipio ON municipio.id_municipio = votacion.id_municipio
	INNER JOIN eleccion ON eleccion.id_eleccion = votacion.id_eleccion) votaciones
GROUP BY votaciones.municipio, votaciones.anio;



SELECT 
	votaciones.municipio AS municipio,
	votaciones.anio AS anio,
	votaciones.departamento AS departamento,
	SUM(votaciones.total) AS votos
FROM(
	SELECT
		votacion.analfabetos + votacion.alfabetos AS total,
		municipio.nombre_municipio AS municipio,
		eleccion.anio_eleccion AS anio,
		municipio.id_departamento AS departamento
	FROM votacion
	INNER JOIN municipio ON municipio.id_municipio = votacion.id_municipio
	INNER JOIN eleccion ON eleccion.id_eleccion = votacion.id_eleccion
	) votaciones
where votaciones.municipio = 'Cabañas'
GROUP BY votaciones.municipio, votaciones.anio, votaciones.departamento


-- 1170 a nivel de departamento
SELECT 
	votaciones.municipio AS municipio,
	votaciones.anio AS anio,
	votaciones.departamento AS departamento,
	SUM(votaciones.total) AS votos
FROM(
	SELECT
		votacion.analfabetos + votacion.alfabetos AS total,
		municipio.nombre_municipio AS municipio,
		eleccion.anio_eleccion AS anio,
		municipio.id_departamento AS departamento
	FROM votacion
	INNER JOIN municipio ON municipio.id_municipio = votacion.id_municipio
	INNER JOIN eleccion ON eleccion.id_eleccion = votacion.id_eleccion
	) votaciones
GROUP BY votaciones.municipio, votaciones.anio, votaciones.departamento;





-- nivel de pais solo con departamentos de cabañas
SELECT 
	votaciones.municipio AS municipio,
	votaciones.anio AS anio,
    departamento.id_pais,
	SUM(votaciones.total) AS votos
FROM(
	SELECT
		votacion.analfabetos + votacion.alfabetos AS total,
		municipio.nombre_municipio AS municipio,
		eleccion.anio_eleccion AS anio,
		municipio.id_departamento AS departamento
	FROM votacion
	INNER JOIN municipio ON municipio.id_municipio = votacion.id_municipio
	INNER JOIN eleccion ON eleccion.id_eleccion = votacion.id_eleccion
	) votaciones
    INNER JOIN departamento ON departamento.id_departamento = votaciones.departamento
where votaciones.municipio = 'Cabañas'
GROUP BY votaciones.municipio, votaciones.anio, departamento.id_pais;


-- consulta para hacer conteos de las de las consultas
SELECT 
	COUNT(*)
	FROM(

    ) conteo;