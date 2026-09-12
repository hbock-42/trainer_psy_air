import 'dart:math';

import 'package:psy_content/psy_content.dart';

/// Whether the flashed shape is filled or empty (spec §2.4-C): the
/// condition that decides which attribute of the stimulus the rule keys
/// off.
enum StimulusFill {
  /// Filled shape: the rule keys off which *shape* is drawn.
  filled,

  /// Empty (outline) shape: the rule keys off which *colour* is drawn.
  empty,
}

/// One flashed stimulus: what the renderer draws and the key that scores
/// it right under the run's [StimulusRuleSet].
class StimulusTrial {
  const StimulusTrial({
    required this.fill,
    required this.shape,
    required this.colour,
    required this.correctKey,
  });

  final StimulusFill fill;
  final StimulusShape shape;
  final StimulusColour colour;

  /// The key ([StimulusResponseParams.keys] entry) that scores this trial
  /// right.
  final String correctKey;

  /// Re-derives the trial [item] (a `GeneratedItem` of `attention_rules`)
  /// stands for, from its own `origin.runSeed`/`params`/`seed` -- the
  /// renderer and the scorer both call this instead of the item carrying
  /// extra fields (see [StimulusRuleSet]). Falls back to `runSeed = seed`
  /// when `origin` carries none (a direct `generate()` call with no
  /// `runSeed`, e.g. a unit test).
  factory StimulusTrial.forItem(GeneratedItem item) =>
      StimulusRuleSet.fromRunSeed(
        item.origin?.runSeed ?? item.seed,
        item.params as StimulusResponseParams,
      ).trial(item.seed);
}

/// The conditional rule of one run (spec §2.4-C): *filled -> the shape
/// decides the key* (`shapeA` -> `keyA`, `shapeB` -> `keyB`); *empty -> the
/// colour decides the key* (`colourA` -> `keyA`, `colourB` -> `keyB`). 2
/// conditions x 2 outcomes -> 2 keys, exactly as briefed to the candidate.
///
/// **Derivation (US-037).** The runtime now passes every engine a `runSeed`
/// identical for the whole run (`ActivityEngine.generate`'s `runSeed`
/// parameter, from `ItemSource.generator`), so the rule set can finally be
/// randomised *per run* while staying identical across every item of that
/// run: [StimulusRuleSet.fromRunSeed] shuffles the `shapes`/`colours`/`keys`
/// pools with `Random(runSeed)` before pairing them up, so two runs with the
/// same `params` get different (but each internally stable) rules.
/// [StimulusRuleSet.fromParams] keeps the older, unshuffled pairing
/// (`shapes[0]`/`colours[0]` with `keys[0]`, etc., matching the family's
/// own briefing example: filled square -> N, filled triangle -> X, empty
/// blue -> N, empty orange -> X) as the canonical stand-in
/// `AttentionRulesRenderer.buildExample` falls back to when it has no run
/// to describe yet (no session started, a catalogue screen). Each item's
/// own `seed` is reserved for what *is* legitimately per-item: which of the
/// 4 rule branches (and which irrelevant shape/colour, for visual variety)
/// this one trial flashes, kept balanced across the run by drawing every
/// branch with equal probability (see [trial]).
class StimulusRuleSet {
  StimulusRuleSet._({
    required this.shapeA,
    required this.shapeB,
    required this.colourA,
    required this.colourB,
    required this.keyA,
    required this.keyB,
    required this.distractorShapes,
    required this.distractorColours,
  });

  /// The canonical, unshuffled rule set for `params` -- see the class doc.
  /// Used as the briefing's fallback illustration when no run is known.
  factory StimulusRuleSet.fromParams(StimulusResponseParams params) => _build(
    shapes: params.shapes,
    colours: params.colours,
    keys: params.keys,
    ruleDepth: params.ruleDepth,
  );

  /// The run's actual rule set (US-037): the `shapes`/`colours`/`keys`
  /// pools of `params` are shuffled with `Random(runSeed)` before pairing,
  /// so the mapping varies run to run while staying fixed within one run
  /// (every item of the run calls this with the same `runSeed`).
  factory StimulusRuleSet.fromRunSeed(
    int runSeed,
    StimulusResponseParams params,
  ) {
    final rng = Random(runSeed);
    final shapes = List<StimulusShape>.of(params.shapes)..shuffle(rng);
    final colours = List<StimulusColour>.of(params.colours)..shuffle(rng);
    final keys = List<String>.of(params.keys)..shuffle(rng);
    return _build(
      shapes: shapes,
      colours: colours,
      keys: keys,
      ruleDepth: params.ruleDepth,
    );
  }

