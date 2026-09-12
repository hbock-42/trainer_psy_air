// ignore_for_file: avoid_print
//
// US-084 (issue #60): scans generator seeds and keeps the ones whose
// generated puzzle matches a target property (rule family for dominos,
// missing-face count for cube nets, object count for viewpoint scenes),
// then writes them as `generated` bank items (GeneratedItem recipes:
// generatorId + seed + params + difficulty) into
// `apps/psy_trainer/assets/content/psy0/<family>/items/seed.json`.
//
// These are *not* picked up by the practice-session launcher: for a family
// whose `TestFamily.generatorId` is set, `practice_session_builder.dart`'s
// `buildActivitySessionConfig` always takes the `_generatorSource` branch
// (fresh random seed, family defaults) and never reads the family's bank
// items -- see `_bankSource`, only reached when `generatorId == null`. So
// this seed bank is a *calibration corpus* for US-086 (hand-picked,
// reproducible items with known properties to check the generator against)
// and a reserve of good worked examples for a future "curated series" mode
// (US-084 card), not something a candidate sees today.
//
// Run (needs the app package's dependencies, `dart pub get` at the repo
// root first):
//   cd apps/psy_trainer && dart run tool/calibration/pick_seeds.dart
//
// Pure Dart: only imports `dart:*`, `package:psy_content` and the engines'
// domain libraries (no Flutter/widget import), so plain `dart run` (the
// Dart SDK bundled with Flutter) is enough -- see the doc comment on
// `calibrate.dart` for why this lives under `apps/psy_trainer/tool/` rather
// than the repo-root `tools/` (those pure-Dart scripts have no package
// dependency of their own and cannot import an app-package library).

import 'dart:convert';
import 'dart:io';

import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/features/engines/logic_dominos/domain/domino_board.dart';
import 'package:psy_trainer/features/engines/spatial_cubes/domain/cube_net_puzzle.dart';
import 'package:psy_trainer/features/engines/spatial_viewpoint/domain/viewpoint_scene.dart';

/// Target distribution across difficulty 1..5 for a bank of [total] items,
/// following `docs/content/AUTHORING.md` §4 ("10 % / 25 % / 35 % / 20 % /
/// 10 %").
Map<int, int> _distributionOf(int total) {
  final raw = [0.10, 0.25, 0.35, 0.20, 0.10];
  final counts = [for (final r in raw) (r * total).round()];
  // Rounding can drift the sum off `total`; fix it up on the middle
  // (largest) bucket so the bank has exactly `total` items.
  final drift = total - counts.reduce((a, b) => a + b);
  counts[2] += drift;
  return {for (var i = 0; i < 5; i++) i + 1: counts[i]};
}

void main() {
  _pickDominos();
  _pickCubeNet();
  _pickViewpoint();
}

// --- Dominos (40 items, spec §2.4-G) ------------------------------------

void _pickDominos() {
  const params = DominosParams();
  final byDifficulty = _distributionOf(40);
  final items = <Map<String, Object?>>[];
  var n = 1;
  for (final difficulty in [1, 2, 3, 4, 5]) {
    final wanted = byDifficulty[difficulty]!;
    // Cycle through the rule families a board can name at this difficulty
    // so the bank covers every family the generator can produce, not just
    // whichever one a plain seed-order scan would hit first.
    final seenKinds = <Set<DominoRuleKind>>{};
    var picked = 0;
    var seed = difficulty * 100000;
    var scanned = 0;
    while (picked < wanted) {
      final board = buildDominoBoard(
        seed: seed,
        params: params,
        difficulty: difficulty,
      );
      final kinds = board.ruleKinds.toSet();
      // Skip a rule-kind combination already picked 3+ times at this
      // difficulty so the bank samples the catalogue's diversity instead
      // of one dominant family; give up on being picky after scanning
      // 20x the wanted count so a run always terminates.
      final seenCount = seenKinds.where((k) => _setEquals(k, kinds)).length;
      scanned++;
      if (seenCount < 3 || scanned > wanted * 20) {
        seenKinds.add(kinds);
        final tag = _dominoTag(kinds);
        items.add({
          'id': 'logic_dominos.$tag.gen.${n.toString().padLeft(4, '0')}',
          'type': 'generated',
          'version': 1,
          'familyId': 'logic_dominos',
          'difficulty': difficulty,
          'tags': ['logic.dominos', 'logic.dominos.$tag'],
          'generatorId': 'dominos',
          'seed': seed,
          'meta': {
            'notes':
                'Calibration seed (US-084/US-086): rules=${kinds.map((k) => k.name).join(', ')}; '
                'series length ${board.dominoes.length}; missing index ${board.missingIndex}; '
                'answer ${board.answer.top}|${board.answer.bottom}. Real-test defaults (no params override).',
          },
        });
        n++;
        picked++;
      }
      seed++;
    }
  }
  _writeBank('logic_dominos', items);
}

