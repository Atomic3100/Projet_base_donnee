USE ClimatCanadaDB;
GO

DROP TABLE IF EXISTS Temperature.Temperatures;
GO

CREATE TABLE Temperature.Temperatures
(
    CodeProvince CHAR(2) NOT NULL,
    Annee SMALLINT NOT NULL,
    TemperatureMoyenne DECIMAL(5,2) NOT NULL,
    CONSTRAINT PK_Temperatures
        PRIMARY KEY (CodeProvince, Annee),
    CONSTRAINT FK_Temperatures_Provinces
        FOREIGN KEY (CodeProvince) REFERENCES Ref.Provinces(CodeProvince),
    CONSTRAINT CK_Temperatures_Annee
        CHECK (Annee BETWEEN 2023 AND 2025)
);
GO

INSERT INTO Temperature.Temperatures
    (CodeProvince, Annee, TemperatureMoyenne)
VALUES
    ('BC', 2023, 11.3),
    ('AB', 2023, 5.5),
    ('PE', 2023, 7.3),
    ('MB', 2023, 4.8),
    ('NB', 2023, 6.4),
    ('NS', 2023, 7.5),
    ('ON', 2023, 11.8),
    ('SK', 2023, 5.2),
    ('QC', 2023, 7.1),
    ('NL', 2023, 6.6),
    ('YT', 2023, -4.1),
    ('NT', 2023, -5.5),
    ('NU', 2023, -14.5),
    ('BC', 2024, 11.0),
    ('AB', 2024, 6.4),
    ('PE', 2024, 7.6),
    ('MB', 2024, 5.7),
    ('NB', 2024, 7.4),
    ('NS', 2024, 7.6),
    ('ON', 2024, 12.5),
    ('SK', 2024, 5.0),
    ('QC', 2024, 8.0),
    ('NL', 2024, 7.2),
    ('YT', 2024, -4.4),
    ('NT', 2024, -7.0),
    ('NU', 2024, -14.2),
    ('BC', 2025, 11.2),
    ('AB', 2025, 4.0),
    ('PE', 2025, 6.8),
    ('MB', 2025, 3.8),
    ('NB', 2025, 5.8),
    ('NS', 2025, 6.9),
    ('ON', 2025, 10.9),
    ('SK', 2025, 4.3),
    ('QC', 2025, 6.0),
    ('NL', 2025, 6.7),
    ('YT', 2025, -3.6),
    ('NT', 2025, -6.0),
    ('NU', 2025, -15.3);
GO

SELECT Annee, COUNT(*) AS NbProvinces
FROM Temperature.Temperatures
GROUP BY Annee
ORDER BY Annee;
GO