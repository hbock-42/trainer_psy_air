import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/features/engines/attention_parity/domain/parity_layout.dart';

void main() {
  const params = ParitySequenceParams();

  ParityLayout build({int seed = 1, int difficulty = 3}) =>
      ParityLayout.build(params: params, seed: seed, difficulty: difficulty);

  group('determinism', () {
    test(
      'the same (params, seed, difficulty) always yields the same layout',
      () {
        final a = build(seed: 42, difficulty: 4);
        final b = build(seed: 42, difficulty: 4);
        expect(a.path, b.path);
        expect(a.numbers, b.numbers);
      },
    );

    test('a different seed yields a different path', () {
      final a = build();
      final b = build(seed: 2);
      expect(a.path, isNot(b.path));
    });
  });

  group('the path', () {
    test('each category stays ascending, and once alternation breaks (one '
        'category exhausted) every later step shares that same parity', () {
      for (var seed = 0; seed < 200; seed++) {
        final layout = build(seed: seed, difficulty: seed % 5 + 1);
        final path = layout.path;
        final evens = path.where((v) => v.isEven).toList();
        final odds = path.where((v) => v.isOdd).toList();
        expect(evens, orderedEquals([...evens]..sort()), reason: 'seed $seed');
        expect(odds, orderedEquals([...odds]..sort()), reason: 'seed $seed');

        var brokenAt = -1;
        for (var i = 1; i < path.length; i++) {
          if (path[i].isEven == path[i - 1].isEven) {
            brokenAt = i;
            break;
          }
        }
        if (brokenAt != -1) {
          final tailParity = path[brokenAt].isEven;
          for (var i = brokenAt; i < path.length; i++) {
            expect(
              path[i].isEven,
              tailParity,
              reason: 'seed $seed: tail must stay same-parity once broken',
            );
          }
        }
      }
    });

    test('every path value is unique and matches the bubble set', () {
      final layout = build(seed: 7);
      expect(layout.path.toSet(), hasLength(layout.path.length));
      expect(layout.numbers.map((n) => n.value).toSet(), layout.path.toSet());
    });

    test('start is the lowest number and end is the last of the path', () {
      for (var seed = 0; seed < 50; seed++) {
        final layout = build(seed: seed);
        expect(layout.startValue, layout.path.reduce(min));
        expect(layout.endValue, layout.path.last);
      }
    });

    test('honours the 12..20 count range across difficulties', () {
      for (var difficulty = 1; difficulty <= 5; difficulty++) {
        final layout = build(difficulty: difficulty);
        expect(layout.path.length, inInclusiveRange(12, 20));
      }
      final easy = build(difficulty: 1);
      final hard = build(difficulty: 5);
      expect(hard.path.length, greaterThanOrEqualTo(easy.path.length));
    });
  });

  group('layout (no overlap)', () {
    test('bubbles stay inside the unit square with a margin', () {
      for (var seed = 0; seed < 100; seed++) {
        final layout = build(seed: seed);
        for (final n in layout.numbers) {
          expect(n.x, inInclusiveRange(0.0, 1.0));
          expect(n.y, inInclusiveRange(0.0, 1.0));
        }
      }
    });

    test('no two bubbles are closer than the minimum separation', () {
      for (var seed = 0; seed < 150; seed++) {
        final layout = build(seed: seed, difficulty: seed % 5 + 1);
        final numbers = layout.numbers;
        for (var i = 0; i < numbers.length; i++) {
          for (var j = i + 1; j < numbers.length; j++) {
            final dx = numbers[i].x - numbers[j].x;
            final dy = numbers[i].y - numbers[j].y;
            final distance = sqrt(dx * dx + dy * dy);
            expect(
              distance,
              greaterThanOrEqualTo(ParityLayout.minSeparation - 1e-9),
              reason:
                  'seed $seed, bubbles ${numbers[i].value}/${numbers[j].value}',
            );
          }
        }
      }
    });
  });
}
