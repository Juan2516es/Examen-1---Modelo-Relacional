USE DivisionPolitica
GO

--Verificar si el país existe
DECLARE @IdPais INT
SELECT @IdPais=Id FROM Pais WHERE Nombre='Japón'

IF @IdPais IS NULL
BEGIN

  --Obtener el codigo del continente
  DECLARE @IdContinente int 
  SELECT @IdContinente=Id FROM Continente WHERE Nombre='Asia'

  IF @IdContinente IS NULL
  BEGIN
   INSERT INTO Continente
   (Nombre)
  VALUES('Asia')
 SET @IdContinente=@@IDENTITY
END

 --Obtener el codigo de Tipo Region
 DECLARE @IdTipoRegion int 
  SELECT @IdTipoRegion=Id FROM TipoRegion WHERE TipoRegion='Perfectura'

  IF @IdTipoRegion IS NULL
  BEGIN
   INSERT INTO TipoRegion
   (TipoRegion)
  VALUES('Perfectura')
 SET @IdTipoRegion=@@IDENTITY
END

--Agregar el PAIS
	INSERT INTO Pais
		(Nombre, IdContinente, IdTipoRegion)
		VALUES('Japón', @IdContinente, @IdTipoRegion)
END

CREATE TABLE #DatosJapon(
	Prefectura varchar(50) NOT NULL, 
	Capital varchar(50) NOT NULL, 
	Area float NULL, 
	Poblacion int NULL
	)

BULK INSERT #DatosJapon
	FROM '"J:\ITM VIRTUAL\3SEMESTRE\Fundamentos y Diseño de Bases de Datos\Japon.csv"'
	WITH ( DATAFILETYPE = 'CHAR', FIELDTERMINATOR = ',')

INSERT INTO Region
	(Nombre, IdPais, Area, Poblacion)
	SELECT Prefectura, @IdPais, Area, Poblacion 
		FROM #DatosJapon


--Verificando las actualizaciones
SELECT *
	FROM Pais P 
		JOIN Region R ON P.Id=R.IdPais
		--JOIN Ciudad C ON R.Id=C.IdRegion
	WHERE P.Nombre='Japón'



--2. En la anterior base de datos, se desea realizar los siguientes cambios en el modelo relacional (sin pérdida de la información existente):
-- Desnormalización en la tabla Pais de la información de la Moneda.
-- Agregar campos para imágenes del Mapa y la Bandera del País.

--Agregar el país
INSERT INTO Pais
(Nombre, IdContinente, IdTipoRegion)
VALUES('Japón', @IdContinente, @IdTipoRegion)

END

ALTER TABLE Pais
ADD Moneda VARCHAR(50);

-- Agregar campos para bandera y mapa (solo rutas o nombres)
ALTER TABLE Pais
ADD Bandera VARCHAR(255),
    Mapa VARCHAR(255);

-- Actualizar el país Japón con su moneda
UPDATE Pais
SET Moneda = 'Yen Japonés'
WHERE Nombre = 'Japón';

-- Verificar cambios
SELECT * FROM Pais WHERE Nombre = 'Japón';