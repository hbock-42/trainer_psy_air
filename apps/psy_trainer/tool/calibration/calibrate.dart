// ignore_for_file: avoid_print
//
// US-086 (issue #62): a headless calibration harness. For every implemented
// generator and difficulty 1..5, it materialises N=200 items and reports
// objective complexity metrics (rule counts, operand sizes, BFS distances,
// lure ratios, etc. -- see each generator's section below), then writes
// `docs/content/difficulty.md` (from the repo root) with the metric
// tables, which difficulty level the metrics land closest to the real-test
// report of `docs/content/psy0-spec.md` §2.4, and recommended adjustments.
//
// **Why this lives under `apps/psy_trainer/tool/` and not the repo-root
// `tools/`.** The engines' domain code (`lib/features/engines/*/domain/`)
// has no Flutter import (only `dart:*` and `package:psy_content`), so it
// *could* run headless -- but it is still part of the `psy_trainer`
// package (whose `pubspec.yaml` depends on the Flutter SDK), and the
// repo-root `tools/` scripts resolve against the workspace root's own
// `pubspec.yaml`, which deliberately carries no dependency of its own (see
// its own doc comment) so it cannot `import 'package:psy_trainer/...'`.
// Running `dart run` *inside* `apps/psy_trainer` (its own `dart_tool/
// package_config.json`, resolved once via `dart pub get` at the workspace
// root) works today with the Dart SDK bundled in Flutter, and needs no
// widget/rendering surface -- confirmed by running this file. This is the
// "simplest that runs headlessly" option the card allows.
//
// Run (needs `dart pub get` at the repo root first):
//   cd apps/psy_trainer && dart run tool/calibration/calibrate.dart
//
// `verbal_boxes` is not covered here:
// - `verbal_boxes`'s generator needs the authored lexical-field catalogue
//   (US-085, `assets/content/psy0/verbal_boxes/lexical_fields/core.json`)
//   loaded from disk and parsed into `LexicalField`s before `buildSeries`
//   can run; out of scope for this pass (see `docs/content/difficulty.md`
//   follow-ups) to keep this harness a pure-Dart, dependency-free script.

import 'dart:io';
import 'dart:math';

import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/features/engines/arithmetic_grid/domain/arithmetic_grid.dart';
import 'package:psy_trainer/features/engines/attention_airways/domain/airways_simulation.dart';
import 'package:psy_trainer/features/engines/attention_parity/domain/parity_layout.dart';
import 'package:psy_trainer/features/engines/logic_dominos/domain/domino_board.dart';
import 'package:psy_trainer/features/engines/multitask_psychomotor/domain/multitask_simulation.dart';
import 'package:psy_trainer/features/engines/planning_tubes/domain/tubes_puzzle.dart';
import 'package:psy_trainer/features/engines/spatial_cubes/domain/cube_net_puzzle.dart';
import 'package:psy_trainer/features/engines/spatial_overlay/domain/overlay_board.dart';
import 'package:psy_trainer/features/engines/spatial_viewpoint/domain/viewpoint_scene.dart';

const int sampleSize = 200;
const List<int> difficulties = [1, 2, 3, 4, 5];

/// One row of a metric table: difficulty -> named numeric averages.
class Metric {
  Metric(this.name, this.perDifficulty);
  final String name;
  final Map<int, double> perDifficulty;
}

class GeneratorReport {
  GeneratorReport({
    required this.generatorId,
    required this.family,
    required this.specNote,
    required this.metrics,
    required this.realTestLevel,
    required this.recommendation,
  });

  final String generatorId;
  final String family;
  final String specNote;
  final List<Metric> metrics;
  final int realTestLevel;
  final String recommendation;
}

void main() {
  final reports = <GeneratorReport>[
    _calibrateDominos(),
    _calibrateCubeNet(),
    _calibrateViewpoint(),
    _calibrateTubes(),
    _calibrateArithmeticGrid(),
    _calibrateOverlay(),
    _calibrateParity(),
    _calibrateAirways(),
    _calibrateNback(),
    _calibrateAttentionRules(),
    _calibrateMultitask(),
  ];

  for (final r in reports) {
    _printReport(r);
  }
  _writeDoc(reports);
}

