# Pair / impair : balayer, alterner, repartir sans paniquer

Sur le papier, cette activité est enfantine : cliquer des nombres dans un certain ordre. En pratique, elle combine trois contraintes qui se gênent mutuellement, la parité, l'ordre croissant et le chronomètre, et elle a une règle cruelle : **une seule erreur et la série repart de zéro**. Les candidats entraînés la classent parmi les activités « sans surprise », ce qui veut dire une chose : la méthode se travaille, et elle paie.

## Ce que mesure l'activité

Pair / impair mesure le **suivi d'une règle alternée sous pression temporelle**, c'est-à-dire la capacité à tenir deux fils en même temps (où j'en suis dans les pairs, où j'en suis dans les impairs) tout en balayant visuellement un nuage de nombres désordonnés. Elle mesure aussi, indirectement, la **récupération après erreur** : un clic faux efface la progression de la série, et le test observe si vous repartez proprement ou si vous vous précipitez et vous trompez à nouveau.

Côté cockpit, c'est l'analogue d'une procédure en deux branches à dérouler dans l'ordre pendant que l'environnement, lui, ne présente rien dans l'ordre.

## Format et chronométrage rapportés

| Élément | Valeur rapportée | Confiance |
|---|---|---|
| Écran | Un nuage de nombres dispersés sans ordre apparent | [rapporté] |
| Consigne | À partir du nombre marqué START, cliquer en alternant un nombre pair puis un nombre impair, chaque catégorie devant être parcourue en ordre croissant | [rapporté] |
| Repères | Les nombres de départ et d'arrivée sont étiquetés START et END | [rapporté] |
| Erreur | Un clic faux fait recommencer la série depuis le début | [rapporté] |
| Interaction | Clic à la souris | [rapporté] |
| Volume | 5 séries lors des sessions 2022–2023 | [rapporté] |
| Nombres par série | 16 dans notre simulation | [estimé] |
| Temps par série | Environ 60 s dans notre simulation | [estimé] |
| Durée totale | Environ 5 min dans notre simulation | [estimé] |

Un point à bien comprendre : **l'ordre croissant s'applique à chaque catégorie séparément**, pas à l'ensemble. La suite 2, 3, 8, 9, 30, 11 est valide : les pairs 2, 8, 30 montent, les impairs 3, 9, 11 montent, et le fait que 11 soit inférieur à 30 n'a aucune importance.

## Méthode et stratégie

> [!METHOD]
> Tenez **deux compteurs mentaux, un par catégorie** : « dernier pair cliqué » et « dernier impair cliqué ». À chaque clic, vous ne cherchez qu'une chose : *le plus petit nombre de la catégorie attendue qui soit supérieur à son compteur*. Vous ne triez jamais le nuage entier, vous ne cherchez qu'un nombre à la fois.

Le déroulé conseillé pour chaque série :

1. **Localiser START et END** avant tout clic. START est votre premier clic ; END sera le dernier, ce qui vous dit dans quelle catégorie la série se termine et donc combien de clics vous attendent si le nuage est équilibré.
2. **Balayer une seule fois le nuage** pendant une ou deux secondes, sans rien mémoriser précisément : juste repérer où sont les petits nombres, où sont les grands, et s'il y a des zones denses. Ce balayage rend toutes les recherches suivantes plus rapides.
3. **Cliquer START**, puis basculer de catégorie : si START est pair, vous cherchez un impair, et inversement.
4. **Chercher le plus petit candidat de la catégorie attendue** supérieur au compteur correspondant. Dites-le mentalement avant de cliquer : « impair, plus grand que 7, le plus petit : 15 ». Cette verbalisation coûte une fraction de seconde et évite la quasi-totalité des redémarrages.
5. **Mettre à jour le compteur** de la catégorie que vous venez de cliquer, basculer de catégorie, recommencer.

Trois techniques qui aident vraiment :

- **Regarder le dernier chiffre, rien d'autre.** La parité se lit sur le chiffre des unités : 0, 2, 4, 6, 8 pair ; 1, 3, 5, 7, 9 impair. Ne « calculez » pas la parité de 47, lisez le 7. Avec un peu d'entraînement, les nombres de la mauvaise catégorie deviennent invisibles.
- **Chercher par zone, pas au hasard.** Après le balayage initial, vous savez à peu près où sont les petits et les grands nombres. Quand votre compteur est à 34, inutile de regarder la zone des nombres à un chiffre.
- **Lever le doigt avant de valider mentalement.** Le clic doit venir *après* la phrase « catégorie, plus grand que, le plus petit ». Cliquer en même temps que l'on réfléchit est la source de la moitié des redémarrages.

