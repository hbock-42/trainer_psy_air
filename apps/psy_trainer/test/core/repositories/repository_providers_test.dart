import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/db/app_database.dart';
import 'package:psy_trainer/core/db/app_database_provider.dart';
import 'package:psy_trainer/core/db/open_database.dart';
import 'package:psy_trainer/core/db/repositories/local_content_repository.dart';
import 'package:psy_trainer/core/db/repositories/local_progress_repository.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';

void main() {
  test('the repository providers bind the Drift implementations', () async {
    final db = AppDatabase(openInMemoryExecutor());
    final container = ProviderContainer.test(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
    );
    addTearDown(db.close);

    expect(
      container.read(contentRepositoryProvider),
      isA<LocalContentRepository>(),
    );
    final progress = container.read(progressRepositoryProvider);
    expect(progress, isA<LocalProgressRepository>());

    // Same database underneath: a write through the provider is visible in
    // the database handed to the container.
    final session = await progress.startSession(mode: SessionMode.practice);
    expect(await db.sessionsDao.byId(session.id), isNotNull);
  });

  test('widget tests can swap in the in-memory fakes', () {
    final content = InMemoryContentRepository();
    final progress = InMemoryProgressRepository();
    final container = ProviderContainer.test(
      overrides: [
        contentRepositoryProvider.overrideWithValue(content),
        progressRepositoryProvider.overrideWithValue(progress),
      ],
    );
    expect(container.read(contentRepositoryProvider), same(content));
    expect(container.read(progressRepositoryProvider), same(progress));
  });
}
