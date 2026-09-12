import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/l10n/strings.dart';
import 'package:psy_trainer/core/theme/app_theme.dart';
import 'package:psy_trainer/features/engines/attention_rules/domain/attention_rules_engine.dart';
import 'package:psy_trainer/features/engines/attention_rules/domain/stimulus_rule_set.dart';
import 'package:psy_trainer/features/train/presentation/engine/engine_ui.dart';
import 'package:psy_trainer/shared/widgets/widgets.dart';

/// *Formes et couleurs* renderer (spec §2.4-C, US-029).
///
/// Draws the flashed shape with a [CustomPainter] only while
/// `render.phase == ItemPhase.stimulus` (the runtime's cadence, 0.5 s every
/// 3 s); the physical keyboard is the primary input (`Focus` +
/// `KeyboardListener`, matching the run's two keys), two on-screen buttons
/// labelled "non représentatif" are the touch fallback
/// (`inputRequirement: keyboard`). [buildExample] shows this run's actual
/// rule when `SessionHost` hands it a [RunExampleContext] (US-037); with
/// none (no run known yet) it falls back to the family's canonical
/// illustration -- see `StimulusRuleSet`'s doc.
class AttentionRulesRenderer extends ActivityRenderer {
  const AttentionRulesRenderer();

  @override
  String get familyId => AttentionRulesEngine.engineFamilyId;

  @override
  Widget build(BuildContext context, ActivityRenderContext render) {
    final item = render.item as GeneratedItem;
    final params = item.params as StimulusResponseParams;
    final ruleSet = StimulusRuleSet.fromParams(params);
    final trial = StimulusTrial.forItem(item);
    return _StimulusView(render: render, ruleSet: ruleSet, trial: trial);
  }

  @override
  Widget? buildExample(BuildContext context, [RunExampleContext? run]) {
    final runParams = run?.params;
    final ruleSet = runParams is StimulusResponseParams
        ? StimulusRuleSet.fromRunSeed(run!.runSeed, runParams)
        : _defaultExampleRuleSet;
    final theme = AppTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          AppStrings.attentionRulesExampleFilled(
            ruleSet.shapeA,
            ruleSet.keyA,
            ruleSet.shapeB,
            ruleSet.keyB,
          ),
          style: theme.textStyles.body,
        ),
        SizedBox(height: theme.spacing.xs),
        Row(
          children: [
            _ExampleShape(
              shape: ruleSet.shapeA,
              filled: true,
              keyLabel: ruleSet.keyA,
            ),
            SizedBox(width: theme.spacing.md),
            _ExampleShape(
              shape: ruleSet.shapeB,
              filled: true,
              keyLabel: ruleSet.keyB,
            ),
          ],
        ),
        SizedBox(height: theme.spacing.md),
        Text(
          AppStrings.attentionRulesExampleEmpty(
            ruleSet.colourA,
            ruleSet.keyA,
            ruleSet.colourB,
            ruleSet.keyB,
          ),
          style: theme.textStyles.body,
        ),
        SizedBox(height: theme.spacing.xs),
        Row(
          children: [
            _ExampleShape(
              shape: ruleSet.shapeA,
              filled: false,
              colour: ruleSet.colourA,
              keyLabel: ruleSet.keyA,
            ),
            SizedBox(width: theme.spacing.md),
            _ExampleShape(
              shape: ruleSet.shapeA,
              filled: false,
              colour: ruleSet.colourB,
              keyLabel: ruleSet.keyB,
            ),
          ],
        ),
      ],
    );
  }
}

/// Canonical illustration matching `family.json`'s own example (filled
/// square -> N, filled triangle -> X; empty blue -> N, empty orange -> X).
/// `buildExample`'s fallback when it gets no [RunExampleContext] (see
/// `ActivityRenderer`): the generator's own defaults, unshuffled.
const StimulusResponseParams _defaultExampleParams = StimulusResponseParams();
final StimulusRuleSet _defaultExampleRuleSet = StimulusRuleSet.fromParams(
  _defaultExampleParams,
);

class _ExampleShape extends StatelessWidget {
  const _ExampleShape({
    required this.shape,
    required this.filled,
    required this.keyLabel,
    this.colour,
  });

  final StimulusShape shape;
  final bool filled;
  final StimulusColour? colour;
  final String keyLabel;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 40,
          height: 40,
          child: CustomPaint(
            painter: _ShapePainter(
              shape: shape,
              filled: filled,
              color: colour == null
                  ? theme.colors.textPrimary
                  : stimulusColorOf(colour!),
            ),
          ),
        ),
        SizedBox(height: theme.spacing.xs),
        Text(keyLabel.toUpperCase(), style: theme.textStyles.bodyStrong),
      ],
    );
  }
}

class _StimulusView extends StatefulWidget {
  const _StimulusView({
    required this.render,
    required this.ruleSet,
    required this.trial,
  });

