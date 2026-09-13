import 'package:gamepads/gamepads.dart' show GamepadButton;

import '../../repositories/model/learning.dart';
import 'gamepad_models.dart';

/// The gamepad mapping/calibration a candidate configures once in Settings
/// ("Manettes"): persisted at `UserProfile.settings['gamepad']`, same
/// pattern as `ReminderSettings`/`ExamRealismOptions`.
///
/// [deadZone] applies to every device (a global default; the settings
/// screen calibrates against whichever device is selected there).
/// [gaugeSelectButton]/[gaugeRecentreButton] are the left stick's "two
/// thumb buttons" (spec §2.3 row 13): which one cycles the selected gauge
/// forward and which nulls it, since real thumb-button placement varies by
/// controller and a candidate may prefer the mapping mirrored.
/// [invertRightStickY] flips the tracking channel's vertical axis, a common
/// preference for flight-style controls.
class GamepadSettings {
  const GamepadSettings({
    this.deadZone = GamepadCalibration.defaultDeadZone,
    this.gaugeSelectButton = GamepadButton.leftBumper,
    this.gaugeRecentreButton = GamepadButton.rightBumper,
    this.invertRightStickY = false,
    this.preferredDeviceId,
  });

  final double deadZone;
  final GamepadButton gaugeSelectButton;
  final GamepadButton gaugeRecentreButton;
  final bool invertRightStickY;

  /// The device id the candidate picked last time, when more than one is
  /// connected; null defaults to "the first device seen".
  final String? preferredDeviceId;

  static const String settingsKey = 'gamepad';

  static const String _keyDeadZone = 'deadZone';
  static const String _keySelectButton = 'gaugeSelectButton';
  static const String _keyRecentreButton = 'gaugeRecentreButton';
  static const String _keyInvertY = 'invertRightStickY';
  static const String _keyPreferredDevice = 'preferredDeviceId';

  static const GamepadSettings defaults = GamepadSettings();

  GamepadCalibration get calibration => GamepadCalibration(deadZone: deadZone);

  factory GamepadSettings.fromProfile(UserProfile? profile) {
    final raw = profile?.settings[settingsKey];
    if (raw is! Map) return defaults;
    return GamepadSettings.fromJson(raw.cast<String, Object?>());
  }

  factory GamepadSettings.fromJson(Map<String, Object?> json) {
    final deadZoneRaw = json[_keyDeadZone];
    final deadZone = deadZoneRaw is num
        ? deadZoneRaw.toDouble().clamp(0.0, 0.9)
        : defaults.deadZone;
    return GamepadSettings(
      deadZone: deadZone,
      gaugeSelectButton:
          _buttonFromName(json[_keySelectButton] as String?) ??
          defaults.gaugeSelectButton,
      gaugeRecentreButton:
          _buttonFromName(json[_keyRecentreButton] as String?) ??
          defaults.gaugeRecentreButton,
      invertRightStickY:
          json[_keyInvertY] as bool? ?? defaults.invertRightStickY,
      preferredDeviceId: json[_keyPreferredDevice] as String?,
    );
  }

  static GamepadButton? _buttonFromName(String? name) {
    if (name == null) return null;
    for (final button in GamepadButton.values) {
      if (button.name == name) return button;
    }
    return null;
  }

  Map<String, Object?> toJson() => {
    _keyDeadZone: deadZone,
    _keySelectButton: gaugeSelectButton.name,
    _keyRecentreButton: gaugeRecentreButton.name,
    _keyInvertY: invertRightStickY,
    _keyPreferredDevice: preferredDeviceId,
  };

  UserProfile applyTo(UserProfile? existing) {
    if (existing == null) {
      return UserProfile(locale: 'fr', settings: {settingsKey: toJson()});
    }
    return existing.copyWith(
      settings: {...existing.settings, settingsKey: toJson()},
    );
  }

  GamepadSettings copyWith({
    double? deadZone,
    GamepadButton? gaugeSelectButton,
    GamepadButton? gaugeRecentreButton,
    bool? invertRightStickY,
    String? preferredDeviceId,
  }) {
    return GamepadSettings(
      deadZone: deadZone ?? this.deadZone,
      gaugeSelectButton: gaugeSelectButton ?? this.gaugeSelectButton,
      gaugeRecentreButton: gaugeRecentreButton ?? this.gaugeRecentreButton,
      invertRightStickY: invertRightStickY ?? this.invertRightStickY,
      preferredDeviceId: preferredDeviceId ?? this.preferredDeviceId,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is GamepadSettings &&
      other.deadZone == deadZone &&
      other.gaugeSelectButton == gaugeSelectButton &&
      other.gaugeRecentreButton == gaugeRecentreButton &&
      other.invertRightStickY == invertRightStickY &&
      other.preferredDeviceId == preferredDeviceId;

  @override
  int get hashCode => Object.hash(
    deadZone,
    gaugeSelectButton,
    gaugeRecentreButton,
    invertRightStickY,
    preferredDeviceId,
  );
}
