-- ************************************
-- 1. Deplegar para cada eleccion el pais y partido politico que obtuvo mayor porcentaje de votos en su pais
-- Nombre de la eleccion, el anio eleccion, pais, nombre del partido politico y porcentaje de votos en su pais
-- cantidad = 6 (uno por pais)
-- ************************************

SELECT
	partido_politico.anio AS anio,
    pais.nombre_pais AS pais,
    partido.nombre_partido AS partido,
    ROUND( (partido_politico.votos / votacion_pais.votos) * 100 ,2) AS porcentaje
FROM (
		-- uno por pais 
		SELECT
			maximo_por_pais.anio AS anio,
			maximo_por_pais.pais AS pais,
			todos_maximos.partido AS partido,
			maximo_por_pais.maximo AS votos
		FROM (
				-- partido con mayor votacion = 6 (uno por pais) 
				SELECT 
					pais_partidoPolitico.anio AS anio,
					pais_partidoPolitico.pais AS pais,
					MAX(pais_partidoPolitico.votos) AS maximo
				FROM (
						-- votos partidos politicos por pais = 18 
						SELECT 
							votos.anio AS anio,
							region.id_pais AS pais,
							votos.partido AS partido,
							SUM(votos.votos) AS votos
						FROM (
								SELECT		
									eleccion.anio_eleccion AS anio,
									departamento.id_departamento AS departamento,
									municipio.id_municipio AS municipio,
									partido.id_partido AS partido,
									(votacion.alfabetos + votacion.analfabetos) AS votos
								FROM votacion
									INNER JOIN eleccion ON eleccion.id_eleccion = votacion.id_eleccion
									INNER JOIN partido ON partido.id_partido = votacion.id_partido
									INNER JOIN municipio ON votacion.id_municipio = municipio.id_municipio
									INNER JOIN departamento ON departamento.id_departamento = municipio.id_departamento
							) votos
							INNER JOIN departamento ON departamento.id_departamento = votos.departamento
							INNER JOIN region ON region.id_region = departamento.id_region
						GROUP BY  votos.anio,region.id_pais, votos.partido
					) pais_partidoPolitico
				GROUP BY pais_partidoPolitico.anio,pais_partidoPolitico.pais
				ORDER BY pais_partidoPolitico.pais
			) maximo_por_pais,
			(
				-- votos partidos politicos por pais = 18 
				SELECT 
					votos.anio AS anio,
					region.id_pais AS pais,
					votos.partido AS partido,
					SUM(votos.votos) AS votos
				FROM (
						SELECT			
							eleccion.anio_eleccion AS anio,
							departamento.id_departamento AS departamento,
							municipio.id_municipio AS municipio,
							partido.id_partido AS partido,
							(votacion.alfabetos + votacion.analfabetos) AS votos
						FROM votacion
							INNER JOIN eleccion ON eleccion.id_eleccion = votacion.id_eleccion
							INNER JOIN partido ON partido.id_partido = votacion.id_partido
							INNER JOIN municipio ON votacion.id_municipio = municipio.id_municipio
							INNER JOIN departamento ON departamento.id_departamento = municipio.id_departamento
					) votos
					INNER JOIN departamento ON departamento.id_departamento = votos.departamento
					INNER JOIN region ON region.id_region = departamento.id_region
				GROUP BY votos.anio,region.id_pais, votos.partido
			) todos_maximos
		WHERE maximo_por_pais.pais = todos_maximos.pais AND maximo_por_pais.anio = todos_maximos.anio AND maximo_por_pais.maximo = todos_maximos.votos
	) partido_politico
    
    INNER JOIN (
				-- votacion por pais 
				SELECT
					region.id_pais AS pais,
					SUM(votos_pais.votos) AS votos
				FROM (
						SELECT
							departamento.id_departamento AS departamento,
							municipio.id_municipio AS municipio,
							(votacion.alfabetos + votacion.analfabetos) AS votos
						FROM votacion
							INNER JOIN sexo ON  sexo.id_sexo = votacion.id_sexo
							INNER JOIN raza ON  raza.id_raza = votacion.id_raza
							INNER JOIN municipio ON votacion.id_municipio = municipio.id_municipio
							INNER JOIN departamento ON departamento.id_departamento = municipio.id_departamento
					) votos_pais
					INNER JOIN departamento ON departamento.id_departamento = votos_pais.departamento
					INNER JOIN region ON region.id_region = departamento.id_region
				GROUP BY region.id_pais
                ) votacion_pais ON votacion_pais.pais = partido_politico.pais
	
    INNER JOIN pais ON pais.id_pais = partido_politico.pais
    INNER JOIN partido ON partido.id_partido = partido_politico.partido;







-- ************************************
-- 2. Desplegar total de votos y porcentaje de votos de mujeres por departamento
-- y por pais. Tiene que dar el 100 por ciento
-- ************************************

SELECT
	pais.nombre_pais AS pais,
    departamento.nombre_departamento as departamento,
    voto_por_departamento.votos as votos,
    ROUND( (voto_por_departamento.votos / total_de_votos.votos) * 100 ,2) as porcentaje
