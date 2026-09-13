# Patrons et rotation de cubes : deux épreuves, une seule intuition spatiale

« Patrons de cubes » regroupe en réalité **deux épreuves distinctes** qui partagent la même intuition de fond — garder en tête l'agencement des faces d'un cube dans l'espace — mais qui se jouent très différemment. La première, le **dépliage de patron**, reprend l'exercice classique (reconstituer un patron 2D incomplet à partir d'un cube de référence), mais avec **deux alphabets de symboles** : des lettres latines, puis un alphabet runique inventé pour empêcher toute mémorisation par cœur des patrons. La seconde, la **rotation-matching**, montre un cube de référence puis plusieurs cubes candidats, et demande de juger pour chacun s'il s'agit du **même objet tourné**, ou d'un cube **modifié** (faces inversées ou permutées) — avec un barème négatif de -0,25 par mauvaise réponse qui change complètement la stratégie à adopter.

## Ce que mesure l'activité

Le dépliage mesure le **pliage mental** : passer d'une figure plane à un solide en gardant la trace des faces voisines, opposées, et de l'orientation des symboles — la même aptitude que la lecture d'un instrument en trois dimensions à partir d'un schéma plat. La rotation-matching mesure une aptitude complémentaire, la **reconnaissance d'invariants sous rotation** : distinguer une transformation rigide (qui préserve toutes les relations entre faces) d'une transformation qui casse cette cohérence (miroir, permutation), un réflexe proche de celui qui permet de reconnaître un aéronef ou un instrument sous des angles de vue différents.

## Format et chronométrage rapportés

| Élément | Valeur rapportée | Confiance |
|---|---|---|
| Dépliage — écran | Un patron de référence complet à gauche, un second patron à faces manquantes à droite, à compléter par glisser-déposer | [rapporté] |
| Dépliage — alphabets | Une partie des planches utilise des lettres latines ("3 cubes/alphabet latin"), une autre un alphabet runique inventé ("2 cubes/alphabet runique") pour empêcher la mémorisation par cœur | [rapporté] |
| Dépliage — volume | 2 phases × 10 patrons, 20 minutes par phase | [rapporté] |
| Rotation-matching — écran | Un cube de référence affiché, puis une série de cubes candidats à juger un par un : rotation valide, ou objet modifié | [rapporté] |
| Rotation-matching — volume | Environ 25 items en 8 à 10 minutes | [rapporté] |
| Rotation-matching — barème | -0,25 point par mauvaise réponse (pas de pénalité documentée pour une absence de réponse) | [rapporté] |
| Sessions | Épreuve présente dans plusieurs debriefs 2019-2026 ; rotation-matching signalée comme un des pièges classiques de ce test | [rapporté] |

## Méthode et stratégie

> [!METHOD]
> **Deux techniques, une racine commune.** Pour le dépliage : repérez les paires de faces opposées et voisines du patron de référence avant de toucher aux faces manquantes. Pour la rotation-matching : suivez une paire de faces adjacentes du cube de référence et vérifiez si cette même paire reste dans la même relation (l'une à droite, en haut, etc. de l'autre) sur le cube candidat — une vraie rotation préserve **toutes** les paires de faces adjacentes, une altération en casse **exactement une**.

### Technique du dépliage : opposées et voisines d'abord

Sur un patron de cube en croix ou en escalier, deux cases séparées par exactement une case sur une même ligne droite du patron sont **opposées** dans le cube ; deux cases qui se touchent par un côté sont **toujours voisines**, jamais opposées. Relevez les trois paires opposées du patron de référence avant de vous occuper du second patron : il ne reste alors qu'à placer chaque face manquante à la position opposée à sa partenaire déjà connue, puis à trancher l'ordre des faces restantes par leurs voisines communes. Cette méthode fonctionne à l'identique avec l'alphabet latin et l'alphabet runique : les runes n'ont **aucune signification à mémoriser**, elles ne sont qu'un symbole parmi d'autres à suivre par sa position, exactement comme une lettre. Le seul piège propre à l'alphabet runique est la tentation de chercher un sens ou une ressemblance entre les symboles ; ignorez-la, la méthode ne dépend que des positions relatives.

Pour l'orientation d'un symbole asymétrique (une rune qui pointe dans une direction, une lettre comme F ou R), la règle est la même que pour les lettres : le symbole doit toujours pointer vers l'arête commune avec la même face voisine, quel que soit l'alphabet. Si cette face voisine change de côté entre les deux patrons, il faut faire pivoter la face d'un demi-tour lors de la pose.

### Technique de la rotation-matching : l'invariant de la paire de faces

Pour juger un cube candidat, choisissez sur le cube de référence **une paire de faces adjacentes bien identifiables** (par exemple la face du dessus et la face avant). Repérez leur relation exacte : laquelle est à gauche de l'autre en tournant dans un sens donné, quel symbole touche quel symbole le long de l'arête commune. Cherchez ensuite cette même paire sur le cube candidat, sous quelque angle qu'il soit présenté :

- **Si la relation entre les deux faces est identique** (même ordre de rotation, même arête de contact) sur le candidat, c'est une **rotation valide**, même si l'axe de rotation est en diagonale ou combine plusieurs axes à la fois — une rotation rigide ne change jamais les relations entre faces, seulement leur position apparente à l'écran.
- **Si la relation est inversée** (l'ordre de rotation s'est inversé, comme dans un miroir) ou si une face a été **remplacée par une autre** qui n'était pas sur le cube de référence, c'est un cube **modifié**.

Il suffit de vérifier **une seule paire bien choisie** pour trancher dans la grande majorité des cas : une transformation qui n'est pas une rotation rigide casse la relation d'au moins une paire adjacente, et cette cassure est en général visible dès la première paire contrôlée. Ne cherchez pas à suivre les six faces à la fois, ce qui ralentit sans fiabiliser le jugement.

### Stratégie face au barème négatif

> [!METHOD]
> **Mieux vaut ne pas répondre au hasard.** Avec -0,25 point par erreur, deviner sur un cube dont vous n'êtes pas sûr a une espérance de gain négative dès que votre confiance tombe sous 20 % environ. Si la paire de faces contrôlée ne donne pas un résultat net après une vérification, passez la question plutôt que de deviner : le score se construit sur la précision, pas sur le nombre de réponses données. La consigne rapportée du côté des candidats — « 20 justes valent mieux que 25 dont 5 fausses » — s'applique ici au pied de la lettre.

## Pièges et erreurs fréquentes

> [!TRAP]
> **Alphabet runique : chercher un sens aux symboles.** Les runes inventées n'ont pas de signification propre à retenir ; c'est un piège volontaire du test pour empêcher la mémorisation par cœur des patrons habituels. Traitez chaque symbole comme une simple étiquette de position, exactement comme une lettre.

> [!TRAP]
> **Rotation en diagonale : croire qu'un axe combiné rend la comparaison impossible.** Un cube tourné selon un axe diagonal ou combiné (plusieurs axes à la fois) reste une rotation rigide : la paire de faces adjacentes contrôlée garde exactement la même relation, seule leur apparence à l'écran change. Ne vous laissez pas déstabiliser par un angle de vue inhabituel.

> [!TRAP]
> **Confondre une permutation de faces avec une rotation.** Un cube où deux faces ont simplement échangé leur place (sans rotation réelle) peut, à un instant donné, ressembler à une rotation si l'on ne contrôle qu'une face isolée. C'est pour cela que la vérification porte toujours sur une **paire** de faces adjacentes et leur relation, jamais sur une face seule.

Autres erreurs classiques :

- **Sur le dépliage, placer une face « par proximité visuelle »** sur le dessin plutôt que par la relation opposée/voisine réelle dans le cube : deux cases voisines sur le patron de référence peuvent se retrouver loin l'une de l'autre sur le second patron tout en restant voisines dans le cube.
- **Sur la rotation-matching, changer de paire de faces à chaque cube candidat** sans raison : gardez si possible la même paire de référence (par exemple toujours dessus/avant) d'un candidat à l'autre pour aller plus vite par automatisme.
- **Se précipiter sur le glisser-déposer du dépliage** avant d'avoir fini de raisonner sur les trois paires opposées : dix secondes de déduction en amont évitent plusieurs manipulations inutiles.

## Exemple guidé 1 — dépliage avec l'alphabet runique

> [!EXAMPLE]
> Patron de référence en croix, alphabet runique : rangée horizontale ᚠ, ᚱ, ᚦ, ᚨ (de gauche à droite), ᚹ au-dessus de ᚱ, ᚲ au-dessous de ᚱ. Second patron, forme en escalier 2-3-1 : ligne du haut cases (1,1) et (1,2), ligne du milieu cases (2,2), (2,3), (2,4), ligne du bas case (3,4). Faces déjà posées : ᚹ en (1,2), ᚱ en (2,3). Faces à placer : ᚠ, ᚦ, ᚨ, ᚲ.

### Étape 1

Paires opposées du patron de référence, par la règle des faces séparées d'une case sur la rangée horizontale : ᚠ–ᚦ (1ʳᵉ et 3ᵉ position), ᚱ–ᚨ (2ᵉ et 4ᵉ position). Par élimination, ᚹ–ᚲ (au-dessus et au-dessous de ᚱ, de part et d'autre de la rangée).

