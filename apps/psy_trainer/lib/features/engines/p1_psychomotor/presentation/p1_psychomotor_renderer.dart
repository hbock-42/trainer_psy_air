import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamepads/gamepads.dart' show GamepadButton;
import 'package:psy_content/psy_content.dart';

import 'package:psy_trainer/core/input/gamepad/gamepad_models.dart';
import 'package:psy_trainer/core/input/gamepad/gamepad_service.dart';
import 'package:psy_trainer/core/input/gamepad/gamepad_service_provider.dart';
import 'package:psy_trainer/core/input/gamepad/keyboard_gamepad_service.dart';
import 'package:psy_trainer/core/l10n/l10n_extensions.dart';
import 'package:psy_trainer/core/theme/app_theme.dart';
import 'package:psy_trainer/features/engines/p1_psychomotor/domain/p1_psychomotor_channels.dart';
import 'package:psy_trainer/features/engines/p1_psychomotor/domain/p1_psychomotor_engine.dart';
import 'package:psy_trainer/features/engines/p1_psychomotor/domain/p1_psychomotor_input.dart';
import 'package:psy_trainer/features/engines/p1_psychomotor/domain/p1_psychomotor_phase_schedule.dart';
import 'package:psy_trainer/features/engines/p1_psychomotor/domain/p1_psychomotor_run_state.dart';
import 'package:psy_trainer/features/engines/p1_psychomotor/domain/p1_psychomotor_scoring.dart';
import 'package:psy_trainer/features/engines/p1_psychomotor/domain/p1_psychomotor_simulation.dart';
import 'package:psy_trainer/features/settings/presentation/providers/gamepad_settings_provider.dart';
import 'package:psy_trainer/features/train/presentation/engine/engine_ui.dart';
import 'package:psy_trainer/shared/widgets/widgets.dart';

import 'p1_psychomotor_run_cache.dart';

/// *Psychomoteur* renderer (spec §2.3 row 13, US-102): six 3-minute phases
/// of continuous divided attention, the 4-channel red-zone-zeroes-the-total
/// rule of `docs/content/psy1-spec.md` §2.2.
///
/// Each phase is one [Item] (`P1PsychomotorEngine`'s class doc explains
/// why); this widget owns a real-time [Ticker] that drives one shared
/// [P1PsychomotorRunState] (persisted across phases in
/// [P1PsychomotorRunCache], keyed by `runSeed`) and submits one
/// [Answer.raw] per phase when its 3 minutes elapse.
///
/// Input: the two sticks come from whichever [GamepadService] reports a
/// device (preferring a real gamepad over the keyboard fallback); F1-F9
/// (letters) and the numpad + Enter (arithmetic) are always the physical
/// keyboard, regardless of which service drives the sticks. A touch-only
/// device (no gamepad, no physical keyboard ever observed) shows a notice
/// and offers [SkipAnswer] in both practice and exam — unlike
/// `multitask_psychomotor`, no touch fallback is offered here even in
/// practice: two of the four channels need continuous proportional stick
/// input that a touch surface cannot approximate at all, so a degraded
/// touch rehearsal would teach the wrong reflexes rather than a merely
/// non-representative version of the right ones (flagged in the story's
/// final report as a deliberate scope cut).
class P1PsychomotorRenderer extends ActivityRenderer {
  const P1PsychomotorRenderer();

  @override
  String get familyId => P1PsychomotorEngine.engineFamilyId;

  @override
  Widget build(BuildContext context, ActivityRenderContext render) {
    final item = render.item as GeneratedItem;
    final simulation = P1PsychomotorEngine.simulationOf(item);
    final runSeed = item.origin?.runSeed ?? item.seed;
    final phaseIndex = item.origin?.index ?? 0;
    final params = item.params as P1PsychomotorParams;
    return _P1PsychomotorView(
      key: ValueKey(item.id),
      render: render,
      simulation: simulation,
      runSeed: runSeed,
      phaseIndex: phaseIndex,
      phaseDurationSec: params.phaseDurationSec,
      phaseCount: params.phaseCount,
    );
  }

  @override
  Widget? buildExample(BuildContext context, [RunExampleContext? run]) {
    final theme = AppTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.l10n.p1PsychomotorExampleGauges,
          style: theme.textStyles.body,
        ),
        SizedBox(height: theme.spacing.xs),
        Text(
          context.l10n.p1PsychomotorExampleTracking,
          style: theme.textStyles.body,
        ),
        SizedBox(height: theme.spacing.xs),
        Text(
          context.l10n.p1PsychomotorExampleLetters,
          style: theme.textStyles.body,
        ),
        SizedBox(height: theme.spacing.xs),
        Text(
          context.l10n.p1PsychomotorExampleArithmetic,
          style: theme.textStyles.body,
        ),
      ],
    );
  }
}

