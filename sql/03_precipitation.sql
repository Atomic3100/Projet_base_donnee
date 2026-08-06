USE ClimatCanadaDB;
GO

DROP TABLE IF EXISTS Precipitation.Precipitations;
GO

CREATE TABLE Precipitation.Precipitations
(
    CodeProvince CHAR(2) NOT NULL,
    Annee SMALLINT NOT NULL,
    PrecipitationMoyenne DECIMAL(10,2) NOT NULL,
    CONSTRAINT PK_Precipitations
        PRIMARY KEY (CodeProvince, Annee),
    CONSTRAINT FK_Precipitations_Provinces
        FOREIGN KEY (CodeProvince) REFERENCES Ref.Provinces(CodeProvince),
    CONSTRAINT CK_Precipitations_Annee
        CHECK (Annee BETWEEN 2023 AND 2025)
);
GO

INSERT INTO Precipitation.Precipitations
    (CodeProvince, Annee, PrecipitationMoyenne)
VALUES
    ('AB', 2023, 510.20),
    ('BC', 2023, 1180.40),
    ('PE', 2023, 1120.80),
    ('MB', 2023, 545.30),
    ('NB', 2023, 1165.50),
    ('NS', 2023, 1280.70),
    ('ON', 2023, 910.40),
    ('QC', 2023, 1050.60),
    ('SK', 2023, 445.90),
    ('NL', 2023, 1320.50),
    ('NT', 2023, 280.40),
    ('NU', 2023, 205.30),
    ('YT', 2023, 315.70),
    ('AB', 2024, 495.60),
    ('BC', 2024, 1215.80),
    ('PE', 2024, 1095.40),
    ('MB', 2024, 560.20),
    ('NB', 2024, 1190.30),
    ('NS', 2024, 1305.10),
    ('ON', 2024, 935.70),
    ('QC', 2024, 1075.20),
    ('SK', 2024, 460.80),
    ('NL', 2024, 1295.40),
    ('NT', 2024, 290.10),
    ('NU', 2024, 215.60),
    ('YT', 2024, 325.90),
    ('AB', 2025, 525.40),
    ('BC', 2025, 1195.60),
    ('PE', 2025, 1140.20),
    ('MB', 2025, 575.80),
    ('NB', 2025, 1210.70),
    ('NS', 2025, 1330.40),
    ('ON', 2025, 950.30),
    ('QC', 2025, 1090.80),
    ('SK', 2025, 475.60),
    ('NL', 2025, 1340.20),
    ('NT', 2025, 300.50),
    ('NU', 2025, 225.40),
    ('YT', 2025, 340.10);
GO

SELECT CodeProvince, Annee, PrecipitationMoyenne
FROM Precipitation.Precipitations
ORDER BY Annee, CodeProvince;
GO

SELECT Annee, COUNT(*) AS NbProvinces
FROM Precipitation.Precipitations
GROUP BY Annee
ORDER BY Annee;
GO