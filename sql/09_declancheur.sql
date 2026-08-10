USE ClimatCanadaDB;
GO

DROP TABLE IF EXISTS Ref.AuditTemperatures;
GO
CREATE OR ALTER TRIGGER Temperature.trg_Audit_Temperatures
ON Temperature.Temperatures
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Ref.AuditTemperatures
        (CodeProvince, Annee, AncienneVal, NouvelleVal)
    SELECT i.CodeProvince, i.Annee, d.TemperatureMoyenne, i.TemperatureMoyenne
    FROM inserted AS i
        INNER JOIN deleted AS d
            ON d.CodeProvince = i.CodeProvince AND d.Annee = i.Annee;
END;
GO

CREATE TABLE Ref.AuditTemperatures
(
    IdAudit INT IDENTITY(1,1) PRIMARY KEY,
    CodeProvince CHAR(2) NOT NULL,
    Annee SMALLINT NOT NULL,
    AncienneVal DECIMAL(5,2) NOT NULL,
    NouvelleVal DECIMAL(5,2) NOT NULL,
    DateAction DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);
GO
UPDATE Temperature.Temperatures
SET TemperatureMoyenne = 25.0
WHERE CodeProvince = 'QC' AND Annee = 2025;

SELECT *
FROM Ref.AuditTemperatures;

UPDATE Temperature.Temperatures
SET TemperatureMoyenne = 6.0
WHERE CodeProvince = 'QC' AND Annee = 2025;