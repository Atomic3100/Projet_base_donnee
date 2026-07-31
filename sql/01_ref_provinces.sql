
CREATE TABLE Ref.Provinces (
    CodeProvince  CHAR(2)  primary key,
    NomProvince  NVARCHAR(30) unique
);
GO

INSERT INTO Ref.Provinces (CodeProvince, NomProvince)
VALUES 
    ('AB', N'Alberta'),
    ('BC', N'Colombie-Britannique'),
    ('MB', N'Manitoba'),
    ('NB', N'Nouveau-Brunswick'),
    ('NL', N'Terre-Neuve-et-Labrador'),
    ('NS', N'Nouvelle-Écosse'),
    ('ON', N'Ontario'),
    ('PE', N'Île-du-Prince-Édouard'),
    ('QC', N'Québec'),
    ('SK', N'Saskatchewan'),
    ('NT', N'Territoires du Nord-Ouest'),
    ('NU', N'Nunavut'),
    ('YT', N'Yukon');
GO

SELECT CodeProvince, NomProvince
FROM ref.Provinces;
GO