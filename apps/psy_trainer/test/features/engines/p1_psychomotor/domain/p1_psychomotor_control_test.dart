import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/features/engines/p1_psychomotor/domain/p1_psychomotor_control.dart';

void main() {
  group('gaugeStep', () {
    test('an unselected gauge only drifts naturally', () {
      final next = P1PsychomotorControl.gaugeStep(
        displacement: 0,
        naturalVelocity: 0.2,
        selected: false,
        stickY: -1,
        dtSec: 1,
      );
      expect(next, closeTo(0.2, 1e-9));
    });

    test('a selected gauge is pulled back toward 0 by stick Y', () {
      // Displaced positive; pushing the stick up (+1) should null it (the
      // control law is "push opposite the current displacement").
      final next = P1PsychomotorControl.gaugeStep(
        displacement: 0.5,
        naturalVelocity: 0,
        selected: true,
        stickY: 1,
        dtSec: 0.5,
      );
      expect(next, lessThan(0.5));
    });

    test('correction outruns the fastest natural drift', () {
      // At full deflection, the correction rate must beat the simulation's
      // own max drift velocity (0.35 * scale, scale <= 1.6 at difficulty 5),
      // otherwise an attentive candidate could never win the tug-of-war.
      const maxDriftVelocity = 0.35 * 1.6;
      expect(
        P1PsychomotorControl.gaugeCorrectionRate,
        greaterThan(maxDriftVelocity),
      );
    });

    test('displacement never exceeds [-1, 1]', () {
      final next = P1PsychomotorControl.gaugeStep(
        displacement: 0.98,
        naturalVelocity: 5,
        selected: false,
        stickY: 0,
        dtSec: 1,
      );
      expect(next, 1.0);
    });
  });

  group('crosshairStep', () {
    test('the cursor moves proportionally to stick deflection', () {
      final (x, y) = P1PsychomotorControl.crosshairStep(
        x: 0,
        y: 0,
        stickX: 1,
        stickY: 0,
        dtSec: 0.1,
      );
      expect(x, closeTo(P1PsychomotorControl.crosshairMaxSpeed * 0.1, 1e-9));
      expect(y, 0);
    });

    test('zero stick input leaves the cursor stationary', () {
      final (x, y) = P1PsychomotorControl.crosshairStep(
        x: 0.3,
        y: -0.2,
        stickX: 0,
        stickY: 0,
        dtSec: 1,
      );
      expect(x, 0.3);
      expect(y, -0.2);
    });

    test('the cursor is clamped to the unit circle', () {
      final (x, y) = P1PsychomotorControl.crosshairStep(
        x: 0.9,
        y: 0.9,
        stickX: 1,
        stickY: 1,
        dtSec: 5,
      );
      expect(x * x + y * y, closeTo(1.0, 1e-6));
    });
  });
}
