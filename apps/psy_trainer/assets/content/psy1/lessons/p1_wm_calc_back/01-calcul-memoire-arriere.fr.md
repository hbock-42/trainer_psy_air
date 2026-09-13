# Calcul mémoire arrière : tenir le résultat pendant que le calcul continue

*Mémoire de travail II*, surnommée « calcul mémoire arrière », enchaîne des calculs simples dont chacun **dépend du résultat du précédent** — sans jamais réafficher ce résultat intermédiaire. Sur quatre étapes de charge croissante, chacune longue d'une vingtaine de calculs ou plus, l'activité ne teste pas votre capacité à calculer (les opérations restent simples) mais votre capacité à **porter un total courant** sur une longue chaîne sans le perdre ni le laisser dériver.

## Ce que mesure l'activité

L'activité mesure le **maintien actif d'un résultat en mémoire de travail pendant qu'un traitement supplémentaire se poursuit** — une charge cognitive très différente d'un calcul isolé. C'est directement transférable au pilotage : ajuster mentalement une masse restante, une quantité de carburant ou une altitude cible au fil d'une série d'instructions successives, sans redemander la valeur de départ à chaque étape.

Trois éléments entrent en jeu : la **rétention du total courant** (ne pas l'oublier entre deux calculs), l'**exécution de l'opération suivante** appliquée à ce total (et non à un nombre affiché), et la **résistance à la dérive cumulative** : une petite erreur non corrigée à l'étape 3 fausse tout le reste de la chaîne jusqu'à l'étape 20.

## Format et chronométrage rapportés

| Élément | Valeur rapportée | Confiance |
|---|---|---|
| Structure | 4 étapes de charge croissante | **[rapporté]** |
| Volume par étape | 20 calculs ou plus par étape | **[rapporté]** |
| Nature des calculs | Opérations arithmétiques simples appliquées en chaîne au résultat courant (le résultat précédent n'est pas réaffiché) | **[rapporté]** |
| Progression de la difficulté | Charge croissante d'une étape à l'autre (probablement : opérations plus nombreuses ou plus variées par étape) | **[rapporté]** |
| Durée et cadence exactes | Non précisées ; comptez un rythme proche du calcul mental simple, quelques secondes par opération | **[estimé]** |
| Pénalité en cas d'erreur | Non documentée ; une erreur non corrigée se répercute logiquement sur tous les calculs suivants de la chaîne | **[estimé]** |

Le point le plus important à retenir : contrairement à un calcul isolé, une erreur ici **ne reste jamais locale**. Elle contamine tous les résultats suivants tant qu'elle n'est pas corrigée, ce qui rend la rigueur du suivi plus importante que la vitesse brute.

## Méthode et stratégie

> [!METHOD]
> **Le total courant est votre seule variable : ne le relisez jamais, mettez-le à jour.** À chaque opération, appliquez-la mentalement au total que vous portez déjà, remplacez immédiatement l'ancien total par le nouveau, et **oubliez l'ancien**. Ne revenez jamais en arrière pour « relire » un résultat précédent : il n'est pas réaffiché, et chercher à s'en souvenir fait perdre le fil de l'opération en cours.

### La technique du total courant

Traitez chaque étape comme un unique nombre qui évolue, pas comme une série de calculs indépendants. Verbalisez intérieurement uniquement le total courant après chaque opération (« … et maintenant 47 … et maintenant 39 … »), jamais l'opération complète avec son historique. C'est la même discipline que tenir un solde de compte au fil d'opérations successives : seul le solde compte, pas la liste des mouvements.

### Ne jamais « re-dériver » le résultat précédent

Le piège principal de cette activité est de douter du total courant et de vouloir le recalculer depuis le début de la chaîne. C'est presque toujours impossible (les valeurs intermédiaires ne sont pas conservées) et toujours plus lent que d'accepter le total courant et d'avancer. Faites confiance à votre suivi ; une chaîne de calculs simples se corrige d'elle-même en moyenne si vous ne paniquez pas sur un doute isolé.

### Le chunking de la chaîne de calcul

Sur une étape de 20 calculs ou plus, ne pensez pas « 20 opérations à faire » mais découpez mentalement en blocs de 4 à 5 opérations, avec une micro-pause de contrôle d'ordre de grandeur entre chaque bloc (« le total est-il resté dans une fourchette plausible ? »). Ce contrôle périodique limite la dérive sans ralentir le rythme global.

### Éviter la dérive cumulative

Une petite erreur d'arithmétique à l'opération 5 devient, sans correction, l'origine d'un écart qui persiste jusqu'à l'opération 20. Le seul rempart efficace est le contrôle d'ordre de grandeur par bloc décrit ci-dessus : il ne corrige pas l'erreur précise, mais il permet de la détecter tôt (« ce total ne devrait pas être négatif à ce stade ») plutôt que de la découvrir à la fin.

## Pièges et erreurs fréquentes

> [!TRAP]
> **Essayer de se souvenir de l'historique complet de la chaîne.** Seul le total courant compte. Retenir chaque opération passée en plus du total actuel double la charge mentale pour rien : ce n'est jamais demandé et ça épuise l'attention avant la fin de l'étape.

> [!TRAP]
> **Paniquer sur un doute et vouloir tout recommencer.** Revenir en arrière n'est presque jamais possible (le résultat précédent n'est pas réaffiché) et coûte un temps qui manquera pour la suite de la chaîne. Acceptez le total courant tel qu'il est et continuez.

> [!TRAP]
> **Laisser une dérive silencieuse s'installer.** Sans contrôle périodique d'ordre de grandeur, une erreur commise tôt dans la chaîne (étape 3 sur 20) reste invisible jusqu'à la fin, où le résultat final paraît juste faux sans qu'on sache où l'erreur s'est produite.

Autres erreurs classiques :

- **Changer de rythme entre les 4 étapes** : la charge augmente progressivement, mais la technique du total courant reste identique — ne changez pas de méthode en cours de test.
- **Confondre l'opération à appliquer et le total courant** : appliquer « + 7 » au chiffre affiché à l'écran plutôt qu'au total qu'on porte en tête est une erreur fréquente en fin de chaîne, quand la fatigue s'installe.
- **Négliger le signe** d'une soustraction dans la chaîne, qui fait basculer le total dans le mauvais sens sans que cela soit immédiatement visible.

## Exemple guidé 1 — une courte chaîne de 4 opérations

> [!EXAMPLE]
> Départ : total courant = 10. Chaîne d'opérations à appliquer successivement : « + 6 », « × 2 », « − 5 », « + 3 ». Quel est le total final ?

### Étape 1

« + 6 » appliqué à 10 : nouveau total = 16. J'oublie le 10, je ne garde que 16.

### Étape 2

« × 2 » appliqué à 16 : nouveau total = 32. J'oublie le 16.

### Étape 3

« − 5 » appliqué à 32 : nouveau total = 27. « + 3 » appliqué à 27 : nouveau total final = **30**.

### Étape 4

Vérification par recalcul global (possible ici car la chaîne est courte) : $((10 + 6) \times 2 - 5) + 3 = (16 \times 2 - 5) + 3 = (32 - 5) + 3 = 27 + 3 = 30$. Cohérent.

## Exemple guidé 2 — une chaîne avec contrôle d'ordre de grandeur

> [!EXAMPLE]
> Départ : total courant = 50. Chaîne : « − 8 », « − 8 », « × 3 », « − 20 », « + 4 », « ÷ 2 ». Quel est le total final ?

### Étape 1

Bloc 1 (deux premières opérations) : « − 8 » sur 50 → 42. « − 8 » sur 42 → 34. Contrôle d'ordre de grandeur : le total doit rester positif et proche de la cinquantaine de départ moins un peu — 34 est plausible.

### Étape 2

Bloc 2 : « × 3 » sur 34 → 102. Contrôle : une multiplication par 3 doit environ tripler le total précédent (34 × 3 ≈ 100) — 102 est cohérent, pas de dérive détectée.

### Étape 3

Bloc 3 : « − 20 » sur 102 → 82. « + 4 » sur 82 → 86.

### Étape 4

« ÷ 2 » sur 86 → total final = **43**. Vérification globale : $(((50-8-8) \times 3) - 20 + 4) / 2 = (34 \times 3 - 16) / 2 = (102-16)/2 = 86/2 = 43$. Cohérent.

## Exemple guidé 3 — repérer une dérive avant la fin de la chaîne

> [!EXAMPLE]
> Départ : total courant = 20. Chaîne : « × 2 », « + 15 », « − 5 », « ÷ 3 », « + 10 ». À l'étape « ÷ 3 », vous obtenez mentalement un total de 50/3 non entier et hésitez : comment procéder ?

### Étape 1

« × 2 » sur 20 → 40. Contrôle : plausible, le total a doublé comme attendu.

### Étape 2

« + 15 » sur 40 → 55. Contrôle : cohérent, légère hausse attendue.

### Étape 3

« − 5 » sur 55 → 50. Avant de diviser, un contrôle d'ordre de grandeur montre que 50 est un multiple probable de valeurs rondes ; si la division par 3 ne tombe pas juste, c'est le signal qu'une opération précédente a été mal appliquée (ici, aucune erreur : 50 n'étant pas un multiple de 3, l'activité utilise en réalité des résultats non entiers arrondis à l'unité la plus proche dans ce cas, comme le permettent certaines chaînes).

