import 'dart:math';

/// The two control laws driven by live stick input (US-102, spec §2.3 row
/// 13). Pure functions of the previous state + one tick's input, so they
/// are unit-testable without any gamepad, ticker or widget.
abstract final class P1PsychomotorControl {
  /// Normalised units/second a fully-deflected left stick Y nulls a
  /// selected gauge by. Comfortably faster than the fastest natural drift
  /// velocity (`0.35 * scale`, `p1_psychomotor_simulation.dart`) so an
  /// attentive candidate can always win the tug-of-war.
  static const double gaugeCorrectionRate = 0.9;

  /// One tick of a gauge's displacement: it keeps drifting at
  /// [naturalVelocity] regardless of selection (spec: gauges drift
  /// continuously), and — only while [selected] — [stickY] additionally
  /// pushes it back toward 0 at up to [gaugeCorrectionRate]. Clamped to
  /// `[-1, 1]` (a gauge cannot overshoot past "fully pegged").
  static double gaugeStep({
    required double displacement,
    required double naturalVelocity,
    required bool selected,
    required double stickY,
    required double dtSec,
  }) {
    final correction = selected ? -stickY * gaugeCorrectionRate : 0.0;
    final next = displacement + (naturalVelocity + correction) * dtSec;
    return next.clamp(-1.0, 1.0);
  }

  /// Full deflection of the right stick moves the crosshair cursor at this
  /// many normalised units/second (the tracking arena is a unit circle of
  /// radius 1) — **direct, proportional velocity control**: the stick's
  /// instantaneous deflection *is* the cursor's instantaneous velocity
  /// command (no acceleration/inertia modelled), matching the spec's
  /// "direct, continuous, 2-axis proportional control" (§2.3 row 13, §3
  /// TestPilote quote). Documented here as the control law this engine
  /// implements, since the spec names the paradigm but not a formula.
  static const double crosshairMaxSpeed = 1.1;

  /// One tick of the crosshair cursor: `velocity = stick * maxSpeed`,
  /// `position += velocity * dt`, clamped to the unit circle (the cursor
  /// cannot leave the tracking arena; spec: "inside a circle").
  static (double, double) crosshairStep({
    required double x,
    required double y,
    required double stickX,
    required double stickY,
    required double dtSec,
  }) {
    final nx = x + stickX * crosshairMaxSpeed * dtSec;
    final ny = y + stickY * crosshairMaxSpeed * dtSec;
    final radius = sqrt(nx * nx + ny * ny);
    if (radius <= 1.0 || radius == 0) return (nx, ny);
    return (nx / radius, ny / radius);
  }
}
