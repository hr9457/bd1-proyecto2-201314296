# DOCUMENTACION 


# Reglas de Normalizacion 


<p></p>

# Modelo
<img src="Imagenes/ER.png" width=500px> 


<p></p>

---
# Listado de Entidades

<p></p>


| Entidad       | Descripcion |
|---------      |-------------| 
| Pais          | Almacena un listado de distintos paises |
| Region        | Guarda las regiones que posee cada pais |
| Departamento  | Almacena diferentes departamentos de cada pais con su region |
| Municipio     | Alamacena cada municipo de cada Departamento |
| Partido       | Guarada cada partido participante de cada pais |
| Sexo          | Almacena los sexos distingibles para cada votatante |
| Raza          | Alamacena todas las razas que tiene participacion en la votacion |
| Seleccion     | Almacena los tipo de elecciones que se efectuaron |
| Votacion      | Guarda todas la votaciones exitentes a nivel de municipo |


<p></p>

# Listado de Atributos

<p></p>

## Pais
| Nombre    | Tipo      | Primary   | Forean    | Unique    | Not Null  |
| ------    | ------    | ------    | ------    | ------    | --------  |
|id_pais    | Integer   |    X      |           |           |  X        |
|nombre_pais|Varchar(100)|          |           |           |  X        |



<p></p>

## Region
| Nombre    | Tipo      | Primary   | Forean    | Unique    | Not Null  |
| ------    | ------    | ------    | ------    | ------    | --------  |
|id_region  | Integer   |    X      |           |           |  X        |
|nombre_region|Varchar(100)|        |           |           |  X        |
|id_pais    | Integer   |           |    X      |           |  X        |




<p></p>

## Departamento
| Nombre    | Tipo      | Primary   | Forean    | Unique    | Not Null  |
| ------    | ------    | ------    | ------    | ------    | --------  |
|id_departamento| Integer   |    X      |       |           |  X        |
|nombre_departamento|Varchar(100)|      |       |           |  X        |
|id_region  | Integer   |           |    X      |           |  X        |




<p></p>

## Municipio
| Nombre    | Tipo      | Primary   | Forean    | Unique    | Not Null  |
| ------    | ------    | ------    | ------    | ------    | --------  |
|id_departamento| Integer   |    X      |       |           |  X        |
|nombre_departamento|Varchar(100)|      |       |           |  X        |
|id_region  | Integer   |           |    X      |           |  X        |



<p></p>

## Partido
| Nombre    | Tipo      | Primary   | Forean    | Unique    | Not Null  |
| ------    | ------    | ------    | ------    | ------    | --------  |
|id_partido | Integer   |    X      |           |           |  X        |
|nombre_partido|Varchar(100)|       |           |           |  X        |
|siglas_partido|Varchar(100)|       |           |           |  X        |
|id_region  | Integer   |           |    X      |           |  X        |



<p></p>

## Sexo
| Nombre    | Tipo      | Primary   | Forean    | Unique    | Not Null  |
| ------    | ------    | ------    | ------    | ------    | --------  |
|id_sexo    | Integer   |    X      |           |           |  X        |
|nombre_sexo|Varchar(50)|           |           |           |  X        |



<p></p>

## Raza
| Nombre    | Tipo      | Primary   | Forean    | Unique    | Not Null  |
| ------    | ------    | ------    | ------    | ------    | --------  |
|id_raza    | Integer   |    X      |           |           |  X        |
|nombre_raza|Varchar(50)|           |           |           |  X        |



<p></p>

## Seleccion
| Nombre    | Tipo      | Primary   | Forean    | Unique    | Not Null  |
| ------    | ------    | ------    | ------    | ------    | --------  |
|id_seleccion| Integer  |    X      |           |           |  X        |
|nombre_seleccion|Varchar(100)|     |           |           |  X        |



<p></p>

## Votacion
| Nombre    | Tipo      | Primary   | Forean    | Unique    | Not Null  |
| ------    | ------    | ------    | ------    | ------    | --------  |
|id_votacion| Integer   |    X      |           |           |  X        |
|analfabeto |Integer    |           |           |           |  X        |
|alfabeto   |Integer    |           |           |           |  X        |
|primaria   |Integer    |           |           |           |  X        |
|nivel_meido|Integer    |           |           |           |  X        |
|universitario|Integer  |           |           |           |  X        |
|id_sexo    | Integer   |           |    X      |           |  X        |
|id_raza    | Integer   |           |    X      |           |  X        |
|id_seleccion| Integer  |           |    X      |           |  X        |
|id_partido | Integer   |           |    X      |           |  X        |
|id_municipio| Integer  |           |    X      |           |  X        |


<p></p>

# Relacion entre Entidades

| Tabla     | Tabla     | Relacion   |
| ------    | ------    | ------     |



# Restriccione para Utilizar 


# Consideraciones del Diseño