Sur un redémarrage : la série reprend à START, mais **vous avez déjà fait le travail de repérage**. Vous connaissez l'emplacement des premiers nombres, vous les recliquez rapidement, et vous reprenez le rythme normal à l'endroit de la faute. Un redémarrage bien géré coûte quelques secondes, pas la série.

## Pièges et erreurs fréquentes

> [!TRAP]
> **Le réflexe de l'ordre global.** Après avoir cliqué 30 (pair), on cherche instinctivement un impair *plus grand que 30*. Faux : on cherche un impair plus grand que le *dernier impair cliqué*, qui peut être 9. Si le prochain impair est 11, c'est 11 qu'il faut cliquer, même s'il est plus petit que 30.

> [!TRAP]
> **Sauter un nombre de sa catégorie.** Cliquer 21 alors que 15 était disponible et non cliqué est une faute, même si 21 est bien impair et bien plus grand que le compteur. Le mot important dans « le plus petit candidat » est *le plus petit*. Le balayage initial sert précisément à ne pas rater un nombre isolé dans un coin.

> [!TRAP]
> **La précipitation après redémarrage.** Le redémarrage déclenche une envie de « rattraper le temps perdu » : on reclique à toute vitesse et l'on commet une deuxième faute au même endroit ou juste avant. La bonne réaction est l'inverse : recliquer les premiers nombres vite parce qu'on les connaît, puis **ralentir** à l'approche de l'endroit de la faute.

Autres erreurs classiques :

- **Oublier START.** Le premier clic n'est pas « le plus petit nombre » mais le nombre étiqueté START, quel qu'il soit.
- **Perdre un compteur.** Après cinq ou six clics, on ne sait plus si le dernier pair était 20 ou 24. La verbalisation « pair, plus grand que 20 » à chaque clic maintient les deux compteurs vivants.
- **Confondre les deux étiquettes.** START et END se ressemblent en périphérie du regard. Vérifiez au balayage initial lequel est lequel.
- **S'entraîner sur des nuages trop réguliers.** Si vos séries d'entraînement rangent toujours les petits nombres en haut à gauche, le jour J vous balayerez au mauvais endroit. Variez les dispositions.

## Exemple guidé 1 — une série complète

> [!EXAMPLE]
> Nuage de huit nombres, dispersés sur l'écran : **12, 39, 4, 21, 34, 7, 20, 15**. Le 4 est étiqueté START, le 39 est étiqueté END. Cliquez en alternant pair et impair, chaque catégorie en ordre croissant.

### Étape 1

Repérage : START est 4 (pair), END est 39 (impair). Balayage rapide : les pairs sont 4, 12, 20, 34 ; les impairs sont 7, 15, 21, 39. Quatre de chaque, la série fera huit clics et se terminera bien par un impair. Compteurs initiaux : pair = rien, impair = rien.

### Étape 2

Premier clic : **4** (START). Compteur pair = 4. Bascule vers les impairs : « impair, le plus petit ». C'est 7. Deuxième clic : **7**. Compteur impair = 7.

### Étape 3

« Pair, plus grand que 4, le plus petit » : 12. Troisième clic : **12**. « Impair, plus grand que 7, le plus petit » : 15. Quatrième clic : **15**. Compteurs : pair = 12, impair = 15.

### Étape 4

« Pair, plus grand que 12 » : 20. Cinquième clic : **20**. « Impair, plus grand que 15 » : 21. Sixième clic : **21**. « Pair, plus grand que 20 » : 34. Septième clic : **34**. « Impair, plus grand que 21 » : 39, qui porte l'étiquette END. Huitième clic : **39**.

### Étape 5

Vérification : ordre cliqué **4, 7, 12, 15, 20, 21, 34, 39**. Les pairs pris dans l'ordre sont 4, 12, 20, 34 (croissant), les impairs 7, 15, 21, 39 (croissant), l'alternance est respectée, le premier clic est START et le dernier est END. Série valide.

## Exemple guidé 2 — quand l'ordre global vous piège

> [!EXAMPLE]
> Nuage : **51, 8, 3, 44, 2, 30, 11, 9**. Le 2 est START, le 51 est END.

### Étape 1

Repérage : START = 2 (pair), END = 51 (impair). Pairs : 2, 8, 30, 44. Impairs : 3, 9, 11, 51. Huit clics attendus. Remarquez dès le balayage que 11 est un « petit » impair alors que 30 et 44 sont de « gros » pairs : c'est là que le piège se trouvera.

