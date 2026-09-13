import 'dart:math';

import 'package:psy_content/psy_content.dart';

/// Which attribute(s) this run's series keys its target rule off (US-115,
/// spec §2.3-3 -- format is an `[open question]`, so this picks the two
/// most plausible shapes a "rare target" vigilance task takes, mirroring
/// the card's own examples).
enum AttentionRuleKind {
  /// The target is a fixed shape+colour pair (e.g. "red circle").
  conjunction,

  /// The target is "the same shape as the immediately preceding stimulus".
  repeatShape,
}

/// The role assigned to one stimulus of a series (mirrors `NbackRole`):
/// how it relates to the series' fixed target rule.
enum AttentionRole {
  /// Matches the rule exactly: the correct answer is "target".
  target,

  /// Shares exactly one attribute with what the rule looks for, without
  /// matching it (a plausible false-alarm source): the correct answer is
  /// "not target".
  lure,

  /// Neither: the correct answer is "not target".
  filler,
}

/// One flashed stimulus: what the renderer draws and whether it is this
/// series' target.
class AttentionStimulus {
  const AttentionStimulus({
    required this.shape,
    required this.colour,
    required this.role,
  });

  final StimulusShape shape;
  final StimulusColour colour;
  final AttentionRole role;

  bool get isTarget => role == AttentionRole.target;

  /// Re-derives the stimulus [item] (a `GeneratedItem` of
  /// `p1_attention_sustained`) stands for, from its own
  /// `origin.runSeed`/`origin.index` and `params` -- the renderer and the
  /// scorer both call this instead of the item carrying extra fields (see
  /// `AttentionSeries`). Falls back to `runSeed = seed`, `index = 0` when
  /// `origin` carries none (a direct `generate()` call, e.g. a unit test).
  static AttentionStimulus decode(
    P1AttentionSustainedParams params,
    int runSeed,
    int index,
  ) {
    final itemsPerSeries = _clampItemsPerSeries(params.itemsPerSeries);
    final seriesIndex = index ~/ itemsPerSeries;
    final indexInSeries = index % itemsPerSeries;
    final series = AttentionSeries.build(params, runSeed, seriesIndex);
    return series.stimuli[indexInSeries];
  }

  static int _clampItemsPerSeries(int itemsPerSeries) =>
      itemsPerSeries < 1 ? 1 : itemsPerSeries;
}

/// One series' fixed target rule and its generated stream of stimuli,
/// derived once from `(params, runSeed, seriesIndex)`.
///
/// **Derivation.** The rule (which kind, and -- for [AttentionRuleKind
/// .conjunction] -- which shape/colour) is drawn from
/// `Random(Object.hash(runSeed, seriesIndex))`, so every item of the same
/// series shares it (the briefing shows it once per series) while
/// different series of the same run -- and the same series across
/// different runs -- get independently drawn rules. The stream itself is
/// then drawn from a second `Random` seeded the same way (with a distinct
/// salt) so reading the rule alone (for a briefing) never has to build the
/// stream, and vice versa.
class AttentionSeries {
  const AttentionSeries({
    required this.seriesIndex,
    required this.ruleKind,
    required this.targetShape,
    required this.targetColour,
    required this.stimuli,
  });

  final int seriesIndex;
  final AttentionRuleKind ruleKind;

  /// The target shape. For [AttentionRuleKind.repeatShape] this is only the
  /// series' *first* stimulus's shape (informational; the actual rule keys
  /// off whatever the previous stimulus was, not this fixed value).
  final StimulusShape targetShape;

  /// The target colour; meaningless for [AttentionRuleKind.repeatShape].
  final StimulusColour targetColour;

  final List<AttentionStimulus> stimuli;

