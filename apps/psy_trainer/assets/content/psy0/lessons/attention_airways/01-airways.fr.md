# Airways : gérer le flux sans surcharger les zones

Airways (appelé « Flèches » dans les premières sessions, « Gestion de flux » dans les listes 2026) est l'une des activités que les candidats citent le plus souvent parmi celles qu'ils **n'arrivent pas à terminer**. Ce n'est pas une question de calcul ni de mémoire : c'est une petite simulation de trafic dans laquelle vous devez surveiller en continu, anticiper et intervenir au bon moment, sans en faire trop.

## Ce que mesure l'activité

Airways mesure l'**attention soutenue dans une scène qui évolue** et la **qualité des décisions stratégiques** prises sous pression. Deux aptitudes se combinent :

- **La vigilance** : rien ne vous prévient qu'une zone est sur le point de déborder ; c'est à vous de balayer la scène en permanence et de repérer le problème avant qu'il se produise.
- **L'économie d'action** : chaque déroutement compte. Le bon candidat n'est pas celui qui clique le plus, mais celui qui évite tous les incidents avec le minimum d'interventions.

Le parallèle avec le métier est évident : un pilote surveille un environnement qui change, hiérarchise les menaces et n'agit que quand c'est nécessaire.

## Format et chronométrage rapportés

| Élément | Valeur rapportée | Confiance |
|---|---|---|
| Scène | Des triangles (« avions ») se déplacent le long de lignes (« routes ») qui traversent des zones grises | [rapporté] |
| Commande | Des boutons de couleur permettent de dérouter un avion vers une autre route | [rapporté] |
| Contrainte 1 | Au plus **4 avions** dans une même zone grise à un instant donné | [rapporté] |
| Contrainte 2 | Au plus **2 avions bleus** dans une même zone grise | [rapporté] |
| Objectif secondaire | Dérouter **le moins d'avions possible** | [rapporté] |
| Sanction | Toute violation d'une contrainte compte comme un « crash » | [rapporté] |
| Volume | 10 séries successives, environ 5 min au total | [rapporté] |
| Durée par série | Environ 30 s dans notre simulation | [estimé] |