  final ActivityRenderContext render;
  final StimulusRuleSet ruleSet;
  final StimulusTrial trial;

  @override
  State<_StimulusView> createState() => _StimulusViewState();
}

class _StimulusViewState extends State<_StimulusView> {
  final FocusNode _focusNode = FocusNode(debugLabel: 'attention_rules');

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (!widget.render.acceptsInput) return KeyEventResult.ignored;
    final label = event.logicalKey.keyLabel.toLowerCase();
    final keys = [widget.ruleSet.keyA, widget.ruleSet.keyB];
    if (!keys.any((k) => k.toLowerCase() == label)) {
      return KeyEventResult.ignored;
    }
    widget.render.onAnswer(Answer.key(label));
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final render = widget.render;
    final trial = widget.trial;
    final showsStimulus = render.phase == ItemPhase.stimulus;
    final feedbackColor = render.feedback == null
        ? null
        : (render.feedback!.correct
              ? theme.colors.success
              : theme.colors.error);

    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _onKeyEvent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Center(
              child: AnimatedContainer(
                duration: theme.durations.fast,
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  border: feedbackColor == null
                      ? null
                      : Border.all(color: feedbackColor, width: 4),
                  borderRadius: theme.radii.mdAll,
                ),
                child: showsStimulus
                    ? CustomPaint(
                        painter: _ShapePainter(
                          shape: trial.shape,
                          filled: trial.fill == StimulusFill.filled,
                          color: trial.fill == StimulusFill.filled
                              ? theme.colors.textPrimary
                              : stimulusColorOf(trial.colour),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ),
          SizedBox(height: theme.spacing.lg),
          Text(
            AppStrings.attentionRulesTouchFallback,
            textAlign: TextAlign.center,
            style: theme.textStyles.caption,
          ),
          SizedBox(height: theme.spacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SecondaryButton(
                key: const Key('attention_rules.touch_key_a'),
                label: widget.ruleSet.keyA.toUpperCase(),
                onPressed: render.acceptsInput
                    ? () => render.onAnswer(Answer.key(widget.ruleSet.keyA))
                    : null,
              ),
              SizedBox(width: theme.spacing.md),
              SecondaryButton(
                key: const Key('attention_rules.touch_key_b'),
                label: widget.ruleSet.keyB.toUpperCase(),
                onPressed: render.acceptsInput
                    ? () => render.onAnswer(Answer.key(widget.ruleSet.keyB))
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Actual colour of each [StimulusColour]: these represent the real-world
/// colour the candidate must discriminate, not a UI theme token, so they are
/// literal (not read from [AppColors]).
Color stimulusColorOf(StimulusColour colour) => switch (colour) {
  StimulusColour.blue => const Color(0xFF2563EB),
  StimulusColour.orange => const Color(0xFFF97316),
  StimulusColour.green => const Color(0xFF16A34A),
  StimulusColour.pink => const Color(0xFFEC4899),
  StimulusColour.red => const Color(0xFFDC2626),
  StimulusColour.yellow => const Color(0xFFEAB308),
};

class _ShapePainter extends CustomPainter {
  const _ShapePainter({
    required this.shape,
    required this.filled,
    required this.color,
  });

  final StimulusShape shape;
  final bool filled;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = filled ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = filled ? 0 : 4;
    final path = _pathFor(shape, size);
    canvas.drawPath(path, paint);
  }

  Path _pathFor(StimulusShape shape, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final cy = h / 2;
    return switch (shape) {
      StimulusShape.square =>
        Path()..addRect(Rect.fromLTWH(w * 0.1, h * 0.1, w * 0.8, h * 0.8)),
      StimulusShape.circle =>
        Path()..addOval(Rect.fromLTWH(w * 0.1, h * 0.1, w * 0.8, h * 0.8)),
      StimulusShape.triangle =>
        Path()
          ..moveTo(cx, h * 0.1)
          ..lineTo(w * 0.9, h * 0.9)
          ..lineTo(w * 0.1, h * 0.9)
          ..close(),
      StimulusShape.diamond =>
        Path()
          ..moveTo(cx, h * 0.1)
          ..lineTo(w * 0.9, cy)
          ..lineTo(cx, h * 0.9)
          ..lineTo(w * 0.1, cy)
          ..close(),
      StimulusShape.star => _starPath(
        cx,
        cy,
        math.min(w, h) / 2 * 0.9,
        math.min(w, h) / 2 * 0.4,
      ),
    };
  }

  Path _starPath(double cx, double cy, double outerR, double innerR) {
    final path = Path();
    for (var i = 0; i < 10; i++) {
      final r = i.isEven ? outerR : innerR;
      final angle = (math.pi / 5) * i - math.pi / 2;
      final x = cx + r * math.cos(angle);
      final y = cy + r * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant _ShapePainter oldDelegate) =>
      oldDelegate.shape != shape ||
      oldDelegate.filled != filled ||
      oldDelegate.color != color;
}
