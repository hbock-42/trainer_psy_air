import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'gamepad_service.dart';
import 'gamepads_package_service.dart';
import 'keyboard_gamepad_service.dart';

/// The real gamepad backend (`gamepads` package: native desktop + the web
/// Gamepad API). One instance for the app's lifetime; tests override this
/// with a `FakeGamepadService`.
final Provider<GamepadService> gamepadServiceProvider =
    Provider<GamepadService>((ref) {
      final service = GamepadsPackageService();
      ref.onDispose(service.dispose);
      return service;
    });

/// The non-representative keyboard fallback (spec §3 option 3), always
/// available regardless of platform. Renderers prefer [gamepadServiceProvider]
/// whenever it reports a device and fall back to this one otherwise.
final Provider<GamepadService> keyboardGamepadServiceProvider =
    Provider<GamepadService>((ref) {
      final service = KeyboardGamepadService();
      ref.onDispose(service.dispose);
      return service;
    });
