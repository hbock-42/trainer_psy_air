# Matrices progressives : trouver la règle avant de chercher la case

Les matrices progressives, popularisées par la batterie de Raven, affichent une grille de 3×3 figures dans laquelle la dernière case est vide ; il faut retrouver, parmi plusieurs options, la figure qui poursuit logiquement le motif. Chaque ligne et chaque colonne évolue selon une ou plusieurs règles (nombre de formes, rotation, remplissage, superposition, taille) et la difficulté vient rarement d'une règle compliquée mais du fait qu'il faut en tester plusieurs avant de trouver celle qui s'applique réellement. Les candidats rapportent cette épreuve comme plus dure que le matériel d'entraînement habituel : la méthode compte plus que l'intuition brute.

## Ce que mesure l'activité

Elle mesure le **raisonnement analogique non verbal** : détecter une règle de transformation à partir d'exemples incomplets, puis l'appliquer pour prédire l'élément manquant. Contrairement au tangram ou aux cubes, il n'y a rien à plier ni à assembler : il s'agit de repérer un motif abstrait qui se répète, une aptitude générale de raisonnement fluide indépendante de toute connaissance préalable.

## Format et chronométrage rapportés

| Élément | Valeur rapportée | Confiance |
|---|---|---|
| Écran | Une grille de 3×3 figures, la case en bas à droite vide, à compléter parmi des options en QCM | [rapporté] |
| Réponse | Sélection d'une option unique parmi celles proposées | [rapporté] |
| Volume | 30 questions | [rapporté] |
| Temps | 30 minutes, soit environ 1 minute par question | [rapporté] |
| Difficulté ressentie | Signalée par un débrief comme nettement plus difficile que le matériel de préparation habituel | [rapporté] |

## Méthode et stratégie

> [!METHOD]
> **Lignes et colonnes séparément, du plus visible au plus subtil.** Analysez d'abord ce qui change entre les trois cases de chaque ligne, puis entre les trois cases de chaque colonne, sans mélanger les deux au début. Testez en premier les règles les plus visibles (nombre de formes, couleur/remplissage), puis seulement si elles ne suffisent pas les règles plus subtiles (rotation, addition/soustraction d'éléments entre cases). Éliminez ensuite toute option qui respecte une ligne ou une colonne mais viole l'autre.

### Vérifier les lignes ET les colonnes, séparément puis ensemble

Une matrice cohérente obéit presque toujours à une règle par ligne (ou par colonne) qui reste stable sur les trois lignes, ou à une règle par colonne stable sur les trois colonnes — parfois les deux à la fois. Commencez par comparer les trois cases de la première ligne entre elles pour formuler une hypothèse de règle, puis vérifiez si cette même règle s'applique aux deuxième et troisième lignes. Faites ensuite le même travail sur les colonnes. Une règle qui ne fonctionne que sur une ligne et pas sur les deux autres est fausse : reformulez-la avant de continuer.

### L'ordre des règles à tester

Les règles les plus faciles à repérer sont aussi celles qu'il faut tester en premier, car elles règlent la majorité des cas en quelques secondes :

1. **Nombre de formes.** La quantité de formes dans chaque case augmente ou diminue régulièrement le long d'une ligne ou d'une colonne (par exemple 1, 2, 3 formes).
2. **Remplissage / couleur.** Une forme passe du contour vide au remplissage partiel puis au remplissage complet, ou change de teinte selon une progression régulière.
3. **Taille.** Une forme grandit ou rétrécit régulièrement d'une case à l'autre.

Si ces trois règles visibles ne suffisent pas à expliquer toute la grille, passez aux règles plus subtiles :

4. **Rotation.** Une forme tourne d'un angle constant (souvent 45° ou 90°) d'une case à l'autre le long d'une ligne ou d'une colonne.
5. **Superposition / addition-soustraction (XOR).** Le contenu d'une case s'obtient en combinant les deux cases précédentes : les éléments présents dans l'une des deux cases mais pas dans les deux à la fois se retrouvent dans la troisième (une sorte de « ou exclusif » visuel), ou au contraire seuls les éléments communs aux deux premières cases survivent dans la troisième.

### Éliminer par cohérence croisée

Une fois une règle de ligne et une règle de colonne identifiées, la case manquante doit satisfaire **les deux en même temps**. Cela permet d'éliminer très vite les options qui ne respectent qu'une seule des deux contraintes : une option qui a le bon nombre de formes (règle de ligne) mais la mauvaise rotation (règle de colonne) doit être écartée, même si elle « semble » proche de la bonne réponse à l'œil.

## Pièges et erreurs fréquentes

