import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/l10n/strings.dart';
import 'package:psy_trainer/core/theme/app_theme.dart';
import 'package:psy_trainer/features/engines/multitask_psychomotor/domain/multitask_engine.dart';
import 'package:psy_trainer/features/engines/multitask_psychomotor/domain/multitask_scoring.dart';
import 'package:psy_trainer/features/engines/multitask_psychomotor/domain/multitask_simulation.dart';
import 'package:psy_trainer/features/engines/multitask_psychomotor/domain/multitask_track.dart';
import 'package:psy_trainer/features/train/presentation/engine/engine_ui.dart';
import 'package:psy_trainer/shared/widgets/widgets.dart';

/// *Multitâche* renderer (spec §2.4-M, §4.4, US-036).
///
/// The whole 5-minute run is one item (`family.json`: `answerFormat:
/// simulation`, `defaultItemCount: 1`): this widget owns a real-time
/// `Ticker` that drives a [MultitaskSimulation] built once from the item's
/// `(seed, params, difficulty)`, paints it every frame, and records every
/// arrow hold / SPACE / F press against the run's own clock (ms since the
/// simulation started). When the ticker reaches `params.durationSec` it
/// scores the run with [MultitaskScoring.evaluate] and submits the result
/// as one `Answer.raw` -- the runtime's own per-item/section timer
/// (`TimingPolicy`, from the blueprint's `sectionTimeSec: 300`) is only a
/// safety net in case this never fires.
///
/// The physical keyboard is the real test's only input
/// (`inputRequirement: keyboard`). On a device with no keyboard detected
/// (heuristic: a touch platform that has not yet sent a hardware key
/// event -- ARCHITECTURE.md "Platforms": "detect ... by whether a hardware
/// key event has been received ... not by screen size alone"), practice
/// shows a labelled "non représentatif" on-screen D-pad + two buttons
/// alongside the simulation; exam mode instead shows a notice and lets the
/// candidate skip the section (`Answer.skip`), since a touch rehearsal of
/// this activity would not be representative at all.
class MultitaskRenderer extends ActivityRenderer {
  const MultitaskRenderer();

  @override
  String get familyId => MultitaskEngine.engineFamilyId;

  @override
  Widget build(BuildContext context, ActivityRenderContext render) {
    final item = render.item as GeneratedItem;
    final simulation = MultitaskEngine.simulationOf(item);
    return _MultitaskView(render: render, simulation: simulation);
  }

  @override
  Widget? buildExample(BuildContext context, [RunExampleContext? run]) {
    final theme = AppTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(AppStrings.multitaskExampleTracking, style: theme.textStyles.body),
        SizedBox(height: theme.spacing.xs),
        Text(AppStrings.multitaskExampleShape, style: theme.textStyles.body),
        SizedBox(height: theme.spacing.xs),
        Text(AppStrings.multitaskExampleCalc, style: theme.textStyles.body),
      ],
    );
  }
}

/// True on a touch-first platform (Android/iOS): the initial guess before
/// any hardware key event is observed (desktop/web start "keyboard
/// confirmed"; see the class doc).
bool _isTouchPlatformGuess() {
  final platform = defaultTargetPlatform;
  return platform == TargetPlatform.android || platform == TargetPlatform.iOS;
}

class _MultitaskView extends StatefulWidget {
  const _MultitaskView({required this.render, required this.simulation});

  final ActivityRenderContext render;
  final MultitaskSimulation simulation;

  @override
  State<_MultitaskView> createState() => _MultitaskViewState();
}

