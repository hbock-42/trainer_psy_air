import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';

import '../progress_repository_contract.dart';

void main() {
  group('InMemoryProgressRepository', () {
    runProgressRepositoryContract(
      create: () async => InMemoryProgressRepository(clock: () => fixedNow),
      dispose: () async {},
    );

    test('exposes its state for assertions in widget tests', () async {
      final repo = InMemoryProgressRepository(clock: () => fixedNow);
      final s = await repo.startSession(mode: SessionMode.practice);
      await repo.recordAttempt(
        NewAttempt(
          sessionId: s.id,
          familyId: 'english',
          itemId: 'e1',
          isCorrect: true,
          responseMs: 10,
          position: 0,
        ),
      );
      await repo.markLessonRead('l1');
      expect(repo.sessionsById.keys, ['session-1']);
      expect(repo.attempts.single.id, 'attempt-1');
      expect(repo.itemStatsById.keys, ['e1']);
      expect(repo.lessonsReadById.keys, ['l1']);
      expect(repo.storedProfile, isNull);
    });

    test('accepts a custom id generator', () async {
      var n = 0;
      final repo = InMemoryProgressRepository(newId: () => 'id-${++n}');
      final s = await repo.startSession(mode: SessionMode.exam);
      expect(s.id, 'id-1');
    });
  });
}
