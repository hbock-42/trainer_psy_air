import 'package:psy_content/psy_content.dart';

/// FR-only strings for the handful of pure-Dart `domain/` places that build
/// user-facing feedback text without a `BuildContext` (US-091 deviation,
/// see the PR description): the domino and 3-D-viewpoint engines' practice
/// feedback ("explication") is generated deep in `domain/` — before US-091,
/// every UI string lived here (`AppStrings`); ARB-based i18n
/// (`AppLocalizations`, read through `context.l10n` — see
/// `lib/core/l10n/l10n_extensions.dart`) replaced it everywhere a widget
/// could reach a `BuildContext`. These two engines' explanation strings are
/// composed by pure functions consumed by the renderer as plain data (no
/// context available at the point they're built), so threading a locale
/// through them was left out of this story; they stay French-only until a
/// follow-up card plumbs a locale parameter through
/// `explanationFor()`/`viewpointExplanation()`.
///
/// `test/architecture/no_app_strings_in_features_test.dart` allows
/// `AppStrings.` only in the two files that use it
/// (`logic_dominos/domain/domino_explanation.dart`,
/// `spatial_viewpoint/domain/viewpoint_explanation.dart`).
abstract final class AppStrings {
  // logic_dominos (US-024): explanationFor() rule sentences.
  static const String dominoRuleLinearEachHalf =
      'Une moitié avance de façon régulière (+k modulo 7).';
  static const String dominoRuleAlternatingTopBottom =
      'Les moitiés haute et basse avancent chacune leur tour (+k modulo 7).';
  static const String dominoRuleMirroredHalves =
      'La moitié basse est le miroir de la moitié haute (leur somme fait 6).';
  static const String dominoRuleConstantSum =
      'La somme des deux moitiés reste la même sur toute la série.';
  static const String dominoRuleInterleavedSeries =
      'Deux séries s\'entrelacent : une pour les positions paires, une pour '
      'les impaires.';

  // spatial_viewpoint (US-034): explanationFor() sentence.
  static String viewpointExplanation(int azimuth, String left, String right) =>
      'Vu depuis la position $azimuth : l\'objet $left est à gauche de '
      'l\'objet $right.';

  /// Article-free noun, meant to follow "l'objet " (`viewpointExplanation`)
  /// so the sentence never has to agree a gender.
  static String viewpointSolidName(SolidKind kind) => switch (kind) {
    SolidKind.cube => 'cube',
    SolidKind.cylinder => 'cylindre',
    SolidKind.cone => 'cône',
    SolidKind.sphere => 'sphère',
    SolidKind.pyramid => 'pyramide',
  };

  static String viewpointColorName(int colorIndex) => switch (colorIndex % 6) {
    0 => 'orange',
    1 => 'bleu ciel',
    2 => 'vert',
    3 => 'jaune',
    4 => 'bleu',
    _ => 'vermillon',
  };
}