  /// Builds the rule and the whole stimulus stream of series [seriesIndex]
  /// of the run `(params, runSeed)`. Series are independent of each other
  /// (the rule never carries across a series boundary), so only this one
  /// series' `itemsPerSeries` stimuli are computed.
  factory AttentionSeries.build(
    P1AttentionSustainedParams params,
    int runSeed,
    int seriesIndex,
  ) {
    final shapes = _atLeastTwoShapes(params.shapes);
    final colours = _atLeastTwoColours(params.colours);
    final itemsPerSeries = params.itemsPerSeries < 1
        ? 1
        : params.itemsPerSeries;

    // Not `Object.hash`: Dart randomises its mixing per process (the same
    // hash-flooding protection that makes `String.hashCode` vary run to
    // run also reaches `Object.hash`, even over plain ints), so it cannot
    // seed a `Random` deterministically across runs/replays. `_mixSeed` is
    // pure integer arithmetic instead -- no hashCode involved -- so the
    // same `(runSeed, seriesIndex)` always draws the same rule and stream,
    // on any run, exactly what `ActivityEngine.generate`'s "same inputs,
    // same item" contract (and replaying a stored attempt) requires.
    final ruleRng = Random(_mixSeed(runSeed, seriesIndex, 1));
    final ruleKind = ruleRng.nextBool()
        ? AttentionRuleKind.conjunction
        : AttentionRuleKind.repeatShape;
    final targetShape = shapes[ruleRng.nextInt(shapes.length)];
    final targetColour = colours[ruleRng.nextInt(colours.length)];

    final streamRng = Random(_mixSeed(runSeed, seriesIndex, 2));
    final stimuli = <AttentionStimulus>[];
    for (var i = 0; i < itemsPerSeries; i++) {
      stimuli.add(
        _nextStimulus(
          rng: streamRng,
          shapes: shapes,
          colours: colours,
          ruleKind: ruleKind,
          targetShape: targetShape,
          targetColour: targetColour,
          targetRatio: params.targetRatio,
          lureRatio: params.lureRatio,
          previous: stimuli.isEmpty ? null : stimuli.last,
          secondBack: stimuli.length < 2 ? null : stimuli[stimuli.length - 2],
        ),
      );
    }
    return AttentionSeries(
      seriesIndex: seriesIndex,
      ruleKind: ruleKind,
      targetShape: targetShape,
      targetColour: targetColour,
      stimuli: stimuli,
    );
  }

  static AttentionStimulus _nextStimulus({
    required Random rng,
    required List<StimulusShape> shapes,
    required List<StimulusColour> colours,
    required AttentionRuleKind ruleKind,
    required StimulusShape targetShape,
    required StimulusColour targetColour,
    required double targetRatio,
    required double lureRatio,
    required AttentionStimulus? previous,
    required AttentionStimulus? secondBack,
  }) {
    var role = _rollRole(rng, targetRatio, lureRatio);
    // repeatShape has no reference before the 2nd (target) / 3rd (lure)
    // item of the series -- demote to a filler until history exists.
    if (ruleKind == AttentionRuleKind.repeatShape) {
      if (role == AttentionRole.target && previous == null) {
        role = AttentionRole.filler;
      }
      if (role == AttentionRole.lure && secondBack == null) {
        role = AttentionRole.filler;
      }
    }

    return switch (ruleKind) {
      AttentionRuleKind.conjunction => _conjunctionStimulus(
        rng: rng,
        shapes: shapes,
        colours: colours,
        targetShape: targetShape,
        targetColour: targetColour,
        role: role,
      ),
      AttentionRuleKind.repeatShape => _repeatShapeStimulus(
        rng: rng,
        shapes: shapes,
        colours: colours,
        role: role,
        previous: previous,
        secondBack: secondBack,
      ),
    };
  }

  static AttentionRole _rollRole(
    Random rng,
    double targetRatio,
    double lureRatio,
  ) {
    final roll = rng.nextDouble();
    if (roll < targetRatio) return AttentionRole.target;
    if (roll < targetRatio + lureRatio) return AttentionRole.lure;
    return AttentionRole.filler;
  }