class _MultitaskViewState extends State<_MultitaskView>
    with SingleTickerProviderStateMixin {
  final FocusNode _focusNode = FocusNode(debugLabel: 'multitask_psychomotor');
  late Ticker _ticker;
  late bool _keyboardConfirmed;
  late bool _showExamSkipNotice;
  int _elapsedMs = 0;
  bool _submitted = false;

  TrackDirection? _heldDirection;
  int? _heldSinceMs;
  final List<HeldInterval> _heldIntervals = [];
  final List<int> _shapePressMs = [];
  final List<int> _calcPressMs = [];

  @override
  void initState() {
    super.initState();
    _keyboardConfirmed = !_isTouchPlatformGuess();
    _showExamSkipNotice = widget.render.isExam && !_keyboardConfirmed;
    _ticker = createTicker(_onTick);
    if (!_showExamSkipNotice) _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTick(Duration elapsed) {
    if (_submitted) return;
    final ms = elapsed.inMilliseconds;
    final durationMs = widget.simulation.durationMs;
    if (ms >= durationMs) {
      setState(() => _elapsedMs = durationMs);
      _finish();
      return;
    }
    setState(() => _elapsedMs = ms);
  }

  void _finish() {
    if (_submitted) return;
    _submitted = true;
    _closeHeldInterval(widget.simulation.durationMs);
    _ticker.stop();
    final metrics = MultitaskScoring.evaluate(
      widget.simulation,
      heldIntervals: _heldIntervals,
      shapePressMs: _shapePressMs,
      calcPressMs: _calcPressMs,
    );
    widget.render.onAnswer(Answer.raw(metrics.toPayload()));
  }

  void _skip() {
    if (_submitted) return;
    _submitted = true;
    widget.render.onAnswer(const Answer.skip());
  }

  TrackDirection? _directionFor(LogicalKeyboardKey key) => switch (key) {
    LogicalKeyboardKey.arrowUp => TrackDirection.up,
    LogicalKeyboardKey.arrowDown => TrackDirection.down,
    LogicalKeyboardKey.arrowLeft => TrackDirection.left,
    LogicalKeyboardKey.arrowRight => TrackDirection.right,
    _ => null,
  };

  void _setHeldDirection(TrackDirection direction) {
    if (_heldDirection == direction) return;
    _closeHeldInterval(_elapsedMs);
    setState(() {
      _heldDirection = direction;
      _heldSinceMs = _elapsedMs;
    });
  }

  void _releaseDirection(TrackDirection direction) {
    if (_heldDirection != direction) return;
    _closeHeldInterval(_elapsedMs);
    setState(() {});
  }

  void _closeHeldInterval(int atMs) {
    final since = _heldSinceMs;
    final direction = _heldDirection;
    if (since != null && direction != null && atMs > since) {
      _heldIntervals.add(
        HeldInterval(startMs: since, endMs: atMs, direction: direction),
      );
    }
    _heldDirection = null;
    _heldSinceMs = null;
  }

  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent && !_keyboardConfirmed) {
      setState(() => _keyboardConfirmed = true);
    }
    if (_submitted || !widget.render.acceptsInput) {
      return KeyEventResult.ignored;
    }
    final direction = _directionFor(event.logicalKey);
    if (direction != null) {
      if (event is KeyDownEvent) {
        _setHeldDirection(direction);
        return KeyEventResult.handled;
      }
      if (event is KeyUpEvent) {
        _releaseDirection(direction);
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    }
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.space) {
        _shapePressMs.add(_elapsedMs);
        return KeyEventResult.handled;
      }
      if (event.logicalKey == LogicalKeyboardKey.keyF) {
        _calcPressMs.add(_elapsedMs);
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    if (_showExamSkipNotice) return _ExamSkipNotice(onSkip: _skip);

    final theme = AppTheme.of(context);
    final simulation = widget.simulation;
    final showsTouchFallback =
        !_keyboardConfirmed && !widget.render.isExam;

    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _onKeyEvent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: CustomPaint(
              painter: _MultitaskPainter(
                simulation: simulation,
                elapsedMs: _elapsedMs,
                theme: theme,
                heldDirection: _heldDirection,
              ),
              child: const SizedBox.expand(),
            ),
          ),
          if (showsTouchFallback) ...[
            SizedBox(height: theme.spacing.sm),
            Text(
              AppStrings.multitaskTouchFallback,
              textAlign: TextAlign.center,
              style: theme.textStyles.caption,
            ),
            SizedBox(height: theme.spacing.sm),
            _TouchControls(
              onDirectionDown: _setHeldDirection,
              onDirectionUp: _releaseDirection,
              onShapePress: () => _shapePressMs.add(_elapsedMs),
              onCalcPress: () => _calcPressMs.add(_elapsedMs),
              enabled: widget.render.acceptsInput,
            ),
          ],
        ],
      ),
    );
  }
}

class _ExamSkipNotice extends StatelessWidget {
  const _ExamSkipNotice({required this.onSkip});

  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          AppStrings.multitaskExamKeyboardRequired,
          textAlign: TextAlign.center,
          style: theme.textStyles.body,
        ),
        SizedBox(height: theme.spacing.lg),
        SecondaryButton(
          key: const Key('multitask.skip_section'),
          label: AppStrings.actionSkip,
          onPressed: onSkip,
        ),
      ],
    );
  }
}

