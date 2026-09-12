import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/strings.dart';
import '../../../../core/repositories/repository_providers.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../engines/english/presentation/english_passage_cache.dart';
import '../engine/engine_registry_provider.dart';
import 'practice_config.dart';
import 'practice_launcher_provider.dart';
import 'practice_session_builder.dart';

/// `/train/family/:familyId` (US-050): configure one family's practice
/// drill — number of items, difficulty, timed on/off — then start it.
///
/// Shows "Bientôt" instead of the controls when the family's engine is not
/// registered yet (a direct link to a family whose engine has not landed):
/// the Train home already hides the tap target, but the route itself stays
/// reachable and must not crash.
class PracticeLauncherScreen extends ConsumerWidget {
  const PracticeLauncherScreen({required this.familyId, super.key});

  final String familyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppTheme.of(context);
    final state = ref.watch(practiceLauncherProvider(familyId));

    return AppScaffold(
      onBack: context.pop,
      title: state.family?.name.resolve(AppStrings.locale),
      body: switch (state.status) {
        PracticeLauncherStatus.notFound => Padding(
          padding: EdgeInsets.all(theme.spacing.lg),
          child: const Text(AppStrings.practiceLauncherNotFound),
        ),
        PracticeLauncherStatus.loading => Padding(
          padding: EdgeInsets.all(theme.spacing.lg),
          child: const Text(AppStrings.trainFamiliesLoading),
        ),
        PracticeLauncherStatus.ready => _LauncherBody(familyId: familyId),
      },
    );
  }
}

class _LauncherBody extends ConsumerWidget {
  const _LauncherBody({required this.familyId});

  final String familyId;

  Future<void> _start(
    BuildContext context,
    WidgetRef ref,
    PracticeConfig config,
  ) async {
    final family = ref.read(practiceLauncherProvider(familyId)).family!;
    final activityConfig = await buildActivitySessionConfig(
      family: family,
      config: config,
      contentRepository: ref.read(contentRepositoryProvider),
      onPassagesLoaded: ref.read(englishPassageCacheProvider).addAll,
    );
    if (!context.mounted) return;
    unawaited(
      context.push(AppRoutes.trainSession('new'), extra: activityConfig),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppTheme.of(context);
    final state = ref.watch(practiceLauncherProvider(familyId));
    final family = state.family!;
    final config = state.config!;
    final notifier = ref.read(practiceLauncherProvider(familyId).notifier);
    final available = ref.watch(
      engineRegistryProvider.select((r) => r.hasFamily(familyId)),
    );

    return SingleChildScrollView(
      padding: EdgeInsets.all(theme.spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!available) ...[
            AppCard(
              child: Text(
                AppStrings.practiceEngineComingSoon,
                style: theme.textStyles.body.copyWith(
                  color: theme.colors.textSecondary,
                ),
              ),
            ),
            SizedBox(height: theme.spacing.lg),
          ],
          Text(
            AppStrings.practiceItemCountLabel,
            style: theme.textStyles.title,
          ),
          SizedBox(height: theme.spacing.sm),
          Wrap(
            spacing: theme.spacing.sm,
            runSpacing: theme.spacing.sm,
            children: [
              for (final choice in PracticeConfig.itemCountChoices)
                _OptionChip(
                  key: ValueKey('item-count-$choice'),
                  label: AppStrings.practiceItemCountOption(choice),
                  selected: config.itemCount == choice,
                  onPressed: available
                      ? () => notifier.setItemCount(choice)
                      : null,
                ),
            ],
          ),
          SizedBox(height: theme.spacing.lg),
          Text(
            AppStrings.practiceDifficultyLabel,
            style: theme.textStyles.title,
          ),
          SizedBox(height: theme.spacing.sm),
          Wrap(
            spacing: theme.spacing.sm,
            runSpacing: theme.spacing.sm,
            children: [
              _OptionChip(
                key: const ValueKey('difficulty-auto'),
                label: AppStrings.practiceDifficultyAuto,
                selected: config.difficulty == null,
                onPressed: available
                    ? () => notifier.setDifficulty(null)
                    : null,
              ),
              for (var level = 1; level <= 5; level++)
                _OptionChip(
                  key: ValueKey('difficulty-$level'),
                  label: AppStrings.practiceDifficultyLevel(level),
                  selected: config.difficulty == level,
                  onPressed: available
                      ? () => notifier.setDifficulty(level)
                      : null,
                ),
            ],
          ),
          SizedBox(height: theme.spacing.lg),
          Text(AppStrings.practiceTimingLabel, style: theme.textStyles.title),
          SizedBox(height: theme.spacing.sm),
          Wrap(
            spacing: theme.spacing.sm,
            runSpacing: theme.spacing.sm,
            children: [
              _OptionChip(
                key: const ValueKey('timing-on'),
                label: AppStrings.practiceTimedOn,
                selected: config.timed,
                onPressed: available
                    ? () => notifier.setTimed(timed: true)
                    : null,
              ),
              _OptionChip(
                key: const ValueKey('timing-off'),
                label: AppStrings.practiceTimedOff,
                selected: !config.timed,
                onPressed: available
                    ? () => notifier.setTimed(timed: false)
                    : null,
              ),
            ],
          ),
          SizedBox(height: theme.spacing.xl),
          PrimaryButton(
            label: AppStrings.practiceStartAction,
            onPressed: available ? () => _start(context, ref, config) : null,
          ),
          SizedBox(height: theme.spacing.sm),
          SecondaryButton(
            label: AppStrings.practiceQuick5Action,
            onPressed: available
                ? () async {
                    final quick5 = await notifier.applyQuick5();
                    if (quick5 == null) return;
                    if (!context.mounted) return;
                    await _start(context, ref, quick5);
                  }
                : null,
          ),
          SizedBox(height: theme.spacing.lg),
          // US-054 hook: re-drilling failed items lands here once it ships.
          const SecondaryButton(label: AppStrings.practiceRetryMistakesSoon),
          SizedBox(height: theme.spacing.xxl),
          Text(
            family.description.resolve(AppStrings.locale),
            style: theme.textStyles.caption,
          ),
        ],
      ),
    );
  }
}

/// A selectable pill, used for the item-count / difficulty / timing choices.
class _OptionChip extends StatelessWidget {
  const _OptionChip({
    required this.label,
    required this.selected,
    required this.onPressed,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    return AppPressable(
      onPressed: onPressed,
      selected: selected,
      semanticsLabel: label,
      excludeSemantics: true,
      minSize: 0,
      builder: (context, state) {
        final background = selected
            ? colors.accentSubtle
            : state.hovered || state.pressed
            ? colors.surfaceRaised
            : colors.surface;
        final border = selected ? colors.accent : colors.border;
        return AppFocusRing(
          visible: state.focused,
          borderRadius: theme.radii.fullAll,
          child: AnimatedContainer(
            duration: theme.durations.fast,
            decoration: BoxDecoration(
              color: state.disabled ? background.disabledOn(theme) : background,
              borderRadius: theme.radii.fullAll,
              border: Border.all(color: border, width: 1.5),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: theme.spacing.md,
              vertical: theme.spacing.sm,
            ),
            child: Text(
              label,
              style: theme.textStyles.label.copyWith(
                color: state.disabled ? colors.textMuted : colors.textPrimary,
              ),
            ),
          ),
        );
      },
    );
  }
}
