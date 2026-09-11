import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/db/app_database.dart';
import 'package:psy_trainer/core/db/repositories/local_progress_repository.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';

import '../../repositories/progress_repository_contract.dart';
import '../example_content.dart';

void main() {
  late AppDatabase db;

  group('LocalProgressRepository', () {
    runProgressRepositoryContract(
      create: () async {
        db = openTestDatabase();
        return LocalProgressRepository(db, clock: () => fixedNow);
      },
      dispose: () => db.close(),
    );
  });

  group('LocalProgressRepository (extras)', () {
    test('generates uuid v4 ids by default', () async {
      db = openTestDatabase();
      addTearDown(db.close);
      final repo = LocalProgressRepository(db);
      final s = await repo.startSession(mode: SessionMode.practice);
      expect(
        s.id,
        matches(
          RegExp(
            r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
          ),
        ),
      );
      expect(s.startedAt.isUtc, isTrue);
    });

    test('recordAttempts is atomic: a bad row rolls back the batch', () async {
      db = openTestDatabase();
      addTearDown(db.close);
      final repo = LocalProgressRepository(db, clock: () => fixedNow);
      final s = await repo.startSession(mode: SessionMode.practice);
      await expectLater(
        repo.recordAttempts([
          NewAttempt(
            sessionId: s.id,
            familyId: 'english',
            itemId: 'e1',
            isCorrect: true,
            responseMs: 1,
            position: 0,
          ),
          const NewAttempt(
            sessionId: 'missing-session',
            familyId: 'english',
            itemId: 'e2',
            isCorrect: true,
            responseMs: 1,
            position: 1,
          ),
        ]),
        throwsA(anything),
      );
      expect(await repo.attemptsForSession(s.id), isEmpty);
      expect(await repo.itemStat('e1'), isNull);
    });
  });
}