  static StimulusRuleSet _build({
    required List<StimulusShape> shapes,
    required List<StimulusColour> colours,
    required List<String> keys,
    required int ruleDepth,
  }) {
    final effectiveShapes = shapes.length >= 2
        ? shapes
        : const <StimulusShape>[StimulusShape.square, StimulusShape.triangle];
    final effectiveColours = colours.length >= 2
        ? colours
        : const <StimulusColour>[StimulusColour.blue, StimulusColour.orange];
    final effectiveKeys = keys.length >= 2 ? keys : const <String>['n', 'x'];
    final extraShapes = effectiveShapes.length > 2
        ? effectiveShapes.sublist(2)
        : const <StimulusShape>[];
    final extraColours = effectiveColours.length > 2
        ? effectiveColours.sublist(2)
        : const <StimulusColour>[];

    // ruleDepth (>= 2) raises complexity by adding distractor shapes/colours
    // -- visual noise on whichever attribute the current condition ignores
    // -- never extra rule branches: the real test always keys 2 conditions x
    // 2 outcomes to 2 keys (spec §2.4-C).
    final extra = (ruleDepth - 2).clamp(
      0,
      extraShapes.length > extraColours.length
          ? extraShapes.length
          : extraColours.length,
    );

    return StimulusRuleSet._(
      shapeA: effectiveShapes[0],
      shapeB: effectiveShapes[1],
      colourA: effectiveColours[0],
      colourB: effectiveColours[1],
      keyA: effectiveKeys[0],
      keyB: effectiveKeys[1],
      distractorShapes: extraShapes.take(extra).toList(),
      distractorColours: extraColours.take(extra).toList(),
    );
  }

  /// The shape scored with [keyA] when filled.
  final StimulusShape shapeA;

  /// The shape scored with [keyB] when filled.
  final StimulusShape shapeB;

  /// The colour scored with [keyA] when empty.
  final StimulusColour colourA;

  /// The colour scored with [keyB] when empty.
  final StimulusColour colourB;

  final String keyA;
  final String keyB;

  /// Extra shapes shown only when empty (irrelevant to scoring), added as
  /// [StimulusResponseParams.ruleDepth] rises above 2.
  final List<StimulusShape> distractorShapes;

  /// Extra colours shown only when filled (irrelevant to scoring), added as
  /// [StimulusResponseParams.ruleDepth] rises above 2.
  final List<StimulusColour> distractorColours;

  /// The two shapes the filled branch chooses between.
  List<StimulusShape> get filledShapes => [shapeA, shapeB];

  /// The two colours the empty branch chooses between.
  List<StimulusColour> get emptyColours => [colourA, colourB];

  /// The key that scores [shape] right when filled.
  String keyForShape(StimulusShape shape) => shape == shapeA ? keyA : keyB;

  /// The key that scores [colour] right when empty.
  String keyForColour(StimulusColour colour) => colour == colourA ? keyA : keyB;

  /// Draws one stimulus deterministically from [seed]: a fill state, its
  /// discriminating attribute (each of the 4 branches equally likely) and,
  /// for visual variety, an independent draw of the attribute the current
  /// fill state ignores.
  StimulusTrial trial(int seed) {
    final rng = Random(seed);
    if (rng.nextBool()) {
      final shape = rng.nextBool() ? shapeA : shapeB;
      return StimulusTrial(
        fill: StimulusFill.filled,
        shape: shape,
        colour: _anyColour(rng),
        correctKey: keyForShape(shape),
      );
    }
    final colour = rng.nextBool() ? colourA : colourB;
    return StimulusTrial(
      fill: StimulusFill.empty,
      shape: _anyShape(rng),
      colour: colour,
      correctKey: keyForColour(colour),
    );
  }

  StimulusShape _anyShape(Random rng) {
    final pool = [shapeA, shapeB, ...distractorShapes];
    return pool[rng.nextInt(pool.length)];
  }

  StimulusColour _anyColour(Random rng) {
    final pool = [colourA, colourB, ...distractorColours];
    return pool[rng.nextInt(pool.length)];
  }
}
