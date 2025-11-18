WITH CantPaises AS ( 
    SELECT 
        M.Id AS IdMoneda,
        COUNT(P.Id) AS TotalPaises
    FROM Moneda M
    LEFT JOIN Pais P ON P.IdMoneda = M.Id
    GROUP BY M.Id
),

UltimoCambio AS (
    SELECT 
        IdMoneda,
        MAX(Fecha) AS UltimaFecha
    FROM CambioMoneda
    GROUP BY IdMoneda
),

ValorUltimo AS (
    SELECT 
        C.IdMoneda,
        C.Cambio AS UltimoCambio
    FROM CambioMoneda C
    INNER JOIN UltimoCambio U
        ON u.IdMoneda = C.IdMoneda
       AND u.UltimaFecha = C.Fecha
),

Promedio30 AS (
    SELECT 
        C.IdMoneda,
        AVG(C.Cambio) AS Promedio30Dias
    FROM CambioMoneda C
    WHERE C.Fecha >= DATEADD(DAY, -30, CAST(GETDATE() AS date))
    GROUP BY C.IdMoneda
)

SELECT
    M.Id,
    M.Moneda,
    M.Sigla,
    CP.TotalPaises,
    UC.UltimaFecha,
    VU.UltimoCambio,
    PR.Promedio30Dias,

    CASE 
        WHEN PR.Promedio30Dias IS NULL THEN 'Baja' 
        WHEN VU.UltimoCambio > PR.Promedio30Dias * 1.03 THEN 'Alta'
        WHEN VU.UltimoCambio BETWEEN PR.Promedio30Dias * 0.97 AND PR.Promedio30Dias * 1.03 THEN 'Media'
        ELSE 'Baja'
    END AS Volatilidad,

    RANK() OVER (ORDER BY CP.TotalPaises DESC) AS RankingUso

FROM Moneda M
LEFT JOIN CantPaises CP ON CP.IdMoneda = M.Id
LEFT JOIN UltimoCambio UC ON UC.IdMoneda = M.Id
LEFT JOIN ValorUltimo VU ON VU.IdMoneda = M.Id
LEFT JOIN Promedio30 PR ON PR.IdMoneda = M.Id
ORDER BY RankingUso, M.Moneda;
