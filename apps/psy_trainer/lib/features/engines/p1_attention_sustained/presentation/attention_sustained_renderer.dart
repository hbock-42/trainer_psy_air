import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:psy_content/psy_content.dart';
import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../train/domain/engine/engine.dart';
import '../../../train/presentation/engine/activity_renderer.dart';
import '../../attention_rules/presentation/attention_rules_renderer.dart'
    show stimulusColorOf;
import '../domain/attention_sustained_engine.dart';
import '../domain/attention_sustained_stimulus.dart';

/// `p1_attention_sustained` renderer (US-115): a big shape+colour stimulus,
/// always visible (like `memory_nback`'s stimulus patch -- a cadence-less
/// run, `TimingPolicy.none`, never reaches `ItemPhase.stimulus` at all, so
/// the stimulus itself must not depend on that phase); the target /
/// not-target controls are enabled once `render.phase != ItemPhase
/// .stimulus` (the cadence's flash-only window, when configured) and
/// `render.acceptsInput`. The active series' target rule is shown as a
/// persistent header (not only on the briefing screen): the rule is
/// redrawn every series (`AttentionSustainedEngine.seriesOf`), and the
/// runtime has no per-series briefing hook, so the header is the only way
/// the candidate learns a new series' rule as it starts.
///
/// Keyboard is primary (space = target, N = not target -- see
/// `AttentionSustainedEngine`'s doc on why "not target" needs its own key
/// rather than silence); two on-screen buttons are the touch fallback
/// (`family.json`'s `inputRequirement: keyboard`), labelled non-
/// representative like `attention_rules`.
class AttentionSustainedRenderer extends ActivityRenderer {
  const AttentionSustainedRenderer();

  @override
  String get familyId => AttentionSustainedEngine.engineFamilyId;

  static const Key targetKey = Key('attention_sustained.target');
  static const Key notTargetKey = Key('attention_sustained.notTarget');
  static const Key stimulusKey = Key('attention_sustained.stimulus');
  static const Key ruleLabelKey = Key('attention_sustained.ruleLabel');

  @override
  Widget build(BuildContext context, ActivityRenderContext render) =>
      _AttentionSustainedView(key: ValueKey(render.item.id), render: render);

  @override
  Widget? buildExample(BuildContext context, [RunExampleContext? run]) {
    final runParams = run?.params;
    final AttentionSeries series;
    if (runParams is P1AttentionSustainedParams) {
      series = AttentionSeries.build(runParams, run!.runSeed, 0);
    } else {
      series = AttentionSeries.build(const P1AttentionSustainedParams(), 0, 0);
    }
    final theme = AppTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(_ruleLabel(context, series), style: theme.textStyles.bodyStrong),
        SizedBox(height: theme.spacing.xs),
        Text(
          context.l10n.attentionSustainedTouchFallback,
          style: theme.textStyles.caption,
        ),
      ],
    );
  }
}

String _ruleLabel(BuildContext context, AttentionSeries series) =>
    switch (series.ruleKind) {
      AttentionRuleKind.conjunction =>
        context.l10n.attentionSustainedRuleConjunction(
          _colourLabel(context, series.targetColour),
          _shapeLabel(context, series.targetShape),
        ),
      AttentionRuleKind.repeatShape =>
        context.l10n.attentionSustainedRuleRepeatShape,
    };

String _shapeLabel(BuildContext context, StimulusShape shape) =>
    switch (shape) {
      StimulusShape.square => context.l10n.shapeSquare,
      StimulusShape.triangle => context.l10n.shapeTriangle,
      StimulusShape.circle => context.l10n.shapeCircle,
      StimulusShape.diamond => context.l10n.shapeDiamond,
      StimulusShape.star => context.l10n.shapeStar,
    };

String _colourLabel(BuildContext context, StimulusColour colour) =>
    switch (colour) {
      StimulusColour.blue => context.l10n.colourBlue,
      StimulusColour.orange => context.l10n.colourOrange,
      StimulusColour.green => context.l10n.colourGreen,
      StimulusColour.pink => context.l10n.colourPink,
      StimulusColour.red => context.l10n.colourRed,
      StimulusColour.yellow => context.l10n.colourYellow,
    };

class _AttentionSustainedView extends StatefulWidget {
  const _AttentionSustainedView({required this.render, super.key});

  final ActivityRenderContext render;

  @override
  State<_AttentionSustainedView> createState() =>
      _AttentionSustainedViewState();
}

