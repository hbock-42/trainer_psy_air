import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/notifications/reminder_content.dart';

const _lines = ReminderLines(
  title: 'PSY Trainer',
  flashcardsDue: _flashcardsDue,
  weakestFamily: _weakestFamily,
  examToday: 'Exam today',
  examCountdown: _examCountdown,
  fallback: 'Practice today?',
);

String _flashcardsDue(int count) => '$count cards due';
String _weakestFamily(String family) => 'Weak: $family';
String _examCountdown(int days) => 'Exam in $days days';

void main() {
  const builder = ReminderContentBuilder();

  test('fallback when nothing applies', () {
    final content = builder.build(
      inputs: const ReminderContentInputs(),
      lines: _lines,
    );
    expect(content.title, 'PSY Trainer');
    expect(content.body, 'Practice today?');
  });

  test('flashcards line only when due > 0', () {
    final none = builder.build(
      inputs: const ReminderContentInputs(),
      lines: _lines,
    );
    expect(none.body, 'Practice today?');

    final some = builder.build(
      inputs: const ReminderContentInputs(dueFlashcards: 5),
      lines: _lines,
    );
    expect(some.body, '5 cards due');
  });

  test('weakest family line only when a name is given', () {
    final content = builder.build(
      inputs: const ReminderContentInputs(weakestFamilyName: 'N-back'),
      lines: _lines,
    );
    expect(content.body, 'Weak: N-back');
  });

  test('exam line: "today" for 0 days left, countdown otherwise', () {
    final today = builder.build(
      inputs: const ReminderContentInputs(examDaysLeft: 0),
      lines: _lines,
    );
    expect(today.body, 'Exam today');

    final soon = builder.build(
      inputs: const ReminderContentInputs(examDaysLeft: 12),
      lines: _lines,
    );
    expect(soon.body, 'Exam in 12 days');
  });

  test('a past exam date (negative days left) is omitted', () {
    final content = builder.build(
      inputs: const ReminderContentInputs(examDaysLeft: -1),
      lines: _lines,
    );
    expect(content.body, 'Practice today?');
  });

  test('every applicable line joins in order: flashcards, family, exam', () {
    final content = builder.build(
      inputs: const ReminderContentInputs(
        dueFlashcards: 3,
        weakestFamilyName: 'Cubes',
        examDaysLeft: 7,
      ),
      lines: _lines,
    );
    expect(content.body, '3 cards due · Weak: Cubes · Exam in 7 days');
  });
}
