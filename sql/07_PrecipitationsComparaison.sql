USE ClimatCanadaDB;
GO

/* ============================================================
   1. Année la plus pluvieuse et année la moins pluvieuse
   ============================================================ */

CREATE OR ALTER PROCEDURE Precipitation.sp_AnneePlusMoinsPluvieuse
AS
BEGIN
    SET NOCOUNT ON;

    WITH
        MoyenneParAnnee
        AS
        (
            SELECT
                Annee,
                CAST(
                AVG(PrecipitationMoyenne)
                AS DECIMAL(10,2)
            ) AS PrecipitationMoyenne
            FROM Precipitation.Precipitations
            GROUP BY Annee
        ),
        Classement
        AS
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

CREATE OR ALTER PROCEDURE Precipitation.sp_ProvincePlusMoinsPluvieuse
AS
BEGIN
    SET NOCOUNT ON;

    WITH
        MoyenneParProvince
        AS
        (
            SELECT
                CodeProvince,
                CAST(
                AVG(PrecipitationMoyenne)
                AS DECIMAL(10,2)
            ) AS PrecipitationMoyenne
            FROM Precipitation.Precipitations
            GROUP BY CodeProvince
        ),
        Classement
        AS
        (
            SELECT
                CodeProvince,
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
            WHEN c.RangPlusPluvieuse = 1
                THEN N'Province ou territoire le plus pluvieux'
            ELSE
                N'Province ou territoire le moins pluvieux'
        END AS Resultat,
        c.CodeProvince,
        p.NomProvince,
        c.PrecipitationMoyenne,
        N'mm' AS Unite
    FROM Classement AS c
        INNER JOIN Ref.Provinces AS p
        ON p.CodeProvince = c.CodeProvince
    WHERE c.RangPlusPluvieuse = 1
        OR c.RangMoinsPluvieuse = 1
    ORDER BY c.PrecipitationMoyenne DESC;
END;
GO


/* Vérifier la création */
SELECT
    s.name AS NomSchema,
    p.name AS NomProcedure,
    p.create_date AS DateCreation,
    p.modify_date AS DateModification
FROM sys.procedures AS p
    INNER JOIN sys.schemas AS s
    ON s.schema_id = p.schema_id
WHERE p.name IN
(
    N'sp_AnneePlusMoinsPluvieuse',
    N'sp_ProvincePlusMoinsPluvieuse'
)
ORDER BY p.name;
GO


/* Exécuter les deux analyses */
EXEC Precipitation.sp_AnneePlusMoinsPluvieuse;
GO

EXEC Precipitation.sp_ProvincePlusMoinsPluvieuse;
GO