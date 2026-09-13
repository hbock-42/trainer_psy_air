import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/input/gamepad/fake_gamepad_service.dart';
import 'package:psy_trainer/core/input/gamepad/gamepad_models.dart';

void main() {
  test('addDevice/removeDevice drive the devices stream', () async {
    final service = FakeGamepadService();
    final emissions = <List<GamepadDeviceInfo>>[];
    final sub = service.devices.listen(emissions.add);

    service.addDevice(const GamepadDeviceInfo(id: 'd1', name: 'Pad 1'));
    await Future<void>.delayed(Duration.zero);
    service.removeDevice('d1');
    await Future<void>.delayed(Duration.zero);

    expect(emissions, hasLength(2));
    expect(emissions[0].single.id, 'd1');
    expect(emissions[1], isEmpty);
    expect(service.currentDevices, isEmpty);

    await sub.cancel();
    service.dispose();
  });

  test('push delivers state to statesOf(deviceId) only', () async {
    final service = FakeGamepadService();
    final states = <GamepadState>[];
    final sub = service.statesOf('d1').listen(states.add);

    service.push(
      const GamepadState(deviceId: 'd1', leftStick: StickVector(x: 0.5)),
    );
    service.push(const GamepadState(deviceId: 'd2'));
    await Future<void>.delayed(Duration.zero);

    expect(states, hasLength(1));
    expect(states.single.leftStick.x, 0.5);

    await sub.cancel();
    service.dispose();
  });

  test('calibrate resolves with the value set by setNextCalibration', () async {
    final service = FakeGamepadService();
    service.setNextCalibration(const GamepadCalibration(deadZone: 0.3));
    final result = await service.calibrate('d1');
    expect(result.deadZone, 0.3);
    service.dispose();
  });

  test('calibrate defaults when nothing was configured', () async {
    final service = FakeGamepadService();
    final result = await service.calibrate('d1');
    expect(result.deadZone, GamepadCalibration.defaultDeadZone);
    service.dispose();
  });
}
