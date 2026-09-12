import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../domain/engine/engine.dart';
import 'activity_renderer.dart';
import 'activity_session_controller.dart';
import 'engine_registry_provider.dart';

/// Runs one activity end to end: briefing (instructions, example, Start),
/// then the engine's renderer with the countdown bars the timing policy
/// calls for, then a minimal end state that reports [onFinished].
///
/// Deliberately plain: the practice screen (US-051) and the exam runner
/// (US-061) wrap it with their own chrome (progress, summary, section
/// breaks) or replace parts of it. Keys on the buttons are stable for tests.
class SessionHost extends ConsumerWidget {
  const SessionHost({
    required this.request,
    required this.onFinished,
    super.key,
  });

  /// The session to run; see [ActivitySessionRequest].
  final ActivitySessionRequest request;

  /// Called once, after the session reached `finished` (completed, aborted
  /// or section timeout) and before its writes necessarily settled; await
  /// the controller's `idle` if the next screen reads the repository.
  final void Function(SessionResult result) onFinished;

  static const Key startKey = Key('session_host.start');
  static const Key nextKey = Key('session_host.next');
  static const Key pauseKey = Key('session_host.pause');
  static const Key resumeKey = Key('session_host.resume');
  static const Key quitKey = Key('session_host.quit');
  static const Key itemTimerKey = Key('session_host.item_timer');
  static const Key sectionTimerKey = Key('session_host.section_timer');
  static const Key feedbackKey = Key('session_host.feedback');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = activitySessionControllerProvider(request);
    ref.listen<ActivitySessionState>(provider, (previous, next) {
      if (next is ActivityFinished && previous is! ActivityFinished) {
        onFinished(next.result);
      }
    });
    final state = ref.watch(provider);
    final controller = ref.read(provider.notifier);
    final config = controller.config;
    final renderer = ref
        .watch(rendererRegistryProvider)
        .byFamily(config.familyId);

    return switch (state) {
      ActivityBriefing() => _Briefing(
        state: state,
        config: config,
        renderer: renderer,
        onStart: controller.start,
      ),
      ActivityRunning() => _Running(
        running: state,
        config: config,
        renderer: renderer,
        controller: controller,
      ),
      ActivityPaused() => _Paused(
        config: config,
        onResume: controller.resume,
        onQuit: controller.abort,
      ),
      ActivityFinished() => const _Finished(),
    };
  }
}

class _Briefing extends StatelessWidget {
  const _Briefing({
    required this.state,
    required this.config,
    required this.renderer,
    required this.onStart,
  });

  final ActivityBriefing state;
  final ActivitySessionConfig config;
  final ActivityRenderer renderer;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final title = config.title?.resolve(AppStrings.locale) ?? config.familyId;
    final briefing =
        config.briefing?.resolve(AppStrings.locale) ??
        AppStrings.sessionBriefingDefault;
    final example = renderer.buildExample(context);

    return Padding(
      padding: EdgeInsets.all(theme.spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: theme.textStyles.headline),
          SizedBox(height: theme.spacing.sm),
          Text(
            AppStrings.sessionItemCount(state.itemCount),
            style: theme.textStyles.caption,
          ),
          if (state.startIndex > 0) ...[
            SizedBox(height: theme.spacing.xs),
            Text(
              AppStrings.sessionResumeHint(
                state.startIndex + 1,
                state.itemCount,
              ),
              style: theme.textStyles.bodyStrong,
            ),
          ],
          SizedBox(height: theme.spacing.lg),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(briefing, style: theme.textStyles.body),
                  SizedBox(height: theme.spacing.lg),
                  AppCard(
                    child:
                        example ??
                        Text(
                          AppStrings.sessionExamplePlaceholder,
                          style: theme.textStyles.caption,
                        ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: theme.spacing.lg),
          PrimaryButton(
            key: SessionHost.startKey,
            label: AppStrings.sessionStart,
            icon: AppIconGlyph.play,
            expand: true,
            autofocus: true,
            onPressed: onStart,
          ),
        ],
      ),
    );
  }
}

class _Running extends ConsumerWidget {
  const _Running({
    required this.running,
    required this.config,
    required this.renderer,
    required this.controller,
  });

  final ActivityRunning running;
  final ActivitySessionConfig config;
  final ActivityRenderer renderer;
  final ActivitySessionController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppTheme.of(context);
    final timing = config.timing;
    final render = ActivityRenderContext(
      item: running.item,
      mode: config.mode,
      phase: running.phase,
      timing: timing,
      itemIndex: running.itemIndex,
      itemCount: running.itemCount,
      showsFeedback: config.showsFeedback,
      feedback: running.feedback,
      itemDeadline: running.itemDeadline,
      onAnswer: controller.answer,
    );
    final hasTimers =
        running.itemDeadline != null || running.sectionDeadline != null;