class _AttentionSustainedViewState extends State<_AttentionSustainedView> {
  final FocusNode _focusNode = FocusNode(debugLabel: 'attention_sustained');

  GeneratedItem get _item => widget.render.item as GeneratedItem;
  P1AttentionSustainedParams get _params =>
      _item.params as P1AttentionSustainedParams;
  AttentionStimulus get _stimulus => AttentionSustainedEngine.stimulusOf(_item);
  AttentionSeries get _series => AttentionSustainedEngine.seriesOf(_item);

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _answer(bool target) {
    if (!widget.render.acceptsInput) return;
    widget.render.onAnswer(
      target ? AttentionAnswer.target : AttentionAnswer.notTarget,
    );
  }

  void _onKey(KeyEvent event) {
    if (event is! KeyDownEvent) return;
    switch (event.logicalKey) {
      case LogicalKeyboardKey.space:
        _answer(true);
      case LogicalKeyboardKey.keyN:
        _answer(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final render = widget.render;
    final stimulus = _stimulus;
    final params = _params;
    final itemsPerSeries = params.itemsPerSeries < 1
        ? 1
        : params.itemsPerSeries;
    final seriesNumber = (render.itemIndex ~/ itemsPerSeries) + 1;
    final seriesCount = params.seriesCount < 1 ? 1 : params.seriesCount;
    final showsAnswerControls =
        render.phase != ItemPhase.stimulus && render.acceptsInput;
    final feedbackColor = render.feedback == null
        ? null
        : (render.feedback!.correct
              ? theme.colors.success
              : theme.colors.error);

    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _onKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.l10n.attentionSustainedSeriesLabel(
              seriesNumber,
              seriesCount,
            ),
            textAlign: TextAlign.center,
            style: theme.textStyles.caption,
          ),
          SizedBox(height: theme.spacing.xs),
          Text(
            _ruleLabel(context, _series),
            key: AttentionSustainedRenderer.ruleLabelKey,
            textAlign: TextAlign.center,
            style: theme.textStyles.bodyStrong,
          ),
          SizedBox(height: theme.spacing.lg),
          Expanded(
            child: Center(
              child: Semantics(
                label: context.l10n.attentionSustainedStimulusSemantics(
                  render.itemIndex + 1,
                ),
                child: ExcludeSemantics(
                  child: AnimatedContainer(
                    duration: theme.durations.fast,
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      border: feedbackColor == null
                          ? null
                          : Border.all(color: feedbackColor, width: 4),
                      borderRadius: theme.radii.mdAll,
                    ),
                    child: CustomPaint(
                      key: AttentionSustainedRenderer.stimulusKey,
                      painter: _AttentionShapePainter(
                        shape: stimulus.shape,
                        color: stimulusColorOf(stimulus.colour),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: theme.spacing.lg),
          Text(
            context.l10n.attentionSustainedTouchFallback,
            textAlign: TextAlign.center,
            style: theme.textStyles.caption,
          ),
          SizedBox(height: theme.spacing.sm),
          Row(
            children: [
              Expanded(
                child: AnswerOptionTile(
                  key: AttentionSustainedRenderer.notTargetKey,
                  label: context.l10n.attentionSustainedNotTargetSemantics('N'),
                  state: showsAnswerControls
                      ? AnswerOptionState.idle
                      : AnswerOptionState.disabled,
                  onPressed: showsAnswerControls ? () => _answer(false) : null,
                  child: Text(context.l10n.attentionSustainedNotTarget),
                ),
              ),
              SizedBox(width: theme.spacing.md),
              Expanded(
                child: AnswerOptionTile(
                  key: AttentionSustainedRenderer.targetKey,
                  label: context.l10n.attentionSustainedTargetSemantics(
                    'Espace',
                  ),
                  state: showsAnswerControls
                      ? AnswerOptionState.idle
                      : AnswerOptionState.disabled,
                  onPressed: showsAnswerControls ? () => _answer(true) : null,
                  child: Text(context.l10n.attentionSustainedTarget),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AttentionShapePainter extends CustomPainter {
  const _AttentionShapePainter({required this.shape, required this.color});

  final StimulusShape shape;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    canvas.drawPath(_pathFor(shape, size), paint);
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
      StimulusShape.star => _starPath(cx, cy, w * 0.45, h * 0.18),
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
  bool shouldRepaint(covariant _AttentionShapePainter oldDelegate) =>
      oldDelegate.shape != shape || oldDelegate.color != color;
}
