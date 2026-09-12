import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/l10n/l10n_extensions.dart';

void main() {
  final fr = lookupAppLocalizations(const Locale('fr'));
  final en = lookupAppLocalizations(const Locale('en'));

  group('AppLocalizations.duration (l10n_extensions)', () {
    test('formats seconds, whole minutes and mixed values', () {
      expect(fr.duration(45), '45 s');
      expect(fr.duration(120), '2 min');
      expect(fr.duration(105), '1 min 45 s');
    });
  });

  group('AppLocalizations.familyFormat', () {
    test('joins items and duration, with the per-item time when known', () {
      expect(
        fr.familyFormat(itemCount: 42, durationSec: 105),
        '42 items · ~1 min 45 s',
      );
      expect(
        fr.familyFormat(itemCount: 1, durationSec: 300, perItemSec: 40),
        '1 item · ~5 min · ~40 s par item',
      );
      expect(
        en.familyFormat(itemCount: 1, durationSec: 300, perItemSec: 40),
        '1 item · ~5 min · ~40 s per item',
      );
    });
  });

  test('masteryPercentText rounds a ratio to a whole percentage', () {
    expect(fr.masteryPercentText(0.724), '72 %');
    expect(fr.masteryPercentText(1), '100 %');
  });
}
