# Billes et éprouvettes : compter les coups sans bouger les billes

L'activité « Billes » (ou « Éprouvettes ») est apparue dans la session 2019, a disparu en 2020 et 2022, puis est revenue en 2023 et en 2026. Elle ressemble à un casse-tête, mais on ne vous demande pas de résoudre le casse-tête à la souris : on vous demande **un nombre**, le nombre minimal de déplacements. Tout se joue donc dans votre tête, et c'est ce qui la rend exigeante.

## Ce que mesure l'activité

Cette activité mesure la **planification** : simuler mentalement une suite d'actions, en évaluer le coût, et trouver la suite la plus courte. C'est la famille des problèmes de type *tour de Hanoï* : des objets empilés, une contrainte de capacité, un seul objet déplacé à la fois. Elle sollicite aussi la mémoire de travail (garder l'état intermédiaire des tubes pendant que l'on compte) et l'inhibition (résister au premier coup « évident » qui n'est pas le bon).

Pour un pilote, c'est la même compétence que préparer une séquence d'actions dans le bon ordre avant de la dérouler, sans pouvoir revenir en arrière.

## Format et chronométrage rapportés

| Élément | Valeur rapportée | Confiance |
|---|---|---|
| Matériel | Trois tubes en U contenant des billes de couleur ; capacités **3 / 2 / 3** billes | [rapporté] |
| Question | Nombre **minimal** de déplacements pour passer de la configuration de départ à la configuration cible | [rapporté] |
| Réponse | Saisie numérique libre (on tape un nombre, on ne déplace pas les billes) | [rapporté] |
| Volume | Environ 10 à 20 questions | [rapporté] |
| Temps par question | Environ 40 s | [rapporté] |
| Sessions | Présente en 2019, 2023 et 2026 ; absente en 2020 et 2022 | [rapporté] |
| Règle de déplacement | Une bille à la fois, uniquement la bille **du dessus** d'un tube, vers un tube qui a encore de la place | [estimé] |

La règle de déplacement n'est pas décrite en détail dans les retours de candidats ; notre simulation applique la règle classique des empilements (une bille, par le haut, capacité respectée). Lisez attentivement la consigne et l'exemple affichés le jour J.

## Méthode et stratégie

> [!METHOD]
> **Lisez la cible par le bas.** Dans chaque tube cible, la bille du fond doit arriver en premier, puis celle du dessus, etc. Trouvez la bille qui doit se poser en premier, regardez ce qui la bloque au départ, garez les billes gênantes dans le tube tampon, et comptez chaque geste sans jamais en oublier. Le total est votre réponse.

En pratique, en 40 s :

1. **Comparer** départ et cible tube par tube. Les billes déjà au bon endroit *et à la bonne hauteur*, avec rien de faux au-dessous d'elles, ne bougent pas. Toutes les autres bougeront au moins une fois.
2. **Borner par le bas.** Le nombre de billes qui doivent bouger est un minimum garanti. Si aucune bille ne gêne, c'est la réponse.
3. **Repérer les blocages.** Une bille qui doit bouger mais qui est recouverte par une bille qui doit rester (ou qui doit arriver plus tard à sa place) impose des déplacements supplémentaires : la bille du dessus doit être garée, puis remise. Chaque garage coûte **deux** coups (aller, retour) sauf si le garage est aussi sa destination finale.
4. **Utiliser le tube de capacité 2 comme tampon**, mais garder en tête qu'il est vite plein : deux billes garées, et il n'accepte plus rien.
5. **Rejouer mentalement** la séquence une fois, en comptant sur les doigts si nécessaire, puis saisir le nombre.

L'ordre des déplacements dans la cible dicte tout : une bille qui doit être *au-dessus* d'une autre dans la cible ne peut pas être posée avant elle, même si elle est disponible tout de suite.

## Pièges et erreurs fréquentes

> [!TRAP]
> **Jouer le coup disponible plutôt que le coup nécessaire.** La bille du dessus est tentante parce qu'elle est libre. Si dans la cible elle doit se retrouver au-dessus d'une bille qui n'est pas encore en place, la déplacer maintenant vous forcera à la redéplacer : deux coups perdus.

> [!TRAP]
> **Oublier la capacité du tube tampon.** Avec deux places seulement, garer une troisième bille est impossible : il faut alors utiliser un tube de capacité 3 comme garage intermédiaire, ce qui change le compte.

> [!TRAP]
> **Compter les billes et non les coups.** Une bille qui doit être garée puis remise compte deux déplacements. Une bille « déjà dans le bon tube » mais à la mauvaise hauteur doit sortir et revenir : deux déplacements aussi.

Autres erreurs classiques :

- **Saisir trop vite** un nombre « au feeling ». Le temps par question (environ 40 s) permet une simulation complète ; utilisez-le.
- **Perdre l'état intermédiaire** au milieu du comptage. Verbalisez chaque coup (« bleu sur B, un ; rouge sur C, deux… ») pour ancrer la séquence.
- **Confondre le bas et le haut** d'un tube en U dessiné à l'écran. Fixez-vous une convention avant de commencer : la bille la plus proche du fond est la première posée, la dernière à sortir.

