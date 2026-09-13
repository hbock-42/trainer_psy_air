import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n_extensions.dart';
import '../../../core/repositories/repository_providers.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/widgets.dart';
import '../../home/presentation/providers/active_module_provider.dart';
import 'launcher/practice_config.dart';
import 'launcher/practice_session_builder.dart';
import 'providers/train_families_provider.dart';
import 'renderers/passage_cache.dart';
import 'session/resume_session_card.dart';

/// Train home (`/train`, US-050): the 14 PSY0 families in real-test order.
///
/// Tapping an available family opens its practice launcher
/// (`/train/family/:familyId`); a family whose engine has not landed yet
/// (US-021..036 land independently) shows "Bientôt" and is disabled. Each
/// available row also offers a "Rapide (5)" shortcut that skips the
/// launcher entirely and starts a 5-item, auto-difficulty drill right away.
class TrainScreen extends ConsumerWidget {
  const TrainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppTheme.of(context);
    final families = ref.watch(trainFamiliesProvider);
    final activeModule = ref.watch(activeModuleProvider);

    return AppScaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(theme.spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(context.l10n.tabTrain, style: theme.textStyles.headline),
            SizedBox(height: theme.spacing.xs),
            Text(
              context.l10n.trainFamiliesSubtitle,
              style: theme.textStyles.caption,
            ),
            SizedBox(height: theme.spacing.md),
            ModuleSwitch(
              available: activeModule.available,
              selected: activeModule.moduleId,
              onSelected: (moduleId) =>
                  ref.read(activeModuleProvider.notifier).setModule(moduleId),
            ),
            SizedBox(height: theme.spacing.lg),
            const ResumeSessionCard(),
            switch (families) {
              AsyncData(value: final list) when list.isEmpty => Padding(
                padding: EdgeInsets.symmetric(vertical: theme.spacing.lg),
                child: Text(
                  context.l10n.trainFamiliesEmpty,
                  style: theme.textStyles.body.copyWith(
                    color: theme.colors.textSecondary,
                  ),
                ),
              ),
              AsyncData(value: final list) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final (i, entry) in list.indexed) ...[
                    if (i > 0) SizedBox(height: theme.spacing.sm),
                    _TrainFamilyTile(index: i + 1, entry: entry),
                  ],
                ],
              ),
              AsyncError() => Padding(
                padding: EdgeInsets.symmetric(vertical: theme.spacing.lg),
                child: Text(
                  context.l10n.trainFamiliesError,
                  style: theme.textStyles.body.copyWith(
                    color: theme.colors.textSecondary,
                  ),
                ),
              ),
              _ => Padding(
                padding: EdgeInsets.symmetric(vertical: theme.spacing.lg),
                child: Text(
                  context.l10n.trainFamiliesLoading,
                  style: theme.textStyles.body.copyWith(
                    color: theme.colors.textSecondary,
                  ),
                ),
              ),
            },
          ],
        ),
      ),
    );
  }
}

class _TrainFamilyTile extends ConsumerWidget {
  const _TrainFamilyTile({required this.index, required this.entry});

  final int index;
  final TrainFamilyEntry entry;

  Future<void> _quick5(BuildContext context, WidgetRef ref) async {
    final family = entry.family;
    final config = await buildActivitySessionConfig(
      family: family,
      config: PracticeConfig.quick5(family),
      contentRepository: ref.read(contentRepositoryProvider),
      onPassagesLoaded: ref.read(passageCacheProvider).addAll,
    );
    if (!context.mounted) return;
    unawaited(context.push(AppRoutes.trainSession('new'), extra: config));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final family = entry.family;
    final name = family.name.resolve(context.l10n.localeName);

    return AppCard(
      padding: EdgeInsets.zero,
      onPressed: entry.available
          ? () => context.push(AppRoutes.trainFamily(family.id))
          : null,
      semanticsLabel: entry.available
          ? context.l10n.trainFamilyOpenSemantics(name)
          : context.l10n.trainFamilyComingSoonHint(name),
      child: Padding(
        padding: EdgeInsets.all(theme.spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                _IndexBadge(index: index, dim: !entry.available),
                SizedBox(width: theme.spacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: theme.textStyles.bodyStrong.copyWith(
                          color: entry.available
                              ? colors.textPrimary
                              : colors.textMuted,
                        ),
                      ),
                      if (!entry.available) ...[
                        SizedBox(height: theme.spacing.xs),
                        Text(
                          context.l10n.trainFamilyComingSoon,
                          style: theme.textStyles.caption,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            // A row of its own (rather than beside the name) so a long,
            // localized family name never has to share width with the
            // button: at 360 dp and 1.3x text scale the two used to
            // overflow the card (US-123).
            if (entry.available) ...[
              SizedBox(height: theme.spacing.sm),
              Align(
                alignment: Alignment.centerRight,
                child: SecondaryButton(
                  label: context.l10n.trainQuick5Label,
                  onPressed: () => _quick5(context, ref),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _IndexBadge extends StatelessWidget {
  const _IndexBadge({required this.index, required this.dim});

  final int index;
  final bool dim;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Container(
      width: theme.spacing.xxl,
      height: theme.spacing.xxl,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: dim
            ? theme.colors.accentSubtle.disabledOn(theme)
            : theme.colors.accentSubtle,
        borderRadius: theme.radii.fullAll,
      ),
      child: Text(
        '$index',
        style: theme.textStyles.label.copyWith(
          // `textMuted` on the faded badge background falls just short of
          // the WCAG AA 4.5:1 ratio (4.12:1; `textContrastGuideline`
          // caught it, US-123) -- `textSecondary` clears it comfortably.
          color: dim ? theme.colors.textSecondary : theme.colors.textPrimary,
        ),
      ),
    );
  }
}
