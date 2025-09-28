--¿Cuántas canciones ha compuesto "JUANES"?
SELECT C.Nombre Compositor,
  COUNT(DISTINCT CC.IdCancion) Canciones
    FROM CancionCompositor CC
         JOIN Compositor C ON CC.IdCompositor = C.Id
WHERE CHARINDEX('JUANES', UPPER (C.Nombre)) > 0
GROUP BY C.Nombre
 

 --¿Qué interpretaciones se tienen de la canción “Lluvia” y en qué ritmos?
 SELECT IT.Id Interpretaciones, I.Nombre Interprete, R.Ritmo, IT.Duracion, C.Titulo
FROM Interpretacion IT
JOIN Cancion C ON IT.IdCancion = C.Id
JOIN Interprete I ON IT.IdInterprete = I.Id
JOIN Ritmo R ON IT.IdRitmo = R.Id
WHERE C.Titulo = 'Lluvia'

--¿Qué canciones hay con el mismo Intérprete y Compositor del ritmo “Balada”?
SELECT DISTINCT C.Titulo Cancion, I.Nombre Interprete, T.Tipo, CP.Nombre Compositor, R.Ritmo Ritmo
FROM Interpretacion IT
JOIN Interprete I   ON IT.IdInterprete = I.Id
JOIN Tipo T         ON I.IdTipo = T.Id
JOIN Cancion C      ON IT.IdCancion = C.Id
JOIN Ritmo R        ON IT.IdRitmo = R.Id
JOIN CancionCompositor CC ON CC.IdCancion = C.Id
JOIN Compositor CP ON CC.IdCompositor = CP.Id
WHERE UPPER(R.Ritmo) = 'BALADA'
  AND UPPER(T.Tipo) = 'SOLISTA'
  AND CHARINDEX(UPPER(I.Nombre), UPPER(CP.Nombre)) > 0
ORDER BY C.Titulo


--¿Listar los países que tienen grupos del ritmo “Salsa”? 
SELECT DISTINCT P.Pais
FROM Interpretacion IT
JOIN Interprete I ON IT.IdInterprete = I.Id
JOIN Tipo T       ON I.IdTipo = T.Id
JOIN Ritmo R      ON IT.IdRitmo = R.Id
JOIN Pais P       ON I.IdPais = P.Id
WHERE R.Ritmo = 'Salsa'
  AND T.Tipo = 'Grupo'
ORDER BY P.Pais

--¿Quiénes interpretan "Candilejas" y "Malaguena"?
SELECT DISTINCT C.Titulo Cancion, I.Nombre Interprete
FROM Interpretacion IT
JOIN Cancion C    ON IT.IdCancion = C.Id
JOIN Interprete I ON IT.IdInterprete = I.Id
WHERE C.Titulo IN ('Candilejas','Malaguena')
ORDER BY C.Titulo, I.Nombre

--Listar artistas que son intérpretes y compositores a la vez y con cuantas canciones compuestas e interpretadas
SELECT I.Nombre Artista,
       COUNT(DISTINCT CC.IdCancion) Canciones_Compuestas,
       COUNT(DISTINCT IT.IdCancion) Canciones_Interpretadas
FROM Interprete I
LEFT JOIN Compositor CP ON CHARINDEX(I.Nombre, CP.Nombre) > 0
LEFT JOIN CancionCompositor CC ON CC.IdCompositor = CP.Id
LEFT JOIN Interpretacion IT ON IT.IdInterprete = I.Id
GROUP BY I.Nombre
HAVING COUNT(DISTINCT CC.IdCancion) > 0
   AND COUNT(DISTINCT IT.IdCancion) > 0
ORDER BY Canciones_Compuestas DESC, Canciones_Interpretadas DESC