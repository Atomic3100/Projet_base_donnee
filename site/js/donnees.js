
const PROVINCES = {
    AB: "Alberta",
    BC: "Colombie-Britannique",
    MB: "Manitoba",
    NB: "Nouveau-Brunswick",
    NL: "Terre-Neuve-et-Labrador",
    NS: "Nouvelle-Écosse",
    ON: "Ontario",
    PE: "Île-du-Prince-Édouard",
    QC: "Québec",
    SK: "Saskatchewan",
    NT: "Territoires du Nord-Ouest",
    NU: "Nunavut",
    YT: "Yukon"
};



const DONNEES = {
    temperature: {
        unite: "°C",
        decimales: 1,
        valeurs: [
            ["AB", 5.5, 6.4, 4.0],
            ["BC", 11.3, 11.0, 11.2],
            ["MB", 4.8, 5.7, 3.8],
            ["NB", 6.4, 7.4, 5.8],
            ["NL", 6.6, 7.2, 6.7],
            ["NS", 7.5, 7.6, 6.9],
            ["NT", -5.5, -7.0, -6.0],
            ["NU", -14.5, -14.2, -15.3],
            ["ON", 11.8, 12.5, 10.9],
            ["PE", 7.3, 7.6, 6.8],
            ["QC", 7.1, 8.0, 6.0],
            ["SK", 5.2, 5.0, 4.3],
            ["YT", -4.1, -4.4, -3.6]
        ]
    },
    pollution: {
        unite: "Mt CO₂",
        decimales: 2,
        valeurs: [
            ["AB", 275.4, 270.1, 264.8],
            ["BC", 64.2, 62.8, 60.9],
            ["MB", 22.1, 21.5, 20.9],
            ["NB", 12.4, 11.9, 11.3],
            ["NL", 10.8, 10.3, 9.9],
            ["NS", 14.7, 13.8, 12.9],
            ["NT", 1.4, 1.3, 1.2],
            ["NU", 0.7, 0.7, 0.6],
            ["ON", 157.3, 153.4, 149.7],
            ["PE", 1.8, 1.7, 1.6],
            ["QC", 84.6, 82.1, 79.8],
            ["SK", 76.5, 74.2, 71.9],
            ["YT", 0.6, 0.5, 0.5]
        ]
    },
    precipitations: {
        unite: "mm",
        decimales: 2,
        valeurs: [
            ["AB", 510.2, 495.6, 525.4],
            ["BC", 1180.4, 1215.8, 1195.6],
            ["MB", 545.3, 560.2, 575.8],
            ["NB", 1165.5, 1190.3, 1210.7],
            ["NL", 1320.5, 1295.4, 1340.2],
            ["NS", 1280.7, 1305.1, 1330.4],
            ["NT", 280.4, 290.1, 300.5],
            ["NU", 205.3, 215.6, 225.4],
            ["ON", 910.4, 935.7, 950.3],
            ["PE", 1120.8, 1095.4, 1140.2],
            ["QC", 1050.6, 1075.2, 1090.8],
            ["SK", 445.9, 460.8, 475.6],
            ["YT", 315.7, 325.9, 340.1]
        ]
    }
};

const ANNEES = [2023, 2024, 2025];


function lireTheme() {
    const brut = document.body.dataset.theme || "";
    return brut.toLowerCase();
}

function formater(valeur, config) {
    return valeur.toFixed(config.decimales) + " " + config.unite;
}


function extraire(config, annee) {
    const colonne = ANNEES.indexOf(annee) + 1;
    return config.valeurs
        .map(ligne => ({
            code: ligne[0],
            nom: PROVINCES[ligne[0]],
            valeur: ligne[colonne]
        }))
        .sort((a, b) => b.valeur - a.valeur);
}


function remplirTableau(lignes, config) {
    const corps = document.getElementById("data-body");
    if (!corps) return;

    corps.innerHTML = "";

    lignes.forEach(ligne => {
        const tr = document.createElement("tr");

        const tdCode = document.createElement("td");
        tdCode.textContent = ligne.code;

        const tdNom = document.createElement("td");
        tdNom.textContent = ligne.nom;

        const tdValeur = document.createElement("td");
        tdValeur.textContent = formater(ligne.valeur, config);

        tr.append(tdCode, tdNom, tdValeur);
        corps.appendChild(tr);
    });
}


function remplirResume(lignes, config) {
    const plusHaut = lignes[0];
    const plusBas = lignes[lignes.length - 1];

    const cibleHaut = document.getElementById("highest");
    const cibleBas = document.getElementById("lowest");
    const cibleNombre = document.getElementById("count");

    if (cibleHaut) {
        cibleHaut.textContent = plusHaut.nom + " — " + formater(plusHaut.valeur, config);
    }
    if (cibleBas) {
        cibleBas.textContent = plusBas.nom + " — " + formater(plusBas.valeur, config);
    }
    if (cibleNombre) {
        cibleNombre.textContent = lignes.length;
    }
}

function remplirGraphique(lignes, config) {
    const zone = document.getElementById("chart");
    if (!zone) return;

    zone.innerHTML = "";

    const valeurs = lignes.map(l => l.valeur);
    const min = Math.min(...valeurs, 0);
    const max = Math.max(...valeurs);
    const etendue = max - min || 1;

    lignes.forEach(ligne => {
        const largeur = ((ligne.valeur - min) / etendue) * 100;

        const rangee = document.createElement("div");
        rangee.className = "chart-row";

        const etiquette = document.createElement("span");
        etiquette.className = "chart-label";
        etiquette.textContent = ligne.code;

        const piste = document.createElement("div");
        piste.className = "chart-track";

        const barre = document.createElement("div");
        barre.className = "chart-bar";
        barre.style.width = Math.max(largeur, 1) + "%";

        const valeur = document.createElement("span");
        valeur.className = "chart-value";
        valeur.textContent = formater(ligne.valeur, config);

        piste.appendChild(barre);
        rangee.append(etiquette, piste, valeur);
        zone.appendChild(rangee);
    });
}


function afficherAnnee(config, annee) {
    const lignes = extraire(config, annee);

    remplirTableau(lignes, config);
    remplirResume(lignes, config);
    remplirGraphique(lignes, config);

    const libelle = document.getElementById("selected-year");
    if (libelle) libelle.textContent = annee;
}


document.addEventListener("DOMContentLoaded", function () {
    const theme = lireTheme();
    const config = DONNEES[theme];

    if (!config) return;

    const selecteur = document.getElementById("year");
    const anneeDepart = selecteur ? Number(selecteur.value) : 2025;

    afficherAnnee(config, anneeDepart);

    if (selecteur) {
        selecteur.addEventListener("change", function () {
            afficherAnnee(config, Number(selecteur.value));
        });
    }
});