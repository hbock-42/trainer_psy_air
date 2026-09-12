import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n_extensions.dart';
import '../../../core/notifications/reminder_scheduler_provider.dart';
import '../../../core/repositories/repositories.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/widgets.dart';
import '../../onboarding/domain/onboarding_answers.dart';
import '../../onboarding/presentation/providers/onboarding_answers_provider.dart';
import '../../onboarding/presentation/providers/onboarding_completed_provider.dart';
import '../../progress/domain/daily_goal.dart';
import '../../progress/presentation/providers/daily_goal_provider.dart';
import '../domain/app_settings.dart';
import 'providers/app_settings_provider.dart';
import 'providers/reminder_settings_provider.dart';
import 'widgets/backup_section.dart';
import 'widgets/time_stepper_field.dart';

/// The Settings tab (US-091): profile summary, appearance (theme/language),
/// sound, keypad layout, "reset all data" (double confirmation) and About.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  /// Exposed for the widget test: the key of the first "reset" button
  /// (opens the first confirmation overlay).
  static const Key resetActionKey = Key('settings.reset_action');

  /// The first overlay's confirm button (moves to the second warning).
  static const Key resetConfirm1Key = Key('settings.reset_confirm_1');

  /// The second (final) overlay's confirm button.
  static const Key resetConfirm2Key = Key('settings.reset_confirm_2');

  /// Either overlay's cancel button.
  static const Key resetCancelKey = Key('settings.reset_cancel');

  /// The screen's outer scroll view — the backup section's paste field
  /// (US-074) owns its own inner `Scrollable`, so a widget test scrolling
  /// to a key further down must disambiguate against this one.
  static const Key scrollKey = Key('settings.scroll');

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