FROM (
		-- votaciones de mujeres pais y por departamento = 81 resultados
		SELECT
			region.id_pais AS pais,
			votos_pais.departamento as departamento,
			SUM(votos_pais.votos) AS votos
		FROM (
				SELECT
					departamento.id_departamento AS departamento,
					municipio.id_municipio AS municipio,
					(votacion.alfabetos + votacion.analfabetos) AS votos
				FROM votacion
					INNER JOIN sexo ON  sexo.id_sexo = votacion.id_sexo AND sexo.nombre_sexo = 'mujeres'
					INNER JOIN municipio ON votacion.id_municipio = municipio.id_municipio
					INNER JOIN departamento ON departamento.id_departamento = municipio.id_departamento
			) votos_pais
			INNER JOIN departamento ON departamento.id_departamento = votos_pais.departamento
			INNER JOIN region ON region.id_region = departamento.id_region
		GROUP BY region.id_pais, votos_pais.departamento
		ORDER BY region.id_pais
	) voto_por_departamento
    INNER JOIN (
				-- votacion por pais de solo mujeres
				SELECT
				region.id_pais AS pais,
				SUM(votos_pais.votos) AS votos
				FROM (
					SELECT
						departamento.id_departamento AS departamento,
						municipio.id_municipio AS municipio,
						(votacion.alfabetos + votacion.analfabetos) AS votos
					FROM votacion
						INNER JOIN sexo ON  sexo.id_sexo = votacion.id_sexo AND sexo.nombre_sexo = 'mujeres'
						INNER JOIN municipio ON votacion.id_municipio = municipio.id_municipio
						INNER JOIN departamento ON departamento.id_departamento = municipio.id_departamento
				) votos_pais
				INNER JOIN departamento ON departamento.id_departamento = votos_pais.departamento
				INNER JOIN region ON region.id_region = departamento.id_region
				GROUP BY region.id_pais
				) total_de_votos on total_de_votos.pais = voto_por_departamento.pais
	INNER JOIN pais on pais.id_pais = voto_por_departamento.pais
    INNER JOIN departamento on departamento.id_departamento = voto_por_departamento.departamento;








-- ************************************
-- 3. Desplegar el nombre del país, nombre del partido político y 
-- número de alcaldías de los partidos políticos que ganaron más alcaldías por país
-- ************************************


SELECT 
	pais.nombre_pais as pais,
    partido.nombre_partido as partido,
	ganadores.alcadias as alcadias
FROM (
		SELECT 
			alcadias_partidos.pais as pais,
			MAX(alcadias_partidos.alcadias) AS alcadias
		FROM (
				-- cantidad de alcadias ganadas por partidos = 18 resultados
				select 
					partidos_ganadores.pais AS pais,
					partidos_ganadores.partido AS partido,
					count(partidos_ganadores.partido) AS alcadias
				from (
						-- ?
						select 
							partido_ganador.pais as pais,
							partido_ganador.departamento as departamento,
							partido_ganador.municipio as municipio,
							partido_municipio.partido,
							partido_ganador.votos as votos
						from (
								-- ganadores por municipio = 1169 reslutados
								select 
									ganador_municipio.pais as pais,
									ganador_municipio.departamento as departamento,
									ganador_municipio.municipio as municipio,
									MAX(ganador_municipio.votos) as votos
								from (
										-- 3495
										SELECT
											region.id_pais AS pais,    
											votos_pais.departamento,
											votos_pais.municipio,
											votos_pais.partido,
											SUM(votos_pais.votos) AS votos
										FROM (
												SELECT
													partido.id_partido as partido,
													departamento.id_departamento AS departamento,
													municipio.id_municipio AS municipio,
													(votacion.alfabetos + votacion.analfabetos) AS votos
												FROM votacion
													INNER JOIN partido on partido.id_partido = votacion.id_partido
													INNER JOIN municipio ON votacion.id_municipio = municipio.id_municipio
													INNER JOIN departamento ON departamento.id_departamento = municipio.id_departamento
											) votos_pais
											INNER JOIN departamento ON departamento.id_departamento = votos_pais.departamento
											INNER JOIN region ON region.id_region = departamento.id_region
										GROUP BY region.id_pais, votos_pais.departamento, votos_pais.municipio,votos_pais.partido
										) ganador_municipio 
								GROUP BY ganador_municipio.pais, ganador_municipio.departamento, ganador_municipio.municipio
							) partido_ganador
							INNER JOIN (
										-- 3495
										SELECT
											region.id_pais AS pais,    
											votos_pais.departamento,
											votos_pais.municipio,
											votos_pais.partido,
											SUM(votos_pais.votos) AS votos
										FROM (
												SELECT
													partido.id_partido as partido,
													departamento.id_departamento AS departamento,
													municipio.id_municipio AS municipio,
													(votacion.alfabetos + votacion.analfabetos) AS votos
												FROM votacion
													INNER JOIN partido on partido.id_partido = votacion.id_partido
													INNER JOIN municipio ON votacion.id_municipio = municipio.id_municipio
													INNER JOIN departamento ON departamento.id_departamento = municipio.id_departamento
											) votos_pais
											INNER JOIN departamento ON departamento.id_departamento = votos_pais.departamento
											INNER JOIN region ON region.id_region = departamento.id_region
										GROUP BY region.id_pais, votos_pais.departamento, votos_pais.municipio,votos_pais.partido
									) partido_municipio on partido_municipio.pais = partido_ganador.pais and partido_municipio.departamento = partido_ganador.departamento 
										and partido_municipio.municipio = partido_ganador.municipio and partido_municipio.votos = partido_ganador.votos
						) partidos_ganadores
				group by	partidos_ganadores.pais, partidos_ganadores.partido
			) alcadias_partidos	
		GROUP BY alcadias_partidos.pais
) ganadores

	INNER JOIN (
				-- cantidad de alcadias ganadas por partidos = 18 resultados
				select 
					partidos_ganadores.pais AS pais,
					partidos_ganadores.partido AS partido,
					count(partidos_ganadores.partido) AS alcadias
				from (
						-- 1170
						select 
							partido_ganador.pais as pais,
							partido_ganador.departamento as departamento,
							partido_ganador.municipio as municipio,
							partido_municipio.partido,
							partido_ganador.votos as votos
						from (
								-- ganadores por municipio = 1169 reslutados
								select 
									ganador_municipio.pais as pais,
									ganador_municipio.departamento as departamento,
									ganador_municipio.municipio as municipio,
									MAX(ganador_municipio.votos) as votos
								from (
										-- 3495
										SELECT
											region.id_pais AS pais,    
											votos_pais.departamento,
											votos_pais.municipio,
											votos_pais.partido,
											SUM(votos_pais.votos) AS votos
										FROM (
												SELECT
													partido.id_partido as partido,
													departamento.id_departamento AS departamento,
													municipio.id_municipio AS municipio,
													(votacion.alfabetos + votacion.analfabetos) AS votos
												FROM votacion
													INNER JOIN partido on partido.id_partido = votacion.id_partido
													INNER JOIN municipio ON votacion.id_municipio = municipio.id_municipio
													INNER JOIN departamento ON departamento.id_departamento = municipio.id_departamento
											) votos_pais
											INNER JOIN departamento ON departamento.id_departamento = votos_pais.departamento
											INNER JOIN region ON region.id_region = departamento.id_region
										GROUP BY region.id_pais, votos_pais.departamento, votos_pais.municipio,votos_pais.partido
										) ganador_municipio 
								GROUP BY ganador_municipio.pais, ganador_municipio.departamento, ganador_municipio.municipio
							) partido_ganador
							INNER JOIN (
										-- 3495
										SELECT
											region.id_pais AS pais,    
											votos_pais.departamento,
											votos_pais.municipio,
											votos_pais.partido,
											SUM(votos_pais.votos) AS votos
										FROM (
												SELECT
													partido.id_partido as partido,
													departamento.id_departamento AS departamento,
													municipio.id_municipio AS municipio,
													(votacion.alfabetos + votacion.analfabetos) AS votos
												FROM votacion
													INNER JOIN partido on partido.id_partido = votacion.id_partido
													INNER JOIN municipio ON votacion.id_municipio = municipio.id_municipio
													INNER JOIN departamento ON departamento.id_departamento = municipio.id_departamento
											) votos_pais
											INNER JOIN departamento ON departamento.id_departamento = votos_pais.departamento
											INNER JOIN region ON region.id_region = departamento.id_region
										GROUP BY region.id_pais, votos_pais.departamento, votos_pais.municipio,votos_pais.partido
									) partido_municipio on partido_municipio.pais = partido_ganador.pais and partido_municipio.departamento = partido_ganador.departamento 
										and partido_municipio.municipio = partido_ganador.municipio and partido_municipio.votos = partido_ganador.votos
						) partidos_ganadores
				group by	partidos_ganadores.pais, partidos_ganadores.partido
	) todos_partidos_alcadia on todos_partidos_alcadia.pais = ganadores.pais and todos_partidos_alcadia.alcadias = ganadores.alcadias
    INNER JOIN pais on pais.id_pais = ganadores.pais
    INNER JOIN partido on partido.id_partido = todos_partidos_alcadia.partido;





