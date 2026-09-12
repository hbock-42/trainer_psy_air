import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n_extensions.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/widgets.dart';
import '../../train/presentation/engine/engine_ui.dart';
import 'exam_run_controller.dart';
import 'exam_run_state.dart';

/// `/exam/run/:blueprintId` (US-061): runs every available section of the
/// blueprint back to back through `SessionHost`, in exam mode — no back, no
/// pause, no feedback unless the family keeps its live feedback
/// (`ExamSection.liveFeedback`); the runtime enforces all three
/// (`ActivitySessionConfig.canPause`/`showsFeedback`).
///
/// Quitting (the top bar's back arrow) asks for confirmation, then aborts
/// the whole exam — never just the current section. Between sections with
/// `breakAfterSec` > 0 a countdown screen offers "Continuer" to skip the
/// rest of the break.
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

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final state = ref.watch(examRunControllerProvider(widget.blueprintId));

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
          SizedBox(height: theme.spacing.xl),
          PrimaryButton(
            key: ExamRunScreen.skipBreakKey,
            label: context.l10n.examRunnerBreakContinue,
            expand: true,
            onPressed: controller.skipBreak,
          ),
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
