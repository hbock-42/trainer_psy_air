import 'dart:async';
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:psy_content/psy_content.dart';

import '../../../core/l10n/l10n_extensions.dart';
import '../../../core/repositories/repositories.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/widgets.dart';
import '../../settings/presentation/widgets/plain_text_area.dart';
import '../../train/domain/engine/engine_clock.dart';
import '../domain/interview_rubric.dart';
import '../domain/psy2_sessions.dart';
import 'providers/interview_questions_provider.dart';
import 'providers/psy2_clock_provider.dart';
import 'providers/psy2_history_provider.dart';
import 'providers/psy2_lessons_provider.dart';
import 'widgets/rubric_scale.dart';

enum _Phase { pickTheme, prep, answering, review, saved }

/// PSY2 interview practice (US-111): pick a theme (or a random question),
/// a 45 s preparation countdown then a 2 min answer countdown, personal
/// notes (text -- no audio recording, see class doc below), then a 5
/// criteria self-assessment rubric persisted as a `TrainingSession` of
/// family [Psy2SessionFamily.interview].
///
/// Audio self-recording (the `record` package) was scoped out: verifying it
/// needs no Material ancestor and builds clean on web/desktop was out of
/// this story's budget, so this screen ships the documented fallback --
/// timers plus a text notes field (`docs/content/psy2-spec.md` §4.1,
/// US-111 card).
class InterviewScreen extends ConsumerStatefulWidget {
  const InterviewScreen({super.key});

  static const Duration prepDuration = Duration(seconds: 45);
  static const Duration answerDuration = Duration(seconds: 120);

  @override
  ConsumerState<InterviewScreen> createState() => _InterviewScreenState();
}

class _InterviewScreenState extends ConsumerState<InterviewScreen> {
  final Random _random = Random();
  final TextEditingController _notesController = TextEditingController();

  _Phase _phase = _Phase.pickTheme;
  InterviewTheme? _selectedTheme;
  InterviewQuestion? _question;
  InterviewRubricScores _scores = defaultInterviewRubricScores();
  bool _showGuidance = false;
  bool _saving = false;

  DateTime? _phaseEndsAt;
  Timer? _ticker;

  @override
  void dispose() {
    _ticker?.cancel();
    _notesController.dispose();
    super.dispose();
  }

  EngineClock get _clock => ref.read(psy2ClockProvider);

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (!mounted) return;
      final endsAt = _phaseEndsAt;
      if (endsAt != null && !_clock.now().isBefore(endsAt)) {
        _advanceFromTimer();
      } else {
        setState(() {});
      }
    });
  }

  void _advanceFromTimer() {
    if (_phase == _Phase.prep) {
      _beginAnswering();
    } else if (_phase == _Phase.answering) {
      _finishAnswering();
    }
  }

  void _pickQuestion(List<InterviewQuestion> pool) {
    final candidates = _selectedTheme == null
        ? pool
        : pool.where((q) => q.theme == _selectedTheme).toList();
    if (candidates.isEmpty) return;
    setState(() {
      _question = candidates[_random.nextInt(candidates.length)];
      _showGuidance = false;
      _notesController.clear();
      _scores = defaultInterviewRubricScores();
      _phase = _Phase.prep;
      _phaseEndsAt = _clock.now().add(InterviewScreen.prepDuration);
    });
    _startTicker();
  }

  void _beginAnswering() {
    setState(() {
      _phase = _Phase.answering;
      _phaseEndsAt = _clock.now().add(InterviewScreen.answerDuration);
    });
  }

  void _finishAnswering() {
    _ticker?.cancel();
    setState(() {
      _phase = _Phase.review;
      _phaseEndsAt = null;
    });
  }

  void _restart() {
    setState(() {
      _phase = _Phase.pickTheme;
      _question = null;
      _phaseEndsAt = null;
    });
  }

  Future<void> _save() async {
    final question = _question;
    if (question == null || _saving) return;
    setState(() => _saving = true);
    final repository = ref.read(progressRepositoryProvider);
    final average = interviewRubricAverage(_scores);
    final session = await repository.startSession(
      mode: SessionMode.practice,
      familyId: Psy2SessionFamily.interview,
      config: {
        'questionId': question.id,
        'theme': question.theme.name,
        'notes': _notesController.text,
        'scores': interviewRubricScoresToJson(_scores),
      },
    );
    await repository.finishSession(
      session.id,
      status: SessionStatus.completed,
      score: average / interviewRubricMaxScore,
    );
    if (!mounted) return;
    ref.invalidate(interviewSessionsProvider);
    setState(() {
      _phase = _Phase.saved;
      _saving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final questions = ref.watch(interviewQuestionsProvider);

    return AppScaffold(
      title: context.l10n.psy2InterviewTitle,
      onBack: context.pop,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(theme.spacing.lg),
        child: switch (questions) {
          AsyncData(value: final list) when list.isEmpty => Text(
            context.l10n.psy2InterviewEmpty,
            style: theme.textStyles.body,
          ),
          AsyncData(value: final list) => _body(context, list),
          AsyncError() => Text(context.l10n.psy2InterviewEmpty),
          _ => const SizedBox.shrink(),
        },
      ),
    );
  }

  Widget _body(BuildContext context, List<InterviewQuestion> pool) {
    return switch (_phase) {
      _Phase.pickTheme => _ThemePicker(
        questions: pool,
        lessons:
            ref.watch(familyLessonsProvider('interview')).value ?? const [],
        selected: _selectedTheme,
        onSelected: (t) => setState(() => _selectedTheme = t),
        onStart: () => _pickQuestion(pool),
      ),
      _Phase.prep || _Phase.answering => _PracticeCard(
        question: _question!,
        phase: _phase,
        remaining: _remaining(),
        total: _phase == _Phase.prep
            ? InterviewScreen.prepDuration
            : InterviewScreen.answerDuration,
        showGuidance: _showGuidance,
        onToggleGuidance: () => setState(() => _showGuidance = !_showGuidance),
        notesController: _notesController,
        onSkip: _phase == _Phase.prep ? _beginAnswering : _finishAnswering,
      ),
      _Phase.review => _ReviewCard(
        scores: _scores,
        onScoreChanged: (criterion, value) =>
            setState(() => _scores = {..._scores, criterion: value}),
        onSave: _save,
        saving: _saving,
      ),
      _Phase.saved => _SavedCard(onRestart: _restart),
    };
  }

  Duration _remaining() {
    final endsAt = _phaseEndsAt;
    if (endsAt == null) return Duration.zero;
    final left = endsAt.difference(_clock.now());
    return left.isNegative ? Duration.zero : left;
  }
}