-- ************************************
-- 4. Desplegar todas las regiones por paises
-- en donde predomina la raza indigena, hay mas votos que otras razas 
-- cantidad = 4
-- ************************************
SELECT 
	pais.nombre_pais,
    region.nombre_region,
    maximo_por_region.votos
FROM (
		-- maximo de por region = 22 resultados
		SELECT 
			voto_por_raza.pais as pais,
			voto_por_raza.region as region,
			MAX(voto_por_raza.votos) as votos
		FROM (
				-- votacion de pais y region = 66 resultados
				SELECT
					region.id_pais AS pais,
					region.id_region AS region,
					votos_pais.raza AS raza,
					SUM(votos_pais.votos) AS votos
				FROM (
						SELECT
							departamento.id_departamento AS departamento,
							municipio.id_municipio AS municipio,
							votacion.id_raza as raza,
							(votacion.alfabetos + votacion.analfabetos) AS votos
						FROM votacion
							INNER JOIN raza ON raza.id_raza = votacion.id_raza
							INNER JOIN municipio ON votacion.id_municipio = municipio.id_municipio
							INNER JOIN departamento ON departamento.id_departamento = municipio.id_departamento
					) votos_pais
					INNER JOIN departamento ON departamento.id_departamento = votos_pais.departamento
					INNER JOIN region ON region.id_region = departamento.id_region
				GROUP BY region.id_pais, region.id_region, votos_pais.raza
				ORDER BY region.id_pais
			) voto_por_raza
		GROUP BY voto_por_raza.pais, voto_por_raza.region
	) maximo_por_region
    
	INNER JOIN (
				-- votacion de pais y region de solo indigenas = 22 resultados
				SELECT
					region.id_pais AS pais,
					region.id_region AS region,
					SUM(votos_pais.votos) AS votos
				FROM (
						SELECT
							departamento.id_departamento AS departamento,
							municipio.id_municipio AS municipio,
							(votacion.alfabetos + votacion.analfabetos) AS votos
						FROM votacion
							INNER JOIN raza ON raza.id_raza = votacion.id_raza and raza.nombre_raza = 'INDIGENAS'
							INNER JOIN municipio ON votacion.id_municipio = municipio.id_municipio
							INNER JOIN departamento ON departamento.id_departamento = municipio.id_departamento
					) votos_pais
					INNER JOIN departamento ON departamento.id_departamento = votos_pais.departamento
					INNER JOIN region ON region.id_region = departamento.id_region
				GROUP BY region.id_pais, region.id_region
				ORDER BY region.id_pais
                ) voto_de_indigenas on voto_de_indigenas.pais = maximo_por_region.pais and voto_de_indigenas.region = maximo_por_region.region and voto_de_indigenas.votos = maximo_por_region.votos
	INNER JOIN pais on pais.id_pais = voto_de_indigenas.pais
    INNER JOIN region on region.id_region = voto_de_indigenas.region;








