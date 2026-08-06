USE ClimatCanadaDB;
GO

/* ============================================================
   1. Année la plus polluée et année la moins polluée
   ============================================================ */

CREATE OR ALTER PROCEDURE Pollution.sp_AnneePlusMoinsPolluee
AS
BEGIN
    SET NOCOUNT ON;

    WITH
        MoyenneParAnnee
        AS
        (
            SELECT
                Annee,
                CAST
            (
                AVG(EmissionCO2)
                AS DECIMAL(12,2)
            ) AS EmissionMoyenneCO2
            FROM Pollution.Pollutions
            GROUP BY Annee
        ),
        Classement
        AS
        (
            SELECT
                Annee,
                EmissionMoyenneCO2,
                RANK() OVER
            (
                ORDER BY EmissionMoyenneCO2 DESC
            ) AS RangPlusPolluee,
                RANK() OVER
            (
                ORDER BY EmissionMoyenneCO2 ASC
            ) AS RangMoinsPolluee
            FROM MoyenneParAnnee
        )
    SELECT
        CASE
            WHEN RangPlusPolluee = 1
                THEN N'Année la plus polluée'
            ELSE
                N'Année la moins polluée'
        END AS Resultat,
        Annee,
        EmissionMoyenneCO2,
        N'Mt CO2' AS Unite
    FROM Classement
    WHERE RangPlusPolluee = 1
        OR RangMoinsPolluee = 1
    ORDER BY EmissionMoyenneCO2 DESC;
END;
GO


/* ============================================================
   2. Province la plus polluée et province la moins polluée
   ============================================================ */

CREATE OR ALTER PROCEDURE Pollution.sp_ProvincePlusMoinsPolluee
AS
BEGIN
    SET NOCOUNT ON;

    WITH
        MoyenneParProvince
        AS
        (
            SELECT
                CodeProvince,
                CAST
            (
                AVG(EmissionCO2)
                AS DECIMAL(12,2)
            ) AS EmissionMoyenneCO2
            FROM Pollution.Pollutions
            GROUP BY CodeProvince
        ),
        Classement
        AS
        (
            SELECT
                CodeProvince,
                EmissionMoyenneCO2,
                RANK() OVER
            (
                ORDER BY EmissionMoyenneCO2 DESC
            ) AS RangPlusPolluee,
                RANK() OVER
            (
                ORDER BY EmissionMoyenneCO2 ASC
            ) AS RangMoinsPolluee
            FROM MoyenneParProvince
        )
    SELECT
        CASE
            WHEN c.RangPlusPolluee = 1
                THEN N'Province ou territoire le plus pollué'
            ELSE
                N'Province ou territoire le moins pollué'
        END AS Resultat,
        c.CodeProvince,
        p.NomProvince,
        c.EmissionMoyenneCO2,
        N'Mt CO2' AS Unite
    FROM Classement AS c
        INNER JOIN Ref.Provinces AS p
        ON p.CodeProvince = c.CodeProvince
    WHERE c.RangPlusPolluee = 1
        OR c.RangMoinsPolluee = 1
    ORDER BY c.EmissionMoyenneCO2 DESC;
END;
GO


/* Vérifier la création des procédures */
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
    N'sp_AnneePlusMoinsPolluee',
    N'sp_ProvincePlusMoinsPolluee'
)
ORDER BY p.name;
GO


/* Exécuter les analyses */
EXEC Pollution.sp_AnneePlusMoinsPolluee;
GO

EXEC Pollution.sp_ProvincePlusMoinsPolluee;
GO