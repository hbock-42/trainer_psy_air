import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/repositories/in_memory/in_memory_content_repository.dart';
import 'package:psy_trainer/core/repositories/model/attempt.dart';
import 'package:psy_trainer/core/repositories/model/session.dart';
import 'package:psy_trainer/features/train/domain/engine/engine.dart';
import 'package:psy_trainer/features/train/domain/mistakes/mistake_pool.dart';
import 'package:psy_trainer/features/train/domain/mistakes/mistake_session_builder.dart';

import '../../../../helpers/fake_engine.dart';

void main() {
  group('itemSourceOfMistakes', () {
    test('bank entries fetch the items from the content repository', () async {
      final content = InMemoryContentRepository(
        items: [
          fakeMcq(id: 'q1'),
          fakeMcq(id: 'q2'),
          fakeMcq(id: 'q3'),
        ],
      );
      const pool = MistakePool([
        MistakeEntry.bank('q2'),
        MistakeEntry.bank('q3'),
      ]);

      final source = await itemSourceOfMistakes(pool, content);

      expect(source, isA<BankSource>());
      expect((source as BankSource).items.map((i) => i.id), ['q2', 'q3']);
    });

    test('generated entries replay from their origins', () async {
      const origin = AttemptOrigin(generatorId: 'dominos', seed: 5);
      const pool = MistakePool([MistakeEntry.generated(origin)]);

      final source = await itemSourceOfMistakes(
        pool,
        InMemoryContentRepository(),
      );

      expect(source, isA<ReplaySource>());
      expect((source as ReplaySource).origins, [origin]);
    });
  });

  group('buildMistakeSessionConfig', () {
    test('builds a practice config over the pool with the given family/'
        'timing/title', () async {
      final content = InMemoryContentRepository(
        items: [
          fakeMcq(id: 'q1'),
          fakeMcq(id: 'q2'),
        ],
      );
      const pool = MistakePool([MistakeEntry.bank('q1')]);

      final config = await buildMistakeSessionConfig(
        familyId: 'fake_family',
        pool: pool,
        contentRepository: content,
        title: const LocalizedText(fr: 'Activité'),
      );

      expect(config.familyId, 'fake_family');
      expect(config.mode, SessionMode.practice);
      expect(config.title, const LocalizedText(fr: 'Activité'));
      expect((config.source as BankSource).items.map((i) => i.id), ['q1']);
    });
  });
}