-- ************************************
-- 5. 10 resultados
-- ************************************

SELECT
	pais.nombre_pais,
    departamento.nombre_departamento,
    municipio.nombre_municipio,
    ROUND( (votos_educacion.primaria / votos_municipio.votos )*100 ,2) as primaria ,
    ROUND( (votos_educacion.media  / votos_municipio.votos )*100 ,2) as medio ,
    ROUND( (votos_educacion.universitario  / votos_municipio.votos )*100 ,2) as universitario,
    votos_educacion.universitario AS votos
FROM (
		-- votacion a nivel de municipio por pais y su departamento = 1169
		SELECT
			region.id_pais AS pais,
			votos_pais.departamento as departamento,
			votos_pais.municipio as municipio,
			SUM(votos_pais.votos_primaria) AS primaria,
			SUM(votos_pais.votos_educacion_media) as media,
			SUM(votos_pais.votos_universitario) as universitario
		FROM (
				SELECT
					departamento.id_departamento AS departamento,
					municipio.id_municipio AS municipio,
					votacion.primaria AS votos_primaria,
					votacion.educacion_media as votos_educacion_media,
					votacion.universitario as votos_universitario
				FROM votacion
					INNER JOIN sexo ON  sexo.id_sexo = votacion.id_sexo
					INNER JOIN raza ON  raza.id_raza = votacion.id_raza
					INNER JOIN municipio ON votacion.id_municipio = municipio.id_municipio
					INNER JOIN departamento ON departamento.id_departamento = municipio.id_departamento
			) votos_pais
			INNER JOIN departamento ON departamento.id_departamento = votos_pais.departamento
			INNER JOIN region ON region.id_region = departamento.id_region
		GROUP BY region.id_pais,votos_pais.departamento, votos_pais.municipio
	) votos_educacion
    
    INNER JOIN (
				-- votacion a nivel de municipio por pais y su departamento = 1169
				SELECT
					region.id_pais AS pais,
					votos_pais.departamento as departamento,
					votos_pais.municipio as municipio,
					SUM(votos_pais.votos) AS votos
				FROM (
						SELECT
							departamento.id_departamento AS departamento,
							municipio.id_municipio AS municipio,
							(votacion.alfabetos + votacion.analfabetos) AS votos
						FROM votacion
							INNER JOIN sexo ON  sexo.id_sexo = votacion.id_sexo
							INNER JOIN raza ON  raza.id_raza = votacion.id_raza
							INNER JOIN municipio ON votacion.id_municipio = municipio.id_municipio
							INNER JOIN departamento ON departamento.id_departamento = municipio.id_departamento
					) votos_pais
					INNER JOIN departamento ON departamento.id_departamento = votos_pais.departamento
					INNER JOIN region ON region.id_region = departamento.id_region
				GROUP BY region.id_pais,votos_pais.departamento, votos_pais.municipio
                ) votos_municipio on votos_municipio.pais = votos_educacion.pais 
				and votos_municipio.departamento = votos_educacion.departamento and votos_municipio.municipio = votos_educacion.municipio
	
    INNER JOIN pais on pais.id_pais = votos_educacion.pais
    INNER JOIN departamento on departamento.id_departamento = votos_educacion.departamento
    INNER JOIN municipio on municipio.id_municipio = votos_educacion.municipio
WHERE  ROUND( (votos_educacion.primaria / votos_municipio.votos )*100 ,2) <= 25 AND ROUND( (votos_educacion.media  / votos_municipio.votos )*100 ,2) >=30
AND ROUND( (votos_educacion.universitario  / votos_municipio.votos )*100 ,2) > 25 AND ROUND( (votos_educacion.universitario  / votos_municipio.votos )*100 ,2) <30
ORDER BY  ROUND( (votos_educacion.universitario  / votos_municipio.votos )*100 ,2);



-- ************************************
-- 6. 
-- ************************************
SELECT 
	pais.nombre_pais as pais,
    departamento.nombre_departamento as departamento,
    ROUND( (mujeres.votos / votos_departamento.votos) *100 ,2) as mujeres_universitarias,
    ROUND( (hombres.votos / votos_departamento.votos) *100 ,2) as hombres_universitarios
