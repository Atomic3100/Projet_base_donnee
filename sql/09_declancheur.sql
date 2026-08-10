USE ClimatCanadaDB;
GO

DROP TABLE IF EXISTS Ref.AuditTemperatures;
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