> [!TRAP]
> **S'arrêter à la première règle visible sans vérifier les colonnes.** Une règle qui explique parfaitement les lignes peut ne pas suffire si la grille combine en réalité une règle de ligne et une règle de colonne différente ; l'option choisie sur la seule base des lignes peut violer la règle des colonnes. Vérifiez toujours les deux avant de conclure.

> [!TRAP]
> **Confondre superposition et addition simple.** Dans une règle de type « ou exclusif », un élément présent dans les deux premières cases d'une ligne **disparaît** dans la troisième, il ne s'additionne pas. Une option qui contient tous les éléments des deux cases précédentes cumulés est un piège classique pour qui n'a pas vérifié la règle sur les autres lignes de la grille.

> [!TRAP]
> **Choisir une option par ressemblance générale plutôt que par vérification de règle.** Une option peut « avoir l'air » cohérente en un coup d'œil rapide sans respecter exactement la progression de taille, de rotation ou de remplissage. Reformulez toujours la règle en mots avant de comparer les options, plutôt que de choisir sur une impression visuelle.

Autres erreurs classiques :

- **Changer de règle en cours d'analyse sans repartir de zéro.** Si l'hypothèse initiale ne colle pas à la troisième ligne, reformulez complètement plutôt que de « forcer » l'ancienne règle avec des exceptions.
- **Ignorer la rotation quand les formes semblent identiques.** Une forme symétrique (un carré, un cercle) peut cacher une rotation qui ne se voit que sur un détail (un petit repère, une pointe) : ne concluez pas trop vite qu'« il n'y a pas de rotation ».
- **Se précipiter sur la première option qui semble plausible** sans avoir éliminé les autres par la règle de la ligne ET de la colonne. À une minute par question, une vérification croisée systématique reste plus rapide qu'un retour en arrière après une erreur.

## Exemple guidé 1 — nombre de formes et remplissage combinés

> [!EXAMPLE]
> Grille 3×3. Ligne 1 : une case avec 1 triangle vide, une case avec 2 triangles vides, une case avec 3 triangles vides. Ligne 2 : 1 triangle à moitié rempli, 2 triangles à moitié remplis, 3 triangles à moitié remplis. Ligne 3 : 1 triangle plein, 2 triangles pleins, case manquante en bas à droite. Options : (A) 3 triangles pleins, (B) 3 triangles à moitié remplis, (C) 2 triangles pleins, (D) 3 triangles vides.

### Étape 1

Règle de ligne : sur chaque ligne, le nombre de triangles augmente de 1, 2, 3 de gauche à droite. La ligne 3 a déjà 1 puis 2 triangles pleins : la case manquante doit donc contenir **3** formes.

### Étape 2

Règle de colonne (remplissage) : sur la troisième colonne (3 formes à chaque fois), le remplissage suit vide (ligne 1), moitié (ligne 2), plein (ligne 3) — cohérent avec le remplissage déjà observé sur les lignes 1 et 2 dans leur ensemble (chaque ligne a un remplissage constant : vide, moitié, plein).

### Étape 3

Élimination croisée : l'option doit avoir 3 formes (élimine C avec 2 formes, et se méfier des options à 3 formes mais mal remplies) et un remplissage plein (élimine B, à moitié rempli, et D, vide).

### Étape 4

Seule l'option **A** (3 triangles pleins) respecte à la fois la règle de ligne (nombre) et la règle de colonne/ligne (remplissage plein sur la troisième ligne).

## Exemple guidé 2 — rotation le long d'une colonne

> [!EXAMPLE]
> Grille 3×3, chaque case contient une seule flèche. Colonne 1 (de haut en bas) : flèche pointant vers le haut, puis vers la droite, puis vers le bas (rotation de 90° à chaque case vers le bas de la colonne). Colonne 2 : flèche vers la droite, vers le bas, vers la gauche. Colonne 3 : flèche vers le bas, vers la gauche, case manquante. Options : (A) flèche vers le haut, (B) flèche vers la droite, (C) flèche vers le bas, (D) flèche vers le bas-gauche (diagonale).

### Étape 1

Règle de colonne : dans chaque colonne, la flèche tourne de 90° dans le sens horaire d'une case à la suivante en descendant. Colonne 3 : vers le bas (ligne 1), vers la gauche (ligne 2, soit +90° horaire par rapport à « bas »), donc ligne 3 doit être « bas » tourné encore de 90° horaire à partir de « gauche », soit **vers le haut**.

### Étape 2

Vérification par la règle de ligne : sur la ligne 3 (si les lignes 1 et 2 de cette ligne étaient visibles, une rotation constante ligne par ligne devrait aussi mener à « vers le haut » pour rester cohérente ; ici l'énoncé ne donne que les colonnes, donc la règle de colonne suffit à elle seule et n'est contredite par aucune information de ligne disponible).

