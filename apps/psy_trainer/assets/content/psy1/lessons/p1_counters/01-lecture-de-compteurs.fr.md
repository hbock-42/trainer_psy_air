# Lecture de compteurs : estimer une valeur sans compter les graduations

« Compteurs » est l'analogue PSY1 le plus proche d'un balayage d'instruments de vol : on vous présente un ou plusieurs cadrans analogiques (aiguille sur une échelle graduée) et il faut en lire la valeur, vite et sans erreur. La tentation naturelle — compter une à une les petites graduations depuis le zéro jusqu'à la position de l'aiguille — est précisément ce qui vous fera manquer le temps imparti. La compétence recherchée est l'**estimation par interpolation visuelle**, pas le comptage.

Précision honnête avant de commencer : ni le nombre exact d'items ni la limite de temps par item ne sont documentés par les débriefs disponibles pour cette épreuve — ce sont des **questions ouvertes**. La méthode enseignée ici (interpolation entre repères, gestion des compteurs à plusieurs tours, ordre de balayage fixe) reste valable quel que soit le volume exact retenu le jour J.

## Ce que mesure l'activité

Lire un compteur mesure la capacité à convertir instantanément une **position visuelle** en une **valeur numérique**, sans passer par un comptage explicite. C'est exactement la compétence mobilisée en pilotage face à un altimètre, un indicateur de vitesse ou une jauge de carburant à aiguille : le pilote ne compte pas les graduations, il reconnaît d'un regard « l'aiguille est aux trois quarts de l'intervalle entre 40 et 50 » et lit 47 ou 48 sans hésitation. Un balayage rapide et fiable sur plusieurs cadrans à la fois — le scan d'instruments classique — est la seconde compétence testée : dans quel ordre regarder plusieurs cadrans pour ne rien manquer sans perdre de temps.

## Format et chronométrage rapportés

| Élément | Valeur rapportée | Confiance |
|---|---|---|
| Nature de l'épreuve | Lecture de valeurs sur des cadrans/compteurs analogiques, réponse à donner | [rapporté] |
| Nombre d'items | Non documenté | [question ouverte] |
| Limite de temps par item | Non documentée ; probable mais non confirmée | [question ouverte] |
| Volume retenu par l'application | Environ 10 items par défaut | [estimé] |
| Format de réponse | Valeur numérique | [assumé] |
| Type de cadrans | Échelles linéaires (0–100), circulaires (0–360°), et échelles non linéaires possibles | [assumé] |

Une conséquence pratique : entraînez-vous à lire vite *et* juste plutôt qu'à optimiser pour une contrainte de temps précise que nous ne pouvons pas garantir identique au jour J.

## Méthode et stratégie

> [!METHOD]
> **Repérez toujours les deux graduations majeures qui encadrent l'aiguille avant de chercher la valeur exacte.** Ne partez jamais du zéro du cadran : cherchez d'abord les deux repères numérotés les plus proches de la position de l'aiguille (par exemple 40 et 50), puis estimez la fraction de l'intervalle parcourue (un quart, un tiers, la moitié, les trois quarts) plutôt que de compter les petites graduations une à une.

**L'interpolation par fractions simples.** L'œil humain estime bien les fractions simples d'un intervalle : la moitié, le tiers, le quart, les trois quarts. Entraînez-vous à reconnaître ces positions d'un coup d'œil plutôt qu'à calculer un pourcentage exact. Une aiguille visiblement un peu avant le milieu entre 40 et 50 se lit directement « environ 44-46 », sans qu'il soit nécessaire de compter cinq petites graduations.

**Les compteurs à plusieurs tours (effet de tour).** Certains compteurs (typiquement une jauge de carburant ou un compte-tours) font plus d'un tour complet pour couvrir toute leur plage de valeurs : l'aiguille repasse par la position « zéro » visuelle sans que la valeur réelle ne soit nulle. Le repère qui distingue les tours est presque toujours un **second indicateur** : une petite fenêtre numérique, une aiguille secondaire plus courte, ou une couleur de fond différente selon le tour. Ne lisez jamais la position de l'aiguille principale sans avoir d'abord vérifié sur quel tour elle se trouve — l'erreur classique est de lire « 20 » alors que la vraie valeur est « 120 », l'aiguille ayant déjà fait un tour complet.

**L'ordre de balayage sur plusieurs cadrans.** Quand plusieurs cadrans sont présentés ensemble, fixez-vous un ordre de lecture systématique — par exemple de gauche à droite puis de haut en bas — et ne le changez jamais en cours d'item, même si un cadran vous semble plus facile à lire qu'un autre. Un ordre fixe évite de relire deux fois le même cadran par erreur ou d'en sauter un sous la pression du temps.

**Se méfier des échelles non linéaires.** Toutes les échelles ne sont pas régulières : certains cadrans resserrent leurs graduations à une extrémité (par exemple pour donner plus de précision dans une zone critique). Avant d'interpoler, vérifiez d'un coup d'œil que l'espacement entre deux graduations voisines est bien constant sur tout le cadran ; si ce n'est pas le cas, l'interpolation par fraction simple doit se faire **localement**, entre les deux graduations numérotées les plus proches, jamais sur l'ensemble du cadran.

## Pièges et erreurs fréquentes

> [!TRAP]
> **L'erreur d'un tour sur un compteur à tours multiples.** Lire la position de l'aiguille sans vérifier le tour en cours donne une valeur juste à un multiple de la plage près (par exemple 20 au lieu de 120). Toujours vérifier l'indicateur de tour avant de valider une lecture sur ce type de cadran.