  /// Target: the exact (shape, colour) pair. Lure: shares exactly one of
  /// the two with the target. Filler: shares neither.
  static AttentionStimulus _conjunctionStimulus({
    required Random rng,
    required List<StimulusShape> shapes,
    required List<StimulusColour> colours,
    required StimulusShape targetShape,
    required StimulusColour targetColour,
    required AttentionRole role,
  }) {
    switch (role) {
      case AttentionRole.target:
        return AttentionStimulus(
          shape: targetShape,
          colour: targetColour,
          role: role,
        );
      case AttentionRole.lure:
        final shape = rng.nextBool()
            ? targetShape
            : _differentShape(rng, shapes, targetShape);
        final colour = shape == targetShape
            ? _differentColour(rng, colours, targetColour)
            : targetColour;
        return AttentionStimulus(shape: shape, colour: colour, role: role);
      case AttentionRole.filler:
        final shape = _differentShape(rng, shapes, targetShape);
        final colour = _differentColour(rng, colours, targetColour);
        return AttentionStimulus(shape: shape, colour: colour, role: role);
    }
  }

  /// Target: same shape as the immediately preceding stimulus. Lure: same
  /// shape as the stimulus *two* back (an "off by one" near-miss on the
  /// rule's own attribute -- the wrong lag rather than a wrong attribute).
  /// Filler: neither. Colour is irrelevant under this rule and drawn freely.
  static AttentionStimulus _repeatShapeStimulus({
    required Random rng,
    required List<StimulusShape> shapes,
    required List<StimulusColour> colours,
    required AttentionRole role,
    required AttentionStimulus? previous,
    required AttentionStimulus? secondBack,
  }) {
    final colour = colours[rng.nextInt(colours.length)];
    switch (role) {
      case AttentionRole.target:
        return AttentionStimulus(
          shape: previous!.shape,
          colour: colour,
          role: role,
        );
      case AttentionRole.lure:
        final lureShape = secondBack!.shape;
        // If the 2-back shape happens to equal the true target (1-back), it
        // would score as a target, not a lure -- fall back to any other
        // shape so the lure stays a genuine non-target.
        final shape = lureShape == previous?.shape
            ? _differentShape(rng, shapes, previous!.shape)
            : lureShape;
        return AttentionStimulus(shape: shape, colour: colour, role: role);
      case AttentionRole.filler:
        final avoid = previous?.shape;
        final shape = avoid == null
            ? shapes[rng.nextInt(shapes.length)]
            : _differentShape(rng, shapes, avoid);
        return AttentionStimulus(shape: shape, colour: colour, role: role);
    }
  }

  static List<StimulusShape> _atLeastTwoShapes(List<StimulusShape> shapes) =>
      shapes.length >= 2
      ? shapes
      : const <StimulusShape>[StimulusShape.square, StimulusShape.circle];

  static List<StimulusColour> _atLeastTwoColours(
    List<StimulusColour> colours,
  ) => colours.length >= 2
      ? colours
      : const <StimulusColour>[StimulusColour.blue, StimulusColour.red];

  static StimulusShape _differentShape(
    Random rng,
    List<StimulusShape> shapes,
    StimulusShape excluded,
  ) {
    if (shapes.length <= 1) return shapes.isEmpty ? excluded : shapes.first;
    var candidate = shapes[rng.nextInt(shapes.length)];
    while (candidate == excluded) {
      candidate = shapes[rng.nextInt(shapes.length)];
    }
    return candidate;
  }

  /// A deterministic, process-stable combination of [runSeed], [seriesIndex]
  /// and [salt] (1 for the rule draw, 2 for the stream draw -- any two
  /// distinct values would do) to seed a `Random`. Plain integer
  /// arithmetic, never `Object.hash`/`hashCode` -- see the call sites'
  /// doc for why.
  static int _mixSeed(int runSeed, int seriesIndex, int salt) =>
      runSeed ^ (seriesIndex * 1000003) ^ (salt * 7919);

  static StimulusColour _differentColour(
    Random rng,
    List<StimulusColour> colours,
    StimulusColour excluded,
  ) {
    if (colours.length <= 1) {
      return colours.isEmpty ? excluded : colours.first;
    }
    var candidate = colours[rng.nextInt(colours.length)];
    while (candidate == excluded) {
      candidate = colours[rng.nextInt(colours.length)];
    }
    return candidate;
  }
}
