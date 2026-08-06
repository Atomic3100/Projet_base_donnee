USE ClimatCanadaDB;
GO

DROP TABLE IF EXISTS Pollution.Pollutions;
GO

CREATE TABLE Pollution.Pollutions
(
    CodeProvince CHAR(2) NOT NULL,
    Annee SMALLINT NOT NULL,
    EmissionCO2 DECIMAL(10,2) NOT NULL,
    CONSTRAINT PK_Pollutions
        PRIMARY KEY (CodeProvince, Annee),
    CONSTRAINT FK_Pollutions_Provinces
        FOREIGN KEY (CodeProvince) REFERENCES Ref.Provinces(CodeProvince),
    CONSTRAINT CK_Pollutions_Annee
        CHECK (Annee BETWEEN 2023 AND 2025)
);
GO

INSERT INTO Pollution.Pollutions
    (CodeProvince, Annee, EmissionCO2)
VALUES
    ('AB', 2023, 275.40),
    ('BC', 2023, 64.20),
    ('PE', 2023, 1.80),
    ('MB', 2023, 22.10),
    ('NB', 2023, 12.40),
    ('NS', 2023, 14.70),
    ('ON', 2023, 157.30),
    ('QC', 2023, 84.60),
    ('SK', 2023, 76.50),
    ('NL', 2023, 10.80),
    ('NT', 2023, 1.40),
    ('NU', 2023, 0.70),
    ('YT', 2023, 0.60),
    ('AB', 2024, 270.10),
    ('BC', 2024, 62.80),
    ('PE', 2024, 1.70),
    ('MB', 2024, 21.50),
    ('NB', 2024, 11.90),
    ('NS', 2024, 13.80),
    ('ON', 2024, 153.40),
    ('QC', 2024, 82.10),
    ('SK', 2024, 74.20),
    ('NL', 2024, 10.30),
    ('NT', 2024, 1.30),
    ('NU', 2024, 0.70),
    ('YT', 2024, 0.50),
    ('AB', 2025, 264.80),
    ('BC', 2025, 60.90),
    ('PE', 2025, 1.60),
    ('MB', 2025, 20.90),
    ('NB', 2025, 11.30),
    ('NS', 2025, 12.90),
    ('ON', 2025, 149.70),
    ('QC', 2025, 79.80),
    ('SK', 2025, 71.90),
    ('NL', 2025, 9.90),
    ('NT', 2025, 1.20),
    ('NU', 2025, 0.60),
    ('YT', 2025, 0.50);
GO

SELECT CodeProvince, Annee, EmissionCO2
FROM Pollution.Pollutions
ORDER BY Annee, CodeProvince;
GO

SELECT Annee, COUNT(*) AS NbProvinces
FROM Pollution.Pollutions
GROUP BY Annee
ORDER BY Annee;
GO