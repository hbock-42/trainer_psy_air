import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/features/onboarding/domain/exam_date_rules.dart';

void main() {
  group('calendarDay', () {
    test('keeps the local date and drops the time', () {
      final instant = DateTime(2026, 9, 12, 23, 30);
      expect(calendarDay(instant), DateTime.utc(2026, 9, 12));
    });

    test('is idempotent on a UTC day', () {
      final day = DateTime.utc(2027, 2, 28);
      expect(calendarDay(day), day);
    });
  });

  group('firstSaturdayOfSeptember', () {
    test('matches the known PSY0 sessions', () {
      // 2026: 1 September is a Tuesday -> Saturday 5 (spec: 4-5 Sept 2026).
      expect(firstSaturdayOfSeptember(2026), DateTime.utc(2026, 9, 5));
      expect(firstSaturdayOfSeptember(2027), DateTime.utc(2027, 9, 4));
      expect(firstSaturdayOfSeptember(2028), DateTime.utc(2028, 9, 2));
      // 2029: 1 September is a Saturday.
      expect(firstSaturdayOfSeptember(2029), DateTime.utc(2029, 9));
    });

    test('always returns a Saturday in September', () {
      for (var year = 2020; year <= 2040; year++) {
        final date = firstSaturdayOfSeptember(year);
        expect(date.weekday, DateTime.saturday, reason: '$year');
        expect(date.month, DateTime.september, reason: '$year');
        expect(date.day, lessThanOrEqualTo(7), reason: '$year');
      }
    });
  });

  group('nextPsy0Date', () {
    test('suggests this year while the session is ahead', () {
      expect(nextPsy0Date(DateTime(2026, 3)), DateTime.utc(2026, 9, 5));
    });

    test('suggests today on the session day itself', () {
      expect(nextPsy0Date(DateTime(2026, 9, 5, 18)), DateTime.utc(2026, 9, 5));
    });

    test('suggests next year once the session has passed', () {
      expect(nextPsy0Date(DateTime(2026, 9, 12)), DateTime.utc(2027, 9, 4));
    });
  });

  group('validateExamDate', () {
    final now = DateTime(2026, 9, 12, 10);

    test('refuses a past day', () {
      expect(
        validateExamDate(DateTime.utc(2026, 9, 11), now: now),
        ExamDateError.inThePast,
      );
      expect(
        validateExamDate(DateTime.utc(2025, 9, 6), now: now),
        ExamDateError.inThePast,
      );
    });

    test('accepts today and the future', () {
      expect(validateExamDate(DateTime.utc(2026, 9, 12), now: now), isNull);
      expect(validateExamDate(DateTime.utc(2027, 9, 4), now: now), isNull);
    });
  });

  group('daysInMonth / clampedDay', () {
    test('knows month lengths and leap years', () {
      expect(daysInMonth(2026, 2), 28);
      expect(daysInMonth(2028, 2), 29);
      expect(daysInMonth(2026, 4), 30);
      expect(daysInMonth(2026, 12), 31);
    });

    test('clamps the day into the month', () {
      expect(clampedDay(2026, 2, 31), DateTime.utc(2026, 2, 28));
      expect(clampedDay(2026, 4, 0), DateTime.utc(2026, 4));
      expect(clampedDay(2026, 9, 5), DateTime.utc(2026, 9, 5));
    });
  });
}