void _printReport(GeneratorReport r) {
  print('\n=== ${r.generatorId} (${r.family}) ===');
  for (final m in r.metrics) {
    final cells = difficulties
        .map((d) => m.perDifficulty[d]!.toStringAsFixed(2))
        .join('  ');
    print('  ${m.name.padRight(24)} $cells');
  }
}

double _avg(Iterable<num> xs) =>
    xs.isEmpty ? 0 : xs.fold<num>(0, (a, b) => a + b) / xs.length;

// --- logic_dominos --------------------------------------------------------

GeneratorReport _calibrateDominos() {
  const params = DominosParams();
  final ruleCount = <int, double>{};
  final length = <int, double>{};
  for (final d in difficulties) {
    final ruleCounts = <int>[];
    final lengths = <int>[];
    for (var seed = 0; seed < sampleSize; seed++) {
      final board = buildDominoBoard(seed: seed, params: params, difficulty: d);
      ruleCounts.add(board.ruleKinds.length);
      lengths.add(board.dominoes.length);
    }
    ruleCount[d] = _avg(ruleCounts);
    length[d] = _avg(lengths);
  }
  return GeneratorReport(
    generatorId: 'dominos',
    family: 'logic_dominos',
    specNote:
        '§2.4-G: modulo-7 series, ~16-20 items, count assumed. §3.1 row 6: 16 items in 8 min.',
    metrics: [Metric('rule count', ruleCount), Metric('series length', length)],
    realTestLevel: 3,
    recommendation:
        'Rule count already maps difficulty 1..4 to 1..4 named rule families '
        '(linear, then one of alternating/mirror/sum, then interleaved with 1 '
        'or 2 sub-rules); difficulty 5 is *intentionally* clamped to the same '
        'catalogue as 4 (see `buildDominoBoard`\'s doc comment and '
        '`domino_board_test.dart`\'s "an out-of-catalog difficulty (5) is '
        'clamped" test) -- the catalogue has no 5th, harder rule family yet. '
        'No change applied: adding one needs a new rule (e.g. a mirrored '
        'interleaved series) *and* a solver update so uniqueness-checking '
        'still recognises it, which is a bigger, separate change than this '
        'calibration pass should make silently. Left as a follow-up.',
  );
}

// --- spatial_cubes ---------------------------------------------------------

GeneratorReport _calibrateCubeNet() {
  const params = CubeNetParams();
  final missing = <int, double>{};
  final tray = <int, double>{};
  for (final d in difficulties) {
    final missingCounts = <int>[];
    final trayCounts = <int>[];
    for (var seed = 0; seed < sampleSize; seed++) {
      final puzzle = buildCubeNetPuzzle(
        seed: seed,
        params: params,
        difficulty: d,
      );
      missingCounts.add(puzzle.targetRequired.length);
      trayCounts.add(puzzle.trayTiles.length);
    }
    missing[d] = _avg(missingCounts);
    tray[d] = _avg(trayCounts);
  }
  return GeneratorReport(
    generatorId: 'cube_net',
    family: 'spatial_cubes',
    specNote: '§2.4-L: 4-5 (2020) up to 10 (2022-2023) items, ~60 s each.',
    metrics: [
      Metric('missing faces', missing),
      Metric('tray tile count', tray),
    ],
    realTestLevel: 3,
    recommendation:
        'missingFaces = difficulty.clamp(2, 5): difficulty 1 and 2 both give '
        '2 missing faces (5 clamped from below), so the two easiest levels '
        'are currently identical. `AUTHORING.md` §4 does not list a cube '
        'column, so there is no spec-backed target to diverge from; no '
        'change applied. If a future story wants 5 distinct levels, the '
        'natural lever is a 1-missing-face tier for difficulty 1 (change the '
        'clamp to `.clamp(1, 5)`) -- flagged as a follow-up, not applied here '
        'since it needs a tray/solver check for the 1-missing-face case '
        '(only one distractor needed) to stay unambiguous.',
  );
}

// --- spatial_viewpoint -------------------------------------------------------

