import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/features/train/presentation/launcher/practice_session_builder.dart';

import 'launcher_fixtures.dart';

void main() {
  group('itemSamplers', () {
    test('english is registered to passageAwareSampler, others default to '
        'balanceByTag', () {
      expect(itemSamplers['english'], passageAwareSampler);
      expect(itemSamplers['culture_aero'], isNull);
    });
  });

  group('passageAwareSampler', () {
    // Two 4-question passages (p1, p2) and four standalone grammar items,
    // deliberately shuffled so id order != authoring order: the sampler must
    // restore it within each passage regardless.
    List<Item> candidates() => [
      bankItem(id: 'r03', familyId: 'english', tag: 'r', passageId: 'p1'),
      bankItem(id: 'g2', familyId: 'english', tag: 'g'),
      bankItem(id: 'r08', familyId: 'english', tag: 'r', passageId: 'p2'),
      bankItem(id: 'r01', familyId: 'english', tag: 'r', passageId: 'p1'),
      bankItem(id: 'g4', familyId: 'english', tag: 'g'),
      bankItem(id: 'r06', familyId: 'english', tag: 'r', passageId: 'p2'),
      bankItem(id: 'r02', familyId: 'english', tag: 'r', passageId: 'p1'),
      bankItem(id: 'g1', familyId: 'english', tag: 'g'),
      bankItem(id: 'r07', familyId: 'english', tag: 'r', passageId: 'p2'),
      bankItem(id: 'r04', familyId: 'english', tag: 'r', passageId: 'p1'),
      bankItem(id: 'g3', familyId: 'english', tag: 'g'),
      bankItem(id: 'r05', familyId: 'english', tag: 'r', passageId: 'p2'),
    ];

    /// Every distinct `passageId` among [items] is either fully absent or
    /// fully present, its questions adjacent and sorted by id.
    void expectPassagesIntact(List<Item> items) {
      var i = 0;
      final seen = <String>{};
      while (i < items.length) {
        final passageId = (items[i] as McqItem).passageId;
        if (passageId == null) {
          i++;
          continue;
        }
        expect(
          seen.add(passageId),
          isTrue,
          reason: 'passage $passageId must not be split across the list',
        );
        final expectedCount = candidates()
            .whereType<McqItem>()
            .where((it) => it.passageId == passageId)
            .length;
        final group = items.skip(i).take(expectedCount).cast<McqItem>();
        expect(
          group.every((it) => it.passageId == passageId),
          isTrue,
          reason: 'passage $passageId questions must be adjacent',
        );
        final ids = group.map((it) => it.id).toList();
        expect(
          ids,
          [...ids]..sort(),
          reason: 'passage $passageId questions must be in id order',
        );
        i += expectedCount;
      }
    }

    test('all candidates fit: still grouped, complete and ordered', () {
      final result = passageAwareSampler(candidates(), 100);
      expect(result, hasLength(candidates().length));
      expectPassagesIntact(result);
    });

    test(
      'trimming keeps every remaining passage whole, complete and ordered',
      () {
        final result = passageAwareSampler(candidates(), 6);
        expectPassagesIntact(result);
        // No item is duplicated and every one came from the candidates.
        expect(result.toSet().length, result.length);
        expect(
          candidates().map((i) => i.id),
          containsAll(result.map((i) => i.id)),
        );
        // A passage is never picked apart: for every included id, its whole
        // group is present.
        for (final item in result.whereType<McqItem>()) {
          final passageId = item.passageId;
          if (passageId == null) continue;
          final wholeGroup = candidates()
              .whereType<McqItem>()
              .where((i) => i.passageId == passageId)
              .map((i) => i.id)
              .toSet();
          expect(result.map((i) => i.id).toSet(), containsAll(wholeGroup));
        }
      },
    );

    test('standalone items (no passageId) balance across tags like '
        'balanceByTag', () {
      final onlyStandalone = [
        for (var i = 0; i < 8; i++)
          bankItem(id: 'g$i', familyId: 'english', tag: 'tag${i % 4}'),
      ];
      final result = passageAwareSampler(onlyStandalone, 4);
      final byTag = <String, int>{};
      for (final item in result) {
        byTag[item.tags.first] = (byTag[item.tags.first] ?? 0) + 1;
      }
      expect(byTag.values.every((count) => count == 1), isTrue);
    });
  });
}
