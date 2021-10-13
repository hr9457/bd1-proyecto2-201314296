-- ************************************
-- 1. Deplegar para cada eleccion el pais y partido politico que obtuvo mayor porcentaje de votos en su pais
-- Nombre de la eleccion, el anio eleccion, pais, nombre del partido politico y porcentaje de votos en su pais
-- cantidad = 6 (uno por pais)
-- ************************************

SELECT 
	partido_politico.eleccion,
	votacion_pais.anio,
	pais.nombre_pais,
    partido.nombre_partido,
	ROUND( ((partido_politico.votos/votacion_pais.votos) * 100) ,2) AS porcentaje
FROM (
		SELECT
			todos_maximos.eleccion AS eleccion,
			maximo_por_pais.anio AS anio,
			maximo_por_pais.pais AS pais,
			todos_maximos.partido AS partido,
			maximo_por_pais.maximo AS votos
		FROM(
				-- 6 partidos uno por pais
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
						partido_municipio.eleccion AS eleccion,
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
								votacion.id_partido AS partido,
                                eleccion.nombre_eleccion AS eleccion
							FROM votacion
							INNER JOIN municipio ON municipio.id_municipio = votacion.id_municipio
							INNER JOIN eleccion ON eleccion.id_eleccion = votacion.id_eleccion
							) partido_municipio 
							INNER JOIN departamento ON departamento.id_departamento = partido_municipio.departamento
					GROUP BY partido_municipio.eleccion ,partido_municipio.anio, departamento.id_pais, partido_municipio.partido
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






-- ************************************
-- 2. Desplegar total de votos y porcentaje de votos de mujeres por departamento
-- y por pais. Tiene que dar el 100 por ciento
-- ************************************

SELECT 
	voto_por_departamento.anio,
    voto_por_departamento.pais,
    voto_por_departamento.departamento,
    voto_por_departamento.votos,
    ROUND( ( voto_por_departamento.votos / total_de_votos.votos ) * 100 ,2) AS porcentaje
FROM(

		-- cantidad de votos por pais dividio por departamento = 81 departamentos
		SELECT 
			votaciones.anio  AS anio,
			departamento.id_pais AS pais,
			departamento.id_departamento AS departamento,
			SUM(votaciones.total) AS votos
		FROM(
			-- conteo de todos los votantes (solo mujeres) 
			SELECT
				votacion.analfabetos + votacion.alfabetos AS total,
				municipio.nombre_municipio AS municipio,
				eleccion.anio_eleccion AS anio,
				municipio.id_departamento AS departamento,
				votacion.id_sexo AS sexo,
				sexo.nombre_sexo
			FROM votacion
				INNER JOIN municipio ON municipio.id_municipio = votacion.id_municipio
				INNER JOIN eleccion ON eleccion.id_eleccion = votacion.id_eleccion 
				INNER JOIN sexo ON  sexo.id_sexo = votacion.id_sexo
			WHERE sexo.nombre_sexo = 'mujeres'
			-- 
			) votaciones
			INNER JOIN departamento ON departamento.id_departamento = votaciones.departamento
		GROUP BY votaciones.anio, departamento.id_pais,departamento.id_departamento
		ORDER BY departamento.id_pais, departamento.id_departamento
        ) voto_por_departamento     
        INNER JOIN (
			-- votos de mujeres por pais = 6 paises
			SELECT 
				votaciones_mujeres.anio AS anio,
				departamento.id_pais AS pais,
				SUM(votaciones_mujeres.total) AS votos
			FROM (
					-- conteo de todos los votantes (solo mujeres) 
					SELECT
						votacion.analfabetos + votacion.alfabetos AS total,
						municipio.id_municipio AS municipio,
						eleccion.anio_eleccion AS anio,
						municipio.id_departamento AS departamento,
						votacion.id_sexo AS sexo,
						sexo.nombre_sexo
					FROM votacion
						INNER JOIN municipio ON municipio.id_municipio = votacion.id_municipio
						INNER JOIN eleccion ON eleccion.id_eleccion = votacion.id_eleccion 
						INNER JOIN sexo ON  sexo.id_sexo = votacion.id_sexo
					WHERE sexo.nombre_sexo = 'mujeres'
					) votaciones_mujeres
					INNER JOIN departamento ON departamento.id_departamento = votaciones_mujeres.departamento 
			GROUP BY votaciones_mujeres.anio, departamento.id_pais
            ) total_de_votos ON total_de_votos.anio = voto_por_departamento.anio  and total_de_votos.pais = voto_por_departamento.pais
ORDER BY voto_por_departamento.pais;






-- ************************************
-- 4. Desplegar todas las regiones por paises
-- en donde predomina la raza indigena, hay mas votos que otras razas 
-- ************************************
SELECT 
	votos_por_raza.pais,
    votos_por_raza.anio,
    votos_por_raza.region,
    votos_por_raza.raza,
    votos_por_raza.votos
FROM (
		-- 66 resultados 
		SELECT 
			departamento.id_pais AS pais,
			votaciones.anio AS anio,
			departamento.id_region AS region,
			votaciones.raza AS raza,
			SUM(votaciones.poblacion) AS votos
		FROM (
				-- votaciones viendo la raza que voto = 20970 
				SELECT
					(votacion.analfabetos + votacion.alfabetos) AS poblacion,
					votacion.id_municipio AS municipio,
					eleccion.anio_eleccion AS anio,
					votacion.id_raza AS raza,
					raza.nombre_raza
				FROM votacion
					INNER JOIN eleccion ON eleccion.id_eleccion = votacion.id_eleccion
					INNER JOIN municipio ON municipio.id_municipio = votacion.id_municipio
					INNER JOIN raza ON raza.id_raza = votacion.id_raza
				) votaciones
				INNER JOIN departamento ON departamento.id_departamento = votaciones.municipio
		GROUP BY departamento.id_pais,votaciones.anio, departamento.id_region,votaciones.raza
		ORDER BY departamento.id_pais
        ) votos_por_raza,
        
        (
			-- 22 resultados 
			SELECT 
				departamento.id_pais AS pais,
				votaciones.anio AS anio,
				departamento.id_region AS region,
				votaciones.raza AS raza,
				SUM(votaciones.poblacion) AS votos
			FROM (
					-- votaciones viendo la raza que voto = 20970 
					SELECT
						(votacion.analfabetos + votacion.alfabetos) AS poblacion,
						votacion.id_municipio AS municipio,
						eleccion.anio_eleccion AS anio,
						votacion.id_raza AS raza,
						raza.nombre_raza
					FROM votacion
						INNER JOIN eleccion ON eleccion.id_eleccion = votacion.id_eleccion
						INNER JOIN municipio ON municipio.id_municipio = votacion.id_municipio
						INNER JOIN raza ON raza.id_raza = votacion.id_raza
					WHERE raza.nombre_raza = 'INDIGENAS'            
					) votaciones
					INNER JOIN departamento ON departamento.id_departamento = votaciones.municipio
			GROUP BY departamento.id_pais,votaciones.anio, departamento.id_region,votaciones.raza
			ORDER BY departamento.id_pais
            ) votos_indigenas
WHERE  votos_por_raza.pais = votos_indigenas.pais and votos_por_raza.anio = votos_indigenas.anio and votos_por_raza.region = votos_indigenas.region
		and votos_por_raza.raza = votos_indigenas.raza and votos_indigenas.votos >= votos_por_raza.votos;




-- consulta para hacer conteos de las de las consultas
SELECT 
	COUNT(*)
	FROM(

    ) conteo;