GeneratorReport _calibrateViewpoint() {
  const params = ViewpointParams();
  final objectCount = <int, double>{};
  for (final d in difficulties) {
    final counts = <int>[];
    for (var seed = 0; seed < sampleSize; seed++) {
      final scene = buildViewpointScene(
        seed: seed,
        params: params,
        difficulty: d,
      );
      counts.add(scene.objects.length);
    }
    objectCount[d] = _avg(counts);
  }
  return GeneratorReport(
    generatorId: 'viewpoint',
    family: 'spatial_viewpoint',
    specNote: '§2.4-K: 10 items, ~10-15 s each, 8 numbered viewpoints.',
    metrics: [Metric('object count', objectCount)],
    realTestLevel: 3,
    recommendation:
        'objectCount already scales monotonically 3/3/4/5/6 across '
        'difficulty 1..5 (params.objectCount=4 shifted by difficulty-3, '
        'clamped 3..6) -- difficulty 1 and 2 coincide at the floor (3), '
        'matching the AUTHORING.md target of a gentle low end. Well '
        'calibrated; no change.',
  );
}

// --- planning_tubes ----------------------------------------------------------

GeneratorReport _calibrateTubes() {
  const params = TubesParams();
  final distance = <int, double>{};
  for (final d in difficulties) {
    final distances = <int>[];
    for (var seed = 0; seed < sampleSize; seed++) {
      final puzzle = TubesPuzzleGenerator.build(
        params: params,
        seed: seed,
        difficulty: d,
      );
      distances.add(puzzle.distance);
    }
    distance[d] = _avg(distances);
  }
  return GeneratorReport(
    generatorId: 'tubes',
    family: 'planning_tubes',
    specNote: '§2.4-B: ~10-20 questions, ~40 s each, min-moves numeric input.',
    metrics: [Metric('BFS distance', distance)],
    realTestLevel: 3,
    recommendation:
        'BFS distance bands `{2}/{3}/{4}/{5}/{6..8}` (default minMoves 2, '
        'maxMoves 8) already give a clean, monotonic difficulty ladder one '
        'move apart. No change.',
  );
}

// --- arithmetic_grid ----------------------------------------------------------

GeneratorReport _calibrateArithmeticGrid() {
  const params = ArithmeticGridParams();
  final maxDisplayed = <int, double>{};
  final wrongCount = <int, double>{};
  for (final d in difficulties) {
    final maxima = <int>[];
    final wrongCounts = <int>[];
    for (var seed = 0; seed < sampleSize; seed++) {
      final grid = ArithmeticGridGenerator.build(
        params: params,
        seed: seed,
        difficulty: d,
      );
      maxima.add(grid.cells.map((c) => c.displayedValue.abs()).reduce(max));
      wrongCounts.add(grid.wrongIndices.length);
    }
    maxDisplayed[d] = _avg(maxima);
    wrongCount[d] = _avg(wrongCounts);
  }
  return GeneratorReport(
    generatorId: 'arithmetic_grid',
    family: 'arithmetic_grid',
    specNote:
        '§2.4-J: "real calculations reported plus simples que Pilotest" '
        '(integers, squares, priorities, simple divisions); §3.1 row 9: 8 '
        'grids, ~45 s each.',
    metrics: [
      Metric('max displayed value', maxDisplayed),
      Metric('wrong-cell count', wrongCount),
    ],
    realTestLevel: 3,
    recommendation:
        'Each operation already self-limits its operand bound to min(12, '
        'cap) (mul/div) or min(20, cap) (square) / min(10, cap) (priority) '
        'regardless of `maxOperand`, so only add/sub grow toward the full '
        'operand cap; that matches "simple divisions/squares" at every '
        'difficulty. No change applied.',
  );
}

// --- spatial_overlay ----------------------------------------------------------

GeneratorReport _calibrateOverlay() {
  const params = OverlayGridParams();
  final tileCount = <int, double>{};
  final overlap = <int, double>{};
  final blackCells = <int, double>{};
  for (final d in difficulties) {
    final tiles = <int>[];
    final overlaps = <int>[];
    final blacks = <int>[];
    for (var seed = 0; seed < sampleSize; seed++) {
      final board = buildOverlayBoard(
        seed: seed,
        params: params,
        difficulty: d,
      );
      tiles.add(board.tiles.length);
      overlaps.add(board.overlapCellCount);
      blacks.add(board.blackCellCount);
    }
    tileCount[d] = _avg(tiles);
    overlap[d] = _avg(overlaps);
    blackCells[d] = _avg(blacks);
  }
  return GeneratorReport(
    generatorId: 'overlay_grid',
    family: 'spatial_overlay',
    specNote:
        '§2.4-E: 3 boards (2020) -> 5 (2022-2026), ~60-90 s; "version II '
        '(2024+) has heavily overlapping shapes and black cells", "fortement '
        'complexifiée" at Sept 2026.',
    metrics: [
      Metric('tile count', tileCount),
      Metric('overlap cell count', overlap),
      Metric('black cell count', blackCells),
    ],
    realTestLevel: 3,
    recommendation:
        'All three levers (tile count, overlap, black cells) already climb '
        'with difficulty, tile count only stepping up at difficulty 5 (spec: '
        '"3 to 4 tiles"). No change.',
  );
}