class _ThemePicker extends StatelessWidget {
  const _ThemePicker({
    required this.questions,
    required this.lessons,
    required this.selected,
    required this.onSelected,
    required this.onStart,
  });

  final List<InterviewQuestion> questions;
  final List<Lesson> lessons;
  final InterviewTheme? selected;
  final ValueChanged<InterviewTheme?> onSelected;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final themes = questions.map((q) => q.theme).toSet().toList()
      ..sort((a, b) => a.index.compareTo(b.index));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(context.l10n.psy2InterviewIntro, style: theme.textStyles.body),
        for (final lesson in lessons) ...[
          SizedBox(height: theme.spacing.lg),
          Text(lesson.title.fr, style: theme.textStyles.title),
          SizedBox(height: theme.spacing.sm),
          MarkdownView(lesson.body?.fr ?? ''),
        ],
        SizedBox(height: theme.spacing.lg),
        SectionHeader(title: context.l10n.psy2InterviewThemeTitle),
        SizedBox(height: theme.spacing.sm),
        SegmentedChoice<InterviewTheme?>(
          key: const Key('interview.theme_picker'),
          semanticsLabel: context.l10n.psy2InterviewThemeTitle,
          selected: selected,
          onSelected: onSelected,
          options: [
            SegmentedOption(
              value: null,
              label: context.l10n.psy2InterviewThemeRandom,
            ),
            for (final t in themes)
              SegmentedOption(value: t, label: interviewThemeLabel(context, t)),
          ],
        ),
        SizedBox(height: theme.spacing.xl),
        PrimaryButton(
          label: context.l10n.psy2InterviewStart,
          expand: true,
          onPressed: onStart,
        ),
      ],
    );
  }
}

class _PracticeCard extends StatelessWidget {
  const _PracticeCard({
    required this.question,
    required this.phase,
    required this.remaining,
    required this.total,
    required this.showGuidance,
    required this.onToggleGuidance,
    required this.notesController,
    required this.onSkip,
  });

