import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/strings.dart';
import '../../../../core/repositories/model/session.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../domain/exam_summary.dart';
import '../providers/dashboard_labels_provider.dart';
import '../providers/exam_history_provider.dart';
import 'family_trend_charts.dart';
import 'progress_bands.dart';

/// Dashboard section (US-071): the global score of every completed
/// simulation as a line, oldest first; tapping a point expands the
/// per-section breakdown of that attempt under the chart. Renders nothing
/// (no header either) until a simulation has been completed.
class ExamScoreChartCard extends ConsumerWidget {
  const ExamScoreChartCard({required this.labels, super.key});

  final DashboardLabels labels;

  /// Completed simulations of [history] (newest first, as the provider
  /// returns them), oldest first.
  static List<ExamSummary> completedOldestFirst(List<ExamSummary> history) =>
      history.where((e) => e.status == SessionStatus.completed).toList()
        ..sort((a, b) => a.startedAt.compareTo(b.startedAt));

  /// "de 40 % à 70 % sur 3 simulations", the semantics summary.
  static String describe(List<ExamSummary> exams) =>
      AppStrings.examChartSummary(
        exams.first.percent,
        exams.last.percent,
        exams.length,
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(examHistoryProvider).value;
    if (history == null) return const SizedBox.shrink();
    final exams = completedOldestFirst(history);
    if (exams.isEmpty) return const SizedBox.shrink();
    return ExamScoreChart(exams: exams, labels: labels);
  }
}

/// The chart and its breakdown panel, over an already filtered, oldest
/// first list of completed [exams].
class ExamScoreChart extends StatefulWidget {
  const ExamScoreChart({required this.exams, required this.labels, super.key});

  final List<ExamSummary> exams;
  final DashboardLabels labels;

  @override
  State<ExamScoreChart> createState() => _ExamScoreChartState();
}

class _ExamScoreChartState extends State<ExamScoreChart> {
  /// Session id rather than index so a refresh keeps the same attempt open.
  String? _selectedId;

  int? get _selectedIndex {
    final index = widget.exams.indexWhere((e) => e.sessionId == _selectedId);
    return index < 0 ? null : index;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final exams = widget.exams;
    final selectedIndex = _selectedIndex;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SectionHeader(
          title: AppStrings.examChartTitle,
          subtitle: AppStrings.examChartSubtitle,
        ),
        SizedBox(height: theme.spacing.md),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              LineChart(
                semanticsLabel: AppStrings.examChartSemanticsLabel,
                semanticsValue: ExamScoreChartCard.describe(exams),
                yMin: 0,
                yMax: 1,
                yTicks: LineChart.evenTicks(
                  0,
                  1,
                  count: 3,
                  format: (v) =>
                      AppStrings.scorePercent(FamilyTrendCharts.percent(v)),
                ),
                xTicks: [
                  for (final (i, e) in exams.indexed)
                    if (i == 0 || i == exams.length - 1)
                      LineChartTick(
                        i.toDouble(),
                        FamilyTrendCharts.shortDate(e.startedAt),
                      ),
                ],
                series: [
                  LineChartSeries(
                    label: AppStrings.examChartTitle,
                    points: [
                      for (final (i, e) in exams.indexed)
                        LineChartPoint(i.toDouble(), e.score),
                    ],
                  ),
                ],
                selectedX: selectedIndex?.toDouble(),
                tooltipBuilder: (context, hit) => _ExamTooltip(
                  exam: exams[hit.x.round()],
                  number: hit.x.round() + 1,
                ),
                onPointSelected: (hit) => setState(() {
                  final tapped = exams[hit.x.round()].sessionId;
                  _selectedId = tapped == _selectedId ? null : tapped;
                }),
              ),
              SizedBox(height: theme.spacing.sm),
              Text(AppStrings.examChartHint, style: theme.textStyles.caption),
              if (selectedIndex != null) ...[
                SizedBox(height: theme.spacing.lg),
                ExamSectionBreakdown(
                  exam: exams[selectedIndex],
                  labels: widget.labels,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ExamTooltip extends StatelessWidget {
  const _ExamTooltip({required this.exam, required this.number});

  final ExamSummary exam;
  final int number;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return LineChartTooltip(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.examAttempt(number), style: theme.textStyles.label),
          Text(
            FamilyTrendCharts.longDate(exam.startedAt),
            style: theme.textStyles.caption,
          ),
          Text(
            AppStrings.examScoreLine(exam.percent),
            style: theme.textStyles.caption.copyWith(
              color: ProgressBands.score(theme, exam.score),
            ),
          ),
        ],
      ),
    );
  }
}

/// The per-section scores of one simulation as horizontal bars, in section
/// order, painted in the readiness bands.
class ExamSectionBreakdown extends StatelessWidget {
  const ExamSectionBreakdown({
    required this.exam,
    required this.labels,
    super.key,
  });

  final ExamSummary exam;
  final DashboardLabels labels;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final locale = Localizations.maybeLocaleOf(context)?.languageCode ?? 'fr';
    final sections = [...exam.sections]
      ..sort((a, b) => a.sectionIndex.compareTo(b.sectionIndex));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppStrings.examSectionsTitle(
            FamilyTrendCharts.longDate(exam.startedAt),
          ),
          style: theme.textStyles.bodyStrong,
        ),
        SizedBox(height: theme.spacing.md),
        if (sections.isEmpty)
          Text(
            AppStrings.examSectionNotReached,
            style: theme.textStyles.caption,
          )
        else
          HorizontalBarChart(
            semanticsLabel: AppStrings.examSectionsSemanticsLabel,
            entries: [
              for (final s in sections)
                BarChartEntry(
                  label: AppStrings.examSectionLabel(
                    s.sectionIndex + 1,
                    labels.familyName(s.familyId, locale: locale, short: false),
                  ),
                  value: s.accuracy.clamp(0.0, 1.0),
                  valueLabel: s.attempts == 0
                      ? AppStrings.examSectionNotReached
                      : AppStrings.examSectionValue(
                          s.correct,
                          s.attempts,
                          FamilyTrendCharts.percent(s.accuracy),
                        ),
                  color: s.attempts == 0
                      ? theme.colors.textMuted
                      : ProgressBands.score(theme, s.accuracy),
                ),
            ],
          ),
      ],
    );
  }
}
