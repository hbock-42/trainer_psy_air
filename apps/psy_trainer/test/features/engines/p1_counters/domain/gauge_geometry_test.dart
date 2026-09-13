import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/features/engines/p1_counters/domain/gauge.dart';

void main() {
  group('GaugeGeometry.circular', () {
    test('angleForValue <-> valueForAngle round-trips across the range', () {
      const rangeMin = 3;
      const rangeMax = 97;
      for (var value = rangeMin; value <= rangeMax; value++) {
        final angle = GaugeGeometry.circularAngleForValue(
          value,
          rangeMin,
          rangeMax,
        );
        final back = GaugeGeometry.circularValueForAngle(
          angle,
          rangeMin,
          rangeMax,
        );
        expect(back, closeTo(value.toDouble(), 1e-9));
      }
    });

    test('rangeMin maps to startAngle, rangeMax to the end of the sweep', () {
      expect(
        GaugeGeometry.circularAngleForValue(0, 0, 100),
        GaugeGeometry.startAngle,
      );
      expect(
        GaugeGeometry.circularAngleForValue(100, 0, 100),
        closeTo(GaugeGeometry.startAngle + GaugeGeometry.sweepAngle, 1e-9),
      );
    });

    test('an angle just before the sweep starts clamps to rangeMin', () {
      final justBefore = GaugeGeometry.circularValueForAngle(
        GaugeGeometry.startAngle - 0.05,
        0,
        100,
      );
      expect(justBefore, 0);
    });

    test('an angle just after the sweep ends clamps to rangeMax', () {
      final justAfter = GaugeGeometry.circularValueForAngle(
        GaugeGeometry.startAngle + GaugeGeometry.sweepAngle + 0.05,
        0,
        100,
      );
      expect(justAfter, 100);
    });
  });

  group('GaugeGeometry.linear', () {
    test('fractionForValue <-> valueForFraction round-trips', () {
      const rangeMin = 10;
      const rangeMax = 60;
      for (var value = rangeMin; value <= rangeMax; value++) {
        final fraction = GaugeGeometry.linearFractionForValue(
          value,
          rangeMin,
          rangeMax,
        );
        final back = GaugeGeometry.linearValueForFraction(
          fraction,
          rangeMin,
          rangeMax,
        );
        expect(back, closeTo(value.toDouble(), 1e-9));
      }
    });
  });

  group('GaugeGeometry.multiNeedle', () {
    test('needle angles <-> value round-trips for every integer value', () {
      const minorCycle = 1000;
      const rangeMax = 10000;
      for (var value = 0; value < rangeMax; value += 37) {
        final fineAngle = GaugeGeometry.fineAngleForValue(value, minorCycle);
        final coarseAngle = GaugeGeometry.coarseAngleForValue(value, rangeMax);
        final back = GaugeGeometry.valueForNeedleAngles(
          fineAngle,
          coarseAngle,
          minorCycle,
          rangeMax,
        );
        expect(
          back,
          closeTo(value.toDouble(), 1e-6),
          reason: 'value=$value fine=$fineAngle coarse=$coarseAngle',
        );
      }
    });

    test('wraps correctly at the top of the range', () {
      const minorCycle = 1000;
      const rangeMax = 6000;
      final fineAngle = GaugeGeometry.fineAngleForValue(5999, minorCycle);
      final coarseAngle = GaugeGeometry.coarseAngleForValue(5999, rangeMax);
      final back = GaugeGeometry.valueForNeedleAngles(
        fineAngle,
        coarseAngle,
        minorCycle,
        rangeMax,
      );
      expect(back, closeTo(5999, 1e-6));
    });
  });
}