FROM (
		-- votacion por pais = 81 ( solo mujeres) 
		SELECT
			region.id_pais AS pais,
			votos_pais.departamento as departamento,
			SUM(votos_pais.votos) AS votos
		FROM (
				SELECT
					departamento.id_departamento AS departamento,
					municipio.id_municipio AS municipio,
					votacion.universitario AS votos
				FROM votacion
					INNER JOIN sexo ON  sexo.id_sexo = votacion.id_sexo and sexo.nombre_sexo = 'mujeres'
					INNER JOIN raza ON  raza.id_raza = votacion.id_raza
					INNER JOIN municipio ON votacion.id_municipio = municipio.id_municipio
					INNER JOIN departamento ON departamento.id_departamento = municipio.id_departamento
			) votos_pais
			INNER JOIN departamento ON departamento.id_departamento = votos_pais.departamento
			INNER JOIN region ON region.id_region = departamento.id_region
		GROUP BY region.id_pais, votos_pais.departamento
		ORDER BY region.id_pais
        ) mujeres
		INNER JOIN (
			-- votacion por pais = 81 ( solo hombres) 
			SELECT
				region.id_pais AS pais,
				votos_pais.departamento as departamento,
				SUM(votos_pais.votos) AS votos
			FROM (
					SELECT
						departamento.id_departamento AS departamento,
						municipio.id_municipio AS municipio,
						votacion.universitario AS votos
					FROM votacion
						INNER JOIN sexo ON  sexo.id_sexo = votacion.id_sexo and sexo.nombre_sexo = 'hombres'
						INNER JOIN raza ON  raza.id_raza = votacion.id_raza
						INNER JOIN municipio ON votacion.id_municipio = municipio.id_municipio
						INNER JOIN departamento ON departamento.id_departamento = municipio.id_departamento
				) votos_pais
				INNER JOIN departamento ON departamento.id_departamento = votos_pais.departamento
				INNER JOIN region ON region.id_region = departamento.id_region
			GROUP BY region.id_pais, votos_pais.departamento
			ORDER BY region.id_pais
		) hombres  ON hombres.pais = mujeres.pais and  hombres.departamento = mujeres.departamento      
        INNER JOIN (
					-- votacion por pais, departamento
					SELECT
						region.id_pais AS pais,
						votos_pais.departamento as departamento,
						SUM(votos_pais.votos) AS votos
					FROM (
							SELECT
								departamento.id_departamento AS departamento,
								municipio.id_municipio AS municipio,
								(votacion.alfabetos + votacion.analfabetos) AS votos
							FROM votacion
								INNER JOIN sexo ON  sexo.id_sexo = votacion.id_sexo
								INNER JOIN raza ON  raza.id_raza = votacion.id_raza
								INNER JOIN municipio ON votacion.id_municipio = municipio.id_municipio
								INNER JOIN departamento ON departamento.id_departamento = municipio.id_departamento
						) votos_pais
						INNER JOIN departamento ON departamento.id_departamento = votos_pais.departamento
						INNER JOIN region ON region.id_region = departamento.id_region
					GROUP BY region.id_pais, votos_pais.departamento
					ORDER BY region.id_pais
        ) votos_departamento on votos_departamento.pais = mujeres.pais and  votos_departamento.departamento = mujeres.departamento
        and votos_departamento.pais = hombres.pais and  votos_departamento.departamento = hombres.departamento
        INNER JOIN pais on pais.id_pais = mujeres.pais
        INNER JOIN departamento on departamento.id_departamento = mujeres.departamento
WHERE ROUND( (mujeres.votos / votos_departamento.votos) *100 ,2) > ROUND( (hombres.votos / votos_departamento.votos) *100 ,2);







-- ************************************
-- 7. pais, region y departamento porcentaje
-- totol = 81
-- ************************************
select
	pais.nombre_pais,
    region.nombre_region,
    (voto_por_region.votos / departamento_pais.total) as total_votos
from (
		-- votacion por pais y region = 22 resultados 
		SELECT
			region.id_pais AS pais,
			region.id_region as region,
			SUM(mujer_indigena.votos) AS votos
		FROM (
				SELECT
					departamento.id_departamento AS departamento,
					municipio.id_municipio AS municipio,
					(votacion.alfabetos + votacion.analfabetos) AS votos
				FROM votacion
					INNER JOIN sexo ON  sexo.id_sexo = votacion.id_sexo
					INNER JOIN raza ON  raza.id_raza = votacion.id_raza
					INNER JOIN municipio ON votacion.id_municipio = municipio.id_municipio
					INNER JOIN departamento ON departamento.id_departamento = municipio.id_departamento
			) mujer_indigena
			INNER JOIN departamento ON departamento.id_departamento = mujer_indigena.departamento
			INNER JOIN region ON region.id_region = departamento.id_region
		GROUP BY region.id_pais, region.id_region
	) voto_por_region
    inner join (
				-- departamentos por region por pais = 22
				select 
					pais.id_pais as pais,
                    region.id_region as region,
					count(departamento.id_departamento) as total
				from departamento
					inner join region on region.id_region = departamento.id_region
					inner join pais on pais.id_pais = region.id_pais
				group by pais.id_pais, region.id_region
                ) departamento_pais on departamento_pais.pais = voto_por_region.pais and departamento_pais.region = voto_por_region.region
	inner join pais on pais.id_pais = voto_por_region.pais
    inner join region on region.id_region = voto_por_region.region;






-- ************************************
-- 8. Desplegar total de votos de cada nivel de escolaridad
-- por pais = 6 paises
-- ************************************
SELECT 
	pais.nombre_pais AS pais,
	SUM(votaciones.primaria) AS primaria,
	SUM(votaciones.nivel_medio) AS nivel_medio,
    SUM(votaciones.universitario) AS universitarios
FROM (
		-- votaciones = 20970 
		SELECT
			votacion.primaria AS primaria,
			votacion.educacion_media AS nivel_medio,
			votacion.universitario AS universitario,
			votacion.id_municipio AS municipio,
            departamento.id_departamento AS departamento
		FROM votacion
			INNER JOIN municipio ON municipio.id_municipio = votacion.id_municipio
            INNER JOIN departamento ON departamento.id_departamento = municipio.id_departamento
	) votaciones
    INNER JOIN departamento ON departamento.id_departamento = votaciones.departamento
    INNER JOIN region ON region.id_region = departamento.id_region
    INNER JOIN pais ON pais.id_pais = region.id_pais
GROUP BY region.id_pais;







-- ************************************
-- 9. Desplegar el nombre del pais y el porcentaje de votos por raza
-- ************************************
SELECT 
	pais.nombre_pais AS pais,
    raza.nombre_raza AS raza,
    ROUND( (votacion_por_raza.votos / votos.votos) *100 ,2) AS porcentaje
