# CONVENTIONS — Projet INF4163

Groupe : [nom]  
Membres : [A] et [B]  
Dernière mise à jour : 2026-07-31

---

## 1. Environnement

- SGBD : SQL Server (Express ou Developer)
- Éditeur SQL : SSMS
- Authentification : mode mixte (Windows + SQL), requis pour Azure
- Éditeur de code : VS Code + Live Server + Prettier
- Versionnement : Git + GitHub (dépôt privé)
- Frontend : HTML / CSS
- Hébergement : local en développement, Azure + site déployé en fin de projet (bonus)

## 2. Structure de la base

Une seule base, quatre schémas (validé par le prof : « si c'est bien maîtrisé »).

- Base : `ClimatCanadaDB`
- Schémas : `Ref`, `Temperature`, `Pollution`, `Precipitation`
- Pas d'accents dans les identifiants (risque d'encodage SSMS / Power BI / Azure / CSV)

Justification : permet une table de provinces partagée avec intégrité
référentielle réelle, plutôt que recopiée dans trois bases.
Azure SQL n'autorise pas les requêtes inter-bases.

## 3. Nommage

- Casse : `PascalCase`
- Tables annuelles : thème + année → `Temperature2023`, `Pollution2024`, `Precipitation2025`
- Appel complet : `Temperature.Temperature2023`
- Toujours préfixer le schéma dans le code, jamais de nom nu
- Préfixes procédures / déclencheurs : [À DÉCIDER]

### Règle de pluriel

- Schémas : singulier — `Ref`, `Temperature`, `Pollution`, `Precipitation`
- Tables de données annuelles : singulier + année — `Temperature2023`
- Tables de référence : pluriel — `Provinces`

Justification : une table de référence liste des entités (pluriel),
une table annuelle contient les mesures d'un thème pour une année (singulier).

## 4. Table de référence

`Ref.Provinces`

| Colonne | Type | Contrainte |
|---|---|---|
| `CodeProvince` | `CHAR(2)` | clé primaire |
| `NomProvince` | Unicode | unique |

- 13 lignes : les 10 provinces + 3 territoires (nom approximatif, assumé —
  l'énoncé emploie lui aussi « province » pour les 13)
- Codes officiels, repris de l'énoncé :
  NL, PE, NS, NB, QC, ON, MB, SK, AB, BC, YT, NT, NU
- Accents conservés dans `NomProvince` (affiché sur le site)
- Figée après création — un seul propriétaire

## 5. Types de données

| Donnée | Type |
|---|---|
| Température (°C) | `DECIMAL(5,2)` |
| CO2 (Mt) | `DECIMAL(8,2)` |
| Précipitations (mm) | `DECIMAL(7,2)` |
| Année | `SMALLINT` |
| Code province | `CHAR(2)` |

Justification : type exact plutôt que `FLOAT`, car les procédures comparent
des MIN/MAX. Deux décimales car nos valeurs sont des moyennes calculées à
partir de plusieurs stations (sources publiées au dixième), ce qui permet
de départager deux provinces proches.

Pas de colonne `Annee` dans les tables annuelles — l'année est dans le nom
de la table. Conséquence : ajouter l'année comme valeur littérale dans
chaque `SELECT` des `UNION`.

## 6. Données

- Sources : climat.meteo.gc.ca, donneesclimatiques.ca
- ECCC ne publie ni par province ni en valeurs absolues (anomalies par
  région climatique) → agrégation de stations à faire nous-mêmes
- Méthode d'agrégation : [À DÉCIDER — combien de stations, lesquelles, données manquantes]
- `/data/brut` : téléchargements intacts, jamais modifiés
- `/data/propre` : un CSV par thème, format long `province,annee,valeur`
- Vérifier : séparateur décimal (virgule/point), marqueur de données manquantes
- Normaliser vers les 13 codes officiels à l'import
- À valider : disponibilité du CO2 2025 (inventaire ECCC a du décalage)

## 7. Dépôt et fichiers

/sql /data/brut /data/propre /site /powerbi /captures /rapport /presentation

- Scripts SQL : `NN_theme_etape.sql`, numérotés dans l'ordre d'exécution
- Noms de fichiers : minuscules, sans accents ni espaces
- Chemins relatifs uniquement
- Commits petits et fréquents, jamais à cheval sur les fichiers de l'autre
- `git pull` avant chaque séance
- Règle : on doit pouvoir repartir d'un serveur vide et tout reconstruire

## 8. Site web

- Un fichier `.html` par onglet (pas de page unique à onglets JS)
- Onglets : Accueil, Température, Pollution, Précipitations, Résultats, Équipe
- `gabarit.html` écrit en premier, propriétaire unique
- Zone éditable entre `<!-- DÉBUT CONTENU -->` et `<!-- FIN CONTENU -->`
- Personne ne touche à l'en-tête/nav/pied hors de sa zone
- CSS : `commun.css` (propriétaire unique) + un CSS par page
- Ordre d'appel : framework → commun.css → page.css
- Encodage UTF-8 + balise viewport obligatoires
- Servi via Live Server, jamais en `file://`
- Framework CSS : [À DÉCIDER — Bootstrap ou CSS pur]
- Palette (3-4 couleurs hex) : [À DÉCIDER]
- Polices (2 max) : [À DÉCIDER]

## 9. Visualisation — BLOCAGE

Test du 31 juillet : « Publier sur le web » est **désactivé par
l'administrateur du tenant UQO**. Message : « Contact your admin to
enable embed code creation ». Pas d'iframe Power BI publique possible.

Tableau Public écarté : ne supporte que les extraits, aucune connexion
live à SQL Server. Incompatible avec « affichage en direct ».

- Demande d'autorisation envoyée au service informatique : [DATE]
- Ce qui fonctionne malgré tout : Power BI Desktop en DirectQuery sur
  SQL Server local → démontrable en live le 10 août
- Plan retenu si pas d'autorisation : graphiques générés dans la page,
  alimentés par la couche de connexion. Perte du bonus +5 % « graphes
  dynamiques », mais l'exigence de base est satisfaite.

À documenter dans le PPT (« difficultés rencontrées ») avec capture d'écran.

## 10. Règle d'architecture

Aucun calcul dans le navigateur. Moyennes, MIN/MAX, classements :
tout sort déjà calculé de la base via procédures stockées.

Test de validation : si les graphiques affichent encore des données alors
que le serveur SQL est éteint, l'architecture est fausse.

## 11. Propriété

| Élément | Propriétaire |
|---|---|
| TempératureDB + ses procédures + onglet Température | [À DÉCIDER] |
| PollutionDB + PrécipitationsDB + leurs onglets | [À DÉCIDER] |
| Gabarit HTML + commun.css | [À DÉCIDER] |
| Couche de connexion aux bases | [l'autre] |
| Table de référence des provinces | [À DÉCIDER] |
| Onglet Résultats | À deux |

## 12. Questions en attente

- Prof : 5 tables pour TempératureDB vs « 9 tables » dans les livrables ?
- Service informatique UQO : activation de « Publier sur le web » ?

## 13. À ne pas oublier

- Logo du groupe
- Nom du groupe
- Photos des membres pour l'onglet Équipe
- Captures d'écran au fur et à mesure, pas à la fin
- Difficultés rencontrées (pour le PPT)
- LISEZMOI.txt dans le zip final