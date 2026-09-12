import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:psy_content/psy_content.dart';
import '../../../core/l10n/strings.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/widgets.dart';
import 'providers/exam_blueprints_provider.dart';

/// Exam home (`/exam`, US-060/061): the PSY0 blueprints, each with its
/// duration and section count, "Commencer" (`/exam/run/:blueprintId`) and a
/// link to the past simulations (`/exam/history`, US-064).
///
/// Sections whose engine has not landed yet are listed greyed ("non
/// disponible — sera ignorée"): the blueprint still runs, those sections are
/// skipped by the runner (US-061).
class ExamScreen extends ConsumerWidget {
  const ExamScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppTheme.of(context);
    final blueprints = ref.watch(examBlueprintsProvider);

    return AppScaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(theme.spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SectionHeader(
              title: AppStrings.tabExam,
              subtitle: AppStrings.examHomeSubtitle,
              trailing: SecondaryButton(
                key: const Key('exam_home.history'),
                label: AppStrings.examHistoryAction,
                onPressed: () => context.push(AppRoutes.examHistory),
              ),
            ),
            SizedBox(height: theme.spacing.lg),
            switch (blueprints) {
              AsyncData(value: final list) when list.isEmpty => Text(
                AppStrings.examEmptyBlueprints,
                style: theme.textStyles.body.copyWith(
                  color: theme.colors.textSecondary,
                ),
              ),
              AsyncData(value: final list) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final (i, entry) in list.indexed) ...[
                    if (i > 0) SizedBox(height: theme.spacing.md),
                    _BlueprintCard(entry: entry),
                  ],
                ],
              ),
              AsyncError() => Text(
                AppStrings.examBlueprintsError,
                style: theme.textStyles.body.copyWith(
                  color: theme.colors.textSecondary,
                ),
              ),
              _ => Text(
                AppStrings.examBlueprintsLoading,
                style: theme.textStyles.body.copyWith(
                  color: theme.colors.textSecondary,
                ),
              ),
            },
          ],
        ),
      ),
    );
  }
}

class _BlueprintCard extends StatelessWidget {
  const _BlueprintCard({required this.entry});

  final ExamBlueprintEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final blueprint = entry.blueprint;
    final name = blueprint.name.resolve(AppStrings.locale);
    final description = blueprint.description.resolve(AppStrings.locale);
    final minutes = (entry.estimatedDurationSec / 60).round();

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(name, style: theme.textStyles.title),
          SizedBox(height: theme.spacing.xs),
          Text(description, style: theme.textStyles.caption),
          SizedBox(height: theme.spacing.sm),
          Text(
            AppStrings.examBlueprintMeta(
              minutes,
              entry.availableCount,
              entry.totalSections,
            ),
            style: theme.textStyles.bodyStrong,
          ),
          SizedBox(height: theme.spacing.sm),
          for (final (i, section) in blueprint.sections.indexed)
            _SectionRow(
              section: section,
              available: entry.availableSections[i],
            ),
          SizedBox(height: theme.spacing.md),
          PrimaryButton(
            key: Key('exam_home.start.${blueprint.id}'),
            label: AppStrings.examStartAction,
            expand: true,
            onPressed: entry.hasAnySection
                ? () => context.push(AppRoutes.examRun(blueprint.id))
                : null,
          ),
        ],
      ),
    );
  }
}

class _SectionRow extends StatelessWidget {
  const _SectionRow({required this.section, required this.available});

  final ExamSection section;
  final bool available;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final label = section.title?.resolve(AppStrings.locale) ?? section.familyId;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: theme.spacing.xs),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: theme.textStyles.body.copyWith(
                color: available ? null : theme.colors.textMuted,
              ),
            ),
          ),
          if (!available)
            Text(
              AppStrings.examSectionUnavailable,
              style: theme.textStyles.caption.copyWith(
                color: theme.colors.textMuted,
              ),
            ),
        ],
      ),
    );
  }
}