FROM (
		-- votacion por pais 
		SELECT
			region.id_pais AS pais,
			votos_raza.raza AS raza,
			SUM(votos_raza.votos) AS votos
		FROM (
				SELECT
					departamento.id_departamento AS departamento,
					municipio.id_municipio AS municipio,
					votacion.id_raza AS raza,
					(votacion.alfabetos + votacion.analfabetos) AS votos
				FROM votacion
					INNER JOIN sexo ON  sexo.id_sexo = votacion.id_sexo
					INNER JOIN raza ON  raza.id_raza = votacion.id_raza
					INNER JOIN municipio ON votacion.id_municipio = municipio.id_municipio
					INNER JOIN departamento ON departamento.id_departamento = municipio.id_departamento
			) votos_raza
			INNER JOIN departamento ON departamento.id_departamento = votos_raza.departamento
			INNER JOIN region ON region.id_region = departamento.id_region
		GROUP BY region.id_pais, votos_raza.raza
        ) votacion_por_raza
        INNER JOIN (
					-- votacion por pais 
					SELECT
						region.id_pais AS pais,
						SUM(votos_pais.votos) AS votos
					FROM (
							SELECT
								departamento.id_departamento AS departamento,
								municipio.id_municipio AS municipio,
								(votacion.alfabetos + votacion.analfabetos) AS votos
							FROM votacion
								INNER JOIN sexo ON  sexo.id_sexo = votacion.id_sexo
								INNER JOIN raza ON  raza.id_raza = votacion.id_raza
								INNER JOIN municipio ON votacion.id_municipio = municipio.id_municipio
								INNER JOIN departamento ON departamento.id_departamento = municipio.id_departamento
						) votos_pais
						INNER JOIN departamento ON departamento.id_departamento = votos_pais.departamento
						INNER JOIN region ON region.id_region = departamento.id_region
					GROUP BY region.id_pais
        ) votos ON votos.pais = votacion_por_raza.pais
        INNER JOIN pais ON pais.id_pais = votos.pais
        INNER JOIN raza ON raza.id_raza = votacion_por_raza.raza
ORDER BY pais.id_pais;
        




-- ************************************
-- 10. pais donde la disputa de partidos halla sido mas peliada
-- 1 resultado = el salvador
-- ************************************

SELECT
	pais.nombre_pais as pais,
	mayor_disputa.votos as votos
FROM (
		SELECT
			MIN(disputa_votos.votos) as votos
		FROM (
				SELECT
					mayor.pais as pais,
					(mayor.votos - menor.votos) as votos
				FROM (
						-- partido con mas votos por pais = 6 resultados 
						SELECT
							votacion_por_partido.pais as pais,
							MAX( votacion_por_partido.votos) as votos
						FROM (
								-- votacion de pais por partido
								SELECT
									region.id_pais AS pais,
									votos_pais.partido as partido,
									SUM(votos_pais.votos) AS votos
								FROM (
										SELECT
											departamento.id_departamento AS departamento,
											municipio.id_municipio AS municipio,
											partido.id_partido as partido,
											(votacion.alfabetos + votacion.analfabetos) AS votos
										FROM votacion
											INNER JOIN partido on partido.id_partido = votacion.id_partido
											INNER JOIN municipio ON votacion.id_municipio = municipio.id_municipio
											INNER JOIN departamento ON departamento.id_departamento = municipio.id_departamento
									) votos_pais
									INNER JOIN departamento ON departamento.id_departamento = votos_pais.departamento
									INNER JOIN region ON region.id_region = departamento.id_region
								GROUP BY region.id_pais, votos_pais.partido
							) votacion_por_partido
						GROUP BY votacion_por_partido.pais
					) mayor,
					(
						-- partido con menor votos por pais = 6 resultados 
						SELECT
							votacion_por_partido.pais as pais,
							MIN( votacion_por_partido.votos) as votos
						FROM (
								-- votacion de pais por partido
								SELECT
									region.id_pais AS pais,
									votos_pais.partido as partido,
									SUM(votos_pais.votos) AS votos
								FROM (
										SELECT
											departamento.id_departamento AS departamento,
											municipio.id_municipio AS municipio,
											partido.id_partido as partido,
											(votacion.alfabetos + votacion.analfabetos) AS votos
										FROM votacion
											INNER JOIN partido on partido.id_partido = votacion.id_partido
											INNER JOIN municipio ON votacion.id_municipio = municipio.id_municipio
											INNER JOIN departamento ON departamento.id_departamento = municipio.id_departamento
									) votos_pais
									INNER JOIN departamento ON departamento.id_departamento = votos_pais.departamento
									INNER JOIN region ON region.id_region = departamento.id_region
								GROUP BY region.id_pais, votos_pais.partido
							) votacion_por_partido
						GROUP BY votacion_por_partido.pais
					) menor
				WHERE mayor.pais = menor.pais
			) disputa_votos
	) mayor_disputa
    INNER JOIN (
				SELECT
					mayor.pais as pais,
					(mayor.votos - menor.votos) as votos
				FROM (
						-- partido con mas votos por pais = 6 resultados 
						SELECT
							votacion_por_partido.pais as pais,
							MAX( votacion_por_partido.votos) as votos
						FROM (
								-- votacion de pais por partido
								SELECT
									region.id_pais AS pais,
									votos_pais.partido as partido,
									SUM(votos_pais.votos) AS votos
								FROM (
										SELECT
											departamento.id_departamento AS departamento,
											municipio.id_municipio AS municipio,
											partido.id_partido as partido,
											(votacion.alfabetos + votacion.analfabetos) AS votos
										FROM votacion
											INNER JOIN partido on partido.id_partido = votacion.id_partido
											INNER JOIN municipio ON votacion.id_municipio = municipio.id_municipio
											INNER JOIN departamento ON departamento.id_departamento = municipio.id_departamento
									) votos_pais
									INNER JOIN departamento ON departamento.id_departamento = votos_pais.departamento
									INNER JOIN region ON region.id_region = departamento.id_region
								GROUP BY region.id_pais, votos_pais.partido
							) votacion_por_partido
						GROUP BY votacion_por_partido.pais
					) mayor,
					(
						-- partido con menor votos por pais = 6 resultados 
						SELECT
							votacion_por_partido.pais as pais,
							MIN( votacion_por_partido.votos) as votos
						FROM (
								-- votacion de pais por partido
								SELECT
									region.id_pais AS pais,
									votos_pais.partido as partido,
									SUM(votos_pais.votos) AS votos
								FROM (
										SELECT
											departamento.id_departamento AS departamento,
											municipio.id_municipio AS municipio,
											partido.id_partido as partido,
											(votacion.alfabetos + votacion.analfabetos) AS votos
										FROM votacion
											INNER JOIN partido on partido.id_partido = votacion.id_partido
											INNER JOIN municipio ON votacion.id_municipio = municipio.id_municipio
											INNER JOIN departamento ON departamento.id_departamento = municipio.id_departamento
									) votos_pais
									INNER JOIN departamento ON departamento.id_departamento = votos_pais.departamento
									INNER JOIN region ON region.id_region = departamento.id_region
								GROUP BY region.id_pais, votos_pais.partido
							) votacion_por_partido
						GROUP BY votacion_por_partido.pais
					) menor
				WHERE mayor.pais = menor.pais
		) diferencia_por_pais on diferencia_por_pais.votos = mayor_disputa.votos
        INNER JOIN pais on pais.id_pais = diferencia_por_pais.pais;






			
