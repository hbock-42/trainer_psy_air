# Dominos : le catalogue des lois modulo 7

Les dominos sont revenus dans la batterie PSY0 en 2024 après plusieurs années d'absence, et ils y figurent encore en 2026. C'est l'activité de **raisonnement inductif pur** de la session : pas de connaissances à mobiliser, seulement une petite arithmétique sur sept valeurs et une bonne discipline de lecture. Les candidats qui la ratent ne manquent presque jamais d'intelligence ; ils manquent d'un **catalogue** de lois à tester dans le bon ordre, et de la réserve de temps que ce catalogue procure.

## Ce que mesure l'activité

Chaque question présente une disposition de dominos (en ligne, en cercle, en matrice ou en spirale) dont un domino est vide. Vous devez **construire le domino manquant** en choisissant ses deux moitiés, chacune de 0 à 6. L'activité mesure le **raisonnement fluide** : repérer une régularité à partir de quelques exemples, la formuler, la prolonger, puis la vérifier. Elle mesure aussi la **flexibilité** : abandonner rapidement une hypothèse qui ne colle pas, plutôt que forcer le motif que l'on voulait voir.

C'est un test très classique de la sélection des pilotes (il a longtemps fait partie des batteries de l'armée de l'air et de l'ENAC). Sa particularité arithmétique : les valeurs **bouclent modulo 7**. Après 6 vient 0, avant 0 vient 6. Tout le catalogue ci-dessous repose là-dessus.

## Format et chronométrage rapportés

| Élément | Valeur rapportée | Confiance |
|---|---|---|
| Tâche | Construire le domino manquant : deux moitiés de 0 à 6 | [rapporté] |
| Réponse | Choix libre de chaque moitié (7 × 7 possibilités), aucune liste de propositions | [rapporté] |
| Volume | Environ 20 questions en environ 10 minutes dans le format des entraîneurs en ligne | [rapporté] |
| Nombre exact d'items le jour J | Inconnu ; notre simulation en propose 16 en 8 minutes | [estimé] |
| Temps par question | Environ 30 s | [estimé] |
| Présence | Sessions 2024, 2025 et 2026 (absent de 2019 à 2023) | [rapporté] |
| Pénalité pour erreur | Non documentée pour cette activité | [estimé] |

Deux conséquences pratiques. D'abord, **une trentaine de secondes par domino** : c'est peu pour tester dix lois au hasard, mais largement assez si vous les testez dans un ordre fixe. Ensuite, la réponse étant libre, il n'y a **aucun indice dans des propositions** : votre vérification finale est votre seule sécurité.

## Méthode et stratégie

> [!METHOD]
> **Sens, moitiés, loi, vérification.** 1) Déterminez le **sens de lecture** (ligne de gauche à droite, cercle dans le sens horaire, spirale de l'extérieur vers l'intérieur, matrice par lignes puis par colonnes). 2) Lisez la **moitié haute seule**, puis la **moitié basse seule**, en notant l'écart entre voisins modulo 7. 3) Si une loi apparaît sur une moitié, appliquez-la ; si aucune n'apparaît, **couplez** les moitiés (somme, différence, échange). 4) Prolongez, puis **relisez toute la série** avec la loi trouvée avant de valider.

### Le catalogue des lois, dans l'ordre où les tester

1. **Pas constant sur une moitié.** Les hauts font +1, +2, +3… (ou −1, −2…) modulo 7. Exemple : 4, 6, 1, 3 est un « +2 » (6 + 2 = 8, et 8 − 7 = 1). C'est la loi la plus fréquente : testez-la en premier, séparément sur chaque moitié.
2. **Pas alterné.** +1 puis +3, puis +1, puis +3… Ou +2 puis −1. Repérez-le quand les écarts oscillent entre deux valeurs.
3. **Pas croissant.** +1, +2, +3, +4… (écarts qui augmentent d'une unité). Plus rare, mais reconnaissable au fait que les écarts eux-mêmes forment une série.
4. **Deux séries entrelacées.** Les dominos de rang impair suivent une loi, ceux de rang pair une autre. Indice : les écarts semblent n'avoir aucun sens, mais en sautant un domino sur deux tout devient régulier.
5. **Somme constante.** Haut + bas donne toujours la même valeur (modulo 7 ou non). Vérifiez-la dès qu'une moitié suit une loi et l'autre semble « aller à l'envers ».
6. **Différence constante.** Bas = haut + k. Cousine de la précédente ; on la reconnaît quand les deux moitiés progressent dans le même sens avec le même pas.
7. **Moitiés échangées.** Le domino suivant est le précédent retourné, parfois avec un pas ajouté. Dans un cercle, le domino d'en face est souvent l'inverse du domino considéré.
8. **Symétrie.** Dans un cercle ou une matrice, les dominos opposés (ou symétriques par rapport à un axe) sont identiques, inversés, ou complémentaires à 6.
9. **Loi sur la somme ou la différence.** Les valeurs individuelles ne suivent rien, mais la somme haut + bas de chaque domino forme une série (+1, +2…), ou bien la différence.
10. **Loi de matrice.** Dans une grille 3 × 3 : la troisième colonne est la somme (ou la différence) des deux premières, moitié par moitié ; ou bien chaque ligne suit la même loi que les autres.

### Comment lire le sens

- **Ligne** : de gauche à droite, sauf si les écarts n'ont de sens que de droite à gauche (un « −2 » lu à l'envers est un « +2 »).
- **Cercle** : sens horaire par défaut ; le vide peut être n'importe où, continuez la série « à travers » lui et vérifiez que le dernier domino rejoint bien le premier.
- **Spirale** : de l'extérieur vers le centre ou l'inverse ; le domino manquant est souvent au centre, ce qui vous oblige à prolonger jusqu'au bout.
- **Matrice** : testez d'abord les lignes, puis les colonnes ; une loi valable sur deux lignes complètes suffit pour la troisième.

