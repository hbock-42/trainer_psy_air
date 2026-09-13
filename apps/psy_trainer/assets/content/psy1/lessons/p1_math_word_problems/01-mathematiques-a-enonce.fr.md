# Mathématiques à énoncé : décomposer avant de calculer

L'activité *Mathématiques* de PSY1 n'a rien à voir avec les grilles de calcul de PSY0. Ici, pas d'égalités toutes faites à vérifier : on vous donne un **énoncé** — un avion qui parcourt une distance, une consommation de carburant, un pourcentage à appliquer, un décalage horaire à calculer — et c'est à vous de construire le calcul avant de le résoudre. Le brouillon est autorisé, ce qui change complètement la stratégie : le facteur limitant n'est plus le calcul lui-même mais la **mise en équation**.

## Ce que mesure l'activité

L'activité mesure le **raisonnement arithmétique en plusieurs étapes sous contrainte de temps** : identifier ce qui est demandé, retrouver la relation qui relie les données de l'énoncé, l'appliquer, puis juger si le résultat est plausible. C'est une compétence directement transférable au pilotage : calculer un temps de vol restant, une distance de dégagement ou une consommation prévisionnelle à partir de données dispersées dans un énoncé opérationnel.

Trois briques la composent : la **lecture analytique** de l'énoncé (repérer l'inconnue et les données utiles, ignorer le bruit), la **maîtrise de quelques relations types** (vitesse/temps/distance, débit de carburant, proportions, conversions, fuseaux horaires) et une **vérification par ordre de grandeur** qui évite de valider un résultat aberrant né d'une erreur d'unité.

## Format et chronométrage rapportés

| Élément | Valeur rapportée | Confiance |
|---|---|---|
| Format de réponse | QCM ou réponse numérique libre selon les items | **[rapporté]** |
| Volume | 30 questions | **[rapporté]** |
| Durée totale | 35 minutes, soit ~1 min 10 par question en moyenne | **[rapporté]** |
| Support | Brouillon autorisé (contrairement aux grilles de calcul de PSY0) | **[rapporté]** |
| Thèmes rencontrés | Vitesse/temps/distance, consommation de carburant, proportions/règle de trois, conversions d'unités, calculs de fuseaux horaires | **[rapporté]** |
| Niveau | Plus exigeant que les grilles de calcul PSY0 (énoncés multi-étapes) | **[rapporté]** |
| Pénalité en cas d'erreur | Non documentée précisément ; considérez un barème proche de celui des autres activités MCQ (correct = 1, faux = 0 ou légèrement négatif) | **[estimé]** |

Une minute dix par question laisse le temps d'écrire l'équation sur le brouillon, mais pas de la refaire deux fois : la méthode doit être la bonne dès la première tentative.

## Méthode et stratégie

> [!METHOD]
> **Quatre temps, toujours dans le même ordre : Inconnue → Relation → Isolement → Vérification.** 1) Repérez en une phrase ce qui est demandé et son unité. 2) Écrivez la relation qui relie les données à l'inconnue (une formule, une proportion). 3) Isolez l'inconnue et substituez les valeurs. 4) Avant de valider, vérifiez que le résultat est du bon ordre de grandeur et de la bonne unité. Un candidat qui saute l'étape 1 recalcule souvent la mauvaise quantité en un temps record.

### Vitesse, temps, distance

La relation de base est $d = v \times t$, qui se réarrange en $v = d / t$ ou $t = d / v$. Le piège n'est presque jamais le calcul mais l'**unité** : convertir un temps en heures décimales (« 1 h 15 » devient 1,25 h, pas 1,15), et convertir km/h en m/s en **divisant par 3,6** (m/s → km/h : multiplier par 3,6). Automatisme à poser dès la lecture : si l'énoncé mélange des minutes et des km/h, convertissez tout de suite les minutes en heures avant d'écrire la relation.

### Consommation de carburant

Le schéma est le même que vitesse/temps/distance mais avec un débit : consommation totale = débit horaire × durée. Isolez la durée maximale (autonomie) par division, la consommation par multiplication. Sanity-check utile : un avion qui « brûlerait » plus de carburant qu'il n'en a l'autonomie annoncée signale presque toujours une inversion débit/durée dans le calcul.

### Proportions et règle de trois

Face à « si *a* correspond à *b*, que correspond *c* ? », posez le tableau à quatre cases et appliquez le produit en croix : $x = (b \times c) / a$. Raccourci : quand *a* et *c* ont un rapport simple (double, moitié, dixième), appliquez ce rapport directement à *b* sans poser le produit en croix — c'est presque toujours plus rapide qu'une division exacte.

### Conversions d'unités

Mémorisez le sens de la conversion (multiplier ou diviser) plutôt que la valeur seule : km/h → m/s se **divise** par 3,6 (les mètres par seconde sont une unité plus fine, donc un nombre plus petit pour la même vitesse). Généralisez ce réflexe : convertir vers une unité plus petite (km → m, h → min) fait **augmenter** le nombre ; convertir vers une unité plus grande le fait **diminuer**. Ce réflexe de sens évite de multiplier au lieu de diviser sous pression.

### Fuseaux horaires