Le détail exact du barème (poids d'un crash par rapport à un déroutement inutile) n'est pas connu. Retenez le principe : **zéro crash d'abord, peu de déroutements ensuite**.

## Méthode et stratégie

> [!METHOD]
> **Compter, anticiper, agir tôt, agir peu.** Avant de toucher un bouton, comptez ce qu'il y a dans chaque zone *et* ce qui s'y dirige. Une zone qui contient 4 avions et vers laquelle un cinquième se dirige va déborder : c'est *celui-là* qu'il faut dérouter, avant qu'il entre. Puis vérifiez la contrainte bleue, qui est plus serrée et se viole plus facilement.

Le cycle de travail à chaque instant :

1. **Balayer** la scène toujours dans le même ordre (par exemple zone de gauche, zone du haut, zone de droite, zone du bas). Un circuit fixe évite d'oublier une zone.
2. **Compter deux nombres par zone** : le total d'avions et le nombre de bleus. Notez mentalement « 3/1 » (trois avions dont un bleu).
3. **Projeter** : pour chaque avion qui approche d'une zone, ajoutez-le au compte. Si le total projeté dépasse 4 ou si les bleus projetés dépassent 2, il y a une menace.
4. **Choisir** l'avion à dérouter : celui dont le déroutement résout la menace **sans en créer une autre** dans la zone de destination. Si deux avions se dirigent vers la zone saturée, dérouter *un seul* suffit en général.
5. **Agir tôt** : dérouter un avion loin de la zone vous laisse de la marge ; attendre le dernier moment vous expose à un clic raté et à un crash.

**Trois heuristiques de capacité :**

- **La contrainte bleue passe en premier.** Une zone peut être à 3 avions et pourtant être en danger si deux d'entre eux sont bleus et qu'un troisième bleu arrive. Regardez la couleur *avant* le total.
- **Un déroutement doit être « gratuit » pour la zone d'arrivée.** Avant de cliquer, vérifiez le compte projeté de la zone où vous envoyez l'avion. Déplacer un problème n'est pas le résoudre.
- **Le non-bleu est la monnaie d'échange.** Quand une zone risque de dépasser 4 au total, dérouter un avion non bleu est souvent plus sûr : il ne mettra pas la contrainte bleue en danger ailleurs.

Enfin, quand la série est calme, ne « rangez » pas la scène par confort : chaque déroutement inutile coûte des points.

## Pièges et erreurs fréquentes

> [!TRAP]
> **Compter ce qui est là, pas ce qui arrive.** L'erreur la plus courante est de regarder une zone à 3 avions et de la juger sûre, alors que deux avions sont sur le point d'y entrer. Le compte utile est toujours le compte *projeté*.

> [!TRAP]
> **Oublier la zone de destination.** Dérouter un avion pour sauver une zone et le faire entrer dans une autre déjà à 4, c'est échanger un crash contre un crash. Vérifiez toujours les deux extrémités du déroutement.

> [!TRAP]
> **Sur-agir.** Sous stress, on déroute « au cas où ». Le score pénalise les déroutements : intervenez seulement quand le compte projeté dépasse la limite.

Autres erreurs classiques :

- **Se focaliser sur un coin.** Après avoir géré une menace, on reste fixé sur la zone concernée et on rate une autre zone qui se remplit. Reprenez le circuit de balayage dès l'action terminée.
- **Confondre les couleurs sous pression.** Les seuls avions à double contrainte sont les bleus ; vérifiez la couleur avant de compter.
- **Paniquer après un crash.** Un incident ne met pas fin à la série. Une erreur ruminée se transforme en deux ou trois.

## Exemple guidé 1 — une zone sur le point de déborder

> [!EXAMPLE]
> La scène comporte trois zones grises, Nord, Est et Sud. Actuellement : Nord contient 4 avions (1 bleu), Est contient 2 avions (2 bleus), Sud contient 1 avion (0 bleu). Deux avions se dirigent vers Nord : un gris et un bleu. Un avion gris se dirige vers Sud. Les boutons de couleur permettent de renvoyer un avion en approche de Nord vers Est ou vers Sud. Que faites-vous ?

### Étape 1

Comptez les zones en « total/bleus » : Nord 4/1, Est 2/2, Sud 1/0. Rien ne dépasse encore les limites.

### Étape 2

Projetez les entrées. Nord recevra deux avions : 6/2, ce qui viole la limite de 4 au total. Sud recevra un avion : 2/0, sans problème. Est ne reçoit rien mais est déjà **plein en bleus** (2/2).

### Étape 3

Choisissez l'action. Il faut retirer au moins deux avions de l'approche de Nord (6 → 4). Les deux avions en approche sont un gris et un bleu. Dérouter le bleu vers Est est interdit : Est passerait à 3 bleus. Dérouter le bleu vers Sud est possible : Sud deviendrait 3/1. Dérouter le gris vers Est ou Sud est possible dans les deux cas.

### Étape 4

Faites le compte minimal. Si vous ne déroutez qu'un seul avion, Nord finit à 5 : insuffisant. Il faut donc deux déroutements : le bleu vers Sud (Sud 3/1) et le gris vers Est (Est 3/2) ou vers Sud (Sud 4/1). Les deux variantes sont valides ; envoyer le gris vers Est répartit la charge et laisse de la marge à Sud.

### Étape 5

Vérification après action : Nord 4/1, Est 3/2, Sud 3/1. Aucune zone ne dépasse 4 au total ni 2 en bleus. Deux déroutements, le minimum possible pour cette situation.

## Exemple guidé 2 — la contrainte bleue avant le total

> [!EXAMPLE]
> Deux zones, Ouest et Est. Ouest contient 2 avions, tous deux bleus. Est contient 3 avions, dont 1 bleu. Un avion bleu se dirige vers Ouest ; un avion gris se dirige vers Est. Vous pouvez dérouter l'avion en approche d'Ouest vers Est, ou l'avion en approche d'Est vers Ouest. Faut-il intervenir ?

### Étape 1

Comptes actuels : Ouest 2/2, Est 3/1. Ouest est déjà au maximum de bleus, même si son total est faible.

### Étape 2

Projections : Ouest recevra un bleu, soit 3/3, violation de la contrainte bleue. Est recevra un gris, soit 4/1, à la limite mais autorisé.

### Étape 3

La menace est sur Ouest, par la couleur et non par le total. Un candidat qui ne regarde que le nombre d'avions (3, bien en dessous de 4) laisse passer le crash.

### Étape 4

Action : dérouter le bleu en approche d'Ouest vers Est. Est passe alors à 5/2 si le gris entre aussi : violation du total. Il faut donc aussi dérouter le gris en approche d'Est vers Ouest : Ouest 3/2, Est 4/2.

### Étape 5

Vérification : Ouest 3/2 et Est 4/2 respectent les deux contraintes. Deux déroutements étaient nécessaires ; un seul aurait déplacé le problème d'une zone à l'autre.

## Exemple guidé 3 — savoir ne rien faire

> [!EXAMPLE]
> Trois zones : A 3/1, B 3/2, C 2/0. Un avion gris se dirige vers A, un avion gris vers B, un avion bleu vers C. Aucun autre mouvement prévu. Devez-vous dérouter quelqu'un ?

### Étape 1

Projections : A devient 4/1, B devient 4/2, C devient 3/1.

### Étape 2

Aucune zone ne dépasse 4 au total ni 2 en bleus. Il n'y a pas de menace, même si A et B sont « pleins ».

### Étape 3

La tentation est de dérouter pour se donner de l'air. C'est une erreur : chaque déroutement est comptabilisé, et un déroutement vers une zone pleine créerait précisément le crash que vous cherchez à éviter.

### Étape 4

Vérification : la bonne action est de ne rien faire, de reprendre le circuit de balayage et d'attendre le prochain mouvement. Zéro crash, zéro déroutement.

## Routine d'échauffement de 5 minutes

1. **1 min — circuit de balayage à blanc.** Sans écran, imaginez trois zones et récitez un ordre de balayage fixe. L'objectif est d'ancrer l'ordre, pas de résoudre quoi que ce soit.
2. **2 min — deux séries en mode Entraînement**, en vous obligeant à annoncer intérieurement « total/bleus » de chaque zone avant toute action.
3. **1 min — une série « mains sur les genoux »** : observez sans cliquer et comptez les menaces que vous auriez dû traiter. Cela calibre le seuil d'intervention.
4. **1 min — relecture des trois pièges** (compte projeté, zone de destination, sur-action), puis on lance.

## Pour aller plus loin

- Le paquet de flashcards `deck.attention_airways` reprend les deux contraintes, le principe du compte projeté et les heuristiques de déroutement.
- Le *Multitâche* sollicite le même balayage en circuit fixe ; s'entraîner à l'un renforce l'autre.
