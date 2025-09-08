CREATE DATABASE RegistroDePublicaciones
GO

USE RegistroDePublicaciones

--Crear la tabla UBICACION
CREATE TABLE Ubicacion (
    Id INT IDENTITY(1,1) 
    CONSTRAINT pk_Ubicacion_Id PRIMARY KEY(Id),
    Pais VARCHAR(80) NOT NULL,
    Deparamento VARCHAR(80) NULL,
    Ciudad VARCHAR(80) NULL
)

--Crear la tabla EDITORIAL
CREATE TABLE Editorial (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(150) NOT NULL,
    IdUbicacion INT NULL,
    CONSTRAINT fk_Editorial_IdUbicacion FOREIGN KEY (IdUbicacion) REFERENCES Ubicacion(Id)
)

--Crear la tabla TIPOPUBLICACION
CREATE TABLE TipoPublicacion (
    Id INT IDENTITY NOT NULL,
    CONSTRAINT pk_TipoPublicacion_Id PRIMARY KEY(Id),
    Nombre VARCHAR(40) NOT NULL UNIQUE
)

--Crear la tabla TITULOSERIADO
CREATE TABLE TituloSeriado (
    Id INT IDENTITY NOT NULL, 
    CONSTRAINT pk_TituloSeriado_Id PRIMARY KEY(Id),
    Titulo VARCHAR(300) NOT NULL,
    issn   VARCHAR(20) UNIQUE NULL,
    IdEditorial      INT NOT NULL,
    CONSTRAINT fk_TituloSeriado_IdEditorial FOREIGN KEY (IdEditorial) REFERENCES Editorial(Id)
)

-- Crear la tabla PUBLICACION
CREATE TABLE Publicacion(
 Id INT IDENTITY NOT NULL, 
    CONSTRAINT pk_Publicacion_Id PRIMARY KEY(Id),
    Titulo           VARCHAR(300) NOT NULL,
    Año SMALLINT NULL CHECK (Año >= 1000 AND Año <= YEAR(GETDATE())),
    Edicion          VARCHAR(50) NULL,
    Notas            VARCHAR(500) NULL,
    IdTipoPublicacion INT NOT NULL,
    IdEditorial       INT NULL,
    CONSTRAINT fk_Publicacion_TipoPublicacion FOREIGN KEY (IdTipoPublicacion) REFERENCES TipoPublicacion(Id),
    CONSTRAINT fk_Publicacion_Editorial FOREIGN KEY (IdEditorial) REFERENCES Editorial(Id)
)

--Craer los indices de la tabla PUBLICACION
CREATE UNIQUE INDEX ix_Publicacion_Titulo 
    ON Publicacion(Titulo);

--Crear la tabala DetallesLibro
CREATE TABLE DetallesLibro(
Id INT IDENTITY NOT NULL, 
    CONSTRAINT pk_DetallesLibro_Id PRIMARY KEY(Id),
    IdPublicacion int NOT NULL,
    isbn       VARCHAR(20) NOT NULL UNIQUE,
    paginas    INT  NULL,
    CONSTRAINT fk_DetallesLibro_IdPublicacion FOREIGN KEY (IdPublicacion) REFERENCES Publicacion(Id)
        ON DELETE CASCADE
)

--Crear la tabla NumeroSeriado
CREATE TABLE NumeroSeriado (
IdPublicacion int  NOT NULL,
CONSTRAINT fk_NumeroSeriado_IdPublicacion 
        FOREIGN KEY (IdPublicacion) REFERENCES Publicacion(Id)
    ON DELETE CASCADE,
    IdTituloSeriado INT NOT NULL,
    CONSTRAINT fk_NumeroSeriado_IdTituloSeriado 
        FOREIGN KEY (IdTituloSeriado) REFERENCES TituloSeriado(Id),
    Volumen           INT NULL CHECK (Volumen > 0),
    NumeroEmision   INT NULL CHECK (NumeroEmision > 0),
    FechaEmision     DATE NULL,
    CONSTRAINT pk_NumeroSeriado 
        PRIMARY KEY(IdPublicacion, IdTituloSeriado)
)

