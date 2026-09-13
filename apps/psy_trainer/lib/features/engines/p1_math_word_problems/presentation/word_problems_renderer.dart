import 'package:flutter/widgets.dart';

import 'package:psy_content/psy_content.dart';
import '../../../train/presentation/engine/engine_ui.dart';
import '../../../train/presentation/renderers/mcq_renderer.dart';
import '../../../train/presentation/renderers/numeric_renderer.dart';

/// [ActivityRenderer] for `p1_math_word_problems` (US-104): the item is
/// either a `NumericItem` or an `McqItem` depending on
/// [P1MathWordProblemsParams.answerMode]
/// (`MathWordProblemsEngine.generate`), so this renderer composes the two
/// existing generic renderers by item type -- a single `RendererRegistry`
/// entry per family id -- the same pattern `MentalArithmeticRenderer` uses.
///
/// The stem is a multi-sentence word problem (often longer than a single
/// arithmetic expression): [NumericRenderer]/[McqRenderer] already wrap the
/// stem in a `SingleChildScrollView` above the input, so it wraps and
/// scrolls on a narrow phone (see the presentation test, 360x780) while the
/// keypad/options stay pinned below, out of the scroll area.
class MathWordProblemsRenderer extends ActivityRenderer {
  const MathWordProblemsRenderer();

  static const _numericRenderer = NumericRenderer(
    familyId: 'p1_math_word_problems',
  );
  static const _mcqRenderer = McqRenderer(familyId: 'p1_math_word_problems');

  @override
  String get familyId => 'p1_math_word_problems';

  @override
  Widget build(BuildContext context, ActivityRenderContext render) {
    return switch (render.item) {
      NumericItem() => _numericRenderer.build(context, render),
      McqItem() => _mcqRenderer.build(context, render),
      _ => const SizedBox.shrink(),
    };
  }

  @override
  Widget? buildExample(BuildContext context, [RunExampleContext? run]) {
    final mode =
        (run?.params as P1MathWordProblemsParams?)?.answerMode ??
        P1AnswerMode.mcq;
    return mode == P1AnswerMode.mcq
        ? _mcqRenderer.buildExample(context, run)
        : _numericRenderer.buildExample(context, run);
  }
}
