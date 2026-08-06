
USE PollutionDB;
GO

/* ============================================================
   1. Année la plus polluée et année la moins polluée
   ============================================================ */

CREATE OR ALTER PROCEDURE dbo.sp_AnneePlusMoinsPolluee
AS
BEGIN
    SET NOCOUNT ON;

    ;
    WITH
        ToutesPollutions
        AS
        (
                                        SELECT
                    2023 AS Annee,
                    EmissionCO2
                FROM dbo.Pollution2023

            UNION ALL

                SELECT
                    2024,
                    EmissionCO2
                FROM dbo.Pollution2024

            UNION ALL

                SELECT
                    2025,
                    EmissionCO2
                FROM dbo.Pollution2025
        ),
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
            FROM ToutesPollutions
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

CREATE OR ALTER PROCEDURE dbo.sp_ProvincePlusMoinsPolluee
AS
BEGIN
    SET NOCOUNT ON;

    ;
    WITH
        ToutesPollutions
        AS
        (
                                        SELECT
                    ProvinceTerritoire,
                    EmissionCO2
                FROM dbo.Pollution2023

            UNION ALL

                SELECT
                    ProvinceTerritoire,
                    EmissionCO2
                FROM dbo.Pollution2024

            UNION ALL

                SELECT
                    ProvinceTerritoire,
                    EmissionCO2
                FROM dbo.Pollution2025
        ),
        MoyenneParProvince
        AS
        (
            SELECT
                ProvinceTerritoire,
                CAST
            (
                AVG(EmissionCO2)
                AS DECIMAL(12,2)
            ) AS EmissionMoyenneCO2
            FROM ToutesPollutions
            GROUP BY ProvinceTerritoire
        ),
        Classement
        AS
        (
            SELECT
                ProvinceTerritoire,
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
            WHEN RangPlusPolluee = 1
                THEN N'Province ou territoire le plus pollué'
            ELSE
                N'Province ou territoire le moins pollué'
        END AS Resultat,
        ProvinceTerritoire,
        EmissionMoyenneCO2,
        N'Mt CO2' AS Unite
    FROM Classement
    WHERE RangPlusPolluee = 1
        OR RangMoinsPolluee = 1
    ORDER BY EmissionMoyenneCO2 DESC;
END;
GO


/* Vérifier la création des procédures */
SELECT
    name AS NomProcedure,
    create_date AS DateCreation,
    modify_date AS DateModification
FROM sys.procedures
WHERE name IN
(
    N'sp_AnneePlusMoinsPolluee',
    N'sp_ProvincePlusMoinsPolluee'
)
ORDER BY name;
GO


/* Exécuter les analyses */
EXEC dbo.sp_AnneePlusMoinsPolluee;
GO

EXEC dbo.sp_ProvincePlusMoinsPolluee;
GO