### Quand séparer et quand coupler

Séparez **toujours** en premier : c'est rapide, et deux lois indépendantes (une par moitié) expliquent la majorité des items. Couplez seulement si, après avoir écrit les écarts d'une moitié, vous ne voyez ni pas constant, ni pas alterné, ni entrelacement. Le couplage coûte plus cher en temps ; ne l'engagez pas par réflexe.

## Pièges et erreurs fréquentes

> [!TRAP]
> **Oublier le bouclage.** 5, 6, 0, 1 est un « +1 » parfaitement régulier. Le candidat qui lit « 5, 6, puis retour à 0 » comme une rupture cherche une loi compliquée là où il n'y en a pas. Avant de conclure à une irrégularité, ajoutez ou retirez 7.

> [!TRAP]
> **Confondre le domino et son orientation.** Un domino posé verticalement puis horizontalement dans un cercle change de « haut » et de « bas » selon le point de vue. Fixez-vous une convention (par exemple la moitié la plus proche du centre est « le haut ») avant de lire, et gardez-la jusqu'à la vérification.

> [!TRAP]
> **Valider sur trois dominos.** Trois valeurs suffisent à « voir » un pas constant… qui se révèle être un pas alterné au quatrième. Lisez la série **entière** avant de formuler la loi, et refaites-la entière après.

Autres erreurs classiques :

- **Forcer la loi précédente.** Après trois items « +2 », on cherche un « +2 » partout. Le catalogue se relit à chaque item, sans a priori.
- **Traiter le domino vide comme une case blanche.** Il fait partie de la série : dans un cercle de huit dominos, le vide est le huitième maillon et la loi doit tourner autour du cercle en passant par lui.
- **Se bloquer.** Si aucune loi ne sort en 30 s, choisissez la plus plausible (celle qui explique le plus de dominos), validez, et passez. Un item abandonné coûte autant qu'un item faux, mais il ne coûte pas les suivants.
- **Négliger la vérification.** La réponse est libre : une inversion haut/bas ou un 7 écrit à la place d'un 0 ne sera signalé par personne.

## Exemple guidé 1 — une ligne à pas constant

> [!EXAMPLE]
> Ligne de cinq dominos lus de gauche à droite : `[1|4]`, `[3|6]`, `[5|1]`, `[0|3]`, `[?|?]`. Trouvez le dernier domino.

### Étape 1

Sens de lecture : ligne, de gauche à droite. Je lis d'abord la moitié haute seule : 1, 3, 5, 0. Les écarts sont +2, +2, puis 5 → 0 : 5 + 2 = 7, et 7 ramené modulo 7 donne 0. C'est bien +2 partout.

### Étape 2

Moitié basse seule : 4, 6, 1, 3. Écarts : +2, puis 6 → 1 : 6 + 2 = 8, et 8 − 7 = 1 ; puis +2. Encore un pas constant de +2. Les deux moitiés suivent la même loi indépendamment : inutile de coupler.

### Étape 3

Prolongation. Haut : 0 + 2 = 2. Bas : 3 + 2 = 5. Le domino manquant est `[2|5]`.

### Étape 4

Vérification en relisant toute la ligne avec la loi : hauts 1, 3, 5, 0, 2 (chaque fois +2 modulo 7) ; bas 4, 6, 1, 3, 5 (idem). Aucune rupture, la réponse `[2|5]` est validée.

## Exemple guidé 2 — un cercle où une moitié « va à l'envers »

