import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/settings/domain/backup_service.dart';

final DateTime fixedNow = DateTime.utc(2026, 9, 12, 10);

BackupService service(ProgressRepository repo) => BackupService(
  repo,
  appName: 'psy-trainer',
  appVersion: '1.0.0-test',
  clock: () => fixedNow,
);

Future<InMemoryProgressRepository> _seeded() async {
  final repo = InMemoryProgressRepository(clock: () => fixedNow);
  final session = await repo.startSession(
    mode: SessionMode.practice,
    familyId: 'english',
  );
  await repo.recordAttempt(
    NewAttempt(
      sessionId: session.id,
      familyId: 'english',
      itemId: 'item-1',
      isCorrect: true,
      responseMs: 900,
      position: 0,
    ),
  );
  await repo.saveFlashcardReview(
    FlashcardReview(
      flashcardId: 'card-1',
      deckId: 'deck-1',
      box: 1,
      reviews: 1,
      lapses: 0,
      nextReviewAt: fixedNow,
    ),
  );
  await repo.markLessonRead('lesson-1');
  await repo.saveProfile(const UserProfile(locale: 'fr'));
  return repo;
}

void main() {
  group('BackupService.exportJson', () {
    test('produces the versioned envelope with every table', () async {
      final repo = await _seeded();
      final json = await service(repo).exportJson();
      final doc = jsonDecode(json) as Map<String, Object?>;

      expect(doc['format'], 'psy-trainer-backup');
      expect(doc['version'], 1);
      expect(doc['exportedAt'], fixedNow.toIso8601String());
      expect((doc['app'] as Map)['name'], 'psy-trainer');

      final data = doc['data'] as Map<String, Object?>;
      expect(data['sessions'] as List, hasLength(1));
      expect(data['attempts'] as List, hasLength(1));
      expect(data['itemStats'] as List, hasLength(1));
      expect(data['flashcardReviews'] as List, hasLength(1));
      expect(data['lessonProgress'] as List, hasLength(1));
      expect(data['profile'], isNotNull);
    });
  });

  group('BackupService.importJson round-trip', () {
    test(
      'exporting from one repository imports cleanly into another',
      () async {
        final source = await _seeded();
        final json = await service(source).exportJson();

        final target = InMemoryProgressRepository(clock: () => fixedNow);
        final summary = await service(target).importJson(json);

        expect(summary.inserted, 6); // session, attempt, item stat,
        // flashcard review, lesson read, profile.
        expect(summary.updated, 0);
        expect(await target.sessions(), hasLength(1));
        expect(await target.allAttempts(), hasLength(1));
        expect((await target.itemStat('item-1'))?.seen, 1);
        expect(await target.allFlashcardReviews(), hasLength(1));
        expect(await target.lessonsRead(), hasLength(1));
        expect((await target.profile())?.locale, 'fr');
      },
    );

    test(
      'importing the same backup twice only updates on real changes',
      () async {
        final repo = await _seeded();
        final json = await service(repo).exportJson();

        final again = await service(repo).importJson(json);
        expect(again.inserted, 0);
        expect(again.updated, 0);
        expect(again.skipped, 6);
      },
    );
  });

  group('BackupService validation', () {
    test('rejects a document that is not JSON', () async {
      final repo = await _seeded();
      expect(
        () => service(repo).importJson('not json at all'),
        throwsA(
          isA<BackupFormatException>().having(
            (e) => e.reason,
            'reason',
            BackupErrorReason.invalidJson,
          ),
        ),
      );
    });

    test('rejects a JSON document that is not an object', () async {
      final repo = await _seeded();
      expect(
        () => service(repo).importJson('[1, 2, 3]'),
        throwsA(
          isA<BackupFormatException>().having(
            (e) => e.reason,
            'reason',
            BackupErrorReason.notAnObject,
          ),
        ),
      );
    });

    test('rejects the wrong format tag', () async {
      final repo = await _seeded();
      final doc = jsonEncode({
        'format': 'something-else',
        'version': 1,
        'data': <String, Object?>{},
      });
      expect(
        () => service(repo).importJson(doc),
        throwsA(
          isA<BackupFormatException>().having(
            (e) => e.reason,
            'reason',
            BackupErrorReason.wrongFormat,
          ),
        ),
      );
    });

    test('rejects a version newer than this app understands', () async {
      final repo = await _seeded();
      final doc = jsonEncode({
        'format': BackupService.format,
        'version': 999,
        'data': <String, Object?>{},
      });
      expect(
        () => service(repo).importJson(doc),
        throwsA(
          isA<BackupFormatException>().having(
            (e) => e.reason,
            'reason',
            BackupErrorReason.unsupportedVersion,
          ),
        ),
      );
    });

    test('rejects a document without a data section', () async {
      final repo = await _seeded();
      final doc = jsonEncode({'format': BackupService.format, 'version': 1});
      expect(
        () => service(repo).importJson(doc),
        throwsA(
          isA<BackupFormatException>().having(
            (e) => e.reason,
            'reason',
            BackupErrorReason.missingData,
          ),
        ),
      );
    });

    test('a valid envelope with empty tables imports as a no-op', () async {
      final repo = await _seeded();
      final doc = jsonEncode({
        'format': BackupService.format,
        'version': 1,
        'data': <String, Object?>{},
      });
      final summary = await service(repo).importJson(doc);
      expect(summary.total, 0);
    });
  });
}