Ramenez toujours les heures locales à une référence commune (UTC) avant de faire l'opération, puis reconvertissez à l'arrivée. Un décalage horaire se **soustrait** à l'heure locale de départ à l'est de la référence, s'**ajoute** à l'ouest (ou l'inverse selon le sens du trajet) : posez explicitement le signe avant de calculer plutôt que de le déduire de tête, c'est la source d'erreur numéro un de ce type d'énoncé.

## Pièges et erreurs fréquentes

> [!TRAP]
> **Mélanger les unités sans les harmoniser.** Une vitesse en km/h combinée à un temps en minutes sans conversion donne un résultat faux par un facteur 60. Convertissez systématiquement tout en unités cohérentes (heures et km, ou minutes et m) avant d'écrire la relation, jamais après.

> [!TRAP]
> **Répondre à la mauvaise inconnue.** Un énoncé qui donne la distance et la vitesse pour demander le temps restant (et non le temps total) piège les lecteurs pressés qui répondent à la question qu'ils avaient anticipée. Relisez la dernière phrase de l'énoncé — c'est elle qui contient l'inconnue exacte — avant d'écrire quoi que ce soit.

> [!TRAP]
> **Valider un résultat aberrant.** Un avion « parcourant » 3 000 km en 20 minutes, ou une consommation représentant dix fois l'autonomie annoncée, signale une erreur de calcul ou d'unité. Toujours comparer le résultat à un ordre de grandeur plausible avant de valider.

Autres erreurs classiques :

- **Poser l'équation à l'envers** (diviser au lieu de multiplier) sous la pression du chronomètre : reformulez la relation à voix basse avant de substituer les valeurs.
- **Oublier de reconvertir** un résultat intermédiaire dans l'unité demandée par la question (répondre en minutes alors que l'énoncé demande des heures).
- **Ignorer le signe** dans un calcul de fuseau horaire ou de variation (gain/perte de temps), ce qui inverse le sens du résultat sans en changer la valeur absolue.
- **Refaire tout le calcul au brouillon sans avoir d'abord identifié la relation** : le brouillon sert à exécuter une méthode déjà choisie, pas à tâtonner.

## Exemple guidé 1 — vitesse, temps, distance

> [!EXAMPLE]
> Un avion parcourt 450 km en 1 h 30. Il doit ensuite parcourir 300 km supplémentaires à la même vitesse moyenne. Combien de temps, en minutes, ce second trajet prendra-t-il ?

### Étape 1

Inconnue : le temps du second trajet, en minutes. Donnée intermédiaire nécessaire : la vitesse moyenne, non fournie directement.

### Étape 2

Relation : $v = d / t$ pour le premier trajet, puis $t = d / v$ pour le second. Je convertis d'abord 1 h 30 en heures décimales : 1,5 h.

### Étape 3

Vitesse : $450 / 1{,}5 = 300$ km/h. Temps du second trajet : $300 / 300 = 1$ h, soit **60 minutes**.

### Étape 4

Vérification par ordre de grandeur : le second trajet fait les deux tiers de la distance du premier (300 sur 450), à vitesse égale il devrait durer les deux tiers du premier temps, soit les deux tiers de 90 min = 60 min. Cohérent, je valide.

## Exemple guidé 2 — carburant et autonomie

> [!EXAMPLE]
> Un avion consomme 180 litres par heure de vol et dispose de 810 litres de carburant au départ, dont une réserve incompressible de 90 litres. Quelle est son autonomie de vol utile, en minutes ?

### Étape 1

Inconnue : autonomie de vol utile en minutes. Donnée clé : carburant réellement disponible pour voler = carburant total moins la réserve incompressible.

### Étape 2

Relation : consommation totale = débit horaire × durée, donc durée = carburant disponible / débit horaire. Carburant disponible : $810 - 90 = 720$ litres.

### Étape 3

Durée : $720 / 180 = 4$ heures, soit **240 minutes**.

### Étape 4

Vérification : à 180 L/h, 4 heures consomment bien $180 \times 4 = 720$ L, ce qui laisse exactement les 90 L de réserve intacts. Ordre de grandeur cohérent avec un vol de moyen-courrier ; je valide.

## Exemple guidé 3 — fuseau horaire

> [!EXAMPLE]
> Un vol décolle à 14 h 20, heure locale de départ (UTC+2), et dure 8 h 10. L'arrivée est en UTC−5. Quelle est l'heure locale d'arrivée ?

### Étape 1

Inconnue : heure locale d'arrivée. Je ramène tout à UTC d'abord : heure de départ en UTC = 14 h 20 − 2 h = 12 h 20 UTC.

### Étape 2

Relation : heure d'arrivée UTC = heure de départ UTC + durée de vol. $12{,}33 + 8{,}17$ heures (12 h 20 = 12,33 h ; 8 h 10 = 8,17 h) $= 20{,}5$ h, soit 20 h 30 UTC.

### Étape 3

Conversion vers le fuseau d'arrivée (UTC−5) : $20 h 30 - 5 h = 15 h 30$, heure locale d'arrivée.

### Étape 4

Vérification : le décalage total entre les deux fuseaux est de 7 h (de UTC+2 à UTC−5). L'heure locale d'arrivée devrait donc être en avance sur l'heure locale de départ d'un écart de (durée de vol − décalage) = 8 h 10 − 7 h = 1 h 10. $14 h 20 + 1 h 10 = 15 h 30$. Cohérent, je valide.

## Routine d'échauffement de 5 minutes

1. **1 min — automatismes de conversion.** Convertissez de tête cinq vitesses km/h ↔ m/s (÷3,6 puis ×3,6) et trois durées « h min » en heures décimales.
2. **2 min — trois énoncés vitesse/temps/distance** en mode Entraînement, en écrivant systématiquement la relation avant de substituer les valeurs.
3. **1 min — un calcul de fuseau horaire**, en ramenant chaque heure locale à UTC avant de calculer, jamais en calculant directement d'un fuseau à l'autre.
4. **1 min — relecture des trois pièges** (mélange d'unités, mauvaise inconnue, résultat aberrant non contrôlé). Puis on lance.

## Pour aller plus loin

- Le paquet de flashcards `p1_math_word_problems.deck.mental_shortcuts` reprend les raccourcis de conversion, les réarrangements de vitesse/temps/distance, la règle de trois et les repères de contrôle par ordre de grandeur.