> [!TRAP]
> **L'erreur de parallaxe.** Sur un cadran présenté légèrement en perspective ou avec une aiguille surélevée par rapport aux graduations, la position apparente de l'aiguille peut sembler décalée d'une graduation par rapport à sa position réelle. Alignez toujours votre lecture sur la pointe de l'aiguille, pas sur son ombre ou son reflet apparent.

> [!TRAP]
> **L'erreur d'une graduation (off-by-one-tick).** Compter les graduations une à une depuis un repère majeur fait facilement perdre le compte d'une unité, surtout sous pression de temps. C'est précisément l'erreur que l'interpolation par fraction simple permet d'éviter : elle ne dépend d'aucun comptage.

Autres erreurs classiques :

- **Lire un cadran linéaire (0–100) comme s'il était circulaire (0–360°)** par automatisme après avoir enchaîné plusieurs cadrans du même type ; vérifiez toujours l'échelle affichée sur le cadran courant.
- **Changer d'ordre de balayage à mi-item** parce qu'un cadran attire le regard en premier ; un ordre fixe reste plus rapide en moyenne, même s'il n'est pas optimal cadran par cadran.
- **Négliger l'unité affichée sur le cadran** (pourcentage, litres, degrés) et donner une valeur juste mais dans la mauvaise unité.

## Exemple guidé 1 — interpoler une lecture simple

> [!EXAMPLE]
> Un cadran linéaire gradué de 0 à 100 par pas de 10 affiche une aiguille positionnée visiblement aux trois quarts de l'intervalle entre les graduations 60 et 70.

### Étape 1

Repérer les deux graduations majeures encadrant l'aiguille : 60 et 70. Ne pas chercher à compter depuis 0.

### Étape 2

Estimer la fraction de l'intervalle parcourue : l'aiguille est visiblement plus proche de 70 que de 60, à environ trois quarts du chemin. Un intervalle de 10 dont on prend les trois quarts vaut 7,5.

### Étape 3

Valeur lue : 60 + 7,5 = **67-68**, arrondie selon la précision demandée par l'item. Aucun comptage de petites graduations n'a été nécessaire.

## Exemple guidé 2 — gérer un compteur à plusieurs tours

> [!EXAMPLE]
> Un compteur de type jauge affiche une plage de 0 à 200, mais l'aiguille ne fait qu'un tour complet pour 100 unités (donc deux tours pour couvrir toute la plage). Une petite fenêtre numérique en bas du cadran indique « 2ᵉ tour ». L'aiguille principale pointe aux deux tiers de l'intervalle entre les graduations 30 et 40 de son propre tour.

### Étape 1

Vérifier en premier l'indicateur de tour, avant toute lecture de l'aiguille principale : la fenêtre indique le deuxième tour, donc il faut ajouter 100 à la lecture de l'aiguille.

### Étape 2

Lire l'aiguille sur son propre tour comme un cadran simple : entre 30 et 40, aux deux tiers, soit 30 + (2/3 × 10) ≈ 37.

### Étape 3

Combiner les deux informations : valeur du tour (100) + lecture locale (37) = **137**. Une lecture qui aurait ignoré l'indicateur de tour aurait donné 37 au lieu de 137, une erreur d'un tour complet.

## Exemple guidé 3 — balayer trois cadrans dans un ordre fixe

> [!EXAMPLE]
> Trois cadrans sont affichés côte à côte : un cadran linéaire à gauche, un cadran circulaire (0–360°) au centre, un second cadran linéaire à droite. Il faut lire les trois valeurs et les reporter dans l'ordre demandé.

### Étape 1

Fixer l'ordre de balayage avant de commencer à lire : gauche, puis centre, puis droite. Ne pas se laisser attirer par le cadran qui semble le plus facile à lire en premier.

### Étape 2

Lire le cadran de gauche par interpolation entre ses deux graduations majeures les plus proches, en vérifiant d'abord son unité et son échelle (linéaire).

### Étape 3

Lire le cadran central en gardant à l'esprit qu'il s'agit d'une échelle circulaire (0 à 360°) : repérer d'abord la position angulaire approximative (par exemple « un peu après le quart de tour ») avant d'affiner en degrés.

### Étape 4

Lire le cadran de droite en dernier, dans le même ordre annoncé au départ, puis reporter les trois valeurs dans l'ordre gauche-centre-droite. Un ordre respecté à chaque item évite d'inverser deux valeurs sous la pression du temps.

## Routine d'échauffement de 5 minutes

1. **1 min — s'entraîner à reconnaître des fractions simples** (quart, tiers, moitié, trois quarts) d'un intervalle sans compter, sur un cadran imaginaire.
2. **2 min — quelques lectures rapides en mode Entraînement**, en verbalisant à chaque fois les deux graduations majeures encadrantes avant la valeur estimée.
3. **1 min — une lecture volontairement sur un compteur à tours multiples**, en insistant sur la vérification systématique de l'indicateur de tour avant toute lecture.
4. **1 min — fixer un ordre de balayage** (par exemple gauche à droite, haut en bas) et s'y tenir sur une série de cadrans multiples, puis on lance la session chronométrée.

## Pour aller plus loin

- Le paquet de flashcards `p1_counters.deck.gauge_reading` reprend l'interpolation entre repères, les compteurs à plusieurs tours, les échelles courantes et les pièges de parallaxe.