-- ************************************
-- 11. votos y porcenaje de votos de mujeres alfabetas indigenas
-- ************************************

SELECT 
	pais.nombre_pais AS pais,
    votacion_mujer_indigena.votos AS votos,
    ROUND( (votacion_mujer_indigena.votos / mujeres_pais.votos) * 100 ,2)AS porcentaje
FROM (
		SELECT
			region.id_pais AS pais,
			SUM(mujer_indigena.votos) AS votos
		FROM (
				SELECT
					departamento.id_departamento AS departamento,
					municipio.id_municipio AS municipio,
					votacion.alfabetos AS votos
				FROM votacion
					INNER JOIN sexo ON  sexo.id_sexo = votacion.id_sexo and sexo.nombre_sexo like 'mujeres'
					INNER JOIN raza ON  raza.id_raza = votacion.id_raza and raza.nombre_raza like 'INDIGENAS'
					INNER JOIN municipio ON votacion.id_municipio = municipio.id_municipio
					INNER JOIN departamento ON departamento.id_departamento = municipio.id_departamento
			) mujer_indigena
			INNER JOIN departamento ON departamento.id_departamento = mujer_indigena.departamento
			INNER JOIN region ON region.id_region = departamento.id_region
		GROUP BY region.id_pais
	) votacion_mujer_indigena
    INNER JOIN (
				-- votacion por pais
				SELECT
					region.id_pais AS pais,
					SUM(mujer_indigena.votos) AS votos
				FROM (
						SELECT
							departamento.id_departamento AS departamento,
							municipio.id_municipio AS municipio,
							(votacion.alfabetos + votacion.analfabetos) AS votos
						FROM votacion
							INNER JOIN sexo ON  sexo.id_sexo = votacion.id_sexo
							INNER JOIN raza ON  raza.id_raza = votacion.id_raza
							INNER JOIN municipio ON votacion.id_municipio = municipio.id_municipio
							INNER JOIN departamento ON departamento.id_departamento = municipio.id_departamento
					) mujer_indigena
					INNER JOIN departamento ON departamento.id_departamento = mujer_indigena.departamento
					INNER JOIN region ON region.id_region = departamento.id_region
				GROUP BY region.id_pais
    ) mujeres_pais ON mujeres_pais.pais = votacion_mujer_indigena.pais
    INNER JOIN pais ON pais.id_pais = mujeres_pais.pais;






-- ************************************
-- 12. resultado = 1
-- ************************************

SELECT
	pais.nombre_pais,
	maximo.porcentaje
