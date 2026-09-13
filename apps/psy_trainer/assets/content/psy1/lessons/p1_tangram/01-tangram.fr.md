# Tangram : composer et compter avec sept pièces

L'activité « Tangram » utilise le jeu de pièces le plus connu de la géométrie récréative : deux grands triangles, un triangle moyen, deux petits triangles, un carré et un parallélogramme, soit sept pièces qui pavent exactement un grand carré. Selon la session, on vous demande soit de reconnaître quelle silhouette peut être composée avec ce jeu fixe, soit — variante apparue en 2024 — de compter combien de fois une pièce donnée apparaît à travers plusieurs silhouettes. Les deux versions se résolvent avec la même intuition : reconnaître une pièce ou un groupe de pièces à sa **forme**, pas en essayant de reconstruire mentalement tout le puzzle.

## Ce que mesure l'activité

Elle mesure la **visualisation spatiale de figures planes** : décomposer une silhouette complexe en formes élémentaires connues, ou recomposer des formes élémentaires en une silhouette cible, sans manipulation physique. C'est un exercice de reconnaissance de motifs autant que de géométrie : les meilleurs candidats ne recalculent presque rien, ils reconnaissent des « signatures » de pièces au premier coup d'œil.

## Format et chronométrage rapportés

| Élément | Valeur rapportée | Confiance |
|---|---|---|
| Jeu de pièces | Toujours le même jeu classique à sept pièces (2 grands triangles, 1 triangle moyen, 2 petits triangles, 1 carré, 1 parallélogramme) | [rapporté] |
| Variante « composition » | Une silhouette est affichée ; il faut placer/identifier l'agencement des sept pièces qui la reconstitue | [rapporté] |
| Variante « comptage » (2024) | Plusieurs silhouettes affichées ; il faut compter combien de fois une pièce donnée (ex. le petit triangle) apparaît à travers l'ensemble | [rapporté] |
| Volume | 24 planches (débrief 2024) ; le nombre et le format précis varient selon la session | [rapporté] |
| Temps | Environ 20 minutes pour l'ensemble des 24 planches, soit ~50 s par planche | [estimé] |
| Interaction | Glisser-déposer et rotation des pièces à l'écran (variante composition) ; réponse numérique ou QCM (variante comptage) | [estimé] |

## Méthode et stratégie

> [!METHOD]
> **Signature avant reconstruction.** Ne cherchez jamais à recomposer mentalement le puzzle entier. Repérez d'abord les pièces qui ont une signature unique (le carré, le parallélogramme, le grand triangle), utilisez l'aire et les angles pour éliminer les silhouettes impossibles, puis balayez systématiquement l'image pour la variante comptage.

### Les signatures à reconnaître d'un coup d'œil

Le jeu classique n'a que quatre formes de base, en trois tailles : petit triangle (aire 1 « unité »), carré et parallélogramme (aire 2 chacun), triangle moyen (aire 2), grand triangle (aire 4, il y en a deux). Trois équivalences reviennent sans cesse dans les silhouettes :

1. **Deux petits triangles, hypoténuse contre hypoténuse, forment un carré tourné à 45°.** Si une silhouette contient un losange (carré tourné) à l'endroit où vous attendiez une seule pièce carrée, ce sont en réalité deux petits triangles.
2. **Deux petits triangles, côté contre côté, forment un triangle moyen ou un parallélogramme.** La même paire de petites pièces peut donc « imiter » trois formes différentes selon leur assemblage — c'est la source numéro un des pièges de comptage.
3. **Un grand triangle a la même forme qu'un triangle moyen, à l'échelle près (rapport 2:1 en côté, 4:1 en aire).** Sur une silhouette dense, mesurez toujours la taille relative avant de conclure qu'un triangle est « le » triangle moyen : il peut s'agir d'un grand triangle partiellement masqué par une autre pièce.

### Aire et angles pour éliminer vite