### Étape 2

Clics 1 et 2 : **2** (START), puis « impair, le plus petit » : **3**. Compteurs : pair = 2, impair = 3.

### Étape 3

« Pair, plus grand que 2 » : **8**. « Impair, plus grand que 3 » : **9**. Compteurs : pair = 8, impair = 9.

### Étape 4

« Pair, plus grand que 8 » : **30**. Maintenant la question piège : « impair, plus grand que **9** », et non plus grand que 30. Le plus petit impair supérieur à 9 est **11**. On clique 11, même s'il est inférieur au 30 que l'on vient de cliquer. Un candidat qui cherche un impair supérieur à 30 cliquerait 51, et la série redémarrerait.

### Étape 5

« Pair, plus grand que 30 » : **44**. « Impair, plus grand que 11 » : **51**, étiqueté END. Fin de série.

### Étape 6

Vérification : ordre cliqué **2, 3, 8, 9, 30, 11, 44, 51**. Pairs : 2, 8, 30, 44, croissant. Impairs : 3, 9, 11, 51, croissant. Alternance respectée, START au début, END à la fin. La suite n'est pas globalement croissante (30 puis 11), et c'est normal.

## Exemple guidé 3 — repartir après un redémarrage

> [!EXAMPLE]
> Nuage : **6, 17, 28, 5, 13, 40, 22, 33**. Le 6 est START, le 33 est END. Vous cliquez 6, 5, 28 : au troisième clic l'écran signale une erreur et la série redémarre.

### Étape 1

Analyse de la faute, en une seconde : après 6 (pair) et 5 (impair), il fallait « pair, plus grand que 6, **le plus petit** ». Les pairs du nuage sont 6, 22, 28, 40 : le plus petit pair supérieur à 6 est 22, pas 28. Vous avez sauté un nombre de la catégorie, sans doute parce que le 22 est isolé dans un coin que le balayage initial n'avait pas couvert. Erreur de logique (nombre sauté), pas de précision.

### Étape 2

Réaction : pas de précipitation. Vous savez déjà où sont 6 et 5, vous les recliquez posément. Compteurs : pair = 6, impair = 5. Vous approchez de l'endroit de la faute : vous **ralentissez** et, cette fois, vous balayez tout l'écran avant de choisir le pair suivant.

### Étape 3

« Pair, plus grand que 6, le plus petit » : **22**, repéré dans son coin. « Impair, plus grand que 5 » : **13**. Compteurs : pair = 22, impair = 13.

### Étape 4

« Pair, plus grand que 22 » : **28**. « Impair, plus grand que 13 » : **17**. « Pair, plus grand que 28 » : **40**. « Impair, plus grand que 17 » : **33**, étiqueté END.

### Étape 5

Vérification : ordre final **6, 5, 22, 13, 28, 17, 40, 33**. Pairs 6, 22, 28, 40 croissants ; impairs 5, 13, 17, 33 croissants ; alternance respectée ; START en tête, END en queue. Le redémarrage a coûté deux clics rapides et une seconde d'analyse, pas davantage. C'est exactement l'objectif : identifier la nature de la faute (nombre sauté, mauvaise catégorie ou clic imprécis), corriger le geste correspondant, et ne rien changer d'autre.

## Routine d'échauffement de 5 minutes

1. **1 min — parité à la volée.** Sans écran, énoncez des nombres à deux chiffres au hasard et dites « pair » ou « impair » dès le dernier chiffre prononcé. Objectif : lire les unités sans calculer.
2. **2 min — deux séries** en mode Entraînement, à vitesse confortable, en verbalisant à chaque clic « catégorie, plus grand que, le plus petit ». Zéro redémarrage est l'objectif, la vitesse vient ensuite.
3. **1 min — une série chronométrée** en visant le temps de la simulation (environ 60 s, valeur estimée), pour sentir la marge dont vous disposez.
4. **1 min — relecture des trois pièges** : ordre global, nombre sauté, précipitation après redémarrage. Respiration, puis on lance.

## Pour aller plus loin

- Le paquet de flashcards `deck.attention_parity` reprend les valeurs du format rapporté, la règle des deux compteurs et les trois pièges.
- Les *Grilles de calcul* sollicitent le même balayage visuel rapide et la même lecture du chiffre des unités ; l'activité *Airways* travaille la même récupération calme après un incident.