### Étape 2

Sur le second patron, les cases (1,1), (1,2), (2,2), (2,3) forment un Z dont les extrémités sont (1,1) et (2,3) : ces deux cases sont opposées. (2,3) porte ᚱ, donc (1,1) reçoit sa face opposée, **ᚨ**. La case (3,4) est opposée à (1,2) qui porte ᚹ : (3,4) reçoit donc **ᚲ**.

### Étape 3

Restent les cases (2,2) et (2,4), séparées d'une case sur la rangée du milieu, donc opposées entre elles : elles reçoivent ᚠ et ᚦ, dans un ordre à déterminer par les voisines. En pliant mentalement autour de ᚱ en (2,3) : la case (1,2) porte ᚹ et se trouve au-dessus de (2,2), donc ᚹ devient la face du dessus quand ᚱ est devant. Sur le patron de référence, quand ᚱ est devant et ᚹ dessus, la face de gauche est ᚠ (voisine directe à gauche de ᚱ sur la rangée). Donc **ᚠ en (2,2)** et, par élimination, **ᚦ en (2,4)**.

### Étape 4

Vérification : les trois paires ᚠ–ᚦ, ᚱ–ᚨ, ᚹ–ᚲ sont respectées dans le second patron ; le raisonnement n'a jamais nécessité de connaître le "sens" des runes, seulement leur position, exactement comme avec des lettres.