## Exemple guidé 1 — une bille qui bloque

> [!EXAMPLE]
> Tubes A (3 places), B (2 places), C (3 places). Les listes vont du fond vers le haut. Départ : A = [rouge, bleu], B = [ ], C = [vert]. Cible : A = [bleu], B = [ ], C = [vert, rouge]. Combien de déplacements au minimum ?

### Étape 1

Comparaison tube par tube. Vert est au fond de C au départ et dans la cible : elle ne bouge pas. Rouge doit passer de A vers C. Bleu doit rester dans A mais descendre au fond : elle est aujourd'hui au-dessus de rouge, elle devra donc sortir puis revenir.

### Étape 2

Borne inférieure : rouge bouge une fois, bleu bouge au moins deux fois (sortir de A, y revenir). Au minimum 3 déplacements, à condition qu'aucun autre blocage n'apparaisse.

### Étape 3

Séquence : bleu de A vers B (coup 1, B sert de tampon) ; rouge de A vers C, sur vert (coup 2) ; bleu de B vers A (coup 3). Les tubes sont alors A = [bleu], B = [ ], C = [vert, rouge].

### Étape 4

Vérification : on rejoue la séquence en contrôlant les capacités (B n'a jamais reçu plus de 2 billes, C n'en a jamais eu plus de 3) et on retrouve exactement la cible. Le compte atteint la borne inférieure : la réponse est **3**.

## Exemple guidé 2 — vider un tube dans le même ordre

> [!EXAMPLE]
> Départ : A = [bleu, rouge, vert] (plein), B = [ ], C = [ ]. Cible : A = [ ], B = [ ], C = [bleu, rouge, vert]. Combien de déplacements ?

### Étape 1

Piège de lecture : la cible n'est pas le simple transvasement de A vers C. Si l'on transvase bille par bille, vert arrive en premier au fond de C et l'ordre est inversé : C = [vert, rouge, bleu]. Ce n'est pas la cible.

### Étape 2

Lecture par le bas : bleu doit se poser la première dans C. Or bleu est au fond de A, sous rouge et vert. Il faut donc garer rouge et vert ailleurs qu'en C avant de bouger bleu. Le tube B a exactement deux places : parfait.

### Étape 3

Séquence : vert de A vers B (1) ; rouge de A vers B (2, B est plein) ; bleu de A vers C (3) ; rouge de B vers C (4) ; vert de B vers C (5). Résultat : C = [bleu, rouge, vert].

### Étape 4

Vérification par la borne : les trois billes doivent bouger (3 coups), et deux d'entre elles doivent être garées avant de rejoindre C, ce qui ajoute un coup chacune (2 coups). Minimum 5, séquence en 5 : la réponse est **5**.

## Exemple guidé 3 — l'ordre de pose compte

> [!EXAMPLE]
> Départ : A = [jaune, vert], B = [rouge], C = [bleu]. Cible : A = [jaune], B = [ ], C = [bleu, rouge, vert]. Combien de déplacements ?

### Étape 1

Comparaison : jaune reste au fond de A, bleu reste au fond de C. Rouge doit aller dans C, vert aussi. Dans la cible, rouge est *sous* vert : rouge doit être posée avant vert.

### Étape 2

Le coup tentant est de déplacer vert, qui est libre au-dessus de A, directement vers C. Ce serait une erreur : vert se retrouverait sur bleu, et rouge ne pourrait plus passer dessous sans que vert ressorte (vert vers A, rouge vers C, vert vers C : 4 coups au total).

### Étape 3

Bonne séquence : rouge de B vers C, sur bleu (1) ; vert de A vers C, sur rouge (2). Les tubes sont A = [jaune], B = [ ], C = [bleu, rouge, vert].

### Étape 4

Vérification : deux billes seulement doivent bouger et aucune ne bloque l'autre si l'on respecte l'ordre de la cible ; la borne inférieure est 2 et la séquence tient en 2. La réponse est **2**, pas 4.

## Routine d'échauffement de 5 minutes

1. **1 min — convention.** Sur une feuille (à l'entraînement seulement : pas de brouillon le jour J), dessinez trois tubes et écrivez « fond → haut ». Répétez à voix basse la règle : une bille, par le haut, capacité respectée.
2. **2 min — trois problèmes faciles** (2 à 3 coups) dans le mode Entraînement, en énonçant chaque coup avant de saisir la réponse.
3. **1 min 30 — deux problèmes avec garage** (4 à 6 coups) où le tube de capacité 2 sert de tampon. Objectif : ne pas oublier les coups de retour.
4. **30 s — relecture des trois pièges** : coup disponible ≠ coup nécessaire, capacité 2, compter des coups et non des billes.

## Pour aller plus loin

- Le paquet de flashcards `deck.planning_tubes` reprend la méthode « lire la cible par le bas », la règle des deux coups par garage et les valeurs du format rapporté.
- Les activités *Formes glissées* et *Cubes* demandent la même discipline : planifier avant d'agir plutôt que tâtonner.
