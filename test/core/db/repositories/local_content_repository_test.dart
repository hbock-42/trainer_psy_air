import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/db/app_database.dart';
import 'package:psy_trainer/core/db/repositories/local_content_repository.dart';

import '../../repositories/content_repository_contract.dart';
import '../example_content.dart';

void main() {
  late AppDatabase db;

  group('LocalContentRepository', () {
    runContentRepositoryContract(
      create: (content) async {
        db = openTestDatabase();
        await content.seed(db, seededAt: seededAt);
        return LocalContentRepository(db);
      },
      dispose: () => db.close(),
    );
  });

  group('LocalContentRepository (extras)', () {
    test('is empty before seeding', () async {
      db = openTestDatabase();
      addTearDown(db.close);
      final repo = LocalContentRepository(db);
      expect(await repo.contentInfo(), isNull);
      expect(await repo.families(), isEmpty);
      expect(await repo.items(familyId: 'english'), isEmpty);
      expect(await repo.decks(), isEmpty);
    });
  });
}
