import 'package:flutter_test/flutter_test.dart';
import 'package:gamepads/gamepads.dart' show GamepadButton;
import 'package:psy_trainer/core/input/gamepad/gamepad_models.dart';

void main() {
  group('StickVector.withDeadZone', () {
    test('zeroes a value inside the dead zone', () {
      const stick = StickVector(x: 0.05, y: -0.08);
      final result = stick.withDeadZone(0.1);
      expect(result.x, 0);
      expect(result.y, 0);
    });

    test('rescales a value outside the dead zone toward the full range', () {
      const stick = StickVector(x: 1.0);
      final result = stick.withDeadZone(0.1);
      expect(result.x, closeTo(1.0, 1e-9));
    });

    test('preserves sign', () {
      const stick = StickVector(x: -0.9);
      final result = stick.withDeadZone(0.1);
      expect(result.x, lessThan(0));
    });
  });

  group('StickVector.clampedToUnitCircle', () {
    test('leaves an in-range vector untouched', () {
      const stick = StickVector(x: 0.5, y: 0.5);
      expect(stick.clampedToUnitCircle(), stick);
    });

    test('scales an over-range vector down to magnitude 1', () {
      const stick = StickVector(x: 1, y: 1);
      final clamped = stick.clampedToUnitCircle();
      expect(clamped.magnitude, closeTo(1.0, 1e-9));
    });
  });

  group('GamepadCalibration', () {
    test('round-trips through JSON', () {
      const calibration = GamepadCalibration(deadZone: 0.2);
      final restored = GamepadCalibration.fromJson(calibration.toJson());
      expect(restored, calibration);
    });

    test('an out-of-range value is clamped on decode', () {
      final restored = GamepadCalibration.fromJson({'deadZone': 5.0});
      expect(restored.deadZone, lessThanOrEqualTo(0.9));
    });

    test('a missing key falls back to the default', () {
      final restored = GamepadCalibration.fromJson(const {});
      expect(restored.deadZone, GamepadCalibration.defaultDeadZone);
    });
  });

  group('GamepadState', () {
    test('isPressed reflects pressedButtons', () {
      const state = GamepadState(
        deviceId: 'd1',
        pressedButtons: {GamepadButton.a},
      );
      expect(state.isPressed(GamepadButton.a), isTrue);
      expect(state.isPressed(GamepadButton.b), isFalse);
    });

    test('copyWith only changes the given fields', () {
      const state = GamepadState(deviceId: 'd1', leftStick: StickVector(x: 1));
      final next = state.copyWith(rightStick: const StickVector(y: 1));
      expect(next.leftStick.x, 1);
      expect(next.rightStick.y, 1);
      expect(next.deviceId, 'd1');
    });
  });
}
