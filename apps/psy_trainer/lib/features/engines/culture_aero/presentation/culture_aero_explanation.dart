import 'package:psy_content/psy_content.dart';

import '../../../../core/l10n/strings.dart';

/// [McqRenderer.explanationFooter] for `culture_aero`: perishable facts
/// (fleet counts, CEOs, new routes) carry `McqItem.validAsOf` (US-028
/// acceptance criteria) and show it under the explanation as "Donnée
/// valable au `<date>`"; items without a date (most of the bank) show
/// nothing extra.
String? cultureAeroExplanationFooter(McqItem item) {
  final validAsOf = item.validAsOf;
  if (validAsOf == null) return null;
  return AppStrings.cultureValidAsOf(validAsOf);
}
