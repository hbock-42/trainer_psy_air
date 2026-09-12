import 'package:psy_content/psy_content.dart';

/// [McqRenderer.explanationFooter] for `culture_aero`: perishable facts
/// (fleet counts, CEOs, new routes) carry `McqItem.validAsOf` (US-028
/// acceptance criteria) and show it under the explanation as "Donnée
/// valable au `<date>`"; items without a date (most of the bank) show
/// nothing extra.
///
/// FR-only (US-091 deviation, see the PR description): `McqRenderer`'s
/// `explanationFooter` callback is `String? Function(McqItem)` — a plain
/// function with no `BuildContext`, registered once in
/// `engine_registry_provider.dart` (a file shared by every engine, not
/// touched here) — so there is no locale to read. Follows the same pattern
/// as the two `AppStrings` domain exceptions
/// (`logic_dominos`/`spatial_viewpoint`).
const List<String> _months = [
  '',
  'janvier',
  'février',
  'mars',
  'avril',
  'mai',
  'juin',
  'juillet',
  'août',
  'septembre',
  'octobre',
  'novembre',
  'décembre',
];

String? cultureAeroExplanationFooter(McqItem item) {
  final validAsOf = item.validAsOf;
  if (validAsOf == null) return null;
  return 'Donnée valable au ${validAsOf.day} ${_months[validAsOf.month]} '
      '${validAsOf.year}.';
}
