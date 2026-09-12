import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/train/presentation/session/resume_session_provider.dart';

void main() {
  final now = DateTime.utc(2026, 9, 12, 12);
  late InMemoryProgressRepository repo;
  late ProviderContainer container;

  setUp(() {
    repo = InMemoryProgressRepository(clock: () => now);
    container = ProviderContainer.test(
      overrides: [
        progressRepositoryProvider.overrideWithValue(repo),
        resumeSessionNowProvider.overrideWithValue(() => now),
      ],
    );
  });

  test('offers the youngest in-progress practice session', () async {
    await repo.startSession(
      mode: SessionMode.practice,
      familyId: 'older',
      startedAt: now.subtract(const Duration(hours: 2)),
    );
    final younger = await repo.startSession(
      mode: SessionMode.practice,
      familyId: 'newer',
      startedAt: now.subtract(const Duration(minutes: 5)),
    );

    final candidate = await container.read(resumeSessionProvider.future);

    expect(candidate, isNotNull);
    expect(candidate!.session.id, younger.id);
  });

  test('marks a session older than 24h abandoned and offers nothing', () async {
    final stale = await repo.startSession(
      mode: SessionMode.practice,
      familyId: 'stale',
      startedAt: now.subtract(const Duration(hours: 30)),
    );

    final candidate = await container.read(resumeSessionProvider.future);

    expect(candidate, isNull);
    expect(repo.sessionsById[stale.id]!.status, SessionStatus.abandoned);
  });

  test('ignores exam sessions', () async {
    await repo.startSession(
      mode: SessionMode.exam,
      startedAt: now.subtract(const Duration(minutes: 1)),
    );

    final candidate = await container.read(resumeSessionProvider.future);

    expect(candidate, isNull);
  });
}
