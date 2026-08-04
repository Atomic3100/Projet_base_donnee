USE PrecipitationsDB;
GO

/* ============================================================
   1. Année la plus pluvieuse et année la moins pluvieuse
   ============================================================ */

CREATE OR ALTER PROCEDURE dbo.sp_AnneePlusMoinsPluvieuse
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH ToutesPrecipitations AS
    (
        SELECT
            2023 AS Annee,
            PrecipitationMoyenne
        FROM dbo.Precipitations2023

        UNION ALL

        SELECT
            2024,
            PrecipitationMoyenne
        FROM dbo.Precipitations2024

        UNION ALL

        SELECT
            2025,
            PrecipitationMoyenne
        FROM dbo.Precipitations2025
    ),
    MoyenneParAnnee AS
    (
        SELECT
            Annee,
            CAST(
                AVG(PrecipitationMoyenne)
                AS DECIMAL(10,2)
            ) AS PrecipitationMoyenne
        FROM ToutesPrecipitations
        GROUP BY Annee
    ),
    Classement AS
    (
        SELECT
            Annee,
            PrecipitationMoyenne,
            RANK() OVER (
                ORDER BY PrecipitationMoyenne DESC
            ) AS RangPlusPluvieuse,
            RANK() OVER (
                ORDER BY PrecipitationMoyenne ASC
            ) AS RangMoinsPluvieuse
        FROM MoyenneParAnnee
    )
    SELECT
        CASE
            WHEN RangPlusPluvieuse = 1
                THEN N'Année la plus pluvieuse'
            ELSE
                N'Année la moins pluvieuse'
        END AS Resultat,
        Annee,
        PrecipitationMoyenne,
        N'mm' AS Unite
    FROM Classement
    WHERE RangPlusPluvieuse = 1
       OR RangMoinsPluvieuse = 1
    ORDER BY PrecipitationMoyenne DESC;
END;
GO


/* ============================================================
   2. Province la plus pluvieuse et la moins pluvieuse
   ============================================================ */

CREATE OR ALTER PROCEDURE dbo.sp_ProvincePlusMoinsPluvieuse
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH ToutesPrecipitations AS
    (
        SELECT
            ProvinceTerritoire,
            PrecipitationMoyenne
        FROM dbo.Precipitations2023

        UNION ALL

        SELECT
            ProvinceTerritoire,
            PrecipitationMoyenne
        FROM dbo.Precipitations2024

        UNION ALL

        SELECT
            ProvinceTerritoire,
            PrecipitationMoyenne
        FROM dbo.Precipitations2025
    ),
    MoyenneParProvince AS
    (
        SELECT
            ProvinceTerritoire,
            CAST(
                AVG(PrecipitationMoyenne)
                AS DECIMAL(10,2)
            ) AS PrecipitationMoyenne
        FROM ToutesPrecipitations
        GROUP BY ProvinceTerritoire
    ),
    Classement AS
    (
        SELECT
            ProvinceTerritoire,
            PrecipitationMoyenne,
            RANK() OVER (
                ORDER BY PrecipitationMoyenne DESC
            ) AS RangPlusPluvieuse,
            RANK() OVER (
                ORDER BY PrecipitationMoyenne ASC
            ) AS RangMoinsPluvieuse
        FROM MoyenneParProvince
    )
    SELECT
        CASE
            WHEN RangPlusPluvieuse = 1
                THEN N'Province ou territoire le plus pluvieux'
            ELSE
                N'Province ou territoire le moins pluvieux'
        END AS Resultat,
        ProvinceTerritoire,
        PrecipitationMoyenne,
        N'mm' AS Unite
    FROM Classement
    WHERE RangPlusPluvieuse = 1
       OR RangMoinsPluvieuse = 1
    ORDER BY PrecipitationMoyenne DESC;
END;
GO


/* Vérifier la création */
SELECT
    name AS NomProcedure,
    create_date AS DateCreation,
    modify_date AS DateModification
FROM sys.procedures
WHERE name IN
(
    N'sp_AnneePlusMoinsPluvieuse',
    N'sp_ProvincePlusMoinsPluvieuse'
)
ORDER BY name;
GO


/* Exécuter les deux analyses */
EXEC dbo.sp_AnneePlusMoinsPluvieuse;
GO

EXEC dbo.sp_ProvincePlusMoinsPluvieuse;
GO