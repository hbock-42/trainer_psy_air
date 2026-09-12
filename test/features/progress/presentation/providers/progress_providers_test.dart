import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/progress/domain/progress_domain.dart';
import 'package:psy_trainer/features/progress/presentation/providers/exam_history_provider.dart';
import 'package:psy_trainer/features/progress/presentation/providers/family_time_series_provider.dart';
import 'package:psy_trainer/features/progress/presentation/providers/progress_analytics_provider.dart';
import 'package:psy_trainer/features/progress/presentation/providers/progress_snapshot_provider.dart';
import 'package:psy_trainer/features/progress/presentation/providers/progress_version_provider.dart';
import 'package:psy_trainer/features/progress/presentation/providers/stats_service_provider.dart';

final DateTime now = DateTime.utc(2026, 9, 30, 12);

void main() {
  late InMemoryProgressRepository progress;
  late ProviderContainer container;

  setUp(() {
    progress = InMemoryProgressRepository(clock: () => now);
    container = ProviderContainer.test(
      overrides: [
        progressRepositoryProvider.overrideWithValue(progress),
        contentRepositoryProvider.overrideWithValue(
          InMemoryContentRepository(),
        ),
        statsServiceProvider.overrideWithValue(StatsService(now: () => now)),
      ],
    );
  });

  Future<void> practice(String family, {required int correct}) async {
    final session = await progress.startSession(
      mode: SessionMode.practice,
      familyId: family,
    );
    await progress.recordAttempts([
      for (var i = 0; i < 10; i++)
        NewAttempt(
          sessionId: session.id,
          familyId: family,
          origin: AttemptOrigin(generatorId: 'g', seed: i),
          isCorrect: i < correct,
          responseMs: 500,
          position: i,
        ),
    ]);
    await progress.finishSession(session.id, status: SessionStatus.completed);
  }

  test('the default wiring builds the analytics over the repositories', () {
    final analytics = container.read(progressAnalyticsProvider);
    expect(analytics.stats.config, const StatsConfig());
    expect(container.read(statsConfigProvider), const StatsConfig());
  });

  test('the snapshot is cached until the version is bumped', () async {
    final empty = await container.read(progressSnapshotProvider.future);
    expect(empty.isEmpty, isTrue);

    await practice('logic', correct: 9);
    // Still the cached, empty snapshot.
    expect(container.read(progressSnapshotProvider).value, same(empty));
    expect(
      (await container.read(progressSnapshotProvider.future)).isEmpty,
      isTrue,
    );

    container.read(progressVersionProvider.notifier).bump();
    expect(container.read(progressVersionProvider), 1);
    final fresh = await container.read(progressSnapshotProvider.future);
    expect(fresh.isEmpty, isFalse);
    expect(fresh.family('logic')!.level, 5);
  });

  test('exam history and time series follow the same version', () async {
    expect(await container.read(examHistoryProvider.future), isEmpty);
    const query = (
      familyId: 'logic',
      from: null,
      to: null,
      mode: SessionMode.practice,
    );
    final sub = container.listen(familyTimeSeriesProvider(query), (_, _) {});
    addTearDown(sub.close);
    expect(
      (await container.read(familyTimeSeriesProvider(query).future)).isEmpty,
      isTrue,
    );

    await practice('logic', correct: 4);
    final exam = await progress.startSession(mode: SessionMode.exam);
    await progress.recordAttempt(
      NewAttempt(
        sessionId: exam.id,
        familyId: 'logic',
        origin: const AttemptOrigin(generatorId: 'g', seed: 1),
        isCorrect: true,
        responseMs: 500,
        position: 0,
        sectionIndex: 0,
      ),
    );
    await progress.finishSession(exam.id, status: SessionStatus.completed);
    container.read(progressVersionProvider.notifier).bump();

    final history = await container.read(examHistoryProvider.future);
    expect(history.single.sessionId, exam.id);
    expect(history.single.score, 1);
    final series = await container.read(familyTimeSeriesProvider(query).future);
    expect(series.points.single.accuracy, 0.4);
  });
}
