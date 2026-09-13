---
name: add-activity-engine
description: Implement a new PSY0/PSY1 activity engine (generator + scorer + renderer) on the shared activity runtime — use for any EPIC-03-style "add engine <family>" story.
---

# Add an activity engine

The generic runtime (`apps/psy_trainer/lib/features/train/domain/engine/`,
`.../presentation/engine/`) sequences items, runs timers/cadence, records attempts and scores
a section. An engine only supplies **a generator, a scorer and a renderer**. Read
`apps/psy_trainer/lib/features/engines/logic_dominos/**` end to end as the reference
implementation while following the 5 steps below.

## Files you touch

Everything under `apps/psy_trainer/lib/features/engines/<family_id>/{domain,presentation}/`,
tests under `apps/psy_trainer/test/features/engines/<family_id>/`, plus **one line each** in
`apps/psy_trainer/lib/features/train/presentation/engine/engine_registry_provider.dart`, l10n
keys appended to both ARB files. Never edit the runtime itself
(`train/domain/engine/`, `train/presentation/engine/` besides the registry file), another
engine, or the content contract/family/blueprint JSON — if a default looks wrong, say so in
the report instead of changing it.

## 1. Generator

`lib/features/engines/<family>/domain/<family>_engine.dart`:

```dart
class DominosEngine extends ActivityEngine {
  const DominosEngine();

  @override
  String get familyId => 'logic_dominos';        // == TestFamily.engineType

  @override
  GeneratorId get generatorId => GeneratorId.dominos;

  @override
  Item generate({
    required GeneratorParams params,
    required int seed,
    required int difficulty,
    int index = 0,
    int? runSeed,
  }) {
    final typed = params as DominosParams;       // cast your typed params
    // derive the puzzle deterministically from Random(seed) (or Random(runSeed)
    // — see below), give it id ActivityEngine.generatedItemId(generatorId, seed)
    // and origin: ItemOrigin(generatorId: generatorId, seed: seed,
    // runSeed: runSeed ?? seed, index: index)
    return Item.generated(...);
  }

  @override
  ItemResult score(Item item, Answer answer) { ... }
}
```

Same `(params, seed, difficulty)` must always yield the same item — unit-test it. Return an
`McqItem`/`NumericItem` when the activity naturally is one; otherwise a `GeneratedItem` whose
`params` (or re-derivation from the seed) carries what the renderer needs. Bank-driven engines
(culture, English) have no generator: leave `generatorId` null.

**`runSeed` / `index` (only when items depend on each other).** `ItemSource.generator`'s own
`seed` is the *run's* `runSeed`, identical across every item of the run; the per-item `seed`
(still one per item, drawn from `Random(runSeed)`) is what `generatedItemId`/`ItemOrigin` key
replay on. Most engines are independent per item and never read `runSeed`/`index` (arithmetic
grid, dominos, parity). An engine whose item *k* depends on earlier items (n-back) or whose
whole run shares one property drawn once (a rule set) reads `runSeed` (and `index` for a
continuous stream) and recomputes the whole run from `Random(runSeed)` each time, storing
`runSeed`/`index` on `origin` so the renderer/scorer can redo the same computation from the
materialised item alone. A direct `generate()` call with no `runSeed` (unit tests) defaults to
`runSeed = seed`, `index = 0`.

## 2. Scorer

Override `score(Item, Answer)` only when the default (`Scorer.scoreItem`: MCQ choice, numeric
with tolerance, sequence recall) doesn't fit. Return `ItemResult(correct:, metrics: {...})` —
metrics are summed into `SectionResult.metricTotals` for the summary screen and analytics.
Never handle `TimeoutAnswer` (the runtime does). Pick the `Answer` case that fits: `choice`,
`numeric`, `multiSelect` (grids), `key` (key presses), `sequence` (ordered tokens/click
paths), `raw` (anything else). Dominos scores an ordered pair with
`Answer.sequence(['$top', '$bottom'])`.

## 3. Renderer

