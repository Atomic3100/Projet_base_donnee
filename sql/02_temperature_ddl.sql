USE ClimatCanadaDB
GO
CREATE TABLE Temperature.Temperature2023
(
    CodeProvince CHAR(2) primary key,
    TemperatureMoyenne DECIMAL(5,2) NOT NULL
);
GO
CREATE TABLE Temperature.Temperature2024
(
    CodeProvince CHAR(2) primary key,
    TemperatureMoyenne DECIMAL(5,2) NOT NULL
);
GO
CREATE TABLE Temperature.Temperature2025
(
    CodeProvince CHAR(2) primary key,
    TemperatureMoyenne DECIMAL(5,2) NOT NULL
);
GO

INSERT INTO Temperature.Temperature2023
    (CodeProvince, TemperatureMoyenne)
VALUES
    ('AB', Temperature2023),
    ('BC', Temperature2023),
    ('MB', Temperature2023),
    ('NB', Temperature2023),
    ('NL', Temperature2023),
    ('NS', Temperature2023),
    ('ON', Temperature2023),
    ('PE', Temperature2023),
    ('QC', Temperature2023),
    ('SK', Temperature2023),
    ('NT', Temperature2023),
    ('NU', Temperature2023),
    ('YT', Temperature2023);
GO

INSERT INTO Temperature.Temperature2024
    (CodeProvince, TemperatureMoyenne)
VALUES
    ('AB', Temperature2024),
    ('BC', Temperature2024),
    ('MB', Temperature2024),
    ('MB', Temperature2024),
    ('NB', Temperature2024),
    ('NL', Temperature2024),
    ('NS', Temperature2024),
    ('ON', Temperature2024),
    ('PE', Temperature2024),
    ('QC', Temperature2024),
    ('SK', Temperature2024),
    ('NT', Temperature2024),
    ('NU', Temperature2024),
    ('YT', Temperature2024);
GO

INSERT INTO Temperature.Temperature2025
    (CodeProvince, TemperatureMoyenne)
VALUES
    ('AB', Temperature2025),
    ('BC', Temperature2025),
    ('MB', Temperature2025),
    ('MB', Temperature2025),
    ('NB', Temperature2025),
    ('NL', Temperature2025),
    ('NS', Temperature2025),
    ('ON', Temperature2025),
    ('PE', Temperature2025),
    ('QC', Temperature2025),
    ('SK', Temperature2025),
    ('NT', Temperature2025),
    ('NU', Temperature2025),
    ('YT', Temperature2025);
GO