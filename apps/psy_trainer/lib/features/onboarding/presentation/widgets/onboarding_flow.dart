import 'package:flutter/widgets.dart';

import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../domain/exam_date_rules.dart';
import '../../domain/onboarding_answers.dart';
import '../../domain/target_stage.dart';
import 'exam_date_step.dart';
import 'target_stage_step.dart';
import 'welcome_step.dart';

/// The three onboarding steps (disclaimer, exam date, target stage) as one
/// sequential flow, reused by the first-run screen and by "edit my profile"
/// in Settings.
///
/// Pure UI: the answers are handed to [onSubmit], which persists them. The
/// disclaimer step cannot be skipped; from step 2 on, a "Skip" action
/// submits [OnboardingAnswers.skipped] (first run only, [initial] == null).
class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({
    required this.onSubmit,
    this.initial,
    this.onExit,
    this.title,
    this.clock = DateTime.now,
    super.key,
  });

  /// Number of steps, for the progress indicator.
  static const int stepCount = 3;

  /// Answers to prefill (editing); null on first run.
  final OnboardingAnswers? initial;

  /// Receives the final answers. The flow shows nothing after this: the
  /// caller navigates away when the future completes.
  final Future<void> Function(OnboardingAnswers answers) onSubmit;

  /// Back from the first step (editing only); null hides the chevron there.
  final VoidCallback? onExit;

  /// Top bar title; defaults to the onboarding title.
  final String? title;

  /// Source of "now" for the date suggestion and validation (tests).
  final DateTime Function() clock;

  bool get isEditing => initial != null;

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  int _step = 0;
  late bool _accepted = widget.isEditing;
  late DateTime? _acceptedAt = widget.initial?.disclaimerAcceptedAt;

  /// The date shown in the stepper (kept when the user goes back).
  late DateTime _draftDate =
      widget.initial?.examDate ?? nextPsy0Date(widget.clock());

  /// The chosen date; null for "I don't know yet".
  late DateTime? _examDate = widget.initial?.examDate;
  late TargetStage _stage =
      widget.initial?.targetStage ?? TargetStage.defaultStage;
  bool _submitting = false;

  void _goTo(int step) => setState(() => _step = step);

  void _onAcceptedChanged(bool value) {
    setState(() {
      _accepted = value;
      if (value) _acceptedAt ??= widget.clock().toUtc();
    });
  }

  void _onExamDateChosen(DateTime? date) {
    setState(() {
      _draftDate = date ?? _draftDate;
      _examDate = date;
      _step = 2;
    });
  }

  Future<void> _submit(OnboardingAnswers answers) async {
    if (_submitting) return;
    setState(() => _submitting = true);
    try {
      await widget.onSubmit(answers);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _finish() => _submit(
    OnboardingAnswers(
      disclaimerAcceptedAt: _acceptedAt!,
      examDate: _examDate,
      targetStage: _stage,
    ),
  );

  Future<void> _skip() =>
      _submit(OnboardingAnswers.skipped(disclaimerAcceptedAt: _acceptedAt!));

  VoidCallback? get _onBack {
    if (_step > 0) return () => _goTo(_step - 1);
    return widget.onExit;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    final Widget step = switch (_step) {
      0 => WelcomeStep(
        key: const ValueKey(0),
        accepted: _accepted,
        onAcceptedChanged: _onAcceptedChanged,
        onContinue: () => _goTo(1),
      ),
      1 => ExamDateStep(
        key: const ValueKey(1),
        date: _draftDate,
        now: widget.clock(),
        onDateChanged: (date) => setState(() => _draftDate = date),
        onContinue: _onExamDateChosen,
        onUnknown: () => _onExamDateChosen(null),
      ),
      _ => TargetStageStep(
        key: const ValueKey(2),
        selected: _stage,
        onSelected: (stage) => setState(() => _stage = stage),
        onFinish: _submitting ? null : _finish,
        finishLabel: widget.isEditing
            ? context.l10n.actionSave
            : context.l10n.actionFinish,
      ),
    };

    return AppScaffold(
      title:
          widget.title ??
          (widget.isEditing
              ? context.l10n.onboardingEditTitle
              : context.l10n.onboardingTitle),
      onBack: _onBack,
      actions: [
        if (!widget.isEditing && _step > 0)
          Padding(
            padding: EdgeInsets.only(right: theme.spacing.sm),
            child: SecondaryButton(
              label: context.l10n.actionSkip,
              onPressed: _submitting ? null : _skip,
            ),
          ),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: theme.spacing.sm),
            child: Semantics(
              label: context.l10n.onboardingStepLabel(
                _step + 1,
                OnboardingFlow.stepCount,
              ),
              excludeSemantics: true,
              child: ProgressDots(
                current: _step + 1,
                total: OnboardingFlow.stepCount,
              ),
            ),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: theme.durations.normal,
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              child: step,
            ),
          ),
        ],
      ),
    );
  }
}
