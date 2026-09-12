import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:psy_content/psy_content.dart';
import '../../../core/l10n/l10n_extensions.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/widgets.dart';
import '../../home/presentation/providers/active_module_provider.dart';
import '../../progress/presentation/providers/exam_date_provider.dart';
import '../../progress/presentation/widgets/readiness_card.dart'
    show ExamCountdownChip;
import 'providers/flashcards_queue_provider.dart';
import 'providers/psy0_families_provider.dart';
import 'widgets/family_card.dart';

/// Learn home (US-040): the PSY0 activities at a glance.
///
/// Header (app name + unofficial-trainer disclaimer, spec §7), a card to the
/// "how the selection works" page, then one [FamilyCard] per PSY0 family in
/// real-test order. Families come from the content repository; before the
/// bundle is seeded (US-013) the list is empty and a designed empty state
/// takes its place.
///
/// Layout: one column on phones, two columns when the window is at least
/// [twoColumnBreakpoint] wide (the same breakpoint that switches the tab bar
/// to a rail), content capped at [maxContentWidth].
class LearnScreen extends ConsumerStatefulWidget {
  const LearnScreen({super.key});

  /// Window width from which family cards are laid out in two columns.
  static const double twoColumnBreakpoint = AppTabBar.railBreakpoint;

  /// Widest the content column gets on desktop.
  static const double maxContentWidth = 1100;