Tous les angles du jeu sont des multiples de 45° (45°, 90°, 135°). **Toute silhouette candidate qui présente un sommet dont l'angle n'est pas un multiple de 45°, ou dont la somme des angles autour d'un point ne fait pas 360°, ne peut pas être composée avec ce jeu** : éliminez-la sans chercher plus loin. De même, l'aire totale des sept pièces est fixe (16 unités si le petit triangle vaut 1) : une silhouette manifestement plus grande ou plus petite que cette aire totale est impossible d'emblée, ce qui écarte souvent une option de QCM en une seconde.

### Ordre de balayage pour la variante comptage

Quand la question demande de compter les occurrences d'une pièce à travers plusieurs planches, ne cherchez pas la pièce au hasard : balayez chaque silhouette **ligne par ligne, de gauche à droite**, en ne vous arrêtant que sur les formes de la bonne taille approximative. Pointez mentalement (ou du doigt) chaque occurrence trouvée pour ne pas repasser deux fois au même endroit, et traitez les planches dans l'ordre où elles sont présentées plutôt que de revenir en arrière — revenir en arrière est la cause principale des doubles comptages ou des oublis sous la pression du temps.

## Pièges et erreurs fréquentes

> [!TRAP]
> **Confondre deux petits triangles assemblés avec une seule pièce moyenne.** Vu de loin, un carré fait de deux petits triangles ressemble à la pièce carrée unique ; un triangle moyen fait de deux petits triangles ressemble au vrai triangle moyen. Regardez toujours s'il existe une ligne de séparation fine au milieu de la forme avant de la compter comme une seule pièce.

> [!TRAP]
> **Oublier que deux tailles de triangle coexistent.** Le grand triangle et le triangle moyen ont exactement la même forme. Sur une silhouette tassée, comparez toujours la taille de la pièce suspectée à une pièce de référence certaine (le carré, par exemple) avant de la classer.

> [!TRAP]
> **Essayer de reconstruire tout le puzzle avant de répondre.** À moins de 50 s par planche, il n'y a pas le temps de replacer virtuellement les sept pièces. La méthode par signature et élimination répond en un tiers du temps.

Autres erreurs classiques :

- **Négliger le parallélogramme.** C'est la seule pièce qui peut apparaître « retournée » (image miroir) sans que cela se voie au premier regard ; une silhouette qui semble impossible peut redevenir possible si vous autorisez son retournement.
- **Compter une pièce partiellement cachée par une autre comme absente.** Si un petit triangle est en partie recouvert mais qu'un sommet à 45° dépasse, il compte quand même.
- **Changer de méthode en cours de planche.** Une fois lancé sur le balayage ligne par ligne, terminez la ligne avant de recompter depuis le début : recommencer par nervosité coûte plus cher que de continuer une hypothèse imparfaite.

## Exemple guidé 1 — éliminer une silhouette impossible par l'aire

> [!EXAMPLE]
> On vous montre une silhouette candidate en forme de grand triangle rectangle isocèle, et on vous demande si elle peut être recomposée exactement avec le jeu complet de sept pièces (2 grands triangles, 1 moyen, 2 petits, 1 carré, 1 parallélogramme). Le triangle candidat a des côtés deux fois plus longs que ceux d'un grand triangle de base.

### Étape 1

Calculez l'aire du triangle candidat en unités du jeu. Un grand triangle de base a une aire de 4 unités (si le petit triangle vaut 1). Un triangle aux côtés deux fois plus longs a une aire multipliée par **4** (le carré du facteur d'échelle), soit 4 × 4 = 16 unités.

### Étape 2

Calculez l'aire totale disponible dans le jeu complet : 2 grands triangles (4 + 4) + 1 triangle moyen (2) + 2 petits triangles (1 + 1) + 1 carré (2) + 1 parallélogramme (2) = 16 unités.

### Étape 3

