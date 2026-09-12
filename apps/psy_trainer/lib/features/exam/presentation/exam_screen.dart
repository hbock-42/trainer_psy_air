import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:psy_content/psy_content.dart';
import '../../../core/l10n/l10n_extensions.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/widgets.dart';
import '../../home/presentation/providers/active_module_provider.dart';
import 'exam_resume_card.dart';
import 'providers/exam_blueprints_provider.dart';
import 'providers/exam_realism_options_provider.dart';

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
    final activeModule = ref.watch(activeModuleProvider);

    return AppScaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(theme.spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SectionHeader(
              title: context.l10n.tabExam,
              subtitle: context.l10n.examHomeSubtitle,
              trailing: SecondaryButton(
                key: const Key('exam_home.history'),
                label: context.l10n.examHistoryAction,
                onPressed: () => context.push(AppRoutes.examHistory),
              ),
            ),
            SizedBox(height: theme.spacing.md),
            ModuleSwitch(
              available: activeModule.available,
              selected: activeModule.moduleId,
              onSelected: (moduleId) =>
                  ref.read(activeModuleProvider.notifier).setModule(moduleId),
            ),
            SizedBox(height: theme.spacing.lg),
            const ExamResumeCard(),
            SizedBox(height: theme.spacing.lg),
            const _RealismOptionsPanel(),
            SizedBox(height: theme.spacing.lg),
            switch (blueprints) {
              AsyncData(value: final list) when list.isEmpty => Text(
                context.l10n.examEmptyBlueprints,
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
                context.l10n.examBlueprintsError,
                style: theme.textStyles.body.copyWith(
                  color: theme.colors.textSecondary,
                ),
              ),
              _ => Text(
                context.l10n.examBlueprintsLoading,
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
    final name = blueprint.name.resolve(context.l10n.localeName);
    final description = blueprint.description.resolve(context.l10n.localeName);
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
            context.l10n.examBlueprintMeta(
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
            label: context.l10n.examStartAction,
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
    final label =
        section.title?.resolve(context.l10n.localeName) ?? section.familyId;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: theme.spacing.xs),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: theme.textStyles.body.copyWith(
                color: available ? null : theme.colors.textMuted,
              ),
            ),
          ),
          if (!available) ...[
            SizedBox(width: theme.spacing.xs),
            // Flexible (not a bare Text): a long section title left the
            // Expanded label above no room, and this fixed-width caption
            // used to force the row past 360 dp at 1.3x text (US-123).
            Flexible(
              child: Text(
                context.l10n.examSectionUnavailable,
                textAlign: TextAlign.end,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textStyles.caption.copyWith(
                  color: theme.colors.textMuted,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// US-063 "realism options" panel: toggles applied by `planExamSections`
/// (negative marking, randomised generators), `SessionHost`'s countdown
/// bars (hidden time), `ExamRunController`/`ExamRunScreen` (break pause,
/// immersive chrome, sound cues) once "Commencer" is pressed. Persisted in
/// `UserProfile.settings['exam.realism']` through `examRealismOptionsProvider`
/// (`ExamRealismOptionsController`), so it survives navigating away and
/// applies to every blueprint below.
class _RealismOptionsPanel extends ConsumerWidget {
  const _RealismOptionsPanel();

  static const Key presetKey = Key('exam_realism.preset');
  static const Key negativeMarkingKey = Key('exam_realism.negative_marking');
  static const Key hideRemainingTimeKey = Key(
    'exam_realism.hide_remaining_time',
  );
  static const Key hideTimerEnglishKey = Key('exam_realism.hide_timer_english');
  static const Key randomizeKey = Key('exam_realism.randomize');
  static const Key allowPauseKey = Key('exam_realism.allow_pause');
  static const Key immersiveKey = Key('exam_realism.immersive');
  static const Key soundCuesKey = Key('exam_realism.sound_cues');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppTheme.of(context);
    final options = ref.watch(examRealismOptionsProvider);
    final controller = ref.read(examRealismOptionsProvider.notifier);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(context.l10n.examRealismTitle, style: theme.textStyles.title),
          SizedBox(height: theme.spacing.xs),
          Text(
            context.l10n.examRealismSubtitle,
            style: theme.textStyles.caption,
          ),
          SizedBox(height: theme.spacing.sm),
          SecondaryButton(
            key: _RealismOptionsPanel.presetKey,
            label: context.l10n.examRealismPresetAction,
            expand: true,
            onPressed: () => unawaited(controller.applyRealConditionsPreset()),
          ),
          SizedBox(height: theme.spacing.md),
          _RealismToggleRow(
            toggleKey: _RealismOptionsPanel.negativeMarkingKey,
            label: context.l10n.examRealismNegativeMarkingLabel,
            value: options.negativeMarkingCulture,
            onChanged: (v) =>
                unawaited(controller.setNegativeMarkingCulture(enabled: v)),
          ),
          _RealismToggleRow(
            toggleKey: _RealismOptionsPanel.hideRemainingTimeKey,
            label: context.l10n.examRealismHideRemainingTimeLabel,
            value: options.hideRemainingTime,
            onChanged: (v) =>
                unawaited(controller.setHideRemainingTime(enabled: v)),
          ),
          _RealismToggleRow(
            toggleKey: _RealismOptionsPanel.hideTimerEnglishKey,
            label: context.l10n.examRealismHideTimerEnglishLabel,
            value: options.hideTimerEnglish,
            onChanged: (v) =>
                unawaited(controller.setHideTimerEnglish(enabled: v)),
          ),
          _RealismToggleRow(
            toggleKey: _RealismOptionsPanel.randomizeKey,
            label: context.l10n.examRealismRandomizeLabel,
            value: options.randomizeGenerated,
            onChanged: (v) =>
                unawaited(controller.setRandomizeGenerated(enabled: v)),
          ),
          _RealismToggleRow(
            toggleKey: _RealismOptionsPanel.allowPauseKey,
            label: context.l10n.examRealismAllowPauseLabel,
            value: options.allowPauseBetweenSections,
            onChanged: (v) =>
                unawaited(controller.setAllowPauseBetweenSections(enabled: v)),
          ),
          _RealismToggleRow(
            toggleKey: _RealismOptionsPanel.immersiveKey,
            label: context.l10n.examRealismImmersiveLabel,
            value: options.immersiveFullScreen,
            onChanged: (v) =>
                unawaited(controller.setImmersiveFullScreen(enabled: v)),
          ),
          _RealismToggleRow(
            toggleKey: _RealismOptionsPanel.soundCuesKey,
            label: context.l10n.examRealismSoundCuesLabel,
            value: options.soundCuesEnabled,
            onChanged: (v) =>
                unawaited(controller.setSoundCuesEnabled(enabled: v)),
            isLast: true,
          ),
        ],
      ),
    );
  }
}

/// One boolean setting row of [_RealismOptionsPanel]: label + on/off pills,
/// same layout as `_SettingRow` in `settings_screen.dart`.
class _RealismToggleRow extends StatelessWidget {
  const _RealismToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
    this.toggleKey,
    this.isLast = false,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Key? toggleKey;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : theme.spacing.sm),
      // A Row gives the trailing `SegmentedChoice` an unbounded width (a
      // non-flex Row child is never constrained along the main axis), so
      // its own `Wrap` never gets the chance to wrap its pills onto a
      // second line -- it and a long, localized label used to overflow
      // together at 360 dp / 1.3x text (US-123). A Column, like
      // `_SettingRow` in `settings_screen.dart`, always bounds the pills to
      // the full row width instead.
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: theme.textStyles.body),
          SizedBox(height: theme.spacing.xs),
          SegmentedChoice<bool>(
            key: toggleKey,
            semanticsLabel: label,
            selected: value,
            onSelected: onChanged,
            options: [
              SegmentedOption(value: true, label: context.l10n.settingsSoundOn),
              SegmentedOption(
                value: false,
                label: context.l10n.settingsSoundOff,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
