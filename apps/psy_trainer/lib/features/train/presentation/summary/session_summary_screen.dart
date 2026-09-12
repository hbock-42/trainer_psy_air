import 'package:flutter/widgets.dart';

import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../domain/engine/engine.dart';
import 'item_review_text.dart';

/// End-of-drill summary (US-052): score, accuracy, response-time stats,
/// best/worst item, the played items with their verdict, and the three
/// exits — retry mistakes (US-054 stub), same config again, or back.
///
/// Stateful only for which item is under review; every metric is read
/// straight off [result] (`SectionResult` already aggregates mean/median/
/// timeouts, see `Scorer.section`).
class SessionSummaryScreen extends StatefulWidget {
  const SessionSummaryScreen({
    required this.result,
    required this.config,
    required this.onRestart,
    required this.onBack,
    this.onRetryMistakes,
    super.key,
  });

  final SessionResult result;
  final ActivitySessionConfig config;
  final VoidCallback onRestart;
  final VoidCallback onBack;

  /// Null disables the "Refaire les erreurs" button (nothing to retry).
  final VoidCallback? onRetryMistakes;

  static const Key restartKey = Key('session_summary.restart');
  static const Key retryMistakesKey = Key('session_summary.retry_mistakes');
  static const Key backKey = Key('session_summary.back');
  static Key itemKey(int index) => Key('session_summary.item.$index');

  @override
  State<SessionSummaryScreen> createState() => _SessionSummaryScreenState();
}

class _SessionSummaryScreenState extends State<SessionSummaryScreen> {
  int? _reviewing;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final reviewing = _reviewing;
    final title =
        widget.config.title?.resolve(context.l10n.localeName) ??
        widget.config.familyId;

    if (reviewing != null) {
      return AppScaffold(
        title: title,
        onBack: () => setState(() => _reviewing = null),
        body: Padding(
          padding: EdgeInsets.all(theme.spacing.lg),
          child: _ReviewPanel(
            outcome: widget.result.outcomes[reviewing],
            index: reviewing,
          ),
        ),
      );
    }

    return AppScaffold(
      title: context.l10n.summaryTitle,
      onBack: widget.onBack,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(theme.spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: theme.textStyles.headline),
            if (widget.result.levelChanges.isNotEmpty) ...[
              SizedBox(height: theme.spacing.xs),
              Text(
                context.l10n.summaryLevelChangeLabel(
                  widget.result.levelChanges.first.from,
                  widget.result.levelChanges.last.to,
                ),
                style: theme.textStyles.caption,
              ),
            ],
            SizedBox(height: theme.spacing.lg),
            _MetricGrid(result: widget.result),
            SizedBox(height: theme.spacing.lg),
            Text(context.l10n.summaryItemsTitle, style: theme.textStyles.title),
            SizedBox(height: theme.spacing.sm),
            for (final outcome in widget.result.outcomes) ...[
              if (outcome.index > 0) SizedBox(height: theme.spacing.sm),
              _ItemRow(
                outcome: outcome,
                onTap: () => setState(() => _reviewing = outcome.index),
              ),
            ],
            SizedBox(height: theme.spacing.xl),
            PrimaryButton(
              key: SessionSummaryScreen.restartKey,
              label: context.l10n.summaryRestartAction,
              expand: true,
              onPressed: widget.onRestart,
            ),
            SizedBox(height: theme.spacing.sm),
            SecondaryButton(
              key: SessionSummaryScreen.retryMistakesKey,
              label: context.l10n.summaryRetryMistakesAction,
              expand: true,
              onPressed: widget.onRetryMistakes,
            ),
            SizedBox(height: theme.spacing.sm),
            SecondaryButton(
              key: SessionSummaryScreen.backKey,
              label: context.l10n.summaryBackAction,
              expand: true,
              onPressed: widget.onBack,
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricGrid extends StatelessWidget {
  const _MetricGrid({required this.result});

  final SessionResult result;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final section = result.section;
    final highlights = _Highlights.of(result.outcomes);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: theme.spacing.sm,
          runSpacing: theme.spacing.sm,
          children: [
            SizedBox(
              width: 160,
              child: ScoreCard(
                title: context.l10n.summaryAccuracyLabel,
                value: '${(section.accuracy * 100).round()} %',
                subtitle: context.l10n.summaryScoreFraction(
                  section.correct,
                  section.played,
                ),
              ),
            ),
            SizedBox(
              width: 160,
              child: ScoreCard(
                title: context.l10n.summaryMeanRtLabel,
                value: _formatMs(section.meanResponseMs),
              ),
            ),
            SizedBox(
              width: 160,
              child: ScoreCard(
                title: context.l10n.summaryMedianRtLabel,
                value: _formatMs(section.medianResponseMs),
              ),
            ),
            SizedBox(
              width: 160,
              child: ScoreCard(
                title: context.l10n.summaryTimeoutsLabel,
                value: '${section.timeouts}',
              ),
            ),
          ],
        ),
        if (highlights.best != null || highlights.worst != null) ...[
          SizedBox(height: theme.spacing.sm),
          if (highlights.best != null)
            Text(
              context.l10n.summaryBestItemLabel(highlights.best!.index + 1),
              style: theme.textStyles.caption,
            ),
          if (highlights.worst != null)
            Text(
              context.l10n.summaryWorstItemLabel(highlights.worst!.index + 1),
              style: theme.textStyles.caption,
            ),
        ],
      ],
    );
  }

  static String _formatMs(double? ms) =>
      ms == null ? '—' : '${(ms / 1000).toStringAsFixed(1)} s';
}

/// Fastest correct answer and the item most worth reworking (the slowest
/// wrong/timed-out one, or — if every answer was correct — the slowest of
/// all).
class _Highlights {
  const _Highlights({this.best, this.worst});

  factory _Highlights.of(List<ItemOutcome> outcomes) {
    ItemOutcome? best;
    ItemOutcome? worst;
    for (final outcome in outcomes) {
      if (outcome.isCorrect) {
        if (best == null || outcome.responseMs < best.responseMs) {
          best = outcome;
        }
      } else {
        if (worst == null || outcome.responseMs > worst.responseMs) {
          worst = outcome;
        }
      }
    }
    if (worst == null && outcomes.isNotEmpty) {
      worst = outcomes.reduce((a, b) => a.responseMs >= b.responseMs ? a : b);
    }
    return _Highlights(best: best, worst: worst);
  }

  final ItemOutcome? best;
  final ItemOutcome? worst;
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({required this.outcome, required this.onTap});

  final ItemOutcome outcome;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final ok = outcome.isCorrect;
    final label = ok
        ? context.l10n.summaryItemCorrectSemantics(outcome.index + 1)
        : context.l10n.summaryItemWrongSemantics(outcome.index + 1);

    return AppCard(
      key: SessionSummaryScreen.itemKey(outcome.index),
      onPressed: onTap,
      semanticsLabel: label,
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
  const _ReviewPanel({required this.outcome, required this.index});

  final ItemOutcome outcome;
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final text = ItemReviewText.of(context, outcome);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.l10n.summaryItemLabel(index + 1),
            style: theme.textStyles.title,
          ),
          SizedBox(height: theme.spacing.md),
          Text(text.stem, style: theme.textStyles.body),
          SizedBox(height: theme.spacing.lg),
          _Field(
            label: context.l10n.summaryReviewMyAnswer,
            value: text.myAnswer,
          ),
          SizedBox(height: theme.spacing.sm),
          _Field(
            label: context.l10n.summaryReviewExpected,
            value: text.expected,
          ),
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
