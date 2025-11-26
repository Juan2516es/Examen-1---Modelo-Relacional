-- 1. Dada la siguiente tabla propuesta por un estudiante :

CREATE TABLE ArtistaCancion (
 IdInterprete INT,
 NombreInterprete NVARCHAR(50),
 IdPais INT,
 Pais NVARCHAR(50),
 IdCancion INT,
 TituloCancion NVARCHAR(50),
 Idiomas NVARCHAR(MAX),  -- "Español, Inglés"
 Ritmo NVARCHAR(50)
)

-- a. Indique TODAS las formas normales que esta tabla NO cumple e identifique por qué.

-- *****Primera Forma Normal (1FN)*****
-- Una tabla NO está en 1FN cuando:
-- * Tiene campos multivalorados o listas
-- * Los datos no son atómicos


-- Esto viola la 1FN porque guarda múltiples valores.
-- El campo [Idiomas] puede tener: "Español, Inglés"
-- Esto NO es atómico → viola 1FN.


-- *****Segunda Forma Normal (2FN)*****
-- Aplica porque la clave sería compuesta:
-- (IdInterprete, IdCancion)


-- Esto viola la 2FN
-- NombreInterprete depende solo de IdInterprete
-- Pais depende solo de IdPais
-- TituloCancion depende solo de IdCancion


-- *****Tercera Forma Normal (3FN)*****
-- Una tabla está en 3FN si:
-- * Está en 2FN
-- * No hay dependencias transitivas


-- Esto viola la 3FN
-- IdInterprete → IdPais → Pais
-- Pais depende de IdPais (atributo no clave).
-- Como IdPais depende de IdInterprete, se forma una dependencia transitiva.


--b. Reescriba el conjunto de tablas normalizadas cumpliendo mínimo hasta 3FN.

CREATE TABLE Interprete(
    IdInterprete INT PRIMARY KEY,
    NombreInterprete NVARCHAR(50),
    IdPais INT NOT NULL
);


CREATE TABLE Pais(
    IdPais INT PRIMARY KEY,
    NombrePais NVARCHAR(50) NOT NULL
);


CREATE TABLE Cancion(
    IdCancion INT PRIMARY KEY,
    TituloCancion NVARCHAR(50),
    Ritmo NVARCHAR(50)
);


CREATE TABLE CancionIdioma(
    IdCancion INT NOT NULL,
    Idioma NVARCHAR(30) NOT NULL,
    PRIMARY KEY(IdCancion, Idioma)
);


CREATE TABLE InterpreteCancion(
    IdInterprete INT NOT NULL,
    IdCancion INT NOT NULL,
    PRIMARY KEY(IdInterprete, IdCancion)
);



-- 2. Analice la tabla Grabacion del modelo entregado:


CREATE TABLE Grabacion (
 IdInterpretacion INT IDENTITY(1,1) NOT NULL,
 IdAlbum INT NOT NULL,
 IdFormato INT NOT NULL,
 CONSTRAINT pkGrabacion PRIMARY KEY (IdInterpretacion, IdAlbum, IdFormato)
);


-- Determine si la tabla Grabacion está en BCNF. Justifique explícitamente usando la definición: “todo determinante debe ser clave”.
-- Si NO estuviera en BCNF, proponga una reestructuración correcta.



-- ***** Boyce-Codd Normal Form (BCNF) *****
-- Toda determinante debe ser clave

-- Según el enunciado:
-- * Una interpretación puede estar en varios álbumes y formatos
-- * En un álbum, no puede repetirse una interpretación en el mismo formato

-- Esto viola BCNF
-- Con solo IdInterpretacion e IdAlbum no se puede identificar la fila, porque falta IdFormato.
-- Por lo tanto IdInterpretacion e IdAlbum no son clave


--Reestructuración para cumplir BCNF


CREATE TABLE InterpretacionAlbum(
    IdInterpretacion INT NOT NULL,
    IdAlbum INT NOT NULL,
    PRIMARY KEY(IdInterpretacion, IdAlbum)
);


CREATE TABLE AlbumFormato(
    IdInterpretacion INT NOT NULL,
    IdAlbum INT NOT NULL,
    IdFormato INT NOT NULL,
    PRIMARY KEY(IdInterpretacion, IdAlbum, IdFormato)
);



--3. En la base de datos, un productor propone una nueva tabla para registrar campañas de promoción:

CREATE TABLE Grabacion(
 IdInterpretacion INT IDENTITY(1,1) NOT NULL,
 IdAlbum INT NOT NULL,
 IdFormato INT NOT NULL,
 CONSTRAINT pkGrabacion PRIMARY KEY (IdInterpretacion, IdAlbum,
IdFormato)
)

--La intención es registrar que una canción de un intérprete se promueve en varias plataformas y en varios países de forma independiente.
 

-- a. Indique si esta tabla viola la 4FN. Justifique usando el concepto de dependencias multivaloradas

-- Esto viola la 4FN porque hay más de una dependencia multivalorada independiente.



-- b. Normalice la tabla cumpliendo la 4FN y la 5FN


CREATE TABLE Interpretacion(
    IdInterpretacion INT PRIMARY KEY,
    Nombre NVARCHAR(100)
);


CREATE TABLE InterpretacionPlataforma(
    IdInterpretacion INT NOT NULL,
    Plataforma NVARCHAR(50) NOT NULL,
    PRIMARY KEY(IdInterpretacion, Plataforma)
);


CREATE TABLE InterpretacionPais(
    IdInterpretacion INT NOT NULL,
    Pais NVARCHAR(50) NOT NULL,
    PRIMARY KEY(IdInterpretacion, Pais)
);


-- Con esta separación cada tabla tiene una sola dependencia multivalorada y se cumple 4FN, también se cumple 5FN porque no quedan dependencias complejas que dividir