enum _ResetStep { none, confirm1, confirm2 }

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  _ResetStep _resetStep = _ResetStep.none;

  Future<void> _confirmReset() async {
    await ref.read(progressRepositoryProvider).clearAll();
    ref.invalidate(appSettingsProvider);
    ref.invalidate(onboardingAnswersProvider);
    ref.read(onboardingCompletedProvider.notifier).reset();
    if (mounted) setState(() => _resetStep = _ResetStep.none);
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final answers = ref.watch(onboardingAnswersProvider);
    final settings = ref.watch(appSettingsProvider);
    final controller = ref.read(appSettingsProvider.notifier);
    final goal = ref.watch(dailyGoalProvider);
    final goalController = ref.read(dailyGoalProvider.notifier);

    return Stack(
      children: [
        AppScaffold(
          title: context.l10n.tabSettings,
          bodyPadding: EdgeInsets.all(theme.spacing.lg),
          body: ListView(
            key: SettingsScreen.scrollKey,
            children: [
              _ProfileSummary(answers: answers.value),
              SizedBox(height: theme.spacing.md),
              SecondaryButton(
                label: context.l10n.settingsEditProfile,
                expand: true,
                onPressed: () => context.go(AppRoutes.settingsProfile),
              ),
              SizedBox(height: theme.spacing.xl),
              SectionHeader(title: context.l10n.settingsSectionAppearance),
              SizedBox(height: theme.spacing.sm),
              _SettingRow(
                label: context.l10n.settingsThemeLabel,
                child: SegmentedChoice<ThemeModePreference>(
                  semanticsLabel: context.l10n.settingsThemeLabel,
                  selected: settings.themeMode,
                  onSelected: controller.setThemeMode,
                  options: [
                    SegmentedOption(
                      value: ThemeModePreference.system,
                      label: context.l10n.settingsThemeSystem,
                    ),
                    SegmentedOption(
                      value: ThemeModePreference.light,
                      label: context.l10n.settingsThemeLight,
                    ),
                    SegmentedOption(
                      value: ThemeModePreference.dark,
                      label: context.l10n.settingsThemeDark,
                    ),
                  ],
                ),
              ),
              SizedBox(height: theme.spacing.md),
              _SettingRow(
                label: context.l10n.settingsLanguageLabel,
                child: SegmentedChoice<LanguagePreference>(
                  semanticsLabel: context.l10n.settingsLanguageLabel,
                  selected: settings.language,
                  onSelected: controller.setLanguage,
                  options: [
                    SegmentedOption(
                      value: LanguagePreference.system,
                      label: context.l10n.settingsLanguageSystem,
                    ),
                    SegmentedOption(
                      value: LanguagePreference.fr,
                      label: context.l10n.settingsLanguageFr,
                    ),
                    SegmentedOption(
                      value: LanguagePreference.en,
                      label: context.l10n.settingsLanguageEn,
                    ),
                  ],
                ),
              ),
              SizedBox(height: theme.spacing.md),
              _SettingRow(
                label: context.l10n.settingsSoundLabel,
                child: SegmentedChoice<bool>(
                  semanticsLabel: context.l10n.settingsSoundLabel,
                  selected: settings.soundEnabled,
                  onSelected: (enabled) =>
                      controller.setSoundEnabled(enabled: enabled),
                  options: [
                    SegmentedOption(
                      value: true,
                      label: context.l10n.settingsSoundOn,
                    ),
                    SegmentedOption(
                      value: false,
                      label: context.l10n.settingsSoundOff,
                    ),
                  ],
                ),
              ),
              SizedBox(height: theme.spacing.md),
              _SettingRow(
                label: context.l10n.settingsKeypadLabel,
                child: SegmentedChoice<KeypadLayout>(
                  semanticsLabel: context.l10n.settingsKeypadLabel,
                  selected: settings.keypadLayout,
                  onSelected: controller.setKeypadLayout,
                  options: [
                    SegmentedOption(
                      value: KeypadLayout.phone,
                      label: context.l10n.settingsKeypadPhone,
                    ),
                    SegmentedOption(
                      value: KeypadLayout.calculator,
                      label: context.l10n.settingsKeypadCalculator,
                    ),
                  ],
                ),
              ),
              SizedBox(height: theme.spacing.xl),
              const _ReminderSection(),
              SizedBox(height: theme.spacing.xl),
              SectionHeader(title: context.l10n.settingsSectionGoal),
              SizedBox(height: theme.spacing.sm),
              _SettingRow(
                label: context.l10n.settingsGoalTargetLabel,
                child: SegmentedChoice<int>(
                  semanticsLabel: context.l10n.settingsGoalTargetLabel,
                  selected: goal.target,
                  onSelected: goalController.setTarget,
                  options: [
                    for (final preset
                        in goal.unit == GoalUnit.items
                            ? DailyGoal.itemPresets
                            : DailyGoal.minutePresets)
                      SegmentedOption(value: preset, label: '$preset'),
                  ],
                ),
              ),
              SizedBox(height: theme.spacing.md),
              _SettingRow(
                label: context.l10n.settingsGoalUnitLabel,
                child: SegmentedChoice<GoalUnit>(
                  semanticsLabel: context.l10n.settingsGoalUnitLabel,
                  selected: goal.unit,
                  onSelected: (unit) async {
                    await goalController.setUnit(unit);
                    // Land on a preset valid for the new unit.
                    final presets = unit == GoalUnit.items
                        ? DailyGoal.itemPresets
                        : DailyGoal.minutePresets;
                    if (!presets.contains(goal.target)) {
                      await goalController.setTarget(presets.first);
                    }
                  },
                  options: [
                    SegmentedOption(
                      value: GoalUnit.items,
                      label: context.l10n.settingsGoalUnitItems,
                    ),
                    SegmentedOption(
                      value: GoalUnit.minutes,
                      label: context.l10n.settingsGoalUnitMinutes,
                    ),
                  ],
                ),
              ),
              SizedBox(height: theme.spacing.xl),
              SectionHeader(title: context.l10n.settingsSectionBackup),
              SizedBox(height: theme.spacing.sm),
              const BackupSection(),
              SizedBox(height: theme.spacing.xl),
              SectionHeader(title: context.l10n.settingsSectionData),
              SizedBox(height: theme.spacing.sm),
              SecondaryButton(
                key: SettingsScreen.resetActionKey,
                label: context.l10n.settingsResetAction,
                expand: true,
                onPressed: () =>
                    setState(() => _resetStep = _ResetStep.confirm1),
              ),
              SizedBox(height: theme.spacing.xl),
              SecondaryButton(
                label: context.l10n.settingsAboutAction,
                expand: true,
                onPressed: () => context.go(AppRoutes.settingsAbout),
              ),
            ],
          ),
        ),
        if (_resetStep == _ResetStep.confirm1)
          _ResetConfirmOverlay(
            theme: theme,
            title: context.l10n.settingsResetConfirm1Title,
            body: context.l10n.settingsResetConfirm1Body,
            confirmKey: SettingsScreen.resetConfirm1Key,
            onConfirm: () => setState(() => _resetStep = _ResetStep.confirm2),
            onCancel: () => setState(() => _resetStep = _ResetStep.none),
          ),
        if (_resetStep == _ResetStep.confirm2)
          _ResetConfirmOverlay(
            theme: theme,
            title: context.l10n.settingsResetConfirm2Title,
            body: context.l10n.settingsResetConfirm2Body,
            confirmKey: SettingsScreen.resetConfirm2Key,
            onConfirm: () => unawaited(_confirmReset()),
            onCancel: () => setState(() => _resetStep = _ResetStep.none),
          ),
      ],
    );
  }
}

