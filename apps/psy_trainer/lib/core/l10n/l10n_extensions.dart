import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' show DateFormat, NumberFormat;
import 'package:psy_content/psy_content.dart';

import 'gen/app_localizations.dart';

export 'gen/app_localizations.dart';

/// `context.l10n` is the one way widgets read UI copy (US-091): every
/// screen/widget under `lib/features/**` and `lib/shared/**` reads its
/// strings from here instead of the old `AppStrings` constants.
extension L10nX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

/// Composed strings that need real Dart logic (pluralisation across several
/// sub-parts, joining optional parts, locale-aware date/number formatting)
/// rather than a single ICU message. Each one is built from plain ARB leaf
/// entries in `app_fr.arb`/`app_en.arb` so every word is still translated;
/// only the *shape* of the sentence (which parts to join, in what order) is
/// Dart code, same as the old `AppStrings` helpers it replaces.
extension L10nComposed on AppLocalizations {
  /// `45 s`, `2 min`, `1 min 45 s`.
  String duration(int seconds) {
    final minutes = seconds ~/ 60;
    final rest = seconds % 60;
    if (minutes == 0) return durationSecondsOnly(rest);
    if (rest == 0) return durationMinutesOnly(minutes);
    return durationMinutesSeconds(minutes, rest);
  }

  /// `42 items · ~2 min`, plus `· ~40 s par item` when a per-item time exists.
  String familyFormat({
    required int itemCount,
    required int durationSec,
    int? perItemSec,
  }) {
    final parts = [
      familyItemsCount(itemCount),
      '~${duration(durationSec)}',
      if (perItemSec != null) familyPerItemSuffix('~${duration(perItemSec)}'),
    ];
    return parts.join(' · ');
  }

  /// `1,2 s` (fr) / `1.2 s` (en): a response time in seconds with one
  /// decimal, using the locale's decimal separator. The unit itself ("s")
  /// is the same abbreviation in both supported locales.
  String seconds(double value) {
    final formatted = NumberFormat('0.0', localeName).format(value);
    return '$formatted s';
  }

  /// `samedi 4 septembre 2027` (fr) / `Saturday, September 4, 2027` (en).
  String formatLongDate(DateTime date) {
    final pattern = localeName == 'fr' ? 'EEEE d MMMM y' : 'EEEE, MMMM d, y';
    return DateFormat(pattern, localeName).format(date);
  }

  /// culture_aero (US-028): perishable-fact footer for `McqItem.validAsOf`.
  /// "Donnée valable au 1 septembre 2026." / "Valid as of September 1, 2026."
  String cultureValidAsOf(DateTime date) {
    final pattern = localeName == 'fr' ? 'd MMMM y' : 'MMMM d, y';
    final formatted = DateFormat(pattern, localeName).format(date);
    return localeName == 'fr'
        ? 'Donnée valable au $formatted.'
        : 'Valid as of $formatted.';
  }

  /// Flashcards session summary: `12 faciles · 3 difficiles · 1 à revoir`.
  String flashcardsSummaryBody({
    required int again,
    required int hard,
    required int good,
  }) {
    return [
      flashcardsSummaryGood(good),
      flashcardsSummaryHard(hard),
      flashcardsSummaryAgain(again),
    ].join(' · ');
  }

  /// `1:30`, `45 s`: the exam-runner break countdown. Digits and a colon
  /// only, so it needs no translation.
  String examRunnerBreakCountdown(int totalSeconds) {
    final m = totalSeconds ~/ 60;
    final s = totalSeconds % 60;
    return m > 0 ? '$m:${s.toString().padLeft(2, '0')}' : '$s s';
  }

  String _shapeName(StimulusShape shape) => switch (shape) {
    StimulusShape.square => shapeSquare,
    StimulusShape.triangle => shapeTriangle,
    StimulusShape.circle => shapeCircle,
    StimulusShape.diamond => shapeDiamond,
    StimulusShape.star => shapeStar,
  };

  String _colourName(StimulusColour colour) => switch (colour) {
    StimulusColour.blue => colourBlue,
    StimulusColour.orange => colourOrange,
    StimulusColour.green => colourGreen,
    StimulusColour.pink => colourPink,
    StimulusColour.red => colourRed,
    StimulusColour.yellow => colourYellow,
  };

  /// attention_rules (US-029) practice-screen example caption, filled-shape
  /// rule: `Forme pleine : carré → A, cercle → S`.
  String attentionRulesExampleShapes(
    StimulusShape shapeA,
    String keyA,
    StimulusShape shapeB,
    String keyB,
  ) => attentionRulesExampleFilled(
    _shapeName(shapeA),
    keyA.toUpperCase(),
    _shapeName(shapeB),
    keyB.toUpperCase(),
  );

  /// Same, empty-shape (colour) rule.
  String attentionRulesExampleColours(
    StimulusColour colourA,
    String keyA,
    StimulusColour colourB,
    String keyB,
  ) => attentionRulesExampleEmpty(
    _colourName(colourA),
    keyA.toUpperCase(),
    _colourName(colourB),
    keyB.toUpperCase(),
  );
}