    return Padding(
      padding: EdgeInsets.all(theme.spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ProgressDots(
            current: running.itemIndex + 1,
            total: running.itemCount,
          ),
          if (hasTimers) ...[
            SizedBox(height: theme.spacing.md),
            _Countdowns(running: running, timing: timing),
          ],
          SizedBox(height: theme.spacing.lg),
          Expanded(child: renderer.build(context, render)),
          if (running.feedback != null) ...[
            SizedBox(height: theme.spacing.md),
            _FeedbackLabel(
              key: SessionHost.feedbackKey,
              result: running.feedback!,
            ),
          ],
          SizedBox(height: theme.spacing.lg),
          Row(
            children: [
              SecondaryButton(
                key: SessionHost.quitKey,
                label: AppStrings.sessionQuit,
                onPressed: controller.abort,
              ),
              if (config.canPause) ...[
                SizedBox(width: theme.spacing.sm),
                SecondaryButton(
                  key: SessionHost.pauseKey,
                  label: AppStrings.sessionPause,
                  icon: AppIconGlyph.pause,
                  onPressed: controller.pause,
                ),
              ],
              const Spacer(),
              if (running.awaitsNext)
                PrimaryButton(
                  key: SessionHost.nextKey,
                  label: AppStrings.sessionNext,
                  icon: AppIconGlyph.chevronRight,
                  autofocus: true,
                  onPressed: controller.next,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// The per-item and per-section bars, ticking on a periodic timer against
/// the engine clock.
class _Countdowns extends ConsumerStatefulWidget {
  const _Countdowns({required this.running, required this.timing});

  final ActivityRunning running;
  final TimingPolicy timing;

  @override
  ConsumerState<_Countdowns> createState() => _CountdownsState();
}

class _CountdownsState extends ConsumerState<_Countdowns> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(milliseconds: 100), (_) {
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
    final now = ref.watch(engineClockProvider).now();
    final running = widget.running;
    final itemLimit = widget.timing.itemLimit;
    final sectionLimit = widget.timing.section;
    final itemLeft = running.itemRemaining(now);
    final sectionLeft = running.sectionRemaining(now);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (sectionLeft != null && sectionLimit != null)
          Semantics(
            label: AppStrings.sessionSectionTimerLabel,
            child: CountdownTimerBar(
              key: SessionHost.sectionTimerKey,
              remaining: sectionLeft,
              total: sectionLimit,
            ),
          ),
        if (itemLeft != null && itemLimit != null) ...[
          if (sectionLeft != null) SizedBox(height: theme.spacing.sm),
          Semantics(
            label: AppStrings.sessionItemTimerLabel,
            child: CountdownTimerBar(
              key: SessionHost.itemTimerKey,
              remaining: itemLeft,
              total: itemLimit,
              showLabel: !widget.timing.isCadence,
            ),
          ),
        ],
      ],
    );
  }
}

class _FeedbackLabel extends StatelessWidget {
  const _FeedbackLabel({required this.result, super.key});

  final ItemResult result;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final (label, color) = switch (result) {
      ItemResult(correct: true) => (
        AppStrings.sessionFeedbackCorrect,
        colors.success,
      ),
      ItemResult(timedOut: true) => (
        AppStrings.sessionFeedbackTimeout,
        colors.warning,
      ),
      ItemResult(skipped: true) => (
        AppStrings.sessionFeedbackSkipped,
        colors.textSecondary,
      ),
      _ => (AppStrings.sessionFeedbackWrong, colors.error),
    };
    return Text(
      label,
      textAlign: TextAlign.center,
      style: theme.textStyles.bodyStrong.copyWith(color: color),
    );
  }
}

class _Paused extends StatelessWidget {
  const _Paused({
    required this.config,
    required this.onResume,
    required this.onQuit,
  });

  final ActivitySessionConfig config;
  final VoidCallback onResume;
  final VoidCallback onQuit;

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
            AppStrings.sessionPausedTitle,
            textAlign: TextAlign.center,
            style: theme.textStyles.headline,
          ),
          SizedBox(height: theme.spacing.xl),
          PrimaryButton(
            key: SessionHost.resumeKey,
            label: AppStrings.sessionResume,
            icon: AppIconGlyph.play,
            expand: true,
            autofocus: true,
            onPressed: onResume,
          ),
          SizedBox(height: theme.spacing.sm),
          SecondaryButton(
            key: SessionHost.quitKey,
            label: AppStrings.sessionQuit,
            expand: true,
            onPressed: onQuit,
          ),
        ],
      ),
    );
  }
}

class _Finished extends StatelessWidget {
  const _Finished();

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Center(
      child: Text(
        AppStrings.sessionFinishedTitle,
        style: theme.textStyles.headline,
      ),
    );
  }
}
