import 'dart:async';

import 'gamepad_models.dart';
import 'gamepad_service.dart';

/// A fully-controllable [GamepadService] for tests: nothing is wired to a
/// real plugin or the keyboard. A test calls [addDevice]/[removeDevice] to
/// drive [devices] and [push] to drive [statesOf] — no dead zone or
/// normalisation is applied here (the test constructs already-normalised
/// [GamepadState]s directly), matching a real service's post-processing
/// contract.
class FakeGamepadService implements GamepadService {
  final StreamController<List<GamepadDeviceInfo>> _devicesController =
      StreamController<List<GamepadDeviceInfo>>.broadcast();
  final Map<String, StreamController<GamepadState>> _stateControllers = {};
  final Map<String, GamepadDeviceInfo> _current = {};
  GamepadCalibration _nextCalibration = const GamepadCalibration();

  void addDevice(GamepadDeviceInfo info) {
    _current[info.id] = info;
    _emitDevices();
  }

  void removeDevice(String id) {
    _current.remove(id);
    _emitDevices();
  }

  /// Pushes [state] to whoever listens to `statesOf(state.deviceId)`.
  void push(GamepadState state) {
    _controllerFor(state.deviceId).add(state);
  }

  /// The value [calibrate] resolves with on its next call.
  void setNextCalibration(GamepadCalibration calibration) {
    _nextCalibration = calibration;
  }

  void _emitDevices() {
    _devicesController.add(List.unmodifiable(_current.values));
  }

  StreamController<GamepadState> _controllerFor(String deviceId) =>
      _stateControllers.putIfAbsent(
        deviceId,
        StreamController<GamepadState>.broadcast,
      );

  @override
  Stream<List<GamepadDeviceInfo>> get devices => _devicesController.stream;

  @override
  List<GamepadDeviceInfo> get currentDevices =>
      List.unmodifiable(_current.values);

  @override
  Stream<GamepadState> statesOf(String deviceId) =>
      _controllerFor(deviceId).stream;

  @override
  Future<GamepadCalibration> calibrate(
    String deviceId, {
    Duration sampleDuration = const Duration(seconds: 2),
  }) async => _nextCalibration;

  @override
  void dispose() {
    _devicesController.close();
    for (final controller in _stateControllers.values) {
      controller.close();
    }
    _stateControllers.clear();
  }
}
