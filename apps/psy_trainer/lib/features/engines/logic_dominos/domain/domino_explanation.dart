import '../../../../core/l10n/strings.dart';
import 'domino_board.dart';

/// The FR sentence(s) naming the rule(s) of [ruleKinds], for the practice
/// feedback (US-024 acceptance criteria: "explanation names the rule(s)").
String explanationFor(List<DominoRuleKind> ruleKinds) => ruleKinds
    .map(_sentenceFor)
    .join(' ');

String _sentenceFor(DominoRuleKind kind) => switch (kind) {
  DominoRuleKind.linearEachHalf => AppStrings.dominoRuleLinearEachHalf,
  DominoRuleKind.alternatingTopBottom =>
    AppStrings.dominoRuleAlternatingTopBottom,
  DominoRuleKind.mirroredHalves => AppStrings.dominoRuleMirroredHalves,
  DominoRuleKind.constantSum => AppStrings.dominoRuleConstantSum,
  DominoRuleKind.interleavedSeries => AppStrings.dominoRuleInterleavedSeries,
};
