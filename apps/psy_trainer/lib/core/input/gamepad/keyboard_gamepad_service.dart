import 'dart:async';

import 'package:flutter/services.dart';
import 'package:gamepads/gamepads.dart' show GamepadButton;

import 'gamepad_models.dart';
import 'gamepad_service.dart';

/// The one synthetic device a [KeyboardGamepadService] ever reports.
const String keyboardGamepadDeviceId = 'keyboard';

/// A non-representative gamepad substitute for a physical keyboard: WASD
/// drives the left stick, the arrow keys drive the right stick, and `1`/`2`
/// stand in for the left stick's two thumb buttons (spec §3 option 3 —
/// "must be clearly flagged as a non-representative substitute").
///
/// Discrete key taps cannot reproduce a spring-centered analog stick's
/// continuous proportional control: every axis here is either `-1`, `0` or
/// `1`, never an intermediate value. [GamepadDeviceInfo.isRepresentative] is
/// false on its one device precisely so the UI always shows that warning.
class KeyboardGamepadService implements GamepadService {
  KeyboardGamepadService({HardwareKeyboard? keyboard})
    : _keyboard = keyboard ?? HardwareKeyboard.instance {
    _keyboard.addHandler(_onKeyEvent);
  }

  final HardwareKeyboard _keyboard;
  final Set<LogicalKeyboardKey> _held = {};
  final StreamController<GamepadState> _stateController =
      StreamController<GamepadState>.broadcast();
  final StreamController<List<GamepadDeviceInfo>> _devicesController =
      StreamController<List<GamepadDeviceInfo>>.broadcast();

  static const GamepadDeviceInfo device = GamepadDeviceInfo(
    id: keyboardGamepadDeviceId,
    name: 'Clavier (non représentatif)',
    isRepresentative: false,
  );

  bool _announced = false;

  bool _onKeyEvent(KeyEvent event) {
    final key = event.logicalKey;
    if (!_isMapped(key)) return false;
    if (event is KeyDownEvent) {
      _held.add(key);
    } else if (event is KeyUpEvent) {
      _held.remove(key);
    }
    if (!_announced) {
      _announced = true;
      _devicesController.add(const [device]);
    }
    _stateController.add(_currentState());
    // Never consumes the event: other widgets (letter/arithmetic input,
    // navigation) still see the same key.
    return false;
  }

  static bool _isMapped(LogicalKeyboardKey key) =>
      key == LogicalKeyboardKey.keyW ||
      key == LogicalKeyboardKey.keyA ||
      key == LogicalKeyboardKey.keyS ||
      key == LogicalKeyboardKey.keyD ||
      key == LogicalKeyboardKey.arrowUp ||
      key == LogicalKeyboardKey.arrowDown ||
      key == LogicalKeyboardKey.arrowLeft ||
      key == LogicalKeyboardKey.arrowRight ||
      key == LogicalKeyboardKey.digit1 ||
      key == LogicalKeyboardKey.digit2;

  GamepadState _currentState() {
    double axis(LogicalKeyboardKey positive, LogicalKeyboardKey negative) {
      var v = 0.0;
      if (_held.contains(positive)) v += 1;
      if (_held.contains(negative)) v -= 1;
      return v;
    }

    final left = StickVector(
      x: axis(LogicalKeyboardKey.keyD, LogicalKeyboardKey.keyA),
      y: axis(LogicalKeyboardKey.keyW, LogicalKeyboardKey.keyS),
    );
    final right = StickVector(
      x: axis(LogicalKeyboardKey.arrowRight, LogicalKeyboardKey.arrowLeft),
      y: axis(LogicalKeyboardKey.arrowUp, LogicalKeyboardKey.arrowDown),
    );
    final buttons = <GamepadButton>{
      if (_held.contains(LogicalKeyboardKey.digit1)) GamepadButton.leftBumper,
      if (_held.contains(LogicalKeyboardKey.digit2)) GamepadButton.rightBumper,
    };
    return GamepadState(
      deviceId: keyboardGamepadDeviceId,
      leftStick: left,
      rightStick: right,
      pressedButtons: buttons,
      timestampMs: DateTime.now().millisecondsSinceEpoch,
    );
  }

  @override
  Stream<List<GamepadDeviceInfo>> get devices => _devicesController.stream;

  @override
  List<GamepadDeviceInfo> get currentDevices =>
      _announced ? const [device] : const [];

  @override
  Stream<GamepadState> statesOf(String deviceId) =>
      deviceId == keyboardGamepadDeviceId
      ? _stateController.stream
      : const Stream.empty();

  @override
  Future<GamepadCalibration> calibrate(
    String deviceId, {
    Duration sampleDuration = const Duration(seconds: 2),
  }) async => const GamepadCalibration();

  @override
  void dispose() {
    _keyboard.removeHandler(_onKeyEvent);
    _stateController.close();
    _devicesController.close();
  }
}
