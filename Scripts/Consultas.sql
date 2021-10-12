-- ************************************
-- 1. Deplegar para cada eleccion el pais y partido politico que obtuvo mayor porcentaje de votos en su pais
-- Nombre de la eleccion, el anio eleccion, pais, nombre del partido politico y porcentaje de votos en su pais
-- cantidad = 6 (uno por pais)
-- ************************************

SELECT 
	votacion_pais.anio,
	pais.nombre_pais,
    partido.nombre_partido,
	ROUND( ((partido_politico.votos/votacion_pais.votos) * 100) ,2) AS porcentaje
FROM (
		SELECT
			maximo_por_pais.anio AS anio,
			maximo_por_pais.pais AS pais,
			todos_maximos.partido AS partido,
			maximo_por_pais.maximo AS votos
		FROM(
				SELECT 
					maximos.anio AS anio,
					maximos.pais AS pais,
					MAX(maximos.votos) AS maximo
				FROM(
					-- votaciones por partido politico en cada pais = 18
					SELECT 
						partido_municipio.anio AS anio,
						departamento.id_pais AS pais,
						partido_municipio.partido AS partido,
						SUM(partido_municipio.total) AS votos
					FROM(
							SELECT
								votacion.analfabetos + votacion.alfabetos AS total,
								municipio.nombre_municipio AS municipio,
								eleccion.anio_eleccion AS anio,
								municipio.id_departamento AS departamento,
								votacion.id_partido AS partido
							FROM votacion
							INNER JOIN municipio ON municipio.id_municipio = votacion.id_municipio
							INNER JOIN eleccion ON eleccion.id_eleccion = votacion.id_eleccion
							) partido_municipio 
							INNER JOIN departamento ON departamento.id_departamento = partido_municipio.departamento
					GROUP BY partido_municipio.anio, departamento.id_pais, partido_municipio.partido
					)maximos
				GROUP BY maximos.anio, maximos.pais
				) maximo_por_pais,
				(
					-- votaciones por partido politico en cada pais = 18
					SELECT 
						partido_municipio.anio AS anio,
						departamento.id_pais AS pais,
						partido_municipio.partido AS partido,
						SUM(partido_municipio.total) AS votos
					FROM(
							SELECT
								votacion.analfabetos + votacion.alfabetos AS total,
								municipio.nombre_municipio AS municipio,
								eleccion.anio_eleccion AS anio,
								municipio.id_departamento AS departamento,
								votacion.id_partido AS partido
							FROM votacion
							INNER JOIN municipio ON municipio.id_municipio = votacion.id_municipio
							INNER JOIN eleccion ON eleccion.id_eleccion = votacion.id_eleccion
							) partido_municipio 
							INNER JOIN departamento ON departamento.id_departamento = partido_municipio.departamento
					GROUP BY partido_municipio.anio, departamento.id_pais, partido_municipio.partido
					) todos_maximos
		WHERE maximo_por_pais.pais = todos_maximos.pais and maximo_por_pais.anio = todos_maximos.anio and maximo_por_pais.maximo = todos_maximos.votos
    ) partido_politico
    INNER JOIN (
				-- cantidad de votos por pais = 6 
				SELECT 
					votaciones.anio  AS anio,
					departamento.id_pais AS pais,
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
				GROUP BY votaciones.anio, departamento.id_pais
                ) 
                votacion_pais ON votacion_pais.pais = partido_politico.pais
		INNER JOIN pais ON pais.id_pais = partido_politico.pais
        INNER JOIN partido ON partido.id_partido =  partido_politico.partido;








-- consulta para hacer conteos de las de las consultas
SELECT 
	COUNT(*)
	FROM(

    ) conteo;