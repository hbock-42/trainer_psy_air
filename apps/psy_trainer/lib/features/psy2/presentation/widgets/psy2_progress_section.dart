import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/repositories/repositories.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../domain/group_exercise_checklist.dart';
import '../../domain/interview_rubric.dart';
import '../group_exercise_screen.dart' show crmDimensionLabel;
import '../interview_screen.dart' show interviewCriterionLabel;
import '../providers/psy2_history_provider.dart';

/// PSY2 progress (US-111/US-112): history and per-criterion average of the
/// interview self-assessments and the group-exercise CRM checklist, plotted
/// with the same [LineChart]/[HorizontalBarChart] primitives the other
/// families' trend charts use. Renders nothing (no header either) while
/// neither history has any completed session yet, so it never appears for
/// someone who has not tried PSY2.
class Psy2ProgressSection extends ConsumerWidget {
  const Psy2ProgressSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppTheme.of(context);
    final interviewSessions = ref.watch(interviewSessionsProvider).value;
    final groupExerciseSessions = ref
        .watch(groupExerciseSessionsProvider)
        .value;
    final hasInterview = (interviewSessions ?? const []).isNotEmpty;
    final hasGroupExercise = (groupExerciseSessions ?? const []).isNotEmpty;
    if (!hasInterview && !hasGroupExercise) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (hasInterview) ...[
          SectionHeader(
            title: context.l10n.psy2ProgressInterviewTitle,
            subtitle: context.l10n.psy2ProgressInterviewSubtitle,
          ),
          SizedBox(height: theme.spacing.md),
          _InterviewTrend(sessions: interviewSessions!),
          SizedBox(height: theme.spacing.xl),
        ],
        if (hasGroupExercise) ...[
          SectionHeader(
            title: context.l10n.psy2ProgressGroupExerciseTitle,
            subtitle: context.l10n.psy2ProgressGroupExerciseSubtitle,
          ),
          SizedBox(height: theme.spacing.md),
          _GroupExerciseTrend(sessions: groupExerciseSessions!),
          SizedBox(height: theme.spacing.xl),
        ],
      ],
    );
  }
}

class _InterviewTrend extends StatelessWidget {
  const _InterviewTrend({required this.sessions});

  final List<TrainingSession> sessions;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final oldestFirst = sessions.reversed.toList();
    final points = [
      for (final (i, session) in oldestFirst.indexed)
        LineChartPoint(
          i.toDouble(),
          interviewRubricAverage(
                interviewRubricScoresFromJson(session.config['scores']),
              ) /
              interviewRubricMaxScore,
        ),
    ];
    final averages = <InterviewRubricCriterion, double>{
      for (final criterion in InterviewRubricCriterion.values)
        criterion:
            oldestFirst
                .map(
                  (s) => interviewRubricScoresFromJson(
                    s.config['scores'],
                  )[criterion]!,
                )
                .fold<int>(0, (a, b) => a + b) /
            oldestFirst.length /
            interviewRubricMaxScore,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppCard(
          child: LineChart(
            semanticsLabel: context.l10n.psy2ProgressInterviewTitle,
            semanticsValue: '${points.length}',
            yMin: 0,
            yMax: 1,
            series: [
              LineChartSeries(
                label: context.l10n.psy2ProgressInterviewTitle,
                points: points,
              ),
            ],
          ),
        ),
        SizedBox(height: theme.spacing.md),
        AppCard(
          child: HorizontalBarChart(
            semanticsLabel: context.l10n.psy2InterviewRubricTitle,
            entries: [
              for (final criterion in InterviewRubricCriterion.values)
                BarChartEntry(
                  label: interviewCriterionLabel(context, criterion),
                  value: averages[criterion]!,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GroupExerciseTrend extends StatelessWidget {
  const _GroupExerciseTrend({required this.sessions});

  final List<TrainingSession> sessions;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final oldestFirst = sessions.reversed.toList();
    final points = [
      for (final (i, session) in oldestFirst.indexed)
        LineChartPoint(
          i.toDouble(),
          crmDimensionAverage(
                crmDimensionScoresFromJson(session.config['scores']),
              ) /
              crmDimensionMaxScore,
        ),
    ];
    final averages = <CrmDimension, double>{
      for (final dimension in CrmDimension.values)
        dimension:
            oldestFirst
                .map(
                  (s) => crmDimensionScoresFromJson(
                    s.config['scores'],
                  )[dimension]!,
                )
                .fold<int>(0, (a, b) => a + b) /
            oldestFirst.length /
            crmDimensionMaxScore,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppCard(
          child: LineChart(
            semanticsLabel: context.l10n.psy2ProgressGroupExerciseTitle,
            semanticsValue: '${points.length}',
            yMin: 0,
            yMax: 1,
            series: [
              LineChartSeries(
                label: context.l10n.psy2ProgressGroupExerciseTitle,
                points: points,
              ),
            ],
          ),
        ),
        SizedBox(height: theme.spacing.md),
        AppCard(
          child: HorizontalBarChart(
            semanticsLabel: context.l10n.psy2GroupExerciseChecklistTitle,
            entries: [
              for (final dimension in CrmDimension.values)
                BarChartEntry(
                  label: crmDimensionLabel(context, dimension),
                  value: averages[dimension]!,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