class _TouchControls extends StatelessWidget {
  const _TouchControls({
    required this.onDirectionDown,
    required this.onDirectionUp,
    required this.onShapePress,
    required this.onCalcPress,
    required this.enabled,
  });

  final void Function(TrackDirection direction) onDirectionDown;
  final void Function(TrackDirection direction) onDirectionUp;
  final VoidCallback onShapePress;
  final VoidCallback onCalcPress;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _DirectionKey(
              key: const Key('multitask.touch_dpad.left'),
              label: '←',
              direction: TrackDirection.left,
              onDown: onDirectionDown,
              onUp: onDirectionUp,
              enabled: enabled,
            ),
            SizedBox(width: theme.spacing.sm),
            Column(
              children: [
                _DirectionKey(
                  key: const Key('multitask.touch_dpad.up'),
                  label: '↑',
                  direction: TrackDirection.up,
                  onDown: onDirectionDown,
                  onUp: onDirectionUp,
                  enabled: enabled,
                ),
                SizedBox(height: theme.spacing.xs),
                _DirectionKey(
                  key: const Key('multitask.touch_dpad.down'),
                  label: '↓',
                  direction: TrackDirection.down,
                  onDown: onDirectionDown,
                  onUp: onDirectionUp,
                  enabled: enabled,
                ),
              ],
            ),
            SizedBox(width: theme.spacing.sm),
            _DirectionKey(
              key: const Key('multitask.touch_dpad.right'),
              label: '→',
              direction: TrackDirection.right,
              onDown: onDirectionDown,
              onUp: onDirectionUp,
              enabled: enabled,
            ),
          ],
        ),
        SizedBox(height: theme.spacing.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SecondaryButton(
              key: const Key('multitask.touch_shape'),
              label: AppStrings.multitaskShapeButtonLabel,
              onPressed: enabled ? onShapePress : null,
            ),
            SizedBox(width: theme.spacing.md),
            SecondaryButton(
              key: const Key('multitask.touch_calc'),
              label: AppStrings.multitaskCalcButtonLabel,
              onPressed: enabled ? onCalcPress : null,
            ),
          ],
        ),
      ],
    );
  }
}

/// A press-and-hold D-pad key (unlike [AppKeypadButton]/[SecondaryButton],
/// which only report a tap): [onDown]/[onUp] fire on pointer down/up|cancel
/// so a held touch scores exactly like a held physical arrow.
class _DirectionKey extends StatelessWidget {
  const _DirectionKey({
    required this.label,
    required this.direction,
    required this.onDown,
    required this.onUp,
    required this.enabled,
    super.key,
  });

  final String label;
  final TrackDirection direction;
  final void Function(TrackDirection direction) onDown;
  final void Function(TrackDirection direction) onUp;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Listener(
      onPointerDown: enabled ? (_) => onDown(direction) : null,
      onPointerUp: enabled ? (_) => onUp(direction) : null,
      onPointerCancel: enabled ? (_) => onUp(direction) : null,
      child: Container(
        width: 48,
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: theme.colors.surface,
          border: Border.all(color: theme.colors.border),
          borderRadius: theme.radii.smAll,
        ),
        child: Text(label, style: theme.textStyles.bodyStrong),
      ),
    );
  }
}

/// Draws the arena, the moving circle (with the current shape inside),
/// the reference shape, the framed calculation and a direction cue.
class _MultitaskPainter extends CustomPainter {
  _MultitaskPainter({
    required this.simulation,
    required this.elapsedMs,
    required this.theme,
    required this.heldDirection,
  });

  final MultitaskSimulation simulation;
  final int elapsedMs;
  final AppTheme theme;
  final TrackDirection? heldDirection;

