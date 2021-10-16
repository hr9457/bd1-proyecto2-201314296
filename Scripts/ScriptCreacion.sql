use Proyecto;

-- tabla de pais
CREATE TABLE pais(
	id_pais INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre_pais VARCHAR(100) NOT NULL
);

-- tabla de regiones
CREATE TABLE region(
	id_region INT NOT NULL AUTO_INCREMENT,
    nombre_region VARCHAR(100) NOT NULL,
    id_pais INT NOT NULL,
    PRIMARY KEY (id_region, id_pais),
    FOREIGN KEY (id_pais) REFERENCES pais(id_pais)
);

-- tabla de departamentos
CREATE TABLE departamento(
	id_departamento INT NOT NULL AUTO_INCREMENT,
    nombre_departamento VARCHAR(100) NOT NULL,
    id_region INT NOT NULL,
    PRIMARY KEY (id_departamento,id_region),
    FOREIGN KEY (id_region) REFERENCES region(id_region)
);


-- tabla para partidos politicos
CREATE TABLE partido(
    id_partido INT NOT NULL AUTO_INCREMENT,
    nombre_partido VARCHAR(100) NOT NULL,
    siglas_partido VARCHAR(100) NOT NULL,
    id_pais INT NOT NULL,
    PRIMARY KEY (id_partido,id_pais),
    FOREIGN KEY (id_pais) REFERENCES pais (id_pais)
);

-- tabla para municipios
CREATE TABLE municipio(
    id_municipio INT NOT NULL AUTO_INCREMENT,
    nombre_municipio VARCHAR(100) NOT NULL,
    id_departamento INT NOT NULL,
    PRIMARY KEY (id_municipio,id_departamento),
    FOREIGN KEY (id_departamento) REFERENCES departamento (id_departamento)
);


-- tabla para raza
CREATE TABLE raza(
    id_raza INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre_raza VARCHAR(50) NOT NULL
);


-- tabla para sexo de las personas
CREATE TABLE sexo(
    id_sexo INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre_sexo VARCHAR(50) NOT NULL
);



-- talba para tipo eleccion por anio
CREATE TABLE eleccion(
    id_eleccion INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre_eleccion VARCHAR(100) NOT NULL,
    anio_eleccion INT NOT NULL
);


-- tabla para votaciones
CREATE TABLE votacion(    
    analfabetos INT NOT NULL,
    alfabetos INT NOT NULL,
    primaria INT NOT NULL,
    educacion_media INT NOT NULL,
    universitario INT NOT NULL,
    id_raza INT NOT NULL,
    id_sexo INT NOT NULL,
    id_municipio INT NOT NULL,
    id_partido INT NOT NULL,
    id_eleccion INT NOT NULL,
    PRIMARY KEY (id_raza,id_sexo,id_municipio,id_partido,id_eleccion),
    FOREIGN KEY (id_raza) REFERENCES raza(id_raza),
    FOREIGN KEY (id_sexo) REFERENCES sexo(id_sexo),
    FOREIGN KEY (id_municipio) REFERENCES municipio(id_municipio),
    FOREIGN KEY (id_partido) REFERENCES partido(id_partido),
    FOREIGN KEY (id_eleccion) REFERENCES eleccion(id_eleccion)
);



-- *************************************
-- Eliminacion de tablas
-- *************************************
DROP TABLE votacion; 
DROP TABLE raza;
DROP TABLE eleccion;
DROP TABLE sexo;
DROP TABLE municipio;  
DROP TABLE departamento;
DROP TABLE partido; 
DROP TABLE pais;
DROP TABLE region;

 