### Étape 3

Élimination : (B) droite, (C) bas et (D) diagonale ne correspondent pas à une rotation de 90° horaire supplémentaire à partir de « gauche ». Seule l'option **(A) vers le haut** complète la rotation régulière de la colonne.

### Étape 4

Piège évité : une lecture rapide aurait pu confondre le sens de rotation (horaire vs antihoraire) en regardant une seule paire de cases au lieu des trois ; vérifier la rotation sur l'ensemble de la colonne (haut→droite→bas, soit trois pas de 90° horaire) confirme sans ambiguïté le sens.

## Exemple guidé 3 — superposition de type « ou exclusif »

> [!EXAMPLE]
> Grille 3×3, chaque case est une petite grille de points 2×2 (quatre positions possibles) où certaines positions sont noircies. Ligne 1 : case 1 a les points en haut-gauche et bas-droite noircis ; case 2 a les points en haut-droite et bas-gauche noircis ; case 3 a les quatre points noircis. Ligne 2 : case 1 a seulement haut-gauche noirci ; case 2 a seulement haut-droite noirci ; case 3 a haut-gauche et haut-droite noircis. Ligne 3 : case 1 a haut-gauche et bas-gauche noircis ; case 2 a bas-gauche et bas-droite noircis ; case 3 manquante. Options : (A) haut-gauche et bas-droite noircis, (B) bas-gauche seul noirci, (C) haut-gauche, bas-gauche et bas-droite noircis, (D) les quatre points noircis.

### Étape 1

Test de la règle « addition simple » sur la ligne 2 : case 1 (haut-gauche) + case 2 (haut-droite) donnerait haut-gauche et haut-droite ensemble si tout s'additionnait — et c'est exactement ce qu'on observe en case 3 (haut-gauche et haut-droite). La règle candidate est donc : **la troisième case contient l'union des points noircis des deux premières cases**, à condition de vérifier qu'aucun point n'est noirci dans les deux premières cases à la fois (sinon il faudrait tester le « ou exclusif » où un point commun aux deux s'annule).

### Étape 2

Vérification sur la ligne 1 : case 1 (haut-gauche, bas-droite) et case 2 (haut-droite, bas-gauche) n'ont aucun point noirci en commun ; leur union donne les quatre points, ce qui correspond bien à la case 3 observée (les quatre points noircis). La règle d'union est confirmée sur les deux lignes disponibles, sans contre-exemple de point commun à annuler.

### Étape 3

Application à la ligne 3 : case 1 (haut-gauche, bas-gauche) et case 2 (bas-gauche, bas-droite) partagent un point commun, **bas-gauche**. Ici la règle doit être affinée : comme les lignes 1 et 2 n'avaient pas de point commun à tester, il faut choisir entre « union » (le point commun reste noirci une fois) et « ou exclusif » (le point commun s'annule). Le format-type de cette famille d'exercices privilégie le « ou exclusif » quand un point commun apparaît, car c'est la seule règle qui explique pourquoi un point compté deux fois ne serait pas simplement dupliqué : bas-gauche s'annule, il ne reste que haut-gauche (unique à la case 1) et bas-droite (unique à la case 2).

### Étape 4

Résultat attendu : haut-gauche et bas-droite noircis, bas-gauche annulé — ce qui correspond à l'option **(A)**. Les options (C) et (D) correspondent à une règle d'union pure sans annulation (ce que la ligne 3 contredit dès qu'un point est partagé), et l'option (B) omet un point qui devrait rester seul. Ce type de règle plus subtile illustre pourquoi il faut toujours tester les règles visibles avant de conclure trop vite à une simple addition.

## Routine d'échauffement de 5 minutes

1. **1 min — récitation de l'ordre des règles.** À voix basse : nombre, remplissage, taille, puis rotation, puis superposition/addition-soustraction.
2. **1 min 30 — deux matrices faciles** (règle de nombre ou de remplissage) en mode Entraînement, en formulant la règle à voix haute avant de choisir une option.
3. **1 min 30 — une matrice avec rotation**, en suivant explicitement le sens (horaire/antihoraire) sur les trois cases d'une même ligne ou colonne avant de répondre.
4. **1 min — relecture des pièges** : vérifier lignes ET colonnes, ne pas confondre union et « ou exclusif », ne pas choisir par ressemblance générale.

## Pour aller plus loin

- L'activité *Tangram* sollicite une reconnaissance de motifs et de sous-figures proche de celle utilisée ici pour repérer une règle visuelle rapidement.