  @override
  void paint(Canvas canvas, Size size) {
    final colors = theme.colors;
    final arena = Rect.fromLTWH(0, 0, size.width, size.height * 0.7);
    canvas.drawRect(
      arena,
      Paint()
        ..color = colors.border
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    final (nx, ny) = simulation.positionAt(elapsedMs);
    const margin = 28.0;
    final cx = arena.left + margin + nx * (arena.width - 2 * margin);
    final cy = arena.top + margin + ny * (arena.height - 2 * margin);
    const radius = 26.0;

    canvas.drawCircle(
      Offset(cx, cy),
      radius,
      Paint()
        ..color = colors.surfaceRaised
        ..style = PaintingStyle.fill,
    );
    canvas.drawCircle(
      Offset(cx, cy),
      radius,
      Paint()
        ..color = colors.border
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    final shape = simulation.shapeAt(elapsedMs).shape;
    _paintShape(
      canvas,
      Rect.fromCircle(center: Offset(cx, cy), radius: radius * 0.6),
      shape,
      colors.textPrimary,
    );

    // Reference shape, top-left.
    final refRect = Rect.fromLTWH(arena.left + 8, arena.top + 8, 32, 32);
    _paintShape(canvas, refRect, simulation.referenceShape, colors.accent);

    // Direction cue, top-right: an arrow pointing the target's direction.
    _paintDirectionCue(
      canvas,
      Offset(arena.right - 28, arena.top + 24),
      simulation.directionAt(elapsedMs),
      colors.textSecondary,
    );
    if (heldDirection != null) {
      _paintDirectionCue(
        canvas,
        Offset(arena.right - 28, arena.top + 64),
        heldDirection!,
        colors.accent,
      );
    }

    // Framed calculation, below the arena.
    final calc = simulation.calcAt(elapsedMs);
    final calcRect = Rect.fromLTWH(0, arena.bottom + 16, size.width, 44);
    canvas.drawRect(
      calcRect,
      Paint()
        ..color = colors.surface
        ..style = PaintingStyle.fill,
    );
    canvas.drawRect(
      calcRect,
      Paint()
        ..color = colors.borderStrong
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    final text = '${calc.a} ${calc.op} ${calc.b} = ${calc.shown}';
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: theme.textStyles.bodyStrong.copyWith(color: colors.textPrimary),
      ),
      textDirection: ui.TextDirection.ltr,
    )..layout(maxWidth: size.width);
    painter.paint(
      canvas,
      Offset(
        calcRect.center.dx - painter.width / 2,
        calcRect.center.dy - painter.height / 2,
      ),
    );
  }

  void _paintShape(Canvas canvas, Rect rect, StimulusShape shape, Color color) {
    final paint = Paint()..color = color;
    final w = rect.width;
    final h = rect.height;
    final cx = rect.center.dx;
    final cy = rect.center.dy;
    final path = switch (shape) {
      StimulusShape.square => Path()..addRect(rect),
      StimulusShape.circle => Path()..addOval(rect),
      StimulusShape.triangle => Path()
        ..moveTo(cx, rect.top)
        ..lineTo(rect.right, rect.bottom)
        ..lineTo(rect.left, rect.bottom)
        ..close(),
      StimulusShape.diamond => Path()
        ..moveTo(cx, rect.top)
        ..lineTo(rect.right, cy)
        ..lineTo(cx, rect.bottom)
        ..lineTo(rect.left, cy)
        ..close(),
      StimulusShape.star => _starPath(cx, cy, math.min(w, h) / 2, math.min(w, h) / 4),
    };
    canvas.drawPath(path, paint);
  }

  Path _starPath(double cx, double cy, double outerR, double innerR) {
    final path = Path();
    for (var i = 0; i < 10; i++) {
      final r = i.isEven ? outerR : innerR;
      final angle = (math.pi / 5) * i - math.pi / 2;
      final x = cx + r * math.cos(angle);
      final y = cy + r * math.sin(angle);
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    path.close();
    return path;
  }

  void _paintDirectionCue(
    Canvas canvas,
    Offset center,
    TrackDirection direction,
    Color color,
  ) {
    final (dx, dy) = direction.delta;
    const len = 16.0;
    final tip = Offset(center.dx + dx * len, center.dy + dy * len);
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    canvas.drawLine(center, tip, paint);
    final angle = math.atan2(dy, dx);
    const headLen = 6.0;
    final left = Offset(
      tip.dx - headLen * math.cos(angle - math.pi / 6),
      tip.dy - headLen * math.sin(angle - math.pi / 6),
    );
    final right = Offset(
      tip.dx - headLen * math.cos(angle + math.pi / 6),
      tip.dy - headLen * math.sin(angle + math.pi / 6),
    );
    canvas.drawLine(tip, left, paint);
    canvas.drawLine(tip, right, paint);
  }

  @override
  bool shouldRepaint(covariant _MultitaskPainter oldDelegate) =>
      oldDelegate.elapsedMs != elapsedMs ||
      oldDelegate.heldDirection != heldDirection;
}