// --- attention_parity ----------------------------------------------------------

GeneratorReport _calibrateParity() {
  const params = ParitySequenceParams();
  final count = <int, double>{};
  for (final d in difficulties) {
    final counts = <int>[];
    for (var seed = 0; seed < sampleSize; seed++) {
      final layout = ParityLayout.build(
        params: params,
        seed: seed,
        difficulty: d,
      );
      counts.add(layout.numbers.length);
    }
    count[d] = _avg(counts);
  }
  return GeneratorReport(
    generatorId: 'parity_sequence',
    family: 'attention_parity',
    specNote:
        '§2.4-D: 5 series (2022-2023), ~16 numbers/series (Pilotest trains 10).',
    metrics: [Metric('number count', count)],
    realTestLevel: 3,
    recommendation:
        'numberCount already grows 2 per difficulty step around the '
        'default 16 (12/14/16/18/20). No change.',
  );
}

// --- attention_airways ----------------------------------------------------------

GeneratorReport _calibrateAirways() {
  const params = AirwaysParams();
  final routeCount = <int, double>{};
  final spawnIntervalMs = <int, double>{};
  for (final d in difficulties) {
    routeCount[d] = AirwaysSimulation.effectiveRouteCount(params, d).toDouble();
    // Mirrors `AirwaysSimulation._buildSchedule`'s private formula (not
    // exposed publicly): base spawn interval shrinks 400 ms per difficulty
    // step above the middle level, clamped to 900..4000 ms.
    spawnIntervalMs[d] = (params.spawnIntervalMs - (d - 3) * 400)
        .clamp(900, 4000)
        .toDouble();
  }
  return GeneratorReport(
    generatorId: 'airways',
    family: 'attention_airways',
    specNote:
        '§2.4-H: 10 successive series (~5 min), capacity 4 / 2 blue per zone.',
    metrics: [
      Metric('route count', routeCount),
      Metric('spawn interval (ms)', spawnIntervalMs),
    ],
    realTestLevel: 3,
    recommendation:
        'Route count (2..4) and spawn interval (900..4000 ms) both already '
        'scale with difficulty ("difficulty = spawn rate / graph complexity" '
        'per the engine\'s own doc comment). No change.',
  );
}

// --- memory_nback ----------------------------------------------------------

GeneratorReport _calibrateNback() {
  const params = NbackParams();
  final n = <int, double>{};
  final paletteSize = <int, double>{};
  final lureRatio = <int, double>{};
  for (final d in difficulties) {
    // `NbackEngine.generate`/`NbackStimulus.decode` never read `difficulty`
    // -- only `params` (fixed to the family default for every practice
    // run, see `practice_session_builder._generatorSource`) drives `n`,
    // `paletteSize`, `lureRatio`. So every column below is identical: this
    // *is* the finding, not a measurement bug.
    n[d] = params.n.toDouble();
    paletteSize[d] = params.paletteSize.toDouble();
    lureRatio[d] = params.lureRatio;
  }
  return GeneratorReport(
    generatorId: 'nback',
    family: 'memory_nback',
    specNote:
        '§2.4-A: 42 stimuli incl. 2 primers, ~1 min 45 s; AUTHORING.md §4 '
        'expects "1-back, 2 colours" at difficulty 1 up to "3-back, 4+ '
        'stimuli, lures" at difficulty 5.',
    metrics: [
      Metric('n (back distance)', n),
      Metric('palette size', paletteSize),
      Metric('lure ratio', lureRatio),
    ],
    realTestLevel: 3,
    recommendation:
        'GAP: difficulty has *no* effect on the generated stream -- `n`, '
        '`paletteSize` and `lureRatio` are read only from `params`, which '
        'practice sessions always set to the family default regardless of '
        'the requested difficulty (`GeneratorParams.defaultsFor`). '
        'AUTHORING.md §4 documents a 1..5 n-back ladder that the engine does '
        'not implement. Not fixed here: `NbackSequence` is one continuous '
        'stream per run (`runSeed`), so "difficulty" would have to become a '
        'run-level (not per-item) concept threaded from the practice-session '
        'builder through to `NbackParams`, which is a session-model change, '
        'not a generator-internal tweak -- too large to make "minimally" in '
        'this pass. Follow-up: pick difficulty-linked `NbackParams` presets '
        '(e.g. difficulty 1..2 -> n=1, paletteSize 2-3; 3 -> n=2, 3 colours, '
        '10% lures (today\'s default); 4..5 -> n=3, digits, lures) and have '
        'the session builder pick one when a specific difficulty (not '
        '"Auto") is selected.',
  );
}

