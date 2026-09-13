import 'dart:math' as math;

import 'package:gamepads/gamepads.dart' show GamepadButton;

/// A 2-axis analog stick reading, each axis normalised to `[-1, 1]`
/// (`x`: left `-1` .. right `1`; `y`: down `-1` .. up `1`, matching the
/// `gamepads` package's own convention).
class StickVector {
  const StickVector({this.x = 0, this.y = 0});

  final double x;
  final double y;

  static const StickVector zero = StickVector();

  double get magnitude => math.sqrt(x * x + y * y);

  /// Zeroed inside [deadZone] (a fraction of full deflection, `[0, 1)`);
  /// otherwise rescaled so the value just outside the dead zone starts at
  /// (near) 0 instead of jumping straight to `deadZone`, and full deflection
  /// still reaches `1`. Applied per-axis independently (simpler and
  /// sufficient for the two engine channels this abstraction serves — a
  /// per-axis dead zone rather than a radial one).
  StickVector withDeadZone(double deadZone) {
    if (deadZone <= 0) return this;
    return StickVector(
      x: _applyDeadZone(x, deadZone),
      y: _applyDeadZone(y, deadZone),
    );
  }

  static double _applyDeadZone(double v, double deadZone) {
    final abs = v.abs();
    if (abs <= deadZone) return 0;
    final sign = v.isNegative ? -1.0 : 1.0;
    final rescaled = (abs - deadZone) / (1 - deadZone);
    return sign * rescaled.clamp(0.0, 1.0);
  }

  /// Clamped so `magnitude <= 1` (a stick's diagonal reads slightly over 1
  /// on raw per-axis values); direction preserved.
  StickVector clampedToUnitCircle() {
    final m = magnitude;
    if (m <= 1.0 || m == 0) return this;
    return StickVector(x: x / m, y: y / m);
  }

  StickVector copyWith({double? x, double? y}) =>
      StickVector(x: x ?? this.x, y: y ?? this.y);

  @override
  bool operator ==(Object other) =>
      other is StickVector && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() =>
      'StickVector(${x.toStringAsFixed(2)}, ${y.toStringAsFixed(2)})';
}

/// One gamepad known to a [GamepadService]: a stable id (platform-dependent
/// — a file descriptor path on Linux, an index on macOS/Windows, a browser
/// index on web) and a display name.
///
/// [isRepresentative] is false for the synthetic device a
/// `KeyboardGamepad`-style fallback exposes: discrete key taps cannot
/// reproduce a spring-centered analog stick's continuous proportional
/// control, so the UI must always label it a non-representative substitute
/// (spec §3, `docs/content/psy1-spec.md`).
class GamepadDeviceInfo {
  const GamepadDeviceInfo({
    required this.id,
    required this.name,
    this.isRepresentative = true,
  });

  final String id;
  final String name;
  final bool isRepresentative;

  @override
  bool operator ==(Object other) =>
      other is GamepadDeviceInfo &&
      other.id == id &&
      other.name == name &&
      other.isRepresentative == isRepresentative;

  @override
  int get hashCode => Object.hash(id, name, isRepresentative);

  @override
  String toString() => 'GamepadDeviceInfo($id, $name)';
}

/// One device's full input state at an instant: two sticks (dead-zone
/// already applied) and the set of currently-held buttons.
class GamepadState {
  const GamepadState({
    required this.deviceId,
    this.leftStick = StickVector.zero,
    this.rightStick = StickVector.zero,
    this.pressedButtons = const <GamepadButton>{},
    this.timestampMs = 0,
  });

  final String deviceId;
  final StickVector leftStick;
  final StickVector rightStick;
  final Set<GamepadButton> pressedButtons;

  /// Milliseconds since epoch this reading was produced at (0 for a
  /// synthetic/test state that does not care).
  final int timestampMs;

  bool isPressed(GamepadButton button) => pressedButtons.contains(button);

  GamepadState copyWith({
    StickVector? leftStick,
    StickVector? rightStick,
    Set<GamepadButton>? pressedButtons,
    int? timestampMs,
  }) => GamepadState(
    deviceId: deviceId,
    leftStick: leftStick ?? this.leftStick,
    rightStick: rightStick ?? this.rightStick,
    pressedButtons: pressedButtons ?? this.pressedButtons,
    timestampMs: timestampMs ?? this.timestampMs,
  );

  @override
  String toString() =>
      'GamepadState($deviceId, left: $leftStick, right: $rightStick, '
      'buttons: $pressedButtons)';
}

/// Per-device calibration: the dead zone applied to both sticks' axes
/// before they reach a [GamepadState]. Persisted at
/// `UserProfile.settings['gamepad']` by `GamepadSettings`.
class GamepadCalibration {
  const GamepadCalibration({this.deadZone = defaultDeadZone});

  /// A conservative default: absorbs a resting stick's small centring
  /// noise without needing per-device calibration first.
  static const double defaultDeadZone = 0.12;

  final double deadZone;

  GamepadCalibration copyWith({double? deadZone}) =>
      GamepadCalibration(deadZone: deadZone ?? this.deadZone);

  Map<String, Object?> toJson() => {'deadZone': deadZone};

  factory GamepadCalibration.fromJson(Map<String, Object?> json) {
    final raw = json['deadZone'];
    final deadZone = raw is num ? raw.toDouble() : defaultDeadZone;
    return GamepadCalibration(deadZone: deadZone.clamp(0.0, 0.9));
  }

  @override
  bool operator ==(Object other) =>
      other is GamepadCalibration && other.deadZone == deadZone;

  @override
  int get hashCode => deadZone.hashCode;
}
