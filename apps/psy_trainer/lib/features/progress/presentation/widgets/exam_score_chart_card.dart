import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_extensions.dart';
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
  static String describe(BuildContext context, List<ExamSummary> exams) =>
      context.l10n.examChartSummary(
        exams.length,
        exams.last.percent,
        exams.first.percent,
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
        SectionHeader(
          title: context.l10n.examChartTitle,
          subtitle: context.l10n.examChartSubtitle,
        ),
        SizedBox(height: theme.spacing.md),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              LineChart(
                semanticsLabel: context.l10n.examChartSemanticsLabel,
                semanticsValue: ExamScoreChartCard.describe(context, exams),
                yMin: 0,
                yMax: 1,
                yTicks: LineChart.evenTicks(
                  0,
                  1,
                  count: 3,
                  format: (v) =>
                      context.l10n.scorePercent(FamilyTrendCharts.percent(v)),
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
                    label: context.l10n.examChartTitle,
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
              Text(context.l10n.examChartHint, style: theme.textStyles.caption),
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
          Text(context.l10n.examAttempt(number), style: theme.textStyles.label),
          Text(
            FamilyTrendCharts.longDate(exam.startedAt),
            style: theme.textStyles.caption,
          ),
          Text(
            context.l10n.examScoreLine(exam.percent),
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
          context.l10n.examSectionsTitle(
            FamilyTrendCharts.longDate(exam.startedAt),
          ),
          style: theme.textStyles.bodyStrong,
        ),
        SizedBox(height: theme.spacing.md),
        if (sections.isEmpty)
          Text(
            context.l10n.examSectionNotReached,
            style: theme.textStyles.caption,
          )
        else
          HorizontalBarChart(
            semanticsLabel: context.l10n.examSectionsSemanticsLabel,
            entries: [
              for (final s in sections)
                BarChartEntry(
                  label: context.l10n.examSectionLabel(
                    s.sectionIndex + 1,
                    labels.familyName(s.familyId, locale: locale, short: false),
                  ),
                  value: s.accuracy.clamp(0.0, 1.0),
                  valueLabel: s.attempts == 0
                      ? context.l10n.examSectionNotReached
                      : context.l10n.examSectionValue(
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
