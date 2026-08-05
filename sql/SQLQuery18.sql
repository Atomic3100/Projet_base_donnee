USE TemperatureDB;
GO

/* ============================================================
   1. Année la plus chaude et année la moins chaude
   ============================================================ */

CREATE OR ALTER PROCEDURE dbo.sp_AnneePlusMoinsChaude
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH ToutesTemperatures AS
    (
        SELECT
            2023 AS Annee,
            TemperatureMoyenne
        FROM dbo.Temperature2023

        UNION ALL

        SELECT
            2024,
            TemperatureMoyenne
        FROM dbo.Temperature2024

        UNION ALL

        SELECT
            2025,
            TemperatureMoyenne
        FROM dbo.Temperature2025
    ),
    MoyenneParAnnee AS
    (
        SELECT
            Annee,
            CAST
            (
                AVG(TemperatureMoyenne)
                AS DECIMAL(6,2)
            ) AS TemperatureMoyenne
        FROM ToutesTemperatures
        GROUP BY Annee
    ),
    Classement AS
    (
        SELECT
            Annee,
            TemperatureMoyenne,
            RANK() OVER
            (
                ORDER BY TemperatureMoyenne DESC
            ) AS RangPlusChaude,
            RANK() OVER
            (
                ORDER BY TemperatureMoyenne ASC
            ) AS RangMoinsChaude
        FROM MoyenneParAnnee
    )
    SELECT
        CASE
            WHEN RangPlusChaude = 1
                THEN N'Année la plus chaude'
            ELSE
                N'Année la moins chaude'
        END AS Resultat,
        Annee,
        TemperatureMoyenne,
        N'°C' AS Unite
    FROM Classement
    WHERE RangPlusChaude = 1
       OR RangMoinsChaude = 1
    ORDER BY TemperatureMoyenne DESC;
END;
GO


/* ============================================================
   2. Province la plus chaude et province la moins chaude
   ============================================================ */

CREATE OR ALTER PROCEDURE dbo.sp_ProvincePlusMoinsChaude
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH ToutesTemperatures AS
    (
        SELECT
            ProvinceTerritoire,
            TemperatureMoyenne
        FROM dbo.Temperature2023

        UNION ALL

        SELECT
            ProvinceTerritoire,
            TemperatureMoyenne
        FROM dbo.Temperature2024

        UNION ALL

        SELECT
            ProvinceTerritoire,
            TemperatureMoyenne
        FROM dbo.Temperature2025
    ),
    MoyenneParProvince AS
    (
        SELECT
            ProvinceTerritoire,
            CAST
            (
                AVG(TemperatureMoyenne)
                AS DECIMAL(6,2)
            ) AS TemperatureMoyenne
        FROM ToutesTemperatures
        GROUP BY ProvinceTerritoire
    ),
    Classement AS
    (
        SELECT
            ProvinceTerritoire,
            TemperatureMoyenne,
            RANK() OVER
            (
                ORDER BY TemperatureMoyenne DESC
            ) AS RangPlusChaude,
            RANK() OVER
            (
                ORDER BY TemperatureMoyenne ASC
            ) AS RangMoinsChaude
        FROM MoyenneParProvince
    )
    SELECT
        CASE
            WHEN RangPlusChaude = 1
                THEN N'Province ou territoire le plus chaud'
            ELSE
                N'Province ou territoire le moins chaud'
        END AS Resultat,
        ProvinceTerritoire,
        TemperatureMoyenne,
        N'°C' AS Unite
    FROM Classement
    WHERE RangPlusChaude = 1
       OR RangMoinsChaude = 1
    ORDER BY TemperatureMoyenne DESC;
END;
GO


/* Vérifier la création des deux procédures */
SELECT
    name AS NomProcedure,
    create_date AS DateCreation,
    modify_date AS DateModification
FROM sys.procedures
WHERE name IN
(
    N'sp_AnneePlusMoinsChaude',
    N'sp_ProvincePlusMoinsChaude'
)
ORDER BY name;
GO


/* Exécuter les deux analyses */
EXEC dbo.sp_AnneePlusMoinsChaude;
GO

EXEC dbo.sp_ProvincePlusMoinsChaude;
GO