FROM (
		SELECT
			MAX( porcentaje_por_pais.porcentaje ) as porcentaje
		FROM (
				SELECT 
					analfabeta_por_pais.pais as pais,
					ROUND( (analfabeta_por_pais.votos / votacion_por_pais.votos) * 100 ,2) as porcentaje
				FROM (
						-- votacion por pais de personas analfabetas
						SELECT
							region.id_pais AS pais,
							SUM(votos_pais.votos) AS votos
						FROM (
								SELECT
									departamento.id_departamento AS departamento,
									municipio.id_municipio AS municipio,
									votacion.analfabetos AS votos
								FROM votacion
									INNER JOIN sexo ON  sexo.id_sexo = votacion.id_sexo
									INNER JOIN raza ON  raza.id_raza = votacion.id_raza
									INNER JOIN municipio ON votacion.id_municipio = municipio.id_municipio
									INNER JOIN departamento ON departamento.id_departamento = municipio.id_departamento
							) votos_pais
							INNER JOIN departamento ON departamento.id_departamento = votos_pais.departamento
							INNER JOIN region ON region.id_region = departamento.id_region
						GROUP BY region.id_pais
					) analfabeta_por_pais
					
					INNER JOIN (
								-- votacion por pais 
								SELECT
									region.id_pais AS pais,
									SUM(votos_pais.votos) AS votos
								FROM (
										SELECT
											departamento.id_departamento AS departamento,
											municipio.id_municipio AS municipio,
											(votacion.alfabetos + votacion.analfabetos) AS votos
										FROM votacion
											INNER JOIN sexo ON  sexo.id_sexo = votacion.id_sexo
											INNER JOIN raza ON  raza.id_raza = votacion.id_raza
											INNER JOIN municipio ON votacion.id_municipio = municipio.id_municipio
											INNER JOIN departamento ON departamento.id_departamento = municipio.id_departamento
									) votos_pais
									INNER JOIN departamento ON departamento.id_departamento = votos_pais.departamento
									INNER JOIN region ON region.id_region = departamento.id_region
								GROUP BY region.id_pais
								) votacion_por_pais on votacion_por_pais.pais = analfabeta_por_pais.pais
				) porcentaje_por_pais
		) maximo
        
        INNER JOIN (
					SELECT 
						analfabeta_por_pais.pais as pais,
						ROUND( (analfabeta_por_pais.votos / votacion_por_pais.votos) * 100 ,2) as porcentaje
					FROM (
							-- votacion por pais de personas analfabetas
							SELECT
								region.id_pais AS pais,
								SUM(votos_pais.votos) AS votos
							FROM (
									SELECT
										departamento.id_departamento AS departamento,
										municipio.id_municipio AS municipio,
										votacion.analfabetos AS votos
									FROM votacion
										INNER JOIN sexo ON  sexo.id_sexo = votacion.id_sexo
										INNER JOIN raza ON  raza.id_raza = votacion.id_raza
										INNER JOIN municipio ON votacion.id_municipio = municipio.id_municipio
										INNER JOIN departamento ON departamento.id_departamento = municipio.id_departamento
								) votos_pais
								INNER JOIN departamento ON departamento.id_departamento = votos_pais.departamento
								INNER JOIN region ON region.id_region = departamento.id_region
							GROUP BY region.id_pais
						) analfabeta_por_pais
						
						INNER JOIN (
									-- votacion por pais 
									SELECT
										region.id_pais AS pais,
										SUM(votos_pais.votos) AS votos
									FROM (
											SELECT
												departamento.id_departamento AS departamento,
												municipio.id_municipio AS municipio,
												(votacion.alfabetos + votacion.analfabetos) AS votos
											FROM votacion
												INNER JOIN sexo ON  sexo.id_sexo = votacion.id_sexo
												INNER JOIN raza ON  raza.id_raza = votacion.id_raza
												INNER JOIN municipio ON votacion.id_municipio = municipio.id_municipio
												INNER JOIN departamento ON departamento.id_departamento = municipio.id_departamento
										) votos_pais
										INNER JOIN departamento ON departamento.id_departamento = votos_pais.departamento
										INNER JOIN region ON region.id_region = departamento.id_region
									GROUP BY region.id_pais
									) votacion_por_pais on votacion_por_pais.pais = analfabeta_por_pais.pais
						) porcentaje_por_pais on porcentaje_por_pais.porcentaje = maximo.porcentaje
                        
                        INNER JOIN pais on pais.id_pais = porcentaje_por_pais.pais;







-- ************************************
-- 13. 
-- ************************************

SELECT
	voto_por_departamento.pais,
    voto_por_departamento.departamento,
    voto_por_departamento.votos
FROM (
		-- votacion de todoso los departamento de Guatemala = 22 departamentos
		SELECT
			pais.nombre_pais AS pais,
			departamento.nombre_departamento as departamento,
			SUM(votos_pais.votos) AS votos
		FROM (
				SELECT
					departamento.id_departamento AS departamento,
					municipio.id_municipio AS municipio,
					(votacion.alfabetos + votacion.analfabetos) AS votos
				FROM votacion
					INNER JOIN sexo ON  sexo.id_sexo = votacion.id_sexo
					INNER JOIN raza ON  raza.id_raza = votacion.id_raza
					INNER JOIN municipio ON votacion.id_municipio = municipio.id_municipio
					INNER JOIN departamento ON departamento.id_departamento = municipio.id_departamento
			) votos_pais
			INNER JOIN departamento ON departamento.id_departamento = votos_pais.departamento
			INNER JOIN region ON region.id_region = departamento.id_region
			INNER JOIN pais on pais.id_pais = region.id_pais and pais.nombre_pais = 'Guatemala'
		GROUP BY region.id_pais, departamento.nombre_departamento
	) voto_por_departamento,
	(    
		-- votos de solo pais y departamento de Guatemala
		SELECT
			pais.nombre_pais AS pais,
			departamento.nombre_departamento as departamento,
			SUM(votos_pais.votos) AS votos
		FROM (
				SELECT
					departamento.id_departamento AS departamento,
					municipio.id_municipio AS municipio,
					(votacion.alfabetos + votacion.analfabetos) AS votos
				FROM votacion
					INNER JOIN sexo ON  sexo.id_sexo = votacion.id_sexo
					INNER JOIN raza ON  raza.id_raza = votacion.id_raza
					INNER JOIN municipio ON votacion.id_municipio = municipio.id_municipio
					INNER JOIN departamento ON departamento.id_departamento = municipio.id_departamento
			) votos_pais
			INNER JOIN departamento ON departamento.id_departamento = votos_pais.departamento and departamento.nombre_departamento = 'Guatemala'
			INNER JOIN region ON region.id_region = departamento.id_region
			INNER JOIN pais on pais.id_pais = region.id_pais and pais.nombre_pais = 'Guatemala'
		GROUP BY region.id_pais, departamento.nombre_departamento
	) departamento_guatemala 
WHERE voto_por_departamento.votos > departamento_guatemala.votos;



-- consulta para hacer conteos de las de las consultas
