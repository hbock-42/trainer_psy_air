import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/repositories/in_memory/in_memory_content_repository.dart';
import 'package:psy_trainer/core/repositories/model/session.dart';
import 'package:psy_trainer/features/train/domain/engine/item_source.dart';
import 'package:psy_trainer/features/train/presentation/launcher/practice_config.dart';
import 'package:psy_trainer/features/train/presentation/launcher/practice_session_builder.dart';

import 'launcher_fixtures.dart';

void main() {
  group('buildActivitySessionConfig', () {
    test('a generator family gets an ItemSource.adaptive with the family '
        'defaults', () async {
      final family = generatorFamily();
      const config = PracticeConfig(
        itemCount: 20,
        difficulty: null,
        timed: true,
      );

      final result = await buildActivitySessionConfig(
        family: family,
        config: config,
        contentRepository: launcherContentRepository(),
      );

      expect(result.familyId, family.id);
      expect(result.mode, SessionMode.practice);
      final source = result.source as AdaptiveSource;
      expect(source.generatorId, GeneratorId.nback);
      expect(source.count, 20);
      expect(source.params, GeneratorParams.defaultsFor(GeneratorId.nback));
      // Auto difficulty with no `autoLevel` passed -> the default level 1
      // ("level 1 when no data", US-053).
      expect(source.initialDifficulty, 1);
    });

    test('a fixed difficulty overrides the resolved auto level as the '
        'starting difficulty', () async {
      final family = generatorFamily();
      const config = PracticeConfig(itemCount: 10, difficulty: 4, timed: true);

      final result = await buildActivitySessionConfig(
        family: family,
        config: config,
        contentRepository: launcherContentRepository(),
        autoLevel: 2,
      );

      final source = result.source as AdaptiveSource;
      expect(source.initialDifficulty, 4);
    });

    test('"Auto" resolves to the caller-supplied family level', () async {
      final family = generatorFamily();
      const config = PracticeConfig(
        itemCount: 10,
        difficulty: null,
        timed: true,
      );

      final result = await buildActivitySessionConfig(
        family: family,
        config: config,
        contentRepository: launcherContentRepository(),
        autoLevel: 3,
        autoFastThresholdMs: 900,
      );

      final source = result.source as AdaptiveSource;
      expect(source.initialDifficulty, 3);
      expect(source.fastThresholdMs, 900);
    });

    test('two runs draw different run seeds (fresh every time)', () async {
      final family = generatorFamily();
      const config = PracticeConfig(
        itemCount: 5,
        difficulty: null,
        timed: true,
      );
      final repo = launcherContentRepository();

      final a = await buildActivitySessionConfig(
        family: family,
        config: config,
        contentRepository: repo,
      );
      final b = await buildActivitySessionConfig(
        family: family,
        config: config,
        contentRepository: repo,
      );

      expect(
        (a.source as AdaptiveSource).runSeed,
        isNot((b.source as AdaptiveSource).runSeed),
      );
    });

    test('a bank family samples items from the content repository', () async {
      final family = bankFamily();
      const config = PracticeConfig(
        itemCount: 8,
        difficulty: null,
        timed: false,
      );

      final result = await buildActivitySessionConfig(
        family: family,
        config: config,
        contentRepository: launcherContentRepository(),
      );

      final source = result.source as BankSource;
      expect(source.items.length, 8);
      expect(source.items.every((i) => i.familyId == family.id), isTrue);
    });

    test('bank sampling is balanced across tags when there are more '
        'candidates than requested', () async {
      final family = bankFamily();
      const config = PracticeConfig(
        itemCount: 8,
        difficulty: null,
        timed: false,
      );

      final result = await buildActivitySessionConfig(
        family: family,
        config: config,
        contentRepository: launcherContentRepository(),
      );

      final source = result.source as BankSource;
      final byTag = <String, int>{};
      for (final item in source.items) {
        final tag = item.tags.first;
        byTag[tag] = (byTag[tag] ?? 0) + 1;
      }
      // 20 items over 4 tags, 8 requested: every tag contributes exactly 2.
      expect(byTag.values.every((count) => count == 2), isTrue);
    });

    test('a bank family filters candidates to the chosen difficulty', () async {
      final family = bankFamily(id: 'family_with_levels');
      final repo = InMemoryContentRepository(
        families: [family],
        items: [
          for (var d = 1; d <= 5; d++)
            bankItem(id: 'd$d', familyId: family.id, difficulty: d),
        ],
      );
      const config = PracticeConfig(itemCount: 10, difficulty: 3, timed: false);

      final result = await buildActivitySessionConfig(
        family: family,
        config: config,
        contentRepository: repo,
      );

      final source = result.source as BankSource;
      expect(source.items, hasLength(1));
      expect(source.items.single.difficulty, 3);
    });

    test('timing follows the practice defaults for [timed]', () async {
      final family = generatorFamily();
      final repo = launcherContentRepository();

      final timed = await buildActivitySessionConfig(
        family: family,
        config: const PracticeConfig(
          itemCount: 5,
          difficulty: null,
          timed: true,
        ),
        contentRepository: repo,
      );
      final untimed = await buildActivitySessionConfig(
        family: family,
        config: const PracticeConfig(
          itemCount: 5,
          difficulty: null,
          timed: false,
        ),
        contentRepository: repo,
      );

      expect(timed.timing.isUntimed, isFalse);
      expect(untimed.timing.isUntimed, isTrue);
    });

    test('a bank family with passageId items uses the passage-aware sampler '
        'and reports the passages it drew', () async {
      final family = englishFamily();
      const passage = Passage(
        id: 'p1',
        body: LocalizedText(fr: 'Un texte.'),
      );
      final repo = InMemoryContentRepository(
        families: [family],
        items: [
          bankItem(
            id: 'r1',
            familyId: family.id,
            tag: 'reading',
            passageId: 'p1',
          ),
          bankItem(
            id: 'r2',
            familyId: family.id,
            tag: 'reading',
            passageId: 'p1',
          ),
          bankItem(id: 'g1', familyId: family.id, tag: 'grammar'),
        ],
        passages: [passage],
      );
      List<Passage>? loaded;

      final result = await buildActivitySessionConfig(
        family: family,
        config: const PracticeConfig(
          itemCount: 10,
          difficulty: null,
          timed: false,
        ),
        contentRepository: repo,
        onPassagesLoaded: (passages) => loaded = passages,
      );

      final source = result.source as BankSource;
      expect(source.items.map((i) => i.id), containsAll(['r1', 'r2', 'g1']));
      expect(loaded, [passage]);
    });

    test('p1_reading_fr (english\'s PSY1/French counterpart) also uses the '
        'passage-aware sampler', () async {
      final family = p1ReadingFrFamily();
      const passage = Passage(
        id: 'p1',
        body: LocalizedText(fr: 'Un texte.'),
      );
      final repo = InMemoryContentRepository(
        families: [family],
        items: [
          bankItem(
            id: 'r1',
            familyId: family.id,
            tag: 'p1_reading_fr.comprehension',
            passageId: 'p1',
          ),
          bankItem(
            id: 'r2',
            familyId: family.id,
            tag: 'p1_reading_fr.comprehension',
            passageId: 'p1',
          ),
        ],
        passages: [passage],
      );
      List<Passage>? loaded;

      final result = await buildActivitySessionConfig(
        family: family,
        config: const PracticeConfig(
          itemCount: 1,
          difficulty: null,
          timed: false,
        ),
        contentRepository: repo,
        onPassagesLoaded: (passages) => loaded = passages,
      );

      // Requesting fewer items than the passage's questions must not
      // split the set: the passage-aware sampler keeps both together.
      final source = result.source as BankSource;
      expect(source.items.map((i) => i.id), containsAll(['r1', 'r2']));
      expect(loaded, [passage]);
    });

    test(
      'a bank family with no passageId items never calls onPassagesLoaded',
      () async {
        var called = false;

        await buildActivitySessionConfig(
          family: bankFamily(),
          config: const PracticeConfig(
            itemCount: 5,
            difficulty: null,
            timed: false,
          ),
          contentRepository: launcherContentRepository(),
          onPassagesLoaded: (_) => called = true,
        );

        expect(called, isFalse);
      },
    );

    test('title carries the family name for the session placeholder', () async {
      final family = bankFamily();
      final result = await buildActivitySessionConfig(
        family: family,
        config: const PracticeConfig(
          itemCount: 5,
          difficulty: null,
          timed: false,
        ),
        contentRepository: launcherContentRepository(),
      );

      expect(result.title, family.name);
    });
  });
}
