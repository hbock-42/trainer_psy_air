import 'package:flutter/widgets.dart';

import '../../../../core/l10n/l10n_extensions.dart';
import '../domain/matrix_figure.dart';
import '../domain/matrix_rules.dart';

/// Names every active rule of [rules] in FR/EN, e.g. "rangée : nombre +1 ;
/// colonne : rotation +90°" -- the practice explanation US-107 asks for.
/// [rules] is `MatrixBoard.activeRules` (the "constant" filler on inactive
/// attributes is never named). Attribute and axis words come from ARB
/// (`context.l10n`); only the join order is plain Dart, same convention as
/// `L10nComposed` in `core/l10n/l10n_extensions.dart` (kept local here since
/// `core/` may not import a feature's domain types).
String matrixExplanationFor(
  BuildContext context,
  List<MatrixRuleDescriptor> rules,
) {
  final l10n = context.l10n;
  final clauses = rules.map((rule) {
    final axis = rule.alongRows ? l10n.matrixAxisRow : l10n.matrixAxisColumn;
    final attribute = _attributeLabel(l10n, rule.attribute);
    final suffix = switch (rule.kind) {
      MatrixRuleKind.constant => '',
      MatrixRuleKind.progression =>
        rule.attribute == MatrixAttribute.rotation
            ? l10n.matrixRuleStepDegrees(rule.step * 45)
            : l10n.matrixRuleStepPlain(rule.step),
      MatrixRuleKind.distributionOfThree => l10n.matrixRuleDistributionSuffix,
      MatrixRuleKind.alternation => l10n.matrixRuleAlternationSuffix,
      MatrixRuleKind.xorOverlay => l10n.matrixRuleXorSuffix,
    };
    return '$axis : $attribute $suffix'.trim();
  });
  return clauses.join(' ; ');
}

String _attributeLabel(AppLocalizations l10n, MatrixAttribute attribute) =>
    switch (attribute) {
      MatrixAttribute.outerShape => l10n.matrixAttributeOuterShape,
      MatrixAttribute.innerShape => l10n.matrixAttributeInnerShape,
      MatrixAttribute.count => l10n.matrixAttributeCount,
      MatrixAttribute.rotation => l10n.matrixAttributeRotation,
      MatrixAttribute.fill => l10n.matrixAttributeFill,
      MatrixAttribute.size => l10n.matrixAttributeSize,
      MatrixAttribute.position => l10n.matrixAttributePosition,
    };
