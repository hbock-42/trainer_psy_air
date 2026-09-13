import 'dart:async';
import 'dart:math' as math;

import 'package:gamepads/gamepads.dart';

import 'gamepad_models.dart';
import 'gamepad_service.dart';

/// The real [GamepadService], on top of the `gamepads` pub.dev package
/// (pinned in `pubspec.yaml`; spec §3 option 1): native controller APIs on
/// desktop (GameInput/GCController/evdev+SDL DB) and the W3C Gamepad API on
/// web, already normalised by the package into a standard Xbox-style
/// `GamepadAxis`/`GamepadButton` layout — this class only narrows that down
/// to the two sticks + buttons a [GamepadState] carries and applies the
/// per-device dead zone.
class GamepadsPackageService implements GamepadService {
  GamepadsPackageService({Duration pollInterval = const Duration(seconds: 1)})
    : _pollInterval = pollInterval {
    unawaited(_init());
  }

  final Duration _pollInterval;
  final Map<String, GamepadDeviceInfo> _deviceInfo = {};
  final Map<String, GamepadState> _lastState = {};
  final Map<String, double> _deadZones = {};
  final Map<String, StreamController<GamepadState>> _stateControllers = {};
  final StreamController<List<GamepadDeviceInfo>> _devicesController =
      StreamController<List<GamepadDeviceInfo>>.broadcast();

  Timer? _pollTimer;
  StreamSubscription<NormalizedGamepadEvent>? _eventSub;

  Future<void> _init() async {
    await _pollDevices();
    // The installed `gamepads` version has no connect/disconnect event
    // stream, only `list()`; poll it instead so a controller plugged in or
    // unplugged mid-session still updates [devices] without a restart.
    _pollTimer = Timer.periodic(
      _pollInterval,
      (_) => unawaited(_pollDevices()),
    );
    _eventSub = Gamepads.normalizedEvents.listen(_onEvent);
  }

  Future<void> _pollDevices() async {
    try {
      final existing = await Gamepads.list();
      final seenIds = existing.map((c) => c.id).toSet();
      var changed = false;
      for (final controller in existing) {
        final info = GamepadDeviceInfo(
          id: controller.id,
          name: controller.name,
        );
        if (_deviceInfo[controller.id] != info) {
          _deviceInfo[controller.id] = info;
          changed = true;
        }
      }
      for (final staleId in _deviceInfo.keys.toList()) {
        if (!seenIds.contains(staleId)) {
          _deviceInfo.remove(staleId);
          _lastState.remove(staleId);
          changed = true;
        }
      }
      if (changed) _emitDevices();
    } on Object {
      // No gamepad backend on this platform/target (e.g. running under a
      // headless test harness without the plugin's native side): behave as
      // "no devices" rather than crash the caller.
    }
  }

  void _onEvent(NormalizedGamepadEvent event) {
    final id = event.gamepadId;
    var next = _lastState[id] ?? GamepadState(deviceId: id);
    final deadZone = _deadZones[id] ?? GamepadCalibration.defaultDeadZone;

    if (event.axis != null) {
      final value = _applyDeadZone(event.value, deadZone);
      next = switch (event.axis!) {
        GamepadAxis.leftStickX => next.copyWith(
          leftStick: next.leftStick.copyWith(x: value),
        ),
        GamepadAxis.leftStickY => next.copyWith(
          leftStick: next.leftStick.copyWith(y: value),
        ),
        GamepadAxis.rightStickX => next.copyWith(
          rightStick: next.rightStick.copyWith(x: value),
        ),
        GamepadAxis.rightStickY => next.copyWith(
          rightStick: next.rightStick.copyWith(y: value),
        ),
        GamepadAxis.leftTrigger || GamepadAxis.rightTrigger => next,
      };
    } else if (event.button != null) {
      final buttons = {...next.pressedButtons};
      if (event.value != 0) {
        buttons.add(event.button!);
      } else {
        buttons.remove(event.button!);
      }
      next = next.copyWith(pressedButtons: buttons);
    }

    next = next.copyWith(timestampMs: event.timestamp);
    _lastState[id] = next;
    _controllerFor(id).add(next);
  }

  static double _applyDeadZone(double raw, double deadZone) =>
      raw.abs() < deadZone ? 0 : raw;

  StreamController<GamepadState> _controllerFor(String deviceId) =>
      _stateControllers.putIfAbsent(
        deviceId,
        StreamController<GamepadState>.broadcast,
      );

  void _emitDevices() {
    _devicesController.add(List.unmodifiable(_deviceInfo.values));
  }

  @override
  Stream<List<GamepadDeviceInfo>> get devices => _devicesController.stream;

  @override
  List<GamepadDeviceInfo> get currentDevices =>
      List.unmodifiable(_deviceInfo.values);

  @override
  Stream<GamepadState> statesOf(String deviceId) =>
      _controllerFor(deviceId).stream;

  /// Sets the dead zone subsequent readings of [deviceId] are filtered
  /// through (persisted separately by the caller — see `GamepadSettings`).
  void setDeadZone(String deviceId, double deadZone) {
    _deadZones[deviceId] = deadZone.clamp(0.0, 0.9);
  }

  @override
  Future<GamepadCalibration> calibrate(
    String deviceId, {
    Duration sampleDuration = const Duration(seconds: 2),
  }) async {
    final samples = <GamepadState>[];
    final sub = statesOf(deviceId).listen(samples.add);
    await Future<void>.delayed(sampleDuration);
    await sub.cancel();
    if (samples.isEmpty) return const GamepadCalibration();
    var maxAbs = 0.0;
    for (final s in samples) {
      for (final v in [
        s.leftStick.x,
        s.leftStick.y,
        s.rightStick.x,
        s.rightStick.y,
      ]) {
        maxAbs = math.max(maxAbs, v.abs());
      }
    }
    // A comfortable margin over the sampled resting noise; never below the
    // package default and capped so a jittery stick cannot ask for a dead
    // zone so wide it eats real input.
    final suggested = (maxAbs * 1.5).clamp(
      GamepadCalibration.defaultDeadZone,
      0.35,
    );
    return GamepadCalibration(deadZone: suggested);
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    unawaited(_eventSub?.cancel());
    for (final controller in _stateControllers.values) {
      controller.close();
    }
    _stateControllers.clear();
    _devicesController.close();
  }
}
