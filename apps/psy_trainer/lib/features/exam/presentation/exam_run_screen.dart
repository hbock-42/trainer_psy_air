import 'dart:async';

import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n_extensions.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/widgets.dart';
import '../../settings/presentation/providers/app_settings_provider.dart';
import '../../train/presentation/engine/engine_ui.dart';
import '../domain/exam_realism_options.dart';
import '../domain/exam_section_planner.dart' show englishFamilyId;
import 'exam_run_controller.dart';
import 'exam_run_state.dart';
import 'providers/exam_realism_options_provider.dart';

/// `/exam/run/:blueprintId` (US-061): runs every available section of the
/// blueprint back to back through `SessionHost`, in exam mode — no back, no
/// pause, no feedback unless the family keeps its live feedback
/// (`ExamSection.liveFeedback`); the runtime enforces all three
/// (`ActivitySessionConfig.canPause`/`showsFeedback`).
///
/// Quitting (the top bar's back arrow) asks for confirmation, then aborts
/// the whole exam — never just the current section. Between sections with
/// `breakAfterSec` > 0 a countdown screen offers "Continuer" to skip the
/// rest of the break, unless the realism panel's "allow pause between
/// sections" is off (US-063), in which case only the auto-continue timer
/// applies.
///
/// US-063 realism options applied here (the rest are applied by
/// `planExamSections`, read once by `ExamRunController` when the run
/// starts): the countdown bars' `TimingDisplay` (hidden for `english` when
/// `hideTimerEnglish`, hidden until under a minute left when
/// `hideRemainingTime`), full-screen immersive chrome + portrait lock on
/// phones (`immersiveFullScreen`), and a start/end beep per section
/// (`soundCuesEnabled`, gated on the global `soundEnabledProvider` mute
/// too).
class ExamRunScreen extends ConsumerStatefulWidget {
  const ExamRunScreen({required this.blueprintId, super.key});

  final String blueprintId;

  static const Key quitConfirmKey = Key('exam_run.quit_confirm');
  static const Key quitCancelKey = Key('exam_run.quit_cancel');
  static const Key skipBreakKey = Key('exam_run.skip_break');
  static const Key breakTimerKey = Key('exam_run.break_timer');

  @override
  ConsumerState<ExamRunScreen> createState() => _ExamRunScreenState();
}

class _ExamRunScreenState extends ConsumerState<ExamRunScreen> {
  bool _confirmingQuit = false;
  bool _immersiveApplied = false;
  bool _wasRunning = false;

  void _askQuit() => setState(() => _confirmingQuit = true);

  void _cancelQuit() => setState(() => _confirmingQuit = false);

  void _confirmQuit(ExamRunState state) {
    setState(() => _confirmingQuit = false);
    final controller = ref.read(
      examRunControllerProvider(widget.blueprintId).notifier,
    );
    switch (state) {
      case ExamRunRunning(:final request):
        ref.read(activitySessionControllerProvider(request).notifier).abort();
      case ExamRunOnBreak():
        controller.abortFromBreak();
      default:
        break;
    }
  }

  /// Phones only (US-063 point 6): macOS/Windows/web keep their normal
  /// window chrome and orientation is meaningless there.
  bool get _isMobile =>
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;

  void _applyImmersiveMode(ExamRealismOptions options) {
    if (!options.immersiveFullScreen || !_isMobile || _immersiveApplied) {
      return;
    }
    _immersiveApplied = true;
    unawaited(
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky),
    );
    unawaited(
      SystemChrome.setPreferredOrientations(const [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]),
    );
  }

  void _restoreImmersiveMode() {
    if (!_immersiveApplied) return;
    _immersiveApplied = false;
    unawaited(SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge));
    unawaited(SystemChrome.setPreferredOrientations(DeviceOrientation.values));
  }

  @override
  void dispose() {
    _restoreImmersiveMode();
    super.dispose();
  }

  /// A short beep at the start/end of a section (US-063 point 6). Gated on
  /// both the realism panel's own toggle and the app-wide sound mute
  /// (`soundEnabledProvider`); `SystemSound.play` is the only cue the
  /// widgets layer offers (no audio asset pipeline here), so a platform
  /// that ignores it is a silent no-op rather than an error.
  void _playSoundCue(ExamRealismOptions options) {
    if (!options.soundCuesEnabled) return;
    if (!ref.read(soundEnabledProvider)) return;
    unawaited(SystemSound.play(SystemSoundType.click));
  }

  TimingDisplay _timingDisplayFor(ExamRealismOptions options, String familyId) {
    if (options.hideTimerEnglish && familyId == englishFamilyId) {
      return TimingDisplay.hidden;
    }
    if (options.hideRemainingTime) return TimingDisplay.hiddenUntilLastMinute;
    return TimingDisplay.visible;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final state = ref.watch(examRunControllerProvider(widget.blueprintId));
    final realism = ref.watch(examRealismOptionsProvider);

    _applyImmersiveMode(realism);
    if (state is ExamRunRunning && !_wasRunning) {
      _wasRunning = true;
      _playSoundCue(realism);
    } else if (state is! ExamRunRunning && _wasRunning) {
      _wasRunning = false;
      _playSoundCue(realism);
    }

    ref.listen<ExamRunState>(examRunControllerProvider(widget.blueprintId), (
      previous,
      next,
    ) {
      if (next is ExamRunDone) {
        context.go(AppRoutes.examReport(next.sessionId));
      } else if (next is ExamRunAborted || next is ExamRunUnavailable) {
        // Nothing to show for these: pop back to the exam home.
      }
    });

    final canQuit = state is ExamRunRunning || state is ExamRunOnBreak;

    return Stack(
      children: [
        AppScaffold(
          title: context.l10n.examRunnerTitle,
          onBack: canQuit ? _askQuit : () => context.pop(),
          body: switch (state) {
            ExamRunLoading() => _Centered(
              child: Text(context.l10n.examRunnerLoading),
            ),
            ExamRunRunning(
              :final planIndex,
              :final totalSections,
              :final request,
              :final familyId,
            ) =>
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.all(theme.spacing.md),
                    child: Text(
                      context.l10n.examRunnerSectionProgress(
                        planIndex + 1,
                        totalSections,
                      ),
                      style: theme.textStyles.caption,
                    ),
                  ),
                  Expanded(
                    child: SessionHost(
                      request: request,
                      timingDisplay: _timingDisplayFor(realism, familyId),
                      onFinished: (result) => ref
                          .read(
                            examRunControllerProvider(
                              widget.blueprintId,
                            ).notifier,
                          )
                          .handleSectionFinished(result),
                    ),
                  ),
                ],
              ),
            ExamRunOnBreak(:final nextPlanIndex, :final totalSections) =>
              _BreakScreen(
                blueprintId: widget.blueprintId,
                nextPlanIndex: nextPlanIndex,
                totalSections: totalSections,
              ),
            ExamRunFinishing() => _Centered(
              child: Text(context.l10n.examRunnerFinishing),
            ),
            ExamRunDone() => _Centered(
              child: Text(context.l10n.examRunnerFinishing),
            ),
            ExamRunAborted() => _EndMessage(
              message: context.l10n.examRunnerAborted,
              onBack: () => context.go(AppRoutes.exam),
            ),
            ExamRunUnavailable() => _EndMessage(
              message: context.l10n.examRunnerUnavailable,
              onBack: () => context.go(AppRoutes.exam),
            ),
            ExamRunError(:final message) => _EndMessage(
              message: message,
              onBack: () => context.go(AppRoutes.exam),
            ),
          },
        ),
        if (_confirmingQuit)
          _QuitConfirmOverlay(
            theme: theme,
            onConfirm: () => _confirmQuit(state),
            onCancel: _cancelQuit,
          ),
      ],
    );
  }
}

