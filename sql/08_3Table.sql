USE ClimatCanadaDB;
GO

DROP VIEW IF EXISTS Temperature.vw_Temperature_2023;
GO
CREATE VIEW Temperature.vw_Temperature_2023
AS
    SELECT CodeProvince, Annee, TemperatureMoyenne
    FROM Temperature.Temperatures
    WHERE Annee = 2023;
GO

DROP VIEW IF EXISTS Temperature.vw_Temperature_2024;
GO
CREATE VIEW Temperature.vw_Temperature_2024
AS
    SELECT CodeProvince, Annee, TemperatureMoyenne
    FROM Temperature.Temperatures
    WHERE Annee = 2024;
GO

DROP VIEW IF EXISTS Temperature.vw_Temperature_2025;
GO
CREATE VIEW Temperature.vw_Temperature_2025
AS
    SELECT CodeProvince, Annee, TemperatureMoyenne
    FROM Temperature.Temperatures
    WHERE Annee = 2025;
GO

DROP VIEW IF EXISTS Pollution.vw_Pollution_2023;
GO
CREATE VIEW Pollution.vw_Pollution_2023
AS
    SELECT CodeProvince, Annee, EmissionCO2
    FROM Pollution.Pollutions
    WHERE Annee = 2023;
GO

DROP VIEW IF EXISTS Pollution.vw_Pollution_2024;
GO
CREATE VIEW Pollution.vw_Pollution_2024
AS
    SELECT CodeProvince, Annee, EmissionCO2
    FROM Pollution.Pollutions
    WHERE Annee = 2024;
GO

DROP VIEW IF EXISTS Pollution.vw_Pollution_2025;
GO
CREATE VIEW Pollution.vw_Pollution_2025
AS
    SELECT CodeProvince, Annee, EmissionCO2
    FROM Pollution.Pollutions
    WHERE Annee = 2025;
GO

DROP VIEW IF EXISTS Precipitation.vw_Precipitation_2023;
GO
CREATE VIEW Precipitation.vw_Precipitation_2023
AS
    SELECT CodeProvince, Annee, PrecipitationMoyenne
    FROM Precipitation.Precipitations
    WHERE Annee = 2023;
GO

DROP VIEW IF EXISTS Precipitation.vw_Precipitation_2024;
GO
CREATE VIEW Precipitation.vw_Precipitation_2024
AS
    SELECT CodeProvince, Annee, PrecipitationMoyenne
    FROM Precipitation.Precipitations
    WHERE Annee = 2024;
GO

DROP VIEW IF EXISTS Precipitation.vw_Precipitation_2025;
GO
CREATE VIEW Precipitation.vw_Precipitation_2025
AS
    SELECT CodeProvince, Annee, PrecipitationMoyenne
    FROM Precipitation.Precipitations
    WHERE Annee = 2025;
GO