  final InterviewQuestion question;
  final _Phase phase;
  final Duration remaining;
  final Duration total;
  final bool showGuidance;
  final VoidCallback onToggleGuidance;
  final TextEditingController notesController;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final isPrep = phase == _Phase.prep;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          interviewThemeLabel(context, question.theme),
          style: theme.textStyles.label,
        ),
        SizedBox(height: theme.spacing.xs),
        Text(question.question.fr, style: theme.textStyles.title),
        SizedBox(height: theme.spacing.lg),
        Semantics(
          label: isPrep
              ? context.l10n.psy2InterviewPrepLabel
              : context.l10n.psy2InterviewAnswerLabel,
          child: CountdownTimerBar(
            key: const Key('interview.timer'),
            remaining: remaining,
            total: total,
          ),
        ),
        SizedBox(height: theme.spacing.sm),
        Text(
          isPrep
              ? context.l10n.psy2InterviewPrepLabel
              : context.l10n.psy2InterviewAnswerLabel,
          style: theme.textStyles.caption,
        ),
        SizedBox(height: theme.spacing.lg),
        SecondaryButton(
          label: showGuidance
              ? context.l10n.psy2InterviewHideGuidance
              : context.l10n.psy2InterviewShowGuidance,
          onPressed: onToggleGuidance,
        ),
        if (showGuidance) ...[
          SizedBox(height: theme.spacing.sm),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.psy2InterviewGuidanceTitle,
                  style: theme.textStyles.bodyStrong,
                ),
                SizedBox(height: theme.spacing.xs),
                Text(question.guidance.fr),
                SizedBox(height: theme.spacing.sm),
                Text(
                  context.l10n.psy2InterviewSkeletonTitle,
                  style: theme.textStyles.bodyStrong,
                ),
                SizedBox(height: theme.spacing.xs),
                Text(question.modelAnswerSkeleton.fr),
              ],
            ),
          ),
        ],
        SizedBox(height: theme.spacing.lg),
        Text(
          context.l10n.psy2InterviewNotesLabel,
          style: theme.textStyles.label,
        ),
        SizedBox(height: theme.spacing.xs),
        PlainTextArea(
          key: const Key('interview.notes'),
          controller: notesController,
          hintText: context.l10n.psy2InterviewNotesHint,
          semanticsLabel: context.l10n.psy2InterviewNotesLabel,
        ),
        SizedBox(height: theme.spacing.lg),
        PrimaryButton(
          key: const Key('interview.skip'),
          label: isPrep
              ? context.l10n.psy2InterviewSkipPrep
              : context.l10n.psy2InterviewFinishAnswer,
          expand: true,
          onPressed: onSkip,
        ),
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({
    required this.scores,
    required this.onScoreChanged,
    required this.onSave,
    required this.saving,
  });

  final InterviewRubricScores scores;
  final void Function(InterviewRubricCriterion, int) onScoreChanged;
  final VoidCallback onSave;
  final bool saving;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(title: context.l10n.psy2InterviewRubricTitle),
        SizedBox(height: theme.spacing.md),
        for (final criterion in InterviewRubricCriterion.values) ...[
          RubricScale<InterviewRubricCriterion>(
            criterion: criterion,
            label: interviewCriterionLabel(context, criterion),
            value: scores[criterion]!,
            onChanged: (v) => onScoreChanged(criterion, v),
          ),
          SizedBox(height: theme.spacing.md),
        ],
        SizedBox(height: theme.spacing.md),
        PrimaryButton(
          key: const Key('interview.save'),
          label: context.l10n.psy2InterviewSave,
          expand: true,
          onPressed: saving ? null : onSave,
        ),
      ],
    );
  }
}

class _SavedCard extends StatelessWidget {
  const _SavedCard({required this.onRestart});

  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppCard(
          child: Text(
            context.l10n.psy2InterviewSaved,
            style: theme.textStyles.bodyStrong,
          ),
        ),
        SizedBox(height: theme.spacing.lg),
        PrimaryButton(
          label: context.l10n.psy2InterviewPracticeAnother,
          expand: true,
          onPressed: onRestart,
        ),
      ],
    );
  }
}

/// FR label of an [InterviewTheme] (public: also used by the history list).
String interviewThemeLabel(BuildContext context, InterviewTheme theme) =>
    switch (theme) {
      InterviewTheme.motivation => context.l10n.psy2ThemeMotivation,
      InterviewTheme.background => context.l10n.psy2ThemeBackground,
      InterviewTheme.crmTeamwork => context.l10n.psy2ThemeCrmTeamwork,
      InterviewTheme.stress => context.l10n.psy2ThemeStress,
      InterviewTheme.selfAwareness => context.l10n.psy2ThemeSelfAwareness,
      InterviewTheme.aviationKnowledge =>
        context.l10n.psy2ThemeAviationKnowledge,
      InterviewTheme.reflective => context.l10n.psy2ThemeReflective,
    };

String interviewCriterionLabel(
  BuildContext context,
  InterviewRubricCriterion criterion,
) => switch (criterion) {
  InterviewRubricCriterion.structure => context.l10n.psy2RubricStructure,
  InterviewRubricCriterion.concreteness => context.l10n.psy2RubricConcreteness,
  InterviewRubricCriterion.selfAwareness =>
    context.l10n.psy2RubricSelfAwareness,
  InterviewRubricCriterion.relevance => context.l10n.psy2RubricRelevance,
  InterviewRubricCriterion.delivery => context.l10n.psy2RubricDelivery,
};
