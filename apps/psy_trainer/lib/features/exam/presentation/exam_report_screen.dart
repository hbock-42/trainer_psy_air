import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n_extensions.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/widgets.dart';
import '../../progress/domain/exam_summary.dart';
import '../../train/domain/engine/engine.dart';
import '../../train/presentation/summary/item_review_text.dart';
import '../domain/exam_pass_thresholds.dart';
import 'providers/exam_report_provider.dart';

/// `/exam/report/:sessionId` (US-062): the global and per-section score,
/// the delta against the previous completed simulation of the same
/// blueprint, a comparison with the (configurable, always labelled
/// "estimation") pass threshold, and the full item-by-item review —
/// reachable from exam history (US-064) and, unchanged, from the Progress
/// tab's `ExamScoreChartCard`.
///
/// Entirely rebuilt from persisted rows (`examReportProvider`): it never
/// depends on `ExamRunController`, so it works the same right after the
/// exam and reopened later from history.
class ExamReportScreen extends ConsumerStatefulWidget {
  const ExamReportScreen({required this.sessionId, super.key});

  final String sessionId;

  static Key itemKey(int sectionIndex, int itemIndex) =>
      Key('exam_report.item.$sectionIndex.$itemIndex');

  @override
  ConsumerState<ExamReportScreen> createState() => _ExamReportScreenState();
}

class _ExamReportScreenState extends ConsumerState<ExamReportScreen> {
  (int, int)? _reviewing;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final data = ref.watch(examReportProvider(widget.sessionId));

    return AppScaffold(
      title: context.l10n.examReportTitle,
      onBack: () {
        if (_reviewing != null) {
          setState(() => _reviewing = null);
        } else {
          context.pop();
        }
      },
      body: switch (data) {
        AsyncData(value: null) => Center(
          child: Text(
            context.l10n.examReportNotFound,
            style: theme.textStyles.body,
          ),
        ),
        AsyncData(value: final report!) =>
          _reviewing != null
              ? _ReviewPanel(
                  outcome: _findOutcome(report, _reviewing!),
                  sectionIndex: _reviewing!.$1,
                  itemIndex: _reviewing!.$2,
                )
              : _ReportBody(
                  report: report,
                  onReview: (sectionIndex, itemIndex) =>
                      setState(() => _reviewing = (sectionIndex, itemIndex)),
                ),
        AsyncError() => Center(
          child: Text(context.l10n.examReportError, style: theme.textStyles.body),
        ),
        _ => Center(child: Text(context.l10n.examReportLoading)),
      },
    );
  }

  static ItemOutcome _findOutcome(ExamReportData report, (int, int) key) {
    final (sectionIndex, itemIndex) = key;
    final section = report.reviewSections.firstWhere(
      (s) => s.sectionIndex == sectionIndex,
    );
    return section.outcomes.firstWhere((o) => o.index == itemIndex);
  }
}

class _ReportBody extends StatelessWidget {
  const _ReportBody({required this.report, required this.onReview});

  final ExamReportData report;
  final void Function(int sectionIndex, int itemIndex) onReview;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final summary = report.summary;
    final threshold = ExamPassThresholds.of(summary.blueprintId);
    final passed = summary.score >= threshold;