Les deux aires coïncident exactement (16 = 16) : la silhouette n'est donc pas exclue par l'aire. Il faudrait vérifier ensuite les angles (ici, un grand triangle rectangle isocèle n'a que des angles de 45° et 90°, compatibles avec le jeu) pour confirmer que la composition est plausible — mais l'étape d'aire, à elle seule, aurait déjà éliminé toute silhouette de taille différente en une seconde, sans avoir à recomposer quoi que ce soit.

## Exemple guidé 2 — reconnaître la paire qui imite une autre pièce

> [!EXAMPLE]
> Une silhouette montre, au centre, une forme carrée traversée par une fine ligne diagonale reliant deux coins opposés. À gauche de ce carré, un vrai triangle moyen isolé, de même taille apparente que chacune des deux moitiés du carré. On vous demande : combien de « triangles moyens » distincts (au sens de la pièce du jeu) apparaissent dans cette planche ?

### Étape 1

La ligne diagonale qui traverse le carré central signale que ce n'est pas la pièce carrée unique : ce sont **deux petits triangles**, hypoténuse contre hypoténuse (signature n°1 du cours). Ces deux moitiés ne sont donc pas des triangles moyens, même si leur taille peut y faire penser au premier regard.

### Étape 2

Comparez la taille du triangle isolé à gauche avec celle d'une moitié du carré central. S'il est visiblement plus grand qu'une simple moitié de carré (aire 2 contre aire 1), c'est bien la pièce triangle moyen du jeu.

### Étape 3

Conclusion : un seul vrai triangle moyen apparaît sur cette planche (celui de gauche) ; le carré central est en réalité une paire de petits triangles et ne doit pas être compté. Une lecture rapide sans vérifier la ligne de séparation aurait fait compter deux triangles moyens à tort, ou zéro carré alors qu'il y en a un valide au sens visuel — la vigilance sur les lignes de séparation fines est ce qui distingue les deux lectures.

## Exemple guidé 3 — balayage systématique pour un comptage sur plusieurs planches

> [!EXAMPLE]
> Trois silhouettes côte à côte : planche A (un profil de maison, toit en grand triangle, corps en carré, cheminée en parallélogramme), planche B (une forme de poisson, nageoire en petit triangle, corps en triangle moyen, queue faite de deux petits triangles côte à côte), planche C (une flèche, pointe en grand triangle, hampe en parallélogramme, ailerons en deux petits triangles superposés en partie). Combien de petits triangles au total à travers les trois planches ?

### Étape 1

Balayez planche A en premier, de gauche à droite : toit (grand triangle, pas un petit), corps (carré, pas un petit), cheminée (parallélogramme, pas un petit). **0 petit triangle** sur la planche A.

### Étape 2

Planche B : nageoire (1 petit triangle isolé), corps (triangle moyen, pas un petit), queue (deux petits triangles côte à côte — vérifiez la ligne de séparation entre eux, elle est visible, donc ce sont bien deux pièces distinctes). **3 petits triangles** sur la planche B (1 + 2).

### Étape 3

Planche C : pointe (grand triangle), hampe (parallélogramme), ailerons (deux petits triangles partiellement superposés — un sommet à 45° dépasse sous la pièce du dessus, donc les deux comptent malgré le recouvrement). **2 petits triangles** sur la planche C.

### Étape 4

Total en balayant les planches dans l'ordre A puis B puis C, sans revenir en arrière : 0 + 3 + 2 = **5 petits triangles**. Le seul risque d'erreur ici était de manquer l'aileron partiellement caché de la planche C ou de fusionner par erreur la queue à deux triangles de la planche B en une seule pièce.

## Routine d'échauffement de 5 minutes

1. **1 min — récitation des trois signatures.** À voix basse : deux petits triangles hypoténuse à hypoténuse = carré tourné ; deux petits triangles côté à côte = triangle moyen ou parallélogramme ; grand triangle et triangle moyen ont la même forme à l'échelle près.
2. **1 min 30 — deux planches faciles de la variante composition** en mode Entraînement, en appliquant d'abord le test d'aire puis le test d'angle avant de manipuler les pièces.
3. **1 min 30 — une planche de la variante comptage**, en imposant un balayage ligne par ligne sans retour en arrière, doigt posé sur l'écran pour marquer la progression.
4. **1 min — relecture des pièges** : lignes de séparation fines à ne pas rater, tailles relatives à comparer, ne jamais tenter de recomposer tout le puzzle avant de répondre.

## Pour aller plus loin

- L'activité *Matrices progressives de Raven* sollicite une reconnaissance de motifs proche (des sous-figures récurrentes à repérer vite), utile à travailler en alternance avec le Tangram.
