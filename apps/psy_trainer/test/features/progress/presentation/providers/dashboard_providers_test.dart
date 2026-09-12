import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/progress/presentation/providers/dashboard_labels_provider.dart';
import 'package:psy_trainer/features/progress/presentation/providers/exam_date_provider.dart';
import 'package:psy_trainer/features/progress/presentation/providers/progress_version_provider.dart';
import 'package:psy_trainer/features/progress/presentation/providers/recent_activity_provider.dart';

import '../progress_fixtures.dart';

void main() {
  late ProgressFixture fixture;
  late ProviderContainer container;

  setUp(() {
    fixture = ProgressFixture();
    container = ProviderContainer.test(overrides: fixture.overrides);
  });

  group('recentActivityProvider', () {
    test('is empty without finished sessions', () async {
      await fixture.progress.startSession(
        mode: SessionMode.practice,
        familyId: 'english',
      );
      expect(await container.read(recentActivityProvider.future), isEmpty);
    });

    test('lists finished sessions newest first with their score', () async {
      await fixture.practice('english', daysAgo: 5, correct: 8);
      final exam = await fixture.exam(daysAgo: 3, correct: 6);
      await fixture.practice(
        'arithmetic_grid',
        daysAgo: 1,
        correct: 0,
        attempts: 0,
        status: SessionStatus.abandoned,
      );

      final activities = await container.read(recentActivityProvider.future);
      expect(activities.map((a) => a.familyId ?? a.blueprintId), [
        'arithmetic_grid',
        'psy0_full',
        'english',
      ]);
      expect(activities[0].score, isNull);
      expect(activities[0].percent, isNull);
      expect(activities[0].attempts, 0);
      expect(activities[0].status, SessionStatus.abandoned);
      expect(activities[1].isExam, isTrue);
      expect(activities[1].sessionId, exam.id);
      expect(activities[1].percent, 60);
      expect(activities[1].attempts, 20);
      expect(activities[2].percent, 80);
      expect(activities[2].attempts, 10);
    });

    test('prefers the stored session score over the accuracy', () async {
      final session = await fixture.practice('english', daysAgo: 1, correct: 8);
      await fixture.progress.finishSession(
        session.id,
        status: SessionStatus.completed,
        score: 0.42,
      );
      final activities = await container.read(recentActivityProvider.future);
      expect(activities.single.percent, 42);
    });

    test('keeps the last $recentActivityLimit sessions only', () async {
      for (var i = 0; i < recentActivityLimit + 3; i++) {
        await fixture.practice('english', daysAgo: i, correct: 5);
      }
      final activities = await container.read(recentActivityProvider.future);
      expect(activities, hasLength(recentActivityLimit));
      expect(activities.first.startedAt, daysAgo(0));
      expect(activities.last.startedAt, daysAgo(recentActivityLimit - 1));
    });

    test('is cached until the version is bumped', () async {
      final empty = await container.read(recentActivityProvider.future);
      await fixture.practice('english', daysAgo: 1, correct: 5);
      expect(await container.read(recentActivityProvider.future), same(empty));
      container.read(progressVersionProvider.notifier).bump();
      expect(await container.read(recentActivityProvider.future), hasLength(1));
    });
  });

  group('examDateProvider', () {
    test('is null without a profile or without a date', () async {
      expect(await container.read(examDateProvider.future), isNull);
      await fixture.progress.saveProfile(const UserProfile(locale: 'fr'));
      container.read(progressVersionProvider.notifier).bump();
      expect(await container.read(examDateProvider.future), isNull);
    });

    test('reads the profile exam date', () async {
      final date = now.add(const Duration(days: 30));
      await fixture.progress.saveProfile(
        UserProfile(locale: 'fr', examDate: date),
      );
      expect(await container.read(examDateProvider.future), date);
    });

    test('daysUntil counts calendar days in local time', () {
      final today = DateTime(2026, 9, 30, 23, 30);
      expect(daysUntil(DateTime(2026, 9, 30, 8), today), 0);
      expect(daysUntil(DateTime(2026, 10, 1, 0, 5), today), 1);
      expect(daysUntil(DateTime(2026, 10, 12), today), 12);
      expect(daysUntil(DateTime(2026, 9, 28), today), -2);
    });
  });

  group('dashboardLabelsProvider', () {
    test('resolves family and blueprint names, falls back to ids', () async {
      final labels = await container.read(dashboardLabelsProvider.future);
      expect(labels.familyName('arithmetic_grid'), 'Calcul');
      expect(
        labels.familyName('arithmetic_grid', short: false),
        'Grilles de calcul',
      );
      expect(labels.familyName('unknown'), 'unknown');
      expect(labels.blueprintName('psy0_full'), 'PSY0 complet');
      expect(labels.blueprintName('nope'), 'nope');
      expect(DashboardLabels.empty.familyName('english'), 'english');
    });
  });
}