/// A labelled row of settings content (label above, the control below), same
/// shape as `_FilterRow` in `family_trend_screen.dart`.
class _SettingRow extends StatelessWidget {
  const _SettingRow({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ExcludeSemantics(
          child: Text(
            label,
            style: theme.textStyles.label.copyWith(
              color: theme.colors.textSecondary,
            ),
          ),
        ),
        SizedBox(height: theme.spacing.xs),
        child,
      ],
    );
  }
}

/// One step of the "reset all data" double confirmation, same overlay
/// pattern as `_QuitConfirmOverlay` (`practice_session_screen.dart`).
class _ResetConfirmOverlay extends StatelessWidget {
  const _ResetConfirmOverlay({
    required this.theme,
    required this.title,
    required this.body,
    required this.confirmKey,
    required this.onConfirm,
    required this.onCancel,
  });

  final AppTheme theme;
  final String title;
  final String body;
  final Key confirmKey;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ColoredBox(
        color: theme.colors.background.withValues(alpha: 0.92),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Padding(
              padding: EdgeInsets.all(theme.spacing.lg),
              child: AppCard(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      title,
                      style: theme.textStyles.title,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: theme.spacing.sm),
                    Text(
                      body,
                      style: theme.textStyles.body,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: theme.spacing.lg),
                    PrimaryButton(
                      key: confirmKey,
                      label: context.l10n.settingsResetConfirmAction,
                      expand: true,
                      onPressed: onConfirm,
                    ),
                    SizedBox(height: theme.spacing.sm),
                    SecondaryButton(
                      key: SettingsScreen.resetCancelKey,
                      label: context.l10n.settingsResetCancelAction,
                      expand: true,
                      onPressed: onCancel,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// "Reminders" section (US-092): on/off + time when the platform supports
/// scheduled notifications (`ReminderScheduler.isSupported`), otherwise an
/// explanation in place of the controls (desktop/web, `docs/ARCHITECTURE.md`
/// "Platforms").
class _ReminderSection extends ConsumerWidget {
  const _ReminderSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppTheme.of(context);
    final scheduler = ref.watch(reminderSchedulerProvider);
    final settings = ref.watch(reminderSettingsProvider);
    final controller = ref.read(reminderSettingsProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: context.l10n.settingsSectionReminders),
        SizedBox(height: theme.spacing.sm),
        if (!scheduler.isSupported)
          Text(
            context.l10n.settingsReminderUnsupported,
            style: theme.textStyles.body.copyWith(
              color: theme.colors.textSecondary,
            ),
          )
        else ...[
          _SettingRow(
            label: context.l10n.settingsReminderLabel,
            child: SegmentedChoice<bool>(
              semanticsLabel: context.l10n.settingsReminderLabel,
              selected: settings.enabled,
              onSelected: (enabled) async {
                if (enabled) await scheduler.requestPermission();
                await controller.setEnabled(enabled: enabled);
              },
              options: [
                SegmentedOption(
                  value: true,
                  label: context.l10n.settingsReminderOn,
                ),
                SegmentedOption(
                  value: false,
                  label: context.l10n.settingsReminderOff,
                ),
              ],
            ),
          ),
          if (settings.enabled) ...[
            SizedBox(height: theme.spacing.md),
            _SettingRow(
              label: context.l10n.settingsReminderTimeLabel,
              child: TimeStepperField(
                hour: settings.hour,
                minute: settings.minute,
                onChanged: (hour, minute) =>
                    unawaited(controller.setTime(hour: hour, minute: minute)),
              ),
            ),
          ],
        ],
      ],
    );
  }
}

class _ProfileSummary extends StatelessWidget {
  const _ProfileSummary({required this.answers});

  final OnboardingAnswers? answers;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final examDate = answers?.examDate;
    final stage = answers?.targetStage;
    final examDateText = examDate == null
        ? context.l10n.settingsProfileSummaryNoExamDate
        : context.l10n.formatLongDate(examDate);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.onboardingEditTitle, style: theme.textStyles.title),
          SizedBox(height: theme.spacing.sm),
          Text('${context.l10n.settingsProfileSummaryExamDate}$examDateText'),
          if (stage != null) ...[
            SizedBox(height: theme.spacing.xs),
            Text(
              '${context.l10n.settingsProfileSummaryStage}'
              '${stage.key.toUpperCase()}',
            ),
          ],
        ],
      ),
    );
  }
}