--Craer indice de la tabla NUMEROSERIADO
CREATE UNIQUE INDEX ix_NumeroSeriado_Compuesto 
ON NumeroSeriado(IdTituloSeriado, Volumen, NumeroEmision, FechaEmision)


--Crear la tabla AUTOR
CREATE TABLE Autor (
    Id INT IDENTITY NOT NULL,
    CONSTRAINT pk_Autor_Id PRIMARY KEY(Id),
    TipoAutor CHAR(1) NOT NULL CHECK (TipoAutor IN ('P','C')) -- P=Persona, C=Corporativo
);

--Crear la tabla PERSONAAUTOR
CREATE TABLE PersonaAutor (
    IdAutor  INT PRIMARY KEY,
    Nombre    VARCHAR(80)  NOT NULL,
    CONSTRAINT fk_PersonaAutor_IdAutor
        FOREIGN KEY (IdAutor) REFERENCES Autor(Id)
        ON DELETE CASCADE
);

--Crear indices de la tabla PERSONAAUTOR
CREATE UNIQUE INDEX ix_PersonaAutor_Nombre 
ON PersonaAutor(Nombre);

--Crear la tabla CORPORATIVOAUTOR
CREATE TABLE CorporativoAutor (
    IdAutor  INT PRIMARY KEY,
    NombreOrganizacion VARCHAR(200) NOT NULL,
    CONSTRAINT fk_CorporativoAutor_IdAutor
        FOREIGN KEY (IdAutor) REFERENCES Autor(Id)
        ON DELETE CASCADE
)

--Crear indice de la tabla CORPORATIVOAUTOR
CREATE UNIQUE INDEX ix_CorporativoAutor_Nombre 
ON CorporativoAutor(NombreOrganizacion)

--Crear la tabla PUBLICACIONAUTOR
CREATE TABLE PublicacionAutor (
    IdPublicacion INT NOT NULL,
    IdAutor       INT NOT NULL,
    Orden   INT NOT NULL,
    Rol            VARCHAR(50) NULL,
    CONSTRAINT pk_PublicacionAutor PRIMARY KEY (IdPublicacion, IdAutor),
    CONSTRAINT pk_IdPublicacion_Orden UNIQUE (IdPublicacion, Orden),
    CONSTRAINT fk_PublicacionAutor_IdPublicacion FOREIGN KEY (IdPublicacion)
        REFERENCES Publicacion(Id) ON DELETE CASCADE,
    CONSTRAINT fk_PublicacionAutor_IdAutor FOREIGN KEY (IdAutor)
        REFERENCES Autor(Id) ON DELETE CASCADE
)

--Crear indice de la tabla PUBLICACIONAUTOR
CREATE UNIQUE INDEX ix_PublicacionAutor_Autor 
ON PublicacionAutor(IdAutor, Orden)


--Crear la tabla DESCRIPTOR
CREATE TABLE Descriptor (
    Id INT IDENTITY NOT NULL,
    CONSTRAINT pk_Descriptor_Id PRIMARY KEY(Id),
    Terminos      VARCHAR(100) NOT NULL UNIQUE
)

--Crear la tabla PUBLICACIONDESCRIPTOR
CREATE TABLE PublicacionDescriptor (
    IdPublicacion INT NOT NULL,
    IdDescriptor  INT NOT NULL,
    CONSTRAINT pk_PublicacionDescriptor PRIMARY KEY (IdPublicacion, IdDescriptor),
    CONSTRAINT fk_PublicacionDescriptor_IdPublicacion FOREIGN KEY (IdPublicacion)
        REFERENCES Publicacion(Id) ON DELETE CASCADE,
    CONSTRAINT fk_PublicacionDescriptor_IdDescriptor FOREIGN KEY (IdDescriptor)
        REFERENCES Descriptor(Id) ON DELETE CASCADE
)

--Craer indice de la tabla PUBLICACIONDESCRIPTOR
CREATE UNIQUE INDEX ix_PublicacionDescriptor_Descriptor 
ON PublicacionDescriptor(IdDescriptor)