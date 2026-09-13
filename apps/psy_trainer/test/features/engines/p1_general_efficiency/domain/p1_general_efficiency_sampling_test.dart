import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/repositories/in_memory/in_memory_content_repository.dart';
import 'package:psy_trainer/features/train/domain/engine/item_source.dart';
import 'package:psy_trainer/features/train/presentation/launcher/practice_config.dart';
import 'package:psy_trainer/features/train/presentation/launcher/practice_session_builder.dart';

/// US-116: the EFG bank tags every item `["efg", "efg.<category>"]` — the
/// generic `"efg"` tag always comes first, so the default [balanceByTag]
/// (which keys off `tags.first`) would lump the whole bank under one tag.
/// `efgTagBalancedSampler`, registered for `p1_general_efficiency` in
/// `itemSamplers`, balances on the first `efg.*` tag instead. This proves
/// that holds end to end through `buildActivitySessionConfig`, the same way
/// `culture_aero_sampling_test.dart` proves it for `culture_aero`'s topics.
void main() {
  const categories = ['efg.numeric', 'efg.verbal', 'efg.spatial', 'efg.logic'];

  TestFamily family() => const TestFamily(
    id: 'p1_general_efficiency',
    moduleId: ModuleId.psy1,
    version: 1,
    order: 6,
    name: LocalizedText(fr: 'Efficience générale (EFG)'),
    description: LocalizedText(fr: 'QCM EFG.'),
    engineType: EngineType.p1GeneralEfficiency,
    answerFormat: AnswerFormat.mcq,
    defaultDurationSec: 1800,
    defaultItemCount: 35,
    confidence: Confidence.assumed,
  );

  McqItem item(String id, String category) => McqItem(
    id: id,
    version: 1,
    familyId: 'p1_general_efficiency',
    difficulty: 2,
    tags: ['efg', category],
    stem: LocalizedText(fr: 'Question $id'),
    options: const [
      McqOption(text: LocalizedText(fr: 'A')),
      McqOption(text: LocalizedText(fr: 'B')),
    ],
    correctIndex: 0,
    explanation: const LocalizedText(fr: 'Parce que.'),
  );

  test('a practice draw spreads (almost) evenly across every efg.<category> '
      'tag, not just the shared "efg" tag', () async {
    // 20 items over 4 categories (5 each), draw 8.
    final items = [
      for (final category in categories)
        for (var i = 0; i < 5; i++) item('$category.$i', category),
    ]..shuffle();
    final repo = InMemoryContentRepository(families: [family()], items: items);

    final result = await buildActivitySessionConfig(
      family: family(),
      config: const PracticeConfig(itemCount: 8, difficulty: null, timed: true),
      contentRepository: repo,
    );

    final source = result.source as BankSource;
    expect(source.items, hasLength(8));
    final byCategory = <String, int>{};
    for (final picked in source.items) {
      final category = picked.tags.firstWhere((t) => t.startsWith('efg.'));
      byCategory[category] = (byCategory[category] ?? 0) + 1;
    }
    // Every category contributes exactly 2: never lumped under "efg".
    expect(byCategory.keys.toSet(), categories.toSet());
    expect(byCategory.values.every((count) => count == 2), isTrue);
  });

  test(
    'when fewer candidates than requested, every candidate is kept',
    () async {
      final items = [
        item('n1', 'efg.numeric'),
        item('n2', 'efg.numeric'),
        item('v1', 'efg.verbal'),
      ];
      final repo = InMemoryContentRepository(
        families: [family()],
        items: items,
      );

      final result = await buildActivitySessionConfig(
        family: family(),
        config: const PracticeConfig(
          itemCount: 35,
          difficulty: null,
          timed: true,
        ),
        contentRepository: repo,
      );

      final source = result.source as BankSource;
      expect(source.items, hasLength(3));
    },
  );
}
