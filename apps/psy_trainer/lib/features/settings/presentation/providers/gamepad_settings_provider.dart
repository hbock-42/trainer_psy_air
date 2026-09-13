import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamepads/gamepads.dart' show GamepadButton;

import '../../../../core/errors/error_logger.dart';
import '../../../../core/input/gamepad/gamepad_settings.dart';
import '../../../../core/repositories/repositories.dart';

/// US-102: the gamepad dead zone + button mapping, hydrated from
/// `UserProfile.settings['gamepad']` once and then held synchronously (same
/// hydration shape as `ReminderSettingsController`).
final NotifierProvider<GamepadSettingsController, GamepadSettings>
gamepadSettingsProvider =
    NotifierProvider<GamepadSettingsController, GamepadSettings>(
      GamepadSettingsController.new,
    );

class GamepadSettingsController extends Notifier<GamepadSettings> {
  Completer<GamepadSettings>? _hydration;

  ProgressRepository get _repository => ref.read(progressRepositoryProvider);

  @override
  GamepadSettings build() {
    _hydration = Completer<GamepadSettings>();
    unawaited(_hydrate());
    return GamepadSettings.defaults;
  }

  Future<void> _hydrate() async {
    GamepadSettings settings;
    try {
      settings = GamepadSettings.fromProfile(await _repository.profile());
    } on Object catch (error, stack) {
      logError(error, stack, context: 'gamepad settings hydration');
      settings = GamepadSettings.defaults;
    }
    state = settings;
    final completer = _hydration;
    if (completer != null && !completer.isCompleted) {
      completer.complete(settings);
    }
  }

  FutureOr<GamepadSettings> whenHydrated() =>
      _hydration?.isCompleted ?? true ? state : _hydration!.future;

  Future<void> setDeadZone(double deadZone) =>
      _update((s) => s.copyWith(deadZone: deadZone));

  Future<void> setGaugeButtons({
    GamepadButton? select,
    GamepadButton? recentre,
  }) => _update(
    (s) => s.copyWith(gaugeSelectButton: select, gaugeRecentreButton: recentre),
  );

  Future<void> setInvertRightStickY({required bool invert}) =>
      _update((s) => s.copyWith(invertRightStickY: invert));

  Future<void> setPreferredDevice(String? deviceId) =>
      _update((s) => s.copyWith(preferredDeviceId: deviceId));

  Future<void> _update(GamepadSettings Function(GamepadSettings) apply) async {
    final next = apply(state);
    state = next;
    final existing = await _repository.profile();
    await _repository.saveProfile(next.applyTo(existing));
  }
}