## Exemple guidé 2 — rotation-matching, un cube valide sur un axe combiné

> [!EXAMPLE]
> Cube de référence : face du dessus marquée d'un carré, face avant marquée d'un triangle, la pointe du triangle touchant l'arête commune avec le carré. Cube candidat, présenté sous un angle différent (vu depuis un coin, rotation apparente sur un axe diagonal) : la face visible en haut à gauche porte le triangle, pointe vers le bas-droite, et la face visible en haut à droite porte le carré, les deux faces partageant une arête entre elles.

### Étape 1

Choisissez la paire de référence : carré (dessus) et triangle (avant), avec la pointe du triangle tournée vers leur arête commune sur le cube de référence.

### Étape 2

Sur le candidat, repérez la même paire : carré et triangle occupent bien deux faces adjacentes, partageant une arête. La pointe du triangle est tournée vers le bas-droite, soit vers cette même arête commune avec le carré — la relation « la pointe touche l'arête partagée avec le carré » est identique à celle du cube de référence.

### Étape 3

Comme la relation entre les deux faces (adjacence, orientation de la pointe vers l'arête commune) est préservée malgré l'angle de vue inhabituel, il s'agit d'une **rotation valide**, même si l'axe de rotation combine plusieurs axes du cube à la fois. Aucune vérification supplémentaire n'est nécessaire.

## Exemple guidé 3 — rotation-matching, un cube modifié par miroir

> [!EXAMPLE]
> Même cube de référence (carré au-dessus, triangle en face, pointe vers l'arête commune avec le carré). Cube candidat : carré et triangle sont bien adjacents, mais la pointe du triangle est tournée **à l'opposé** de leur arête commune.

### Étape 1

Même paire de référence : carré et triangle adjacents, avec sur la référence la pointe du triangle tournée vers l'arête commune.

### Étape 2

Sur le candidat, la pointe est tournée à l'opposé de cette arête. Une rotation rigide, quel que soit l'axe, ne peut jamais faire "s'éloigner" la pointe de l'arête partagée avec une face qui reste adjacente : si l'adjacence est conservée, l'orientation relative doit l'être aussi.

### Étape 3

La relation est donc inversée par rapport à la référence : c'est un cube **modifié** (face retournée sur elle-même ou remplacée par une variante miroir), pas une rotation. Une seule paire de faces a suffi à trancher, sans avoir besoin d'examiner les quatre autres faces du cube.

## Routine d'échauffement de 5 minutes

1. **1 min — récitation des règles du dépliage.** À voix basse : séparées d'une case sur une ligne = opposées ; extrémités d'un Z = opposées ; troisième paire par élimination.
2. **1 min 30 — une planche de dépliage en alphabet runique** en mode Entraînement, en traitant chaque symbole comme une simple étiquette de position.
3. **1 min 30 — cinq jugements de rotation-matching**, en choisissant systématiquement la même paire de faces de référence (par exemple dessus/avant) sur chaque candidat.
4. **1 min — relecture des pièges et de la stratégie de barème** : ne pas répondre au hasard en rotation-matching, ne jamais placer une face « par proximité visuelle » en dépliage.

## Pour aller plus loin

- L'activité *Matrices progressives de Raven* sollicite un raisonnement analytique sur des motifs qui complète bien la visualisation en trois dimensions travaillée ici.
