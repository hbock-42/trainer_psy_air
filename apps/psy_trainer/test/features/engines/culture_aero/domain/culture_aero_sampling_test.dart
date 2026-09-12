import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/repositories/in_memory/in_memory_content_repository.dart';
import 'package:psy_trainer/features/train/domain/engine/item_source.dart';
import 'package:psy_trainer/features/train/presentation/launcher/practice_config.dart';
import 'package:psy_trainer/features/train/presentation/launcher/practice_session_builder.dart';

/// US-028 acceptance criterion: "balanced sampling across topics". The
/// round-robin-by-first-tag balancing already lives in
/// `buildActivitySessionConfig` / `_balancedByTag`
/// (`features/train/presentation/launcher/practice_session_builder.dart`,
/// generic to every bank family — see its own test suite in
/// `test/features/train/presentation/launcher/practice_session_builder_test
/// .dart`); this proves it holds for `culture_aero`'s real 15
/// `culture.<topic>` tags (spec §2.4-N/§3, docs/content/psy0-spec.md lists
/// 14 topic areas, the authored bank in US-083 landed one extra: see the
/// engine README / PR notes for the count mismatch).
void main() {
  const topics = [
    'culture.accidents',
    'culture.af_fleet_figures',
    'culture.airports_manufacturers',
    'culture.flight_mechanics',
    'culture.history',
    'culture.human_factors',
    'culture.institutions',
    'culture.instruments',
    'culture.meteorology',
    'culture.navigation',
    'culture.network_geography',
    'culture.ops_documents',
    'culture.pilot_job_cadet_path',
    'culture.rules_of_the_air',
    'culture.subsidiaries_alliances',
  ];

  TestFamily family() => const TestFamily(
    id: 'culture_aero',
    moduleId: ModuleId.psy0,
    version: 1,
    order: 12,
    name: LocalizedText(fr: 'Culture générale aéronautique'),
    description: LocalizedText(fr: 'QCM culture.'),
    engineType: EngineType.cultureAero,
    answerFormat: AnswerFormat.mcq,
    defaultDurationSec: 900,
    defaultItemCount: 48,
    defaultPerItemTimeSec: 18,
    confidence: Confidence.reported,
  );

  McqItem item(String id, String tag) => McqItem(
    id: id,
    version: 1,
    familyId: 'culture_aero',
    difficulty: 3,
    tags: [tag],
    stem: LocalizedText(fr: 'Question $id'),
    options: const [
      McqOption(text: LocalizedText(fr: 'A')),
      McqOption(text: LocalizedText(fr: 'B')),
      McqOption(text: LocalizedText(fr: 'C')),
      McqOption(text: LocalizedText(fr: 'D')),
    ],
    correctIndex: 0,
    explanation: const LocalizedText(fr: 'Parce que.'),
  );

  test('a practice draw from a 15-topic bank spreads (almost) evenly '
      'across every culture.<topic> tag', () async {
    // 30 items over 15 topics (2 each), draw 15.
    final items = [
      for (final topic in topics) ...[
        item('$topic.a', topic),
        item('$topic.b', topic),
      ],
      // shuffle so the balancer cannot rely on input order alone.
    ]..shuffle();
    final repo = InMemoryContentRepository(families: [family()], items: items);

    final result = await buildActivitySessionConfig(
      family: family(),
      config: const PracticeConfig(
        itemCount: 15,
        difficulty: null,
        timed: true,
      ),
      contentRepository: repo,
    );

    final source = result.source as BankSource;
    expect(source.items, hasLength(15));
    final byTopic = <String, int>{};
    for (final picked in source.items) {
      byTopic[picked.tags.first] = (byTopic[picked.tags.first] ?? 0) + 1;
    }
    // One item per topic: no topic is skipped, none is drawn twice.
    expect(byTopic.keys.toSet(), topics.toSet());
    expect(byTopic.values.every((count) => count == 1), isTrue);
  });

  test('when fewer candidates than requested, every candidate is kept '
      '(no topic starves another below its stock)', () async {
    final items = [
      item('single-topic-1', topics.first),
      item('single-topic-2', topics.first),
      item('other-topic-1', topics[1]),
    ];
    final repo = InMemoryContentRepository(families: [family()], items: items);

    final result = await buildActivitySessionConfig(
      family: family(),
      config: const PracticeConfig(
        itemCount: 48,
        difficulty: null,
        timed: true,
      ),
      contentRepository: repo,
    );

    final source = result.source as BankSource;
    expect(source.items, hasLength(3));
  });
}
