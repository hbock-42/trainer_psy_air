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
  /// stands for, from its own `seed`/`params` -- the renderer and the
  /// scorer both call this instead of the item carrying extra fields (see
  /// [StimulusRuleSet]).
  factory StimulusTrial.forItem(GeneratedItem item) =>
      StimulusRuleSet.fromParams(
        item.params as StimulusResponseParams,
      ).trial(item.seed);
}

/// The conditional rule of one run (spec §2.4-C): *filled -> the shape
/// decides the key* (`shapeA` -> `keyA`, `shapeB` -> `keyB`); *empty -> the
/// colour decides the key* (`colourA` -> `keyA`, `colourB` -> `keyB`). 2
/// conditions x 2 outcomes -> 2 keys, exactly as briefed to the candidate.
///
/// **Convention (why this is not seeded by the per-item `seed`).**
/// `ItemSource.generator` (`item_source.dart`) draws one independent
/// `itemSeed` per stimulus from the run's seed before calling
/// `ActivityEngine.generate` (`params`, that `itemSeed`, `difficulty`); nothing
/// ties one item's `itemSeed` to another's, so nothing derived from it can be
/// shared across the run. The one value every call *does* share is `params`
/// itself (the same `StimulusResponseParams` instance for every item), so
/// [StimulusRuleSet.fromParams] derives the rule from `params` alone --
/// `shapes[0]`/`colours[0]` always pair with `keys[0]`, `shapes[1]`/`colours[1]`
/// with `keys[1]` -- which trivially makes it identical for every item of a
/// run (and matches the family's own briefing example: filled square -> N,
/// filled triangle -> X, empty blue -> N, empty orange -> X). "Shapes,
/// colours and keys randomised per run" is then simply a property of the
/// `params` the caller builds the run's `GeneratorSource` with (a different
/// order, or a longer `shapes`/`colours` pool `ruleDepth` also draws
/// distractors from) -- this class only ever reacts to `params`, so any such
/// variation flows straight through. Each item's own `seed` is reserved for
/// what *is* legitimately per-item: which of the 4 rule branches (and which
/// irrelevant shape/colour, for visual variety) this one trial flashes, kept
/// balanced across the run by drawing every branch with equal probability
/// (see [trial]).
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

  /// Derives the run's rule set from `params` alone -- see the class doc.
  factory StimulusRuleSet.fromParams(StimulusResponseParams params) {
    final shapes = params.shapes.length >= 2
        ? params.shapes
        : const <StimulusShape>[StimulusShape.square, StimulusShape.triangle];
    final colours = params.colours.length >= 2
        ? params.colours
        : const <StimulusColour>[StimulusColour.blue, StimulusColour.orange];
    final keys = params.keys.length >= 2
        ? params.keys
        : const <String>['n', 'x'];
    final extraShapes = shapes.length > 2
        ? shapes.sublist(2)
        : const <StimulusShape>[];
    final extraColours = colours.length > 2
        ? colours.sublist(2)
        : const <StimulusColour>[];

    // ruleDepth (>= 2) raises complexity by adding distractor shapes/colours
    // -- visual noise on whichever attribute the current condition ignores
    // -- never extra rule branches: the real test always keys 2 conditions x
    // 2 outcomes to 2 keys (spec §2.4-C).
    final extra = (params.ruleDepth - 2).clamp(
      0,
      extraShapes.length > extraColours.length
          ? extraShapes.length
          : extraColours.length,
    );

    return StimulusRuleSet._(
      shapeA: shapes[0],
      shapeB: shapes[1],
      colourA: colours[0],
      colourB: colours[1],
      keyA: keys[0],
      keyB: keys[1],
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