`lib/features/engines/<family>/presentation/<family>_renderer.dart`:

```dart
class DominosRenderer extends ActivityRenderer {
  const DominosRenderer();

  @override
  String get familyId => 'logic_dominos';

  @override
  Widget build(BuildContext context, ActivityRenderContext render) => ...;

  @override
  Widget? buildExample(BuildContext context, [RunExampleContext? run]) => ...;
}
```

- Widgets layer only (`design-system` skill for tokens/widgets) — no Material/Cupertino.
- Draw `render.item` for `render.phase`, call `render.onAnswer(answer)` **once**, show
  `render.feedback` when non-null (the runtime already applied the practice/exam
  show-feedback policy — the renderer never decides whether to show it).
- Keyboard input via `Focus`/`KeyboardListener` + `LogicalKeyboardKey`; a touch fallback is
  fine but must be labelled non-representative when the family's `inputRequirement` is
  `keyboard` — see `docs/ARCHITECTURE.md` "Platforms" for the exact convention.
- Never run your own timers for the runtime's limits: `SessionHost` draws the countdown bars
  from `render.itemDeadline`; cadence phases arrive through `render.phase`.
- `buildExample(context, [run])` is optional, for the briefing screen; ignore `run` unless the
  activity derives run-specific state from the run seed (only then does `SessionHost` pass a
  populated `RunExampleContext` — `runSeed` + `params` of the run about to play).
- Strings through `context.l10n`, keys added to **both**
  `apps/psy_trainer/lib/core/l10n/app_fr.arb` and `app_en.arb` (see `ship-a-story`).

## 4. Register

Add one line to each registry in
`apps/psy_trainer/lib/features/train/presentation/engine/engine_registry_provider.dart`,
**alphabetical by family id**:

```dart
final Provider<EngineRegistry> engineRegistryProvider = Provider(
  (ref) => EngineRegistry(<ActivityEngine>[
    ...
    const DominosEngine(),
    ...
  ]),
);
```

The list is **non-const**; prefix your own entry with `const` unless your engine/renderer
captures `ref` (e.g. `WordBoxesEngine(ref.read(lexicalFieldCatalogueProvider))` does not use
`const`). Several engine stories touch this file in parallel — expect a trivial merge conflict
on push; resolve by keeping every line from both sides (see `ship-a-story`, "merge hotspots").

## 5. Check the content matches

Check `assets/content/psy0/<family>/family.json` (`engineType`, `generatorId`,
`defaultCadence`, `defaultPerItemTimeSec`, `liveFeedback`) and every section of
`assets/content/psy0/blueprints/*.json` that references your family
(`itemSelection.generated.params`, `cadence`, `scoringPolicy`) actually match what the
generator expects. A new params key is a **contract change** (`docs/content/CONTRACT.md` §3) —
do not edit the JSON yourself if a default looks wrong; report it instead.

## Tests

- `test/features/engines/<family>/domain/<family>_engine_test.dart`: determinism per seed
  (same inputs -> same/equal item), announced counts, no ambiguous items, scorer correctness
  for right/wrong/swapped/wrong-answer-kind cases. See
  `apps/psy_trainer/test/features/engines/logic_dominos/domain/dominos_engine_test.dart`.
- A full-session test with `ActivitySession` + `ManualClock` + `InMemoryProgressRepository`
  for any cadence/timing behaviour.
- `test/features/engines/<family>/presentation/<family>_renderer_test.dart`: widget-test the
  renderer through `SessionHost` with the engine registered — template:
  `apps/psy_trainer/test/features/train/presentation/engine/session_host_test.dart` (overrides
  `progressRepositoryProvider`, `engineRegistryProvider`, `rendererRegistryProvider`,
  `engineClockProvider`; `test/helpers/fake_engine.dart` / `fake_renderer.dart` for other
  tests' fakes).

See the `data-layer` skill for how attempts/sessions persist, `design-system` for the widget
catalogue, and `ship-a-story` for verification, l10n, merge and PR mechanics.