class _Centered extends StatelessWidget {
  const _Centered({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Center(child: child);
}

class _EndMessage extends StatelessWidget {
  const _EndMessage({required this.message, required this.onBack});

  final String message;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Padding(
      padding: EdgeInsets.all(theme.spacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            message,
            style: theme.textStyles.body,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: theme.spacing.lg),
          PrimaryButton(
            label: context.l10n.examRunnerBackToHome,
            expand: true,
            onPressed: onBack,
          ),
        ],
      ),
    );
  }
}

/// Countdown between two sections (`ExamSection.breakAfterSec`); "Continuer"
/// starts the next section right away. Ticks locally against
/// `engineClockProvider` (same pattern as `SessionHost`'s own countdowns)
/// rather than through controller state, so the break itself stays one
/// state and the timer is purely a display concern.
class _BreakScreen extends ConsumerStatefulWidget {
  const _BreakScreen({
    required this.blueprintId,
    required this.nextPlanIndex,
    required this.totalSections,
  });

  final String blueprintId;
  final int nextPlanIndex;
  final int totalSections;

  @override
  ConsumerState<_BreakScreen> createState() => _BreakScreenState();
}

class _BreakScreenState extends ConsumerState<_BreakScreen> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(milliseconds: 200), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final controller = ref.read(
      examRunControllerProvider(widget.blueprintId).notifier,
    );
    final now = ref.watch(engineClockProvider).now();
    final remaining = controller.breakRemaining(now) ?? Duration.zero;
    final seconds = remaining.inSeconds;

    return Padding(
      padding: EdgeInsets.all(theme.spacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.l10n.examRunnerBreakTitle,
            textAlign: TextAlign.center,
            style: theme.textStyles.headline,
          ),
          SizedBox(height: theme.spacing.sm),
          Text(
            context.l10n.examRunnerSectionProgress(
              widget.nextPlanIndex + 1,
              widget.totalSections,
            ),
            textAlign: TextAlign.center,
            style: theme.textStyles.caption,
          ),
          SizedBox(height: theme.spacing.lg),
          Text(
            key: ExamRunScreen.breakTimerKey,
            context.l10n.examRunnerBreakCountdown(seconds),
            textAlign: TextAlign.center,
            style: theme.textStyles.title,
          ),
          if (controller.allowsSkippingBreak) ...[
            SizedBox(height: theme.spacing.xl),
            PrimaryButton(
              key: ExamRunScreen.skipBreakKey,
              label: context.l10n.examRunnerBreakContinue,
              expand: true,
              onPressed: controller.skipBreak,
            ),
          ],
        ],
      ),
    );
  }
}

class _QuitConfirmOverlay extends StatelessWidget {
  const _QuitConfirmOverlay({
    required this.theme,
    required this.onConfirm,
    required this.onCancel,
  });

  final AppTheme theme;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ColoredBox(
        color: theme.colors.background.withValues(alpha: 0.92),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Padding(
              padding: EdgeInsets.all(theme.spacing.lg),
              child: AppCard(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      context.l10n.examQuitConfirmTitle,
                      style: theme.textStyles.title,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: theme.spacing.sm),
                    Text(
                      context.l10n.examQuitConfirmBody,
                      style: theme.textStyles.body,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: theme.spacing.lg),
                    PrimaryButton(
                      key: ExamRunScreen.quitConfirmKey,
                      label: context.l10n.examQuitConfirmAction,
                      expand: true,
                      onPressed: onConfirm,
                    ),
                    SizedBox(height: theme.spacing.sm),
                    SecondaryButton(
                      key: ExamRunScreen.quitCancelKey,
                      label: context.l10n.sessionQuitCancelAction,
                      expand: true,
                      onPressed: onCancel,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
