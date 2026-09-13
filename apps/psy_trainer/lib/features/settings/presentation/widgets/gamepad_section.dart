import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamepads/gamepads.dart' show GamepadButton;

import '../../../../core/input/gamepad/gamepad_models.dart';
import '../../../../core/input/gamepad/gamepad_service.dart';
import '../../../../core/input/gamepad/gamepad_service_provider.dart';
import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/widgets.dart';
import '../providers/gamepad_settings_provider.dart';

/// Settings → "Manettes" (US-102): the devices `GamepadsPackageService`
/// currently sees, a live axis view of the first one, the dead zone and
/// the gauge-channel button mapping (`GamepadSettings`, persisted at
/// `UserProfile.settings['gamepad']`).
class GamepadSection extends ConsumerStatefulWidget {
  const GamepadSection({super.key});

  static const double deadZoneLow = 0.05;
  static const double deadZoneMedium = GamepadCalibration.defaultDeadZone;
  static const double deadZoneHigh = 0.25;

  /// Buttons offered for the gauge-channel mapping — the ones a dual-stick
  /// gamepad places near the thumbs.
  static const List<GamepadButton> gaugeButtonChoices = [
    GamepadButton.leftBumper,
    GamepadButton.rightBumper,
    GamepadButton.x,
    GamepadButton.y,
    GamepadButton.a,
    GamepadButton.b,
  ];

  @override
  ConsumerState<GamepadSection> createState() => _GamepadSectionState();
}

class _GamepadSectionState extends ConsumerState<GamepadSection> {
  List<GamepadDeviceInfo> _devices = const [];
  GamepadState? _liveState;

  @override
  void initState() {
    super.initState();
    final service = ref.read(gamepadServiceProvider);
    _devices = service.currentDevices;
    service.devices.listen((devices) {
      if (!mounted) return;
      setState(() => _devices = devices);
    });
  }

  void _listenTo(GamepadService service, String deviceId) {
    service.statesOf(deviceId).listen((state) {
      if (!mounted) return;
      setState(() => _liveState = state);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final settings = ref.watch(gamepadSettingsProvider);
    final controller = ref.read(gamepadSettingsProvider.notifier);
    final service = ref.read(gamepadServiceProvider);
    final primary = _devices.isEmpty ? null : _devices.first;

    if (primary != null && _liveState?.deviceId != primary.id) {
      _listenTo(service, primary.id);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(title: context.l10n.settingsSectionGamepad),
        SizedBox(height: theme.spacing.sm),
        if (_devices.isEmpty)
          Text(
            context.l10n.settingsGamepadNoneDetected,
            style: theme.textStyles.body,
          )
        else
          for (final device in _devices)
            Padding(
              padding: EdgeInsets.only(bottom: theme.spacing.xs),
              child: Text(device.name, style: theme.textStyles.bodyStrong),
            ),
        if (primary != null) ...[
          SizedBox(height: theme.spacing.sm),
          _AxisPreview(state: _liveState),
        ],
        SizedBox(height: theme.spacing.lg),
        _SettingRow(
          label: context.l10n.settingsGamepadDeadZoneLabel,
          child: SegmentedChoice<double>(
            semanticsLabel: context.l10n.settingsGamepadDeadZoneLabel,
            selected: settings.deadZone,
            onSelected: controller.setDeadZone,
            options: [
              SegmentedOption(
                value: GamepadSection.deadZoneLow,
                label: context.l10n.settingsGamepadDeadZoneLow,
              ),
              SegmentedOption(
                value: GamepadSection.deadZoneMedium,
                label: context.l10n.settingsGamepadDeadZoneMedium,
              ),
              SegmentedOption(
                value: GamepadSection.deadZoneHigh,
                label: context.l10n.settingsGamepadDeadZoneHigh,
              ),
            ],
          ),
        ),
        SizedBox(height: theme.spacing.md),
        _SettingRow(
          label: context.l10n.settingsGamepadInvertYLabel,
          child: SegmentedChoice<bool>(
            semanticsLabel: context.l10n.settingsGamepadInvertYLabel,
            selected: settings.invertRightStickY,
            onSelected: (invert) =>
                controller.setInvertRightStickY(invert: invert),
            options: [
              SegmentedOption(
                value: false,
                label: context.l10n.settingsGamepadInvertYOff,
              ),
              SegmentedOption(
                value: true,
                label: context.l10n.settingsGamepadInvertYOn,
              ),
            ],
          ),
        ),
        SizedBox(height: theme.spacing.md),
        _SettingRow(
          label: context.l10n.settingsGamepadSelectButtonLabel,
          child: SegmentedChoice<GamepadButton>(
            semanticsLabel: context.l10n.settingsGamepadSelectButtonLabel,
            selected: settings.gaugeSelectButton,
            onSelected: (button) => controller.setGaugeButtons(select: button),
            options: [
              for (final button in GamepadSection.gaugeButtonChoices)
                SegmentedOption(value: button, label: button.name),
            ],
          ),
        ),
        SizedBox(height: theme.spacing.md),
        _SettingRow(
          label: context.l10n.settingsGamepadRecentreButtonLabel,
          child: SegmentedChoice<GamepadButton>(
            semanticsLabel: context.l10n.settingsGamepadRecentreButtonLabel,
            selected: settings.gaugeRecentreButton,
            onSelected: (button) =>
                controller.setGaugeButtons(recentre: button),
            options: [
              for (final button in GamepadSection.gaugeButtonChoices)
                SegmentedOption(value: button, label: button.name),
            ],
          ),
        ),
      ],
    );
  }
}

class _AxisPreview extends StatelessWidget {
  const _AxisPreview({required this.state});

  final GamepadState? state;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final left = state?.leftStick ?? StickVector.zero;
    final right = state?.rightStick ?? StickVector.zero;
    return Semantics(
      label: context.l10n.settingsGamepadLiveAxesLabel,
      child: Row(
        children: [
          Expanded(
            child: _AxisBar(label: 'L.x', value: left.x, theme: theme),
          ),
          SizedBox(width: theme.spacing.sm),
          Expanded(
            child: _AxisBar(label: 'L.y', value: left.y, theme: theme),
          ),
          SizedBox(width: theme.spacing.sm),
          Expanded(
            child: _AxisBar(label: 'R.x', value: right.x, theme: theme),
          ),
          SizedBox(width: theme.spacing.sm),
          Expanded(
            child: _AxisBar(label: 'R.y', value: right.y, theme: theme),
          ),
        ],
      ),
    );
  }
}

class _AxisBar extends StatelessWidget {
  const _AxisBar({
    required this.label,
    required this.value,
    required this.theme,
  });

  final String label;
  final double value;
  final AppTheme theme;

  @override
  Widget build(BuildContext context) {
    final fraction = ((value + 1) / 2).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: theme.textStyles.caption,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: theme.spacing.xs),
        Stack(
          children: [
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: theme.colors.surface,
                border: Border.all(color: theme.colors.border),
                borderRadius: theme.radii.smAll,
              ),
            ),
            FractionallySizedBox(
              widthFactor: fraction,
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: theme.colors.accent,
                  borderRadius: theme.radii.smAll,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: theme.textStyles.label),
        SizedBox(height: theme.spacing.xs),
        child,
      ],
    );
  }
}
