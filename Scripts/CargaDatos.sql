-- paises = 6 
INSERT INTO pais(pais.nombre_pais)
	SELECT 
		DISTINCT pais 
	FROM temporal;

