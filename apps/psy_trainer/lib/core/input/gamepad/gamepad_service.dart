import 'gamepad_models.dart';

/// A source of gamepad input, abstracted so engines never depend on a
/// concrete plugin (US-102, spec §3): [GamepadsPackageService] on real
/// hardware (desktop native + the web Gamepad API, via the `gamepads`
/// package), [KeyboardGamepadService] as a non-representative fallback, and
/// [FakeGamepadService] in tests.
///
/// Implementations normalise both sticks to `[-1, 1]` per axis and apply a
/// dead zone (see [GamepadCalibration]) before a reading reaches
/// [statesOf]'s stream — nothing downstream re-applies dead-zone logic.
abstract class GamepadService {
  /// Emits the full list of currently-known devices every time one connects
  /// or disconnects (including the initial snapshot on first listen).
  Stream<List<GamepadDeviceInfo>> get devices;

  /// Snapshot of [devices]' last known value; empty before the first
  /// connection scan completes.
  List<GamepadDeviceInfo> get currentDevices;

  /// Live state of [deviceId]; an empty broadcast stream for a device id
  /// this service has never seen (never errors — a device that connects
  /// later starts emitting on the same stream instance).
  Stream<GamepadState> statesOf(String deviceId);

  /// Samples [deviceId] for [sampleDuration] to suggest a dead zone from its
  /// resting noise. Does not persist anything — the caller (the settings
  /// screen) saves the result to `GamepadSettings`. Implementations with no
  /// meaningful calibration (the keyboard fallback, the fake) return
  /// [GamepadCalibration.defaultDeadZone] immediately.
  Future<GamepadCalibration> calibrate(
    String deviceId, {
    Duration sampleDuration = const Duration(seconds: 2),
  });

  /// Releases every subscription/stream this service owns. Safe to call
  /// once; further use after disposal is undefined.
  void dispose();
}