// --- attention_rules ----------------------------------------------------------

GeneratorReport _calibrateAttentionRules() {
  const params = StimulusResponseParams();
  final ruleDepth = <int, double>{};
  for (final d in difficulties) {
    // Same situation as n-back: `StimulusRuleSet.fromRunSeed` reads
    // `params.ruleDepth` only; `AttentionRulesEngine.generate` never
    // derives it from `difficulty`.
    ruleDepth[d] = params.ruleDepth.toDouble();
  }
  return GeneratorReport(
    generatorId: 'stimulus_response',
    family: 'attention_rules',
    specNote:
        '§2.4-C: rules given at start, shape flashes every 3 s, ~2 min, live '
        'feedback ("résilience"). Not in AUTHORING.md\'s §4 difficulty table '
        '-- the real test itself does not vary this activity\'s format '
        '(spec: "100% Pilotest, no surprise" for well-trained candidates).',
    metrics: [Metric('rule depth', ruleDepth)],
    realTestLevel: 3,
    recommendation:
        'ruleDepth is fixed at 2 (params default) regardless of difficulty, '
        'same root cause as n-back. Left unchanged: unlike n-back, no spec '
        'or AUTHORING.md target says this activity should get harder with '
        'difficulty (the real test\'s format is reported stable), so this is '
        'not treated as a gap here -- noted for completeness only.',
  );
}

// --- multitask_psychomotor ----------------------------------------------------

GeneratorReport _calibrateMultitask() {
  const params = MultitaskParams();
  final scale = <int, double>{};
  final shapeEvents = <int, double>{};
  final calcEvents = <int, double>{};
  for (final d in difficulties) {
    scale[d] = MultitaskSimulation.scaleFor(d);
    final shapes = <int>[];
    final calcs = <int>[];
    for (var seed = 0; seed < sampleSize; seed++) {
      final sim = MultitaskSimulation.build(
        seed: seed,
        params: params,
        difficulty: d,
      );
      shapes.add(sim.shapeEvents.length);
      calcs.add(sim.calcEvents.length);
    }
    shapeEvents[d] = _avg(shapes);
    calcEvents[d] = _avg(calcs);
  }
  return GeneratorReport(
    generatorId: 'multitask',
    family: 'multitask_psychomotor',
    specNote:
        '§2.4-M: continuous ~5 min, tracking + shape-match + calc-check '
        'simultaneously; "tracking target reported plus erratique que '
        'Pilotest".',
    metrics: [
      Metric('tracking scale', scale),
      Metric('shape events', shapeEvents),
      Metric('calc events', calcEvents),
    ],
    realTestLevel: 3,
    recommendation:
        'Tracking noise/speed and shape/calc event *rate* all scale with the '
        'same `scaleFor(difficulty) = 1 + 0.15*(difficulty-3)` factor '
        '(0.7x..1.3x): higher difficulty shortens the average shape/calc '
        'interval, so event counts climb with difficulty too, as the table '
        'shows. This is already the engine\'s own explicit design '
        '(`MultitaskSimulation`\'s doc comment: difficulty 3 = the family\'s '
        'documented defaults, "not spec\'d, the real test\'s difficulty curve '
        'is undocumented"). No change: matches this harness\'s numbers and '
        'is already flagged by the engine\'s own author as awaiting '
        'real-test data.',
  );
}

