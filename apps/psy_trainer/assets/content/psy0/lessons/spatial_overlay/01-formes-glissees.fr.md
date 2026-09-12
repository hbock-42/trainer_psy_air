# Formes glissées : l'algèbre des superpositions

« Formes glissées » est l'activité que les candidats citent le plus souvent parmi celles qu'ils **n'ont pas terminées**. Présente à toutes les sessions depuis 2019, elle a été durcie en 2024 (version II, chevauchements importants, cases noires) et encore signalée comme « fortement complexifiée » à la session de septembre 2026. On ne la réussit pas au tâtonnement : il faut une méthode de déduction, et l'appliquer vite.

## Ce que mesure l'activité

L'activité mesure le **raisonnement visuo-spatial combinatoire** : prédire le résultat de la superposition de plusieurs formes sur une grille, sous des règles de combinaison de couleurs, et retrouver quelle disposition produit une grille cible. Elle mobilise l'attention sélective (isoler une case parmi des dizaines), la mémoire de travail (retenir un placement provisoire pendant qu'on en teste un autre) et surtout la capacité à **déduire au lieu d'essayer**.

## Format et chronométrage rapportés

| Élément | Valeur rapportée | Confiance |
|---|---|---|
| Matériel | Une grille centrale, une grille cible, 3 à 4 pièces (formes composées de cases marine ou grises) à faire glisser sur la grille centrale | [rapporté] |
| Règles de superposition | marine + marine = marine ; marine + gris = gris ; gris + gris = marine | [rapporté] |
| Validation | Passage automatique à la planche suivante dès que la grille reproduit la cible | [rapporté] |
| Volume | 3 planches en 2020, **5 planches** de 2022 à 2026 | [rapporté] |
| Temps par planche | Environ 60 à 90 s | [rapporté] |
| Version II (2024 →) | Pièces qui se chevauchent fortement, apparition de **cases noires** | [rapporté] |
| Cases noires | Rôle exact non documenté ; dans notre simulation, une case noire de la cible est une case qu'aucune pièce ne doit couvrir | [estimé] |
| Case non couverte | Reste vide (couleur de fond) dans notre simulation | [estimé] |
| Rotation des pièces | Non signalée par les candidats ; nos pièces glissent sans tourner | [estimé] |

## Méthode et stratégie

> [!METHOD]
> **Lisez les trois règles comme une règle de parité.** Le marine est neutre (marine + x = x) ; le gris inverse (gris + gris = marine). Une case couverte est donc **grise si un nombre impair de cases grises la recouvrent**, **marine si ce nombre est pair** (zéro compris, pourvu qu'au moins une pièce la couvre). Il ne reste plus qu'à compter les gris, case par case.

La méthode complète en quatre temps :

1. **Compter les couvertures.** Additionnez les cases de toutes les pièces et comparez au nombre de cases colorées de la cible. L'excédent vous dit combien de chevauchements il y aura. Zéro excédent : les pièces ne se chevauchent pas, le problème devient un puzzle classique.
2. **Chercher les placements forcés.** Une case de la cible qui ne peut être atteinte que par une seule pièce (à cause de la forme, du bord de la grille ou d'une case noire voisine) fixe cette pièce. Commencez par les pièces les plus grandes ou les plus biscornues : elles ont le moins de positions possibles.
3. **Utiliser la parité des gris.** Une case grise de la cible reçoit 1 ou 3 gris ; une case marine en reçoit 0 ou 2. Une pièce entièrement marine ne peut jamais, seule, produire du gris ; une pièce entièrement grise ne peut produire du marine que si une autre pièce grise la recouvre.
4. **Poser, puis vérifier case par case** avant de passer à la pièce suivante. Le passage automatique à la planche suivante confirme la solution ; s'il ne se produit pas, une case au moins est fausse.

Sur les planches de la version II, les chevauchements sont la règle : attendez-vous à ce qu'une case reçoive deux ou trois pièces. C'est précisément là que le comptage de parité fait gagner du temps sur l'essai-erreur.

## Pièges et erreurs fréquentes

> [!TRAP]
> **Croire que gris + gris = gris.** C'est l'erreur qui coûte le plus. Deux gris superposés donnent du marine. Une case cible marine peut donc être le résultat de deux pièces grises, et une case grise de la cible ne peut pas venir de deux pièces grises.

> [!TRAP]
> **Déplacer les pièces au hasard pour « voir ».** Chaque glissement coûte deux à trois secondes et brouille la mémoire de ce qui a déjà été testé. Décidez d'abord, glissez ensuite.

> [!TRAP]
> **Oublier les cases non couvertes.** Une case vide de la cible ne doit recevoir aucune pièce : c'est une contrainte aussi forte qu'une case colorée, et souvent la plus discriminante pour placer les grandes pièces.

Autres erreurs classiques :

- **S'acharner sur une planche.** Avec 5 planches et un temps global limité, mieux vaut appliquer la méthode proprement sur quatre planches que tâtonner sur une seule.
- **Ne pas relire la cible après un placement.** L'écran change à chaque pièce posée ; vérifiez la case que vous venez de modifier, pas seulement l'allure générale.
- **Se surconditionner sur les couleurs d'un entraîneur.** Les teintes exactes peuvent différer le jour J ; retenez la structure « couleur neutre / couleur qui inverse », pas les couleurs elles-mêmes.

## Exemple guidé 1 — un chevauchement à trouver

> [!EXAMPLE]
> Grille 2 × 2, cases notées (ligne, colonne). Cible : (1,1) marine, (1,2) gris, (2,1) marine, (2,2) marine. Pièces : **P** domino horizontal marine-marine ; **Q** domino vertical gris-gris ; **R** domino horizontal marine à gauche, gris à droite. Où poser les pièces ?

### Étape 1

Comptage : les pièces couvrent 2 + 2 + 2 = 6 cases pour 4 cases cibles, toutes colorées. Il y aura donc exactement deux chevauchements (deux cases recevront deux pièces). Parité attendue : (1,2) doit recevoir un nombre impair de gris ; les trois autres cases un nombre pair.

### Étape 2

Placement forcé de Q. Q est vertical et entièrement gris : il occupe la colonne 1 ou la colonne 2. En colonne 1, il déposerait un gris sur (1,1) et sur (2,1), deux cases qui doivent finir marine : chacune aurait besoin d'un second gris, or il ne reste qu'un seul gris disponible (celui de R). Impossible. Q va donc en colonne 2 : gris sur (1,2) et sur (2,2).

### Étape 3

Placement de R. La case (2,2) a reçu un gris et doit finir marine : il lui faut un second gris. Seule R peut le fournir, avec sa case grise à droite : R se pose sur la ligne 2, marine sur (2,1), gris sur (2,2). Il ne reste que la ligne 1 pour P : marine sur (1,1) et (1,2).

### Étape 4

Vérification case par case : (1,1) = marine (P) → marine ✔ ; (1,2) = marine (P) + gris (Q) → gris ✔ ; (2,1) = marine (R) → marine ✔ ; (2,2) = gris (Q) + gris (R) → marine ✔. Les quatre cases correspondent à la cible.

## Exemple guidé 2 — la pièce biscornue d'abord

> [!EXAMPLE]
> Grille 3 × 3. Cible : (1,1) marine, (1,2) gris, (1,3) marine, (2,1) gris, (2,2) gris ; les quatre autres cases (2,3), (3,1), (3,2), (3,3) sont vides. Pièces : **S**, un coin de trois cases avec une case marine dont une case grise à droite et une case grise en dessous ; **T**, domino horizontal marine-marine ; **U**, case isolée grise.

### Étape 1

Comptage : 3 + 2 + 1 = 6 couvertures pour 5 cases colorées : un seul chevauchement. Trois cases grises dans la cible, trois cases grises dans les pièces (deux dans S, une dans U) : chaque gris tombera donc sur une case grise différente, et le chevauchement se fera avec une case marine de T.

### Étape 2

Placement de S, la pièce la plus contrainte. Son motif est « marine, avec gris à droite et gris en dessous ». Si sa case marine était en (1,2), son gris de droite tomberait en (1,3), case marine de la cible, qui aurait alors besoin d'un second gris : il n'en resterait qu'un (U), mais (2,1) et (2,2) en réclament chacune un. Impossible. Si sa case marine était en (2,2), son gris de droite tomberait sur (2,3), une case vide de la cible : interdit ; en (2,1), son gris du dessous tomberait sur (3,1), vide aussi. Reste la position marine en (1,1), gris en (1,2) et en (2,1) : compatible.

### Étape 3

Placement de T puis de U. Il reste à produire (1,3) marine et (2,2) gris. T (deux marines en ligne) doit couvrir (1,3) ; son autre case est alors (1,2), déjà grise par S : marine + gris = gris, la case reste grise, c'est le chevauchement annoncé. U, la case grise isolée, se pose sur (2,2).

### Étape 4

Vérification : (1,1) marine (S) ✔ ; (1,2) gris (S) + marine (T) = gris ✔ ; (1,3) marine (T) ✔ ; (2,1) gris (S) ✔ ; (2,2) gris (U) ✔ ; les quatre cases du bas restent vides ✔. La planche est résolue.

## Exemple guidé 3 — deux gris qui font un marine

> [!EXAMPLE]
> Grille 2 × 3 (deux lignes, trois colonnes). Cible : ligne 1 entièrement marine ; ligne 2 : (2,1) gris, (2,2) marine, (2,3) gris. Pièces : **P**, barre horizontale de trois cases marines ; **Q** et **R**, deux dominos horizontaux gris-gris identiques.

### Étape 1

Comptage : 3 + 2 + 2 = 7 couvertures pour 6 cases : un chevauchement. La cible contient deux cases grises, les pièces quatre cases grises : deux gris doivent donc s'annuler l'un l'autre sur une même case, qui apparaîtra marine.

### Étape 2

Placement de P. La barre de trois ne tient que sur une ligne complète. Si elle occupait la ligne 2, la ligne 1 devrait être produite par Q et R seuls : deux dominos gris ne peuvent pas créer trois cases marines (au mieux deux, en se superposant totalement, et la troisième resterait vide). P va donc en ligne 1, qui devient entièrement marine sans aucun gris.

### Étape 3

Placement de Q et R sur la ligne 2, trois cases pour deux dominos : l'un couvre (2,1)-(2,2), l'autre (2,2)-(2,3). La case (2,2) reçoit deux gris.

### Étape 4

Vérification : (1,1), (1,2), (1,3) = marine (P) ✔ ; (2,1) = gris ✔ ; (2,2) = gris + gris = marine ✔ ; (2,3) = gris ✔. La case marine du milieu est bien le fruit de deux gris superposés : c'est le mécanisme à reconnaître au premier coup d'œil sur les planches de la version II.

## Routine d'échauffement de 5 minutes

1. **1 min — récitation des règles** sous forme de parité : « marine neutre, gris inverse, pair = marine, impair = gris ». Testez-vous sur trois combinaisons dites à voix haute.
2. **2 min — deux planches faciles** (sans chevauchement) dans le mode Entraînement, en annonçant le placement forcé avant de glisser la première pièce.
3. **1 min 30 — une planche avec chevauchements**, en comptant à voix basse les couvertures avant de toucher aux pièces.
4. **30 s — relecture des pièges** : gris + gris = marine, cases vides interdites, décider avant de glisser.

## Pour aller plus loin

- Le paquet de flashcards `deck.spatial_overlay` reprend les trois règles, leur lecture en parité et les valeurs du format rapporté.
- La logique « déduire les placements forcés avant d'essayer » est la même que dans l'activité *Cubes* ; les deux se travaillent bien en alternance.