  @override
  ConsumerState<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends ConsumerState<LearnScreen> {
  bool _disclaimerExpanded = false;

  void _openFamily(TestFamily family) =>
      context.push(AppRoutes.learnFamily(family.id));

  void _openTrain() => context.go(AppRoutes.train);

  void _openHowItWorks() => context.push(AppRoutes.learnHowItWorks);

  void _openCards() => context.push(AppRoutes.learnCards);

  void _openProfile() => context.push(AppRoutes.settingsProfile);

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final families = ref.watch(psy0FamiliesProvider);
    final activeModule = ref.watch(activeModuleProvider);
    final dueToday = ref.watch(flashcardsDueTodayProvider).value ?? 0;
    final examDate = ref.watch(examDateProvider).value;
    final examDaysLeft = examDate == null
        ? null
        : daysUntil(examDate, DateTime.now());
    final twoColumns =
        MediaQuery.sizeOf(context).width >= LearnScreen.twoColumnBreakpoint;

    return AppScaffold(
      // The scroll view spans the whole body and the width cap sits inside
      // it, so scrolling works from the margins of a wide window too.
      // A Column in a scroll view rather than a lazy ListView: the page
      // holds at most ~15 cards and eager building keeps the whole list
      // measurable (tests, semantics) at no visible cost.
      body: SingleChildScrollView(
        padding: EdgeInsets.all(theme.spacing.lg),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: LearnScreen.maxContentWidth,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Header(
                  expanded: _disclaimerExpanded,
                  onToggle: () => setState(
                    () => _disclaimerExpanded = !_disclaimerExpanded,
                  ),
                  examDaysLeft: examDaysLeft,
                  onExamTap: _openProfile,
                ),
                SizedBox(height: theme.spacing.lg),
                ModuleSwitch(
                  available: activeModule.available,
                  selected: activeModule.moduleId,
                  onSelected: (moduleId) => ref
                      .read(activeModuleProvider.notifier)
                      .setModule(moduleId),
                ),
                SizedBox(height: theme.spacing.xl),
                _HowItWorksCard(onPressed: _openHowItWorks),
                if (dueToday > 0) ...[
                  SizedBox(height: theme.spacing.xl),
                  _FlashcardsDueCard(due: dueToday, onPressed: _openCards),
                ],
                SizedBox(height: theme.spacing.xl),
                SectionHeader(
                  title: context.l10n.learnFamiliesTitle,
                  subtitle: context.l10n.learnFamiliesSubtitle,
                ),
                SizedBox(height: theme.spacing.md),
                switch (families) {
                  AsyncData(value: final list) when list.isEmpty =>
                    const _EmptyState(),
                  AsyncData(value: final list) => _FamilyGrid(
                    families: list,
                    twoColumns: twoColumns,
                    onLearn: _openFamily,
                    onTrain: _openTrain,
                  ),
                  AsyncError() => _Message(context.l10n.learnFamiliesError),
                  _ => _Message(context.l10n.learnFamiliesLoading),
                },
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// App name, short disclaimer and the expandable full disclaimer (spec §7).
class _Header extends StatelessWidget {
  const _Header({
    required this.expanded,
    required this.onToggle,
    required this.examDaysLeft,
    required this.onExamTap,
  });

  final bool expanded;
  final VoidCallback onToggle;

  /// Whole days until the exam date, or `null` to hide the countdown chip
  /// (US-093; reuses `examDateProvider`/`daysUntil`, same as the dashboard's
  /// `ReadinessCard`).
  final int? examDaysLeft;
  final VoidCallback onExamTap;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Semantics(
                header: true,
                child: Text(
                  context.l10n.appName,
                  style: theme.textStyles.headline,
                ),
              ),
            ),
            if (examDaysLeft != null) ...[
              SizedBox(width: theme.spacing.sm),
              AppPressable(
                key: const Key('learn.exam_countdown_chip'),
                onPressed: onExamTap,
                semanticsLabel: context.l10n.examDateSemanticsLabel,
                builder: (context, state) =>
                    ExamCountdownChip(daysLeft: examDaysLeft!),
              ),
            ],
          ],
        ),
        SizedBox(height: theme.spacing.sm),
        Text(context.l10n.disclaimerShort, style: theme.textStyles.caption),
        SizedBox(height: theme.spacing.xs),
        _LinkButton(
          label: expanded
              ? context.l10n.learnDisclaimerCollapse
              : context.l10n.learnDisclaimerExpand,
          onPressed: onToggle,
        ),
        if (expanded) ...[
          SizedBox(height: theme.spacing.sm),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.disclaimerTitle,
                  style: theme.textStyles.bodyStrong,
                ),
                SizedBox(height: theme.spacing.sm),
                Text(context.l10n.disclaimerParagraph1),
                SizedBox(height: theme.spacing.sm),
                Text(context.l10n.disclaimerParagraph2),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

/// Underlined text action, for inline links (no button chrome).
class _LinkButton extends StatelessWidget {
  const _LinkButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: AppPressable(
        onPressed: onPressed,
        semanticsLabel: label,
        excludeSemantics: true,
        // No `minSize: 0` override: the design system's own rule is a
        // 48x48 minimum hit target for every interactive widget
        // (`androidTapTargetGuideline` caught the 26 dp-tall link, US-123).
        // The extra hit area is invisible padding, not a visual change.
        builder: (context, state) => AppFocusRing(
          visible: state.focused,
          borderRadius: theme.radii.smAll,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: theme.spacing.xs),
            child: Text(
              label,
              style: theme.textStyles.label.copyWith(
                color: state.hovered || state.pressed
                    ? theme.colors.accent
                    : theme.colors.textPrimary,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Entry to the "how the selection works" page.
class _HowItWorksCard extends StatelessWidget {
  const _HowItWorksCard({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return AppCard(
      onPressed: onPressed,
      semanticsLabel: context.l10n.learnHowItWorksSemantics,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.learnHowItWorksTitle,
                  style: theme.textStyles.title,
                ),
                SizedBox(height: theme.spacing.xs),
                Text(
                  context.l10n.learnHowItWorksSubtitle,
                  style: theme.textStyles.body.copyWith(
                    color: theme.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: theme.spacing.sm),
          AppIcon(
            AppIconGlyph.chevronRight,
            size: 20,
            color: theme.colors.textMuted,
          ),
        ],
      ),
    );
  }
}

/// "À réviser aujourd'hui" entry (US-042): the flashcards due across every
/// deck. Only rendered by the parent when [due] is positive (no deck seeded
/// yet, or every card up to date, both hide the whole card so the layout
/// below never shifts for nothing).
class _FlashcardsDueCard extends StatelessWidget {
  const _FlashcardsDueCard({required this.due, required this.onPressed});

  final int due;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return AppCard(
      onPressed: onPressed,
      semanticsLabel: context.l10n.flashcardsHomeSemantics,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.flashcardsHomeTitle,
                  style: theme.textStyles.title,
                ),
                SizedBox(height: theme.spacing.xs),
                Text(
                  context.l10n.flashcardsHomeCount(due),
                  style: theme.textStyles.body.copyWith(
                    color: theme.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: theme.spacing.sm),
          AppIcon(
            AppIconGlyph.chevronRight,
            size: 20,
            color: theme.colors.textMuted,
          ),
        ],
      ),
    );
  }
}

/// The family cards: a single column, or rows of two on wide windows.
class _FamilyGrid extends StatelessWidget {
  const _FamilyGrid({
    required this.families,
    required this.twoColumns,
    required this.onLearn,
    required this.onTrain,
  });

  final List<TestFamily> families;
  final bool twoColumns;
  final ValueChanged<TestFamily> onLearn;
  final VoidCallback onTrain;

  Widget _card(TestFamily family, int index) => FamilyCard(
    key: ValueKey('family-card-${family.id}'),
    family: family,
    index: index + 1,
    onLearn: () => onLearn(family),
    onTrain: onTrain,
  );

  @override
  Widget build(BuildContext context) {
    final gap = AppTheme.of(context).spacing.md;
    if (!twoColumns) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (i, family) in families.indexed) ...[
            if (i > 0) SizedBox(height: gap),
            _card(family, i),
          ],
        ],
      );
    }
    final rows = <Widget>[];
    for (var i = 0; i < families.length; i += 2) {
      final left = _card(families[i], i);
      final right = i + 1 < families.length
          ? _card(families[i + 1], i + 1)
          : const SizedBox.shrink();
      if (i > 0) rows.add(SizedBox(height: gap));
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: left),
              SizedBox(width: gap),
              Expanded(child: right),
            ],
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: rows,
    );
  }
}

/// Shown while no family is seeded (before US-013 or after a failed seed).
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppIcon(
                AppIconGlyph.book,
                size: 28,
                color: theme.colors.textMuted,
              ),
              SizedBox(width: theme.spacing.md),
              Expanded(
                child: Text(
                  context.l10n.learnEmptyTitle,
                  style: theme.textStyles.title,
                ),
              ),
            ],
          ),
          SizedBox(height: theme.spacing.sm),
          Text(
            context.l10n.learnEmptyBody,
            style: theme.textStyles.body.copyWith(
              color: theme.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Loading / error line under the section header.
class _Message extends StatelessWidget {
  const _Message(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: theme.spacing.lg),
      child: Text(
        text,
        style: theme.textStyles.body.copyWith(
          color: theme.colors.textSecondary,
        ),
      ),
    );
  }
}
