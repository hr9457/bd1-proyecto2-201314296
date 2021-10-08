use Proyecto;

CREATE TABLE temporal(
	nombre_eleccion VARCHAR(100),
    anio_eleccion INT,
    pais VARCHAR(100),
    region VARCHAR(100),
    departamento VARCHAR(100),
    municipio VARCHAR(100),
    partido VARCHAR(100),
    nombre_partido VARCHAR(100),
    sexo VARCHAR(50),
    raza VARCHAR(50),
    analfabetos INT,
    alfabetos INT,
    primaria INT,
    nivel_medio INT,
    universitario INT
);

select * from temporal;
DROP TABLE temporal;