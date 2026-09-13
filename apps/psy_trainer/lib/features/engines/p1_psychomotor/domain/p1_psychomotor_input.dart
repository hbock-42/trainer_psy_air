/// One tick's worth of continuous stick input, decoupled from
/// `GamepadService`/`GamepadState` (`core/input/gamepad/`) so this pure-Dart
/// domain layer never depends on Flutter or the gamepad plugin — the
/// renderer is the only place a `GamepadState`/keyboard event gets turned
/// into one of these.
///
/// [selectNextGauge]/[selectPrevGauge] are edge-triggered (true only on the
/// tick a thumb button transitions from released to pressed — a renderer
/// held-button state must debounce this itself before building the
/// sample), everything else is the instantaneous stick deflection.
class P1PsychomotorTickInput {
  const P1PsychomotorTickInput({
    this.leftStickY = 0,
    this.selectNextGauge = false,
    this.selectPrevGauge = false,
    this.rightStickX = 0,
    this.rightStickY = 0,
  });

  static const P1PsychomotorTickInput none = P1PsychomotorTickInput();

  /// Nulls the selected gauge (`P1PsychomotorControl.gaugeStep`); `[-1, 1]`.
  final double leftStickY;

  /// Cycles the selected gauge forward/backward by one on the tick it
  /// becomes true.
  final bool selectNextGauge;
  final bool selectPrevGauge;

  /// Drives the crosshair cursor (`P1PsychomotorControl.crosshairStep`);
  /// each `[-1, 1]`.
  final double rightStickX;
  final double rightStickY;
}