// --- Doc output --------------------------------------------------------------

void _writeDoc(List<GeneratorReport> reports) {
  final buf = StringBuffer();
  buf.writeln('# Generator difficulty calibration (US-086, issue #62)');
  buf.writeln();
  buf.writeln(
    'Generated by `apps/psy_trainer/tool/calibration/calibrate.dart` '
    '(`cd apps/psy_trainer && dart run tool/calibration/calibrate.dart`), '
    'N=$sampleSize items per generator per difficulty level (seeds '
    '0..${sampleSize - 1}), real-test default `params` (no overrides). '
    'Re-run it and paste the tables back here whenever a generator\'s '
    'difficulty mapping changes.',
  );
  buf.writeln();
  buf.writeln(
    '**Target**: difficulty 3 should read like the real PSY0 test '
    '(`docs/content/psy0-spec.md` §2.4/§2.5 -- Pilotest\'s own stanine '
    'scale calls 7/9 the trained level, so our difficulty 3 aims at what '
    'the spec reports as the *typical* real-test item, not the hardest '
    'one). Below, every generator we could measure lands difficulty 3 at '
    'its real-test default (`GeneratorParams.defaultsFor`) by construction '
    '-- these are the parameters shipped in `assets/content/psy0/*/family.json` '
    'and `generators.schema.json`\'s documented real-test defaults, not '
    'independently re-derived. What this harness actually checks is '
    '*monotonicity and spread* across 1..5, which is what the "calibrate" '
    'card is about.',
  );
  buf.writeln();
  buf.writeln('## Not covered by this pass');
  buf.writeln();
  buf.writeln(
    '- `verbal_boxes` (`word_boxes` generator): needs the US-085 lexical-'
    'field bank loaded from JSON before `WordBoxSeries.build` can run. Out '
    'of scope for a pure-Dart harness in this pass; a follow-up can load '
    '`assets/content/psy0/verbal_boxes/lexical_fields/core.json` through '
    '`psy_content`\'s own parser and call `WordBoxSeries.build` the same '
    'way.',
  );
  buf.writeln();
  buf.writeln('## Human play-testing (card step, not automatable)');
  buf.writeln();
  buf.writeln(
    'The card asks for 2-3 people to play each difficulty and confirm it '
    '*feels* right; that cannot be scripted. Follow-up: once the seed bank '
    'of US-084 exists for `logic_dominos`/`spatial_cubes`/'
    '`spatial_viewpoint` (`assets/content/psy0/<family>/items/seed.json`), '
    'have 2-3 people attempt a handful of each difficulty band (loading '
    'them e.g. through a temporary debug screen or by pointing a practice '
    'session\'s `ItemSource.bank` at the seed file) and compare their pass '
    'rate/timing per difficulty against the metrics below.',
  );
  buf.writeln();

  for (final r in reports) {
    buf.writeln('## `${r.generatorId}` (`${r.family}`)');
    buf.writeln();
    buf.writeln('Spec: ${r.specNote}');
    buf.writeln();
    buf.writeln('Real-test level: difficulty ${r.realTestLevel}.');
    buf.writeln();
    buf.write('| metric ');
    for (final d in difficulties) {
      buf.write('| d$d ');
    }
    buf.writeln('|');
    buf.write('|---');
    for (final _ in difficulties) {
      buf.write('|---');
    }
    buf.writeln('|');
    for (final m in r.metrics) {
      buf.write('| ${m.name} ');
      for (final d in difficulties) {
        buf.write('| ${m.perDifficulty[d]!.toStringAsFixed(2)} ');
      }
      buf.writeln('|');
    }
    buf.writeln();
    buf.writeln('**Recommendation.** ${r.recommendation}');
    buf.writeln();
  }

  // Resolve relative to the current working directory, which the run
  // instructions above fix to `apps/psy_trainer`, so the doc always lands
  // at the repo's `docs/content/difficulty.md`.
  final resolved = File(
    '${Directory.current.path}/../../docs/content/difficulty.md',
  );
  resolved.parent.createSync(recursive: true);
  resolved.writeAsStringSync(buf.toString());
  print('\nwrote ${resolved.path}');
}
