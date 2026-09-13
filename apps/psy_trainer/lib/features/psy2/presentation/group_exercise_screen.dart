import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n_extensions.dart';
import '../../../core/repositories/repositories.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/widgets.dart';
import '../../settings/presentation/widgets/plain_text_area.dart';
import '../domain/group_exercise_checklist.dart';
import '../domain/psy2_sessions.dart';
import 'providers/psy2_history_provider.dart';
import 'providers/psy2_lessons_provider.dart';
import 'widgets/rubric_scale.dart';

/// PSY2 group-exercise guide and CRM self-assessment (US-112): the CRM
/// behaviour lessons, the "organise a peer group" guide, and a checklist
/// (6 dimensions x score + notes, plus two reflection prompts) persisted as
/// a `TrainingSession` of family [Psy2SessionFamily.groupExercise] after a
/// mock session.
class GroupExerciseScreen extends ConsumerStatefulWidget {
  const GroupExerciseScreen({super.key});

  @override
  ConsumerState<GroupExerciseScreen> createState() =>
      _GroupExerciseScreenState();
}

class _GroupExerciseScreenState extends ConsumerState<GroupExerciseScreen> {
  CrmDimensionScores _scores = defaultCrmDimensionScores();
  final Map<CrmDimension, TextEditingController> _wentWell = {
    for (final d in CrmDimension.values) d: TextEditingController(),
  };
  final Map<CrmDimension, TextEditingController> _toImprove = {
    for (final d in CrmDimension.values) d: TextEditingController(),
  };
  final TextEditingController _reflection1 = TextEditingController();
  final TextEditingController _reflection2 = TextEditingController();
  bool _saving = false;
  bool _saved = false;

  @override
  void dispose() {
    for (final c in _wentWell.values) {
      c.dispose();
    }
    for (final c in _toImprove.values) {
      c.dispose();
    }
    _reflection1.dispose();
    _reflection2.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) return;
    setState(() => _saving = true);
    final repository = ref.read(progressRepositoryProvider);
    final average = crmDimensionAverage(_scores);
    final session = await repository.startSession(
      mode: SessionMode.practice,
      familyId: Psy2SessionFamily.groupExercise,
      config: {
        'scores': crmDimensionScoresToJson(_scores),
        'wentWell': {
          for (final e in _wentWell.entries) e.key.name: e.value.text,
        },
        'toImprove': {
          for (final e in _toImprove.entries) e.key.name: e.value.text,
        },
        'reflection1': _reflection1.text,
        'reflection2': _reflection2.text,
      },
    );
    await repository.finishSession(
      session.id,
      status: SessionStatus.completed,
      score: average / crmDimensionMaxScore,
    );
    if (!mounted) return;
    ref.invalidate(groupExerciseSessionsProvider);
    setState(() {
      _saving = false;
      _saved = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final lessons = ref.watch(familyLessonsProvider('group_exercise'));

    return AppScaffold(
      title: context.l10n.psy2GroupExerciseTitle,
      onBack: context.pop,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(theme.spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            switch (lessons) {
              AsyncData(value: final list) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final lesson in list) ...[
                    Text(lesson.title.fr, style: theme.textStyles.title),
                    SizedBox(height: theme.spacing.sm),
                    MarkdownView(lesson.body?.fr ?? ''),
                    SizedBox(height: theme.spacing.xl),
                  ],
                ],
              ),
              _ => const SizedBox.shrink(),
            },
            if (_saved)
              AppCard(
                child: Text(
                  context.l10n.psy2GroupExerciseSaved,
                  style: theme.textStyles.bodyStrong,
                ),
              )
            else ...[
              SectionHeader(
                title: context.l10n.psy2GroupExerciseChecklistTitle,
              ),
              SizedBox(height: theme.spacing.md),
              for (final dimension in CrmDimension.values) ...[
                RubricScale<CrmDimension>(
                  criterion: dimension,
                  label: crmDimensionLabel(context, dimension),
                  value: _scores[dimension]!,
                  onChanged: (v) =>
                      setState(() => _scores = {..._scores, dimension: v}),
                ),
                SizedBox(height: theme.spacing.sm),
                Text(
                  context.l10n.psy2GroupExerciseWentWell,
                  style: theme.textStyles.label,
                ),
                SizedBox(height: theme.spacing.xs),
                PlainTextArea(
                  controller: _wentWell[dimension]!,
                  minLines: 2,
                  maxLines: 4,
                  semanticsLabel: context.l10n.psy2GroupExerciseWentWell,
                ),
                SizedBox(height: theme.spacing.sm),
                Text(
                  context.l10n.psy2GroupExerciseToImprove,
                  style: theme.textStyles.label,
                ),
                SizedBox(height: theme.spacing.xs),
                PlainTextArea(
                  controller: _toImprove[dimension]!,
                  minLines: 2,
                  maxLines: 4,
                  semanticsLabel: context.l10n.psy2GroupExerciseToImprove,
                ),
                SizedBox(height: theme.spacing.lg),
              ],
              Text(
                context.l10n.psy2GroupExerciseReflection1,
                style: theme.textStyles.label,
              ),
              SizedBox(height: theme.spacing.xs),
              PlainTextArea(
                controller: _reflection1,
                semanticsLabel: context.l10n.psy2GroupExerciseReflection1,
              ),
              SizedBox(height: theme.spacing.md),
              Text(
                context.l10n.psy2GroupExerciseReflection2,
                style: theme.textStyles.label,
              ),
              SizedBox(height: theme.spacing.xs),
              PlainTextArea(
                controller: _reflection2,
                semanticsLabel: context.l10n.psy2GroupExerciseReflection2,
              ),
              SizedBox(height: theme.spacing.lg),
              PrimaryButton(
                key: const Key('group_exercise.save'),
                label: context.l10n.psy2GroupExerciseSave,
                expand: true,
                onPressed: _saving ? null : _save,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

String crmDimensionLabel(BuildContext context, CrmDimension dimension) =>
    switch (dimension) {
      CrmDimension.communication => context.l10n.psy2DimCommunication,
      CrmDimension.leadership => context.l10n.psy2DimLeadership,
      CrmDimension.situationalAwareness =>
        context.l10n.psy2DimSituationalAwareness,
      CrmDimension.decisionMaking => context.l10n.psy2DimDecisionMaking,
      CrmDimension.workloadManagement => context.l10n.psy2DimWorkloadManagement,
      CrmDimension.teamwork => context.l10n.psy2DimTeamwork,
    };