bool _isTouchPlatformGuess() {
  final platform = defaultTargetPlatform;
  return platform == TargetPlatform.android || platform == TargetPlatform.iOS;
}

class _P1PsychomotorView extends ConsumerStatefulWidget {
  const _P1PsychomotorView({
    required super.key,
    required this.render,
    required this.simulation,
    required this.runSeed,
    required this.phaseIndex,
    required this.phaseDurationSec,
    required this.phaseCount,
  });

  final ActivityRenderContext render;
  final P1PsychomotorSimulation simulation;
  final int runSeed;
  final int phaseIndex;
  final int phaseDurationSec;
  final int phaseCount;

  @override
  ConsumerState<_P1PsychomotorView> createState() => _P1PsychomotorViewState();
}

class _P1PsychomotorViewState extends ConsumerState<_P1PsychomotorView>
    with SingleTickerProviderStateMixin {
  final FocusNode _focusNode = FocusNode(debugLabel: 'p1_psychomotor');
  late final Ticker _ticker;
  late final P1PsychomotorRunState _runState;
  late final int _phaseStartMs;
  late final int _phaseDurationMs;

  bool _keyboardConfirmed = !_isTouchPlatformGuess();
  bool _showDeviceNotice = false;
  bool _submitted = false;
  int _elapsedInPhaseMs = 0;

  GamepadService? _stickService;
  String? _stickDeviceId;
  bool _stickIsRepresentative = true;
  Set<GamepadButton> _previousButtons = const {};
  GamepadState? _latestGamepadState;

  final StringBuffer _arithmeticBuffer = StringBuffer();

  @override
  void initState() {
    super.initState();
    _phaseStartMs = widget.phaseIndex * widget.phaseDurationSec * 1000;
    _phaseDurationMs = widget.phaseDurationSec * 1000;
    _runState = P1PsychomotorRunCache.of(widget.runSeed, widget.simulation);
    _ticker = createTicker(_onTick);

    _resolveStickService(startTickerIfReady: false);
    ref
        .read(gamepadServiceProvider)
        .devices
        .listen((_) => _resolveStickService(startTickerIfReady: true));

    if (!_showDeviceNotice) _ticker.start();
  }

  void _resolveStickService({required bool startTickerIfReady}) {
    final gamepad = ref.read(gamepadServiceProvider);
    if (gamepad.currentDevices.isNotEmpty) {
      final preferred = ref.read(gamepadSettingsProvider).preferredDeviceId;
      final devices = gamepad.currentDevices;
      final chosen = devices.firstWhere(
        (d) => d.id == preferred,
        orElse: () => devices.first,
      );
      _attachStickService(
        gamepad,
        chosen.id,
        isRepresentative: true,
        startTickerIfReady: startTickerIfReady,
      );
      return;
    }
    if (widget.render.isExam) {
      // Exam requires a real gamepad; no keyboard fallback.
      if (mounted) setState(() => _showDeviceNotice = true);
      if (_ticker.isTicking) _ticker.stop();
      return;
    }
    final keyboard = ref.read(keyboardGamepadServiceProvider);
    _attachStickService(
      keyboard,
      keyboardGamepadDeviceId,
      isRepresentative: false,
      startTickerIfReady: startTickerIfReady,
    );
  }

  void _attachStickService(
    GamepadService service,
    String deviceId, {
    required bool isRepresentative,
    required bool startTickerIfReady,
  }) {
    if (_stickService == service && _stickDeviceId == deviceId) return;
    _stickService = service;
    _stickDeviceId = deviceId;
    _stickIsRepresentative = isRepresentative;
    service.statesOf(deviceId).listen((state) {
      _latestGamepadState = state;
    });
    if (mounted && _showDeviceNotice) {
      setState(() => _showDeviceNotice = false);
    }
    if (startTickerIfReady && !_ticker.isTicking && !_submitted) {
      _ticker.start();
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  P1PsychomotorTickInput _sampleInput() {
    final state = _latestGamepadState;
    if (state == null) return P1PsychomotorTickInput.none;
    final invertY = ref.read(gamepadSettingsProvider).invertRightStickY;
    final settings = ref.read(gamepadSettingsProvider);
    final selectButton = settings.gaugeSelectButton;
    final recentreButton = settings.gaugeRecentreButton;
    final nextEdge =
        state.isPressed(selectButton) &&
        !_previousButtons.contains(selectButton);
    final prevEdge =
        state.isPressed(recentreButton) &&
        !_previousButtons.contains(recentreButton);
    _previousButtons = state.pressedButtons;
    return P1PsychomotorTickInput(
      leftStickY: state.leftStick.y,
      selectNextGauge: nextEdge,
      selectPrevGauge: prevEdge,
      rightStickX: state.rightStick.x,
      rightStickY: invertY ? -state.rightStick.y : state.rightStick.y,
    );
  }

  void _onTick(Duration elapsed) {
    if (_submitted || _showDeviceNotice) return;
    final ms = elapsed.inMilliseconds;
    final clamped = ms >= _phaseDurationMs ? _phaseDurationMs : ms;
    final nowMs = _phaseStartMs + clamped;
    final phase = P1PsychomotorPhaseSchedule.forIndex(widget.phaseIndex);
    _runState.tick(
      nowMs: nowMs,
      input: _sampleInput(),
      activeChannels: phase.activeChannels,
    );
    setState(() => _elapsedInPhaseMs = clamped);
    if (ms >= _phaseDurationMs) _finishPhase();
  }

  void _finishPhase() {
    if (_submitted) return;
    _submitted = true;
    _ticker.stop();
    final metrics = P1PsychomotorMetrics.fromRunState(_runState);
    if (widget.phaseIndex >= widget.phaseCount - 1) {
      P1PsychomotorRunCache.release(widget.runSeed);
    }
    widget.render.onAnswer(Answer.raw(metrics.toPayload()));
  }

  void _skip() {
    if (_submitted) return;
    _submitted = true;
    P1PsychomotorRunCache.release(widget.runSeed);
    widget.render.onAnswer(const Answer.skip());
  }

  int get _nowMs => _phaseStartMs + _elapsedInPhaseMs;

  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent && !_keyboardConfirmed) {
      setState(() => _keyboardConfirmed = true);
    }
    if (_submitted || !widget.render.acceptsInput) {
      return KeyEventResult.ignored;
    }
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final fKeyPosition = _functionKeyPosition(event.logicalKey);
    if (fKeyPosition != null) {
      _runState.registerLetterPress(fKeyPosition, _nowMs);
      return KeyEventResult.handled;
    }
    final digit = _digitOf(event.logicalKey);
    if (digit != null) {
      _arithmeticBuffer.write(digit);
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.backspace &&
        _arithmeticBuffer.isNotEmpty) {
      final s = _arithmeticBuffer.toString();
      _arithmeticBuffer
        ..clear()
        ..write(s.substring(0, s.length - 1));
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.numpadEnter) {
      final text = _arithmeticBuffer.toString();
      _arithmeticBuffer.clear();
      final value = int.tryParse(text);
      if (value != null) {
        _runState.submitArithmeticAnswer(value, _nowMs);
      }
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  static int? _functionKeyPosition(LogicalKeyboardKey key) {
    const fKeys = [
      LogicalKeyboardKey.f1,
      LogicalKeyboardKey.f2,
      LogicalKeyboardKey.f3,
      LogicalKeyboardKey.f4,
      LogicalKeyboardKey.f5,
      LogicalKeyboardKey.f6,
      LogicalKeyboardKey.f7,
      LogicalKeyboardKey.f8,
      LogicalKeyboardKey.f9,
    ];
    final index = fKeys.indexOf(key);
    return index == -1 ? null : index;
  }

  static String? _digitOf(LogicalKeyboardKey key) {
    const digits = [
      LogicalKeyboardKey.digit0,
      LogicalKeyboardKey.digit1,
      LogicalKeyboardKey.digit2,
      LogicalKeyboardKey.digit3,
      LogicalKeyboardKey.digit4,
      LogicalKeyboardKey.digit5,
      LogicalKeyboardKey.digit6,
      LogicalKeyboardKey.digit7,
      LogicalKeyboardKey.digit8,
      LogicalKeyboardKey.digit9,
    ];
    const numpad = [
      LogicalKeyboardKey.numpad0,
      LogicalKeyboardKey.numpad1,
      LogicalKeyboardKey.numpad2,
      LogicalKeyboardKey.numpad3,
      LogicalKeyboardKey.numpad4,
      LogicalKeyboardKey.numpad5,
      LogicalKeyboardKey.numpad6,
      LogicalKeyboardKey.numpad7,
      LogicalKeyboardKey.numpad8,
      LogicalKeyboardKey.numpad9,
    ];
    var index = digits.indexOf(key);
    if (index != -1) return '$index';
    index = numpad.indexOf(key);
    if (index != -1) return '$index';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (_showDeviceNotice) {
      return _DeviceRequiredNotice(onSkip: _skip);
    }
    final theme = AppTheme.of(context);
    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _onKeyEvent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!_stickIsRepresentative)
            Padding(
              padding: EdgeInsets.only(bottom: theme.spacing.xs),
              child: Text(
                context.l10n.p1PsychomotorKeyboardFallbackBanner,
                textAlign: TextAlign.center,
                style: theme.textStyles.caption.copyWith(
                  color: theme.colors.warning,
                ),
              ),
            ),
          Expanded(
            child: RepaintBoundary(
              child: CustomPaint(
                painter: _P1PsychomotorPainter(
                  runState: _runState,
                  simulation: widget.simulation,
                  nowMs: _nowMs,
                  arithmeticBuffer: _arithmeticBuffer.toString(),
                  theme: theme,
                ),
                child: const SizedBox.expand(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DeviceRequiredNotice extends StatelessWidget {
  const _DeviceRequiredNotice({required this.onSkip});

  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.l10n.p1PsychomotorDeviceRequired,
          textAlign: TextAlign.center,
          style: theme.textStyles.body,
        ),
        SizedBox(height: theme.spacing.lg),
        SecondaryButton(
          key: const Key('p1_psychomotor.skip_section'),
          label: context.l10n.actionSkip,
          onPressed: onSkip,
        ),
      ],
    );
  }
}

/// Draws the whole cockpit-like scene: 4 gauges, the tracking circle, the
/// 9-letter grid, the arithmetic box and a per-channel score bar with a
/// red-zone marker.
class _P1PsychomotorPainter extends CustomPainter {
  _P1PsychomotorPainter({
    required this.runState,
    required this.simulation,
    required this.nowMs,
    required this.arithmeticBuffer,
    required this.theme,
  });

  final P1PsychomotorRunState runState;
  final P1PsychomotorSimulation simulation;
  final int nowMs;
  final String arithmeticBuffer;
  final AppTheme theme;

  @override
  void paint(Canvas canvas, Size size) {
    final colors = theme.colors;
    const pad = 8.0;
    const scoreBarsHeight = 72.0;
    final topHeight = size.height - scoreBarsHeight - pad;

    final gaugesRect = Rect.fromLTWH(
      pad,
      pad,
      size.width * 0.28,
      topHeight - pad,
    );
    final trackingRect = Rect.fromLTWH(
      gaugesRect.right + pad,
      pad,
      size.width * 0.34,
      topHeight - pad,
    );
    final rightColRect = Rect.fromLTWH(
      trackingRect.right + pad,
      pad,
      size.width - trackingRect.right - 2 * pad,
      topHeight - pad,
    );
    final lettersRect = Rect.fromLTWH(
      rightColRect.left,
      rightColRect.top,
      rightColRect.width,
      rightColRect.height * 0.6,
    );
    final arithmeticRect = Rect.fromLTWH(
      rightColRect.left,
      lettersRect.bottom + pad,
      rightColRect.width,
      rightColRect.height * 0.4 - pad,
    );

    _paintGauges(canvas, gaugesRect, colors);
    _paintTracking(canvas, trackingRect, colors);
    _paintLetters(canvas, lettersRect, colors);
    _paintArithmetic(canvas, arithmeticRect, colors);
    _paintScoreBars(
      canvas,
      Rect.fromLTWH(
        pad,
        topHeight + pad,
        size.width - 2 * pad,
        scoreBarsHeight,
      ),
      colors,
    );
  }

  void _paintGauges(Canvas canvas, Rect rect, AppColors colors) {
    canvas.drawRect(
      rect,
      Paint()
        ..color = colors.border
        ..style = PaintingStyle.stroke,
    );
    final gaugeHeight = rect.height / p1PsychomotorGaugeCount;
    for (var i = 0; i < p1PsychomotorGaugeCount; i++) {
      final top = rect.top + i * gaugeHeight;
      final cellRect = Rect.fromLTWH(rect.left, top, rect.width, gaugeHeight);
      final selected = i == runState.selectedGauge;
      final displacement = runState.gaugeDisplacement[i];
      final centerY = cellRect.center.dy;
      canvas.drawLine(
        Offset(cellRect.left + 4, centerY),
        Offset(cellRect.right - 4, centerY),
        Paint()
          ..color = colors.border
          ..strokeWidth = 1,
      );
      final needleX =
          cellRect.center.dx + displacement * (cellRect.width / 2 - 8);
      canvas.drawCircle(
        Offset(needleX, centerY),
        6,
        Paint()
          ..color =
              displacement.abs() * 100 >
                  (100 - P1PsychomotorScoring.redZoneThreshold)
              ? colors.error
              : (selected ? colors.accent : colors.textSecondary),
      );
      if (selected) {
        canvas.drawRect(
          cellRect.deflate(2),
          Paint()
            ..color = colors.accent
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );
      }
    }
  }

  void _paintTracking(Canvas canvas, Rect rect, AppColors colors) {
    final center = rect.center;
    final radius = math.min(rect.width, rect.height) / 2 - 4;
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = colors.border
        ..style = PaintingStyle.stroke,
    );
    final (tx, ty) = simulation.targetPositionAt(nowMs);
    canvas.drawCircle(
      Offset(center.dx + tx * radius, center.dy - ty * radius),
      7,
      Paint()..color = colors.textSecondary,
    );
    canvas.drawCircle(
      Offset(
        center.dx + runState.cursorX * radius,
        center.dy - runState.cursorY * radius,
      ),
      6,
      Paint()..color = colors.accent,
    );
  }

  void _paintLetters(Canvas canvas, Rect rect, AppColors colors) {
    canvas.drawRect(
      rect,
      Paint()
        ..color = colors.border
        ..style = PaintingStyle.stroke,
    );
    final wave = simulation.letterWaveAt(nowMs);
    const cols = 3, rows = 3;
    final cellW = rect.width / cols;
    final cellH = rect.height / rows;
    for (var i = 0; i < p1PsychomotorLetterCount; i++) {
      final col = i % cols;
      final row = i ~/ cols;
      final cellRect = Rect.fromLTWH(
        rect.left + col * cellW,
        rect.top + row * cellH,
        cellW,
        cellH,
      );
      final isTarget = wave.isTarget(i);
      final painter = TextPainter(
        text: TextSpan(
          text: wave.letters[i],
          style: theme.textStyles.bodyStrong.copyWith(
            color: isTarget ? colors.accent : colors.textPrimary,
          ),
        ),
        textDirection: ui.TextDirection.ltr,
      )..layout();
      painter.paint(
        canvas,
        Offset(
          cellRect.center.dx - painter.width / 2,
          cellRect.center.dy - painter.height / 2,
        ),
      );
    }
  }

  void _paintArithmetic(Canvas canvas, Rect rect, AppColors colors) {
    canvas.drawRect(
      rect,
      Paint()
        ..color = colors.surface
        ..style = PaintingStyle.fill,
    );
    canvas.drawRect(
      rect,
      Paint()
        ..color = colors.borderStrong
        ..style = PaintingStyle.stroke,
    );
    final problem = simulation.arithmeticProblemAt(nowMs);
    final text =
        '${problem.a} ${problem.op} ${problem.b} = '
        '${arithmeticBuffer.isEmpty ? '?' : arithmeticBuffer}';
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: theme.textStyles.numeric.copyWith(color: colors.textPrimary),
      ),
      textDirection: ui.TextDirection.ltr,
    )..layout(maxWidth: rect.width);
    painter.paint(
      canvas,
      Offset(
        rect.center.dx - painter.width / 2,
        rect.center.dy - painter.height / 2,
      ),
    );
  }

  void _paintScoreBars(Canvas canvas, Rect rect, AppColors colors) {
    const channels = P1PsychomotorChannel.values;
    final barWidth = rect.width / channels.length;
    for (var i = 0; i < channels.length; i++) {
      final channel = channels[i];
      final score = runState.scoreOf(channel).clamp(0.0, 100.0);
      final barRect = Rect.fromLTWH(
        rect.left + i * barWidth + 4,
        rect.top,
        barWidth - 8,
        rect.height,
      );
      canvas.drawRect(
        barRect,
        Paint()
          ..color = colors.surface
          ..style = PaintingStyle.fill,
      );
      final fillHeight = barRect.height * (score / 100);
      final isRed = score < P1PsychomotorScoring.redZoneThreshold;
      canvas.drawRect(
        Rect.fromLTWH(
          barRect.left,
          barRect.bottom - fillHeight,
          barRect.width,
          fillHeight,
        ),
        Paint()..color = isRed ? colors.error : colors.success,
      );
      final redZoneY =
          barRect.bottom -
          barRect.height * (P1PsychomotorScoring.redZoneThreshold / 100);
      canvas.drawLine(
        Offset(barRect.left, redZoneY),
        Offset(barRect.right, redZoneY),
        Paint()
          ..color = colors.error
          ..strokeWidth = 1,
      );
      canvas.drawRect(
        barRect,
        Paint()
          ..color = colors.border
          ..style = PaintingStyle.stroke,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _P1PsychomotorPainter oldDelegate) =>
      oldDelegate.nowMs != nowMs ||
      oldDelegate.arithmeticBuffer != arithmeticBuffer;
}
