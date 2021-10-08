use Proyecto;

-- tabla de pais
CREATE TABLE pais(
	id_pais INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre_pais VARCHAR(100)
);

-- tabla de regiones
CREATE TABLE region(
	id_region INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre_region VARCHAR(100)
);

-- tabla de departamentos
CREATE TABLE departamento(
	id_departamento INT NOT NULL AUTO_INCREMENT,
    nombre_departamento VARCHAR(100),
    id_region INT NOT NULL,
    id_pais INT NOT NULL,
    PRIMARY KEY (id_departamento,id_region,id_pais),
    FOREIGN KEY (id_pais) REFERENCES pais(id_pais),
    FOREIGN KEY (id_region) REFERENCES region(id_region)
);


-- tabla para partidos politicos
CREATE TABLE partido(
    id_partido INT NOT NULL AUTO_INCREMENT,
    nombre_partido VARCHAR(100),
    siglas_partido VARCHAR(100),
    id_pais INT NOT NULL,
    PRIMARY KEY (id_partido,id_pais),
    FOREIGN KEY (id_pais) REFERENCES pais (id_pais)
);

-- tabla para municipios
CREATE TABLE municipio(
    id_municipio INT NOT NULL AUTO_INCREMENT,
    nombre_municipio VARCHAR(100),
    id_departamento INT NOT NULL,
    PRIMARY KEY (id_municipio,id_departamento),
    FOREIGN KEY (id_departamento) REFERENCES departamento (id_departamento)
);


-- tabla para raza
CREATE TABLE raza(
    id_raza INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre_raza VARCHAR(50)
);


-- tabla para sexo de las personas
CREATE TABLE sexo(
    id_sexo INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre_sexo VARCHAR(50)
);


-- tabla para votaciones
CREATE TABLE votacion(
    id_raza INT NOT NULL,
    id_sexo INT NOT NULL,
    id_municipio INT NOT NULL,
    id_partido INT NOT NULL,
    analfabetos INT NOT NULL,
    alfabetos INT NOT NULL,
    primaria INT NOT NULL,
    educacion_meia INT NOT NULL,
    universitario INT NOT NULL,
    anio_votacion INT NOT NULL
);