    return SingleChildScrollView(
      padding: EdgeInsets.all(theme.spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            report.blueprintName ?? context.l10n.examReportTitle,
            style: theme.textStyles.headline,
          ),
          SizedBox(height: theme.spacing.lg),
          ScoreCard(
            title: context.l10n.examReportGlobalScoreLabel,
            value: '${summary.percent} %',
            subtitle: passed
                ? context.l10n.examReportEstimatedPass((threshold * 100).round())
                : context.l10n.examReportEstimatedFail((threshold * 100).round()),
            delta: summary.deltaVsPrevious == null
                ? null
                : summary.deltaVsPrevious! * 100,
            deltaSuffix: ' pts',
          ),
          SizedBox(height: theme.spacing.lg),
          Text(
            context.l10n.examReportSectionsTitle,
            style: theme.textStyles.title,
          ),
          SizedBox(height: theme.spacing.sm),
          for (final section in summary.sections) ...[
            _SectionCard(
              section: section,
              delta: report.sectionDeltas[section.sectionIndex],
            ),
            SizedBox(height: theme.spacing.sm),
          ],
          SizedBox(height: theme.spacing.lg),
          Text(context.l10n.examReportReviewTitle, style: theme.textStyles.title),
          SizedBox(height: theme.spacing.sm),
          for (final section in report.reviewSections)
            if (section.outcomes.isNotEmpty) ...[
              Text(section.familyId, style: theme.textStyles.label),
              SizedBox(height: theme.spacing.xs),
              for (final outcome in section.outcomes) ...[
                _ItemRow(
                  sectionIndex: section.sectionIndex,
                  outcome: outcome,
                  onTap: () => onReview(section.sectionIndex, outcome.index),
                ),
                SizedBox(height: theme.spacing.xs),
              ],
              SizedBox(height: theme.spacing.sm),
            ],
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.section, this.delta});

  final SectionScore section;

  /// `accuracy - previous.accuracy` of the same section in the previous
  /// completed simulation (US-062); null when there is none.
  final double? delta;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return AppCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(section.familyId, style: theme.textStyles.bodyStrong),
                SizedBox(height: theme.spacing.xs),
                Text(
                  context.l10n.examReportSectionFraction(
                    section.correct,
                    section.attempts,
                    section.unanswered,
                  ),
                  style: theme.textStyles.caption,
                ),
                if (delta != null) ...[
                  SizedBox(height: theme.spacing.xs),
                  Text(
                    ScoreCard.formatDelta(delta! * 100),
                    style: theme.textStyles.caption.copyWith(
                      color: delta! > 0
                          ? theme.colors.success
                          : delta! < 0
                          ? theme.colors.error
                          : theme.colors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Text(
            '${(section.accuracy * 100).round()} %',
            style: theme.textStyles.title,
          ),
        ],
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({
    required this.sectionIndex,
    required this.outcome,
    required this.onTap,
  });

  final int sectionIndex;
  final ItemOutcome outcome;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final ok = outcome.isCorrect;

    return AppCard(
      key: ExamReportScreen.itemKey(sectionIndex, outcome.index),
      onPressed: onTap,
      semanticsLabel: context.l10n.summaryItemLabel(outcome.index + 1),
      padding: EdgeInsets.symmetric(
        horizontal: theme.spacing.md,
        vertical: theme.spacing.sm,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              context.l10n.summaryItemLabel(outcome.index + 1),
              style: theme.textStyles.body,
            ),
          ),
          AppIcon(
            ok ? AppIconGlyph.check : AppIconGlyph.cross,
            color: ok ? colors.success : colors.error,
          ),
        ],
      ),
    );
  }
}

class _ReviewPanel extends StatelessWidget {
  const _ReviewPanel({
    required this.outcome,
    required this.sectionIndex,
    required this.itemIndex,
  });

  final ItemOutcome outcome;
  final int sectionIndex;
  final int itemIndex;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final text = ItemReviewText.of(context, outcome);

    return SingleChildScrollView(
      padding: EdgeInsets.all(theme.spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.l10n.summaryItemLabel(itemIndex + 1),
            style: theme.textStyles.title,
          ),
          SizedBox(height: theme.spacing.md),
          Text(text.stem, style: theme.textStyles.body),
          SizedBox(height: theme.spacing.lg),
          _Field(label: context.l10n.summaryReviewMyAnswer, value: text.myAnswer),
          SizedBox(height: theme.spacing.sm),
          _Field(label: context.l10n.summaryReviewExpected, value: text.expected),
          if (text.explanation != null) ...[
            SizedBox(height: theme.spacing.lg),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.activityExplanationTitle,
                    style: theme.textStyles.label,
                  ),
                  SizedBox(height: theme.spacing.xs),
                  Text(text.explanation!, style: theme.textStyles.body),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textStyles.label),
        SizedBox(height: theme.spacing.xs),
        Text(value, style: theme.textStyles.bodyStrong),
      ],
    );
  }
}
