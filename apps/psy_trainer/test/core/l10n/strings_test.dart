import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/l10n/strings.dart';

void main() {
  group('AppStrings.duration', () {
    test('formats seconds, whole minutes and mixed values', () {
      expect(AppStrings.duration(45), '45 s');
      expect(AppStrings.duration(120), '2 min');
      expect(AppStrings.duration(105), '1 min 45 s');
    });
  });

  group('AppStrings.familyFormat', () {
    test('joins items and duration, with the per-item time when known', () {
      expect(
        AppStrings.familyFormat(itemCount: 42, durationSec: 105),
        '42 items · ~1 min 45 s',
      );
      expect(
        AppStrings.familyFormat(itemCount: 1, durationSec: 300, perItemSec: 40),
        '1 item · ~5 min · ~40 s par item',
      );
    });
  });

  test('masteryPercent rounds a ratio to a whole percentage', () {
    expect(AppStrings.masteryPercent(0.724), '72 %');
    expect(AppStrings.masteryPercent(1), '100 %');
  });
}
