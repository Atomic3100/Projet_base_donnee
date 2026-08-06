USE ClimatCanadaDB;
GO

/* ============================================================
   1. Année la plus chaude et année la moins chaude
   ============================================================ */

CREATE OR ALTER PROCEDURE Temperature.sp_AnneePlusMoinsChaude
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
                AVG(TemperatureMoyenne)
                AS DECIMAL(6,2)
            ) AS TemperatureMoyenne
            FROM Temperature.Temperatures
            GROUP BY Annee
        ),
        Classement
        AS
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

CREATE OR ALTER PROCEDURE Temperature.sp_ProvincePlusMoinsChaude
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
                AVG(TemperatureMoyenne)
                AS DECIMAL(6,2)
            ) AS TemperatureMoyenne
            FROM Temperature.Temperatures
            GROUP BY CodeProvince
        ),
        Classement
        AS
        (
            SELECT
                CodeProvince,
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
            WHEN c.RangPlusChaude = 1
                THEN N'Province ou territoire le plus chaud'
            ELSE
                N'Province ou territoire le moins chaud'
        END AS Resultat,
        c.CodeProvince,
        p.NomProvince,
        c.TemperatureMoyenne,
        N'°C' AS Unite
    FROM Classement AS c
        INNER JOIN Ref.Provinces AS p
        ON p.CodeProvince = c.CodeProvince
    WHERE c.RangPlusChaude = 1
        OR c.RangMoinsChaude = 1
    ORDER BY c.TemperatureMoyenne DESC;
END;
GO


/* Vérifier la création des deux procédures */
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
    N'sp_AnneePlusMoinsChaude',
    N'sp_ProvincePlusMoinsChaude'
)
ORDER BY p.name;
GO


/* Exécuter les deux analyses */
EXEC Temperature.sp_AnneePlusMoinsChaude;
GO

EXEC Temperature.sp_ProvincePlusMoinsChaude;
GO