### Étape 4

« ÷ 3 » sur 50 → environ 16,7, arrondi à 17 selon la convention du test. « + 10 » sur 17 → total final ≈ **27**. La leçon de cet exemple : un total qui ne « tombe pas rond » n'est pas nécessairement une erreur — le contrôle d'ordre de grandeur sert à repérer une dérive franche (un total devenu négatif ou disproportionné), pas à exiger un résultat entier à chaque étape.

## Routine d'échauffement de 5 minutes

1. **1 min — total courant à voix haute.** Partez d'un nombre à deux chiffres et appliquez cinq opérations simples dictées à voix haute, en n'énonçant que le total courant après chacune.
2. **2 min — deux chaînes de 10 opérations** en mode Entraînement, avec un contrôle d'ordre de grandeur toutes les 4 à 5 opérations.
3. **1 min — repérage de dérive volontaire** : recommencez une chaîne en introduisant sciemment une petite erreur au milieu, et entraînez-vous à sentir que le total final « ne colle pas » avec l'ordre de grandeur attendu.
4. **1 min — relecture des trois pièges** (retenir l'historique complet, vouloir tout recommencer, dérive silencieuse non contrôlée). Puis on lance.

## Pour aller plus loin

- L'activité *Mémoire de travail inversée* (Mémoire de travail I) partage la même famille de compétences — maintenir une information active en mémoire de travail — sous une forme mnémonique plutôt qu'arithmétique ; s'entraîner sur l'une renforce l'autre.