String _dominoTag(Set<DominoRuleKind> kinds) {
  if (kinds.contains(DominoRuleKind.interleavedSeries)) return 'spiral';
  if (kinds.contains(DominoRuleKind.alternatingTopBottom)) return 'alternating';
  if (kinds.contains(DominoRuleKind.mirroredHalves)) return 'mirror';
  if (kinds.contains(DominoRuleKind.constantSum)) return 'sum';
  return 'linear';
}

bool _setEquals(Set<DominoRuleKind> a, Set<DominoRuleKind> b) =>
    a.length == b.length && a.containsAll(b);

// --- Cube nets (20 items, spec §2.4-L) -----------------------------------

void _pickCubeNet() {
  const params = CubeNetParams();
  final byDifficulty = _distributionOf(20);
  final items = <Map<String, Object?>>[];
  var n = 1;
  for (final difficulty in [1, 2, 3, 4, 5]) {
    final wanted = byDifficulty[difficulty]!;
    if (wanted == 0) continue;
    var picked = 0;
    var seed = difficulty * 100000;
    while (picked < wanted) {
      final puzzle = buildCubeNetPuzzle(
        seed: seed,
        params: params,
        difficulty: difficulty,
      );
      final missing = puzzle.targetRequired.length;
      items.add({
        'id': 'spatial_cubes.letters.gen.${n.toString().padLeft(4, '0')}',
        'type': 'generated',
        'version': 1,
        'familyId': 'spatial_cubes',
        'difficulty': difficulty,
        'tags': ['spatial.cube_net', 'spatial.cube_net.letters'],
        'generatorId': 'cube_net',
        'seed': seed,
        'meta': {
          'notes':
              'Calibration seed (US-084/US-086): $missing missing face(s) out of 6, '
              '${puzzle.trayTiles.length} tray tiles. Real-test defaults (no params override).',
        },
      });
      n++;
      picked++;
      seed++;
    }
  }
  _writeBank('spatial_cubes', items);
}

// --- Viewpoint (20 items, spec §2.4-K) -----------------------------------

void _pickViewpoint() {
  const params = ViewpointParams();
  final byDifficulty = _distributionOf(20);
  final items = <Map<String, Object?>>[];
  var n = 1;
  for (final difficulty in [1, 2, 3, 4, 5]) {
    final wanted = byDifficulty[difficulty]!;
    if (wanted == 0) continue;
    var picked = 0;
    var seed = difficulty * 100000;
    while (picked < wanted) {
      final scene = buildViewpointScene(
        seed: seed,
        params: params,
        difficulty: difficulty,
      );
      items.add({
        'id': 'spatial_viewpoint.azimuth.gen.${n.toString().padLeft(4, '0')}',
        'type': 'generated',
        'version': 1,
        'familyId': 'spatial_viewpoint',
        'difficulty': difficulty,
        'tags': ['spatial.viewpoint', 'spatial.viewpoint.azimuth'],
        'generatorId': 'viewpoint',
        'seed': seed,
        'meta': {
          'notes':
              'Calibration seed (US-084/US-086): ${scene.objects.length} objects, '
              'correct azimuth ${scene.correctAzimuth}/8. Real-test defaults (no params override).',
        },
      });
      n++;
      picked++;
      seed++;
    }
  }
  _writeBank('spatial_viewpoint', items);
}

// --- Output ---------------------------------------------------------------

void _writeBank(String family, List<Map<String, Object?>> items) {
  final bank = {
    '\$schema':
        '../../../../../../packages/psy_content/schema/bank.schema.json',
    'kind': 'bank',
    'familyId': family,
    'items': items,
  };
  final dir = Directory('assets/content/psy0/$family/items');
  dir.createSync(recursive: true);
  final file = File('${dir.path}/seed.json');
  const encoder = JsonEncoder.withIndent('  ');
  file.writeAsStringSync('${encoder.convert(bank)}\n');
  print('wrote ${items.length} items to ${file.path}');
}