> [!EXAMPLE]
> Six dominos disposés en cercle, lus dans le sens horaire à partir du sommet, moitié « haute » côté centre : `[0|6]`, `[3|3]`, `[6|0]`, `[2|4]`, `[5|1]`, `[?|?]`. Trouvez le sixième domino.

### Étape 1

Moitié haute seule : 0, 3, 6, 2, 5. Écarts : +3, +3, puis 6 → 2 : 6 + 3 = 9, 9 − 7 = 2, c'est +3 ; puis 2 → 5 : +3. Un pas constant de +3.

### Étape 2

Moitié basse seule : 6, 3, 0, 4, 1. Écarts : −3, −3, puis 0 → 4 : 0 − 3 = −3, et −3 + 7 = 4, c'est bien −3 ; puis 4 → 1 : −3. Un pas constant de −3. Chaque moitié a sa propre loi, la lecture séparée suffit.

### Étape 3

Prolongation. Haut : 5 + 3 = 8, soit 1 modulo 7. Bas : 1 − 3 = −2, soit 5 modulo 7. Le domino manquant est `[1|5]`.

### Étape 4

Contre-vérification par une deuxième loi : la somme haut + bas vaut 6 sur chaque domino (0 + 6, 3 + 3, 6 + 0, 2 + 4, 5 + 1). Pour `[1|5]`, 1 + 5 = 6 également. Deux lois indépendantes (pas +3 / −3, et somme constante 6) donnent la même réponse : c'est la meilleure garantie possible. Je vérifie enfin l'orientation (1 côté centre, 5 côté extérieur) et `[1|5]` est validé.

## Exemple guidé 3 — une matrice 3 × 3

> [!EXAMPLE]
> Neuf dominos en grille. Ligne 1 : `[2|5]`, `[4|3]`, `[6|1]`. Ligne 2 : `[5|6]`, `[3|4]`, `[1|3]`. Ligne 3 : `[3|2]`, `[6|6]`, `[?|?]`. Trouvez le domino en bas à droite.

### Étape 1

Sens de lecture : matrice, je teste d'abord les lignes. Ligne 1, moitié haute : 2, 4, 6, un « +2 » possible. Ligne 2, moitié haute : 5, 3, 1, un « −2 ». Les deux lignes ne suivent pas le même pas : l'hypothèse « pas constant par ligne » n'explique pas la grille, je l'abandonne.

### Étape 2

Je passe aux lois de matrice : la troisième colonne est-elle la somme des deux premières, moitié par moitié ? Ligne 1, haut : 2 + 4 = 6, et le troisième domino a bien 6 en haut. Bas : 5 + 3 = 8, soit 1 modulo 7, et il a bien 1 en bas. Ligne 2, haut : 5 + 3 = 8 → 1, correct ; bas : 6 + 4 = 10 → 3, correct. La loi tient sur les deux lignes complètes.

### Étape 3

Application à la ligne 3. Haut : 3 + 6 = 9, soit 2 modulo 7. Bas : 2 + 6 = 8, soit 1 modulo 7. Le domino manquant est `[2|1]`.

### Étape 4

Vérification : je refais les trois additions de tête en partant du résultat. Ligne 1 : 6 − 4 = 2 (haut) et 1 − 3 = −2 → 5 (bas), on retrouve `[2|5]`. Ligne 3 : 2 − 6 = −4 → 3 (haut) et 1 − 6 = −5 → 2 (bas), on retrouve `[3|2]`. La loi est cohérente dans les deux sens. Je vérifie aussi que je n'ai pas inversé les moitiés : haut 2, bas 1. `[2|1]` est validé.

## Routine d'échauffement de 5 minutes

1. **1 min — la table du modulo.** Sans écran, récitez les additions qui bouclent : 4 + 3 = 0, 5 + 4 = 2, 6 + 6 = 5, 3 − 5 = 5, 0 − 2 = 5, 1 − 4 = 4. L'objectif est que « 8 devient 1 » et « −2 devient 5 » ne demandent plus aucun effort.
2. **1 min — écarts à vue.** Prenez quatre valeurs au hasard (par exemple 2, 6, 3, 0) et dites les écarts modulo 7 entre voisins (+4, −3, −3). Faites-le trois fois.
3. **2 min — quatre dominos** en mode Entraînement, en vous imposant l'ordre du catalogue : séparer, puis coupler. Chronométrez-vous à 30 s par item.
4. **1 min — relecture** des dix lois et des trois pièges (bouclage, orientation, validation trop précoce). Puis on lance.

## Pour aller plus loin

- Le paquet de flashcards `deck.logic_dominos` reprend la table d'addition et de soustraction modulo 7, les dix lois du catalogue avec un exemple chacune, et les conventions de lecture (ligne, cercle, spirale, matrice).
- Les *Grilles de calcul* entraînent la même vérification rapide des additions et multiplications ; les dominos y gagnent en vitesse.
