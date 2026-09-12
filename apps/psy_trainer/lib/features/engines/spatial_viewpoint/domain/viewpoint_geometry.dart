/// Pure geometry of `spatial_viewpoint` (spec §2.4-K, US-034): projecting a
/// scene laid out on a ground grid into what an observer standing at one of
/// the 8 numbered viewpoints around it would see.
///
/// Numbering convention (lesson `assets/content/psy0/lessons/spatial_viewpoint/*.fr.md`):
/// azimuth 1 is north, azimuths increase clockwise (2 north-east, 3 east, ...
/// 8 north-west). All positions are `(east, north)` pairs, origin at the
/// scene's centre; the observer stands outside the circle of objects,
/// looking back toward the centre.
///
/// Nothing here depends on Flutter: it is exercised directly by
/// `viewpoint_geometry_test.dart` (projection ordering from each azimuth)
/// and reused by the scene generator and the painter.
library;

import 'dart:math' as math;

/// One radian step per azimuth (`2*pi/8`); azimuth 1 = 0 rad (north).
double azimuthAngleRad(int azimuth) => (azimuth - 1) * (math.pi / 4);

/// The `(east, north)` unit vector the observer at [azimuth] looks *toward*
/// (i.e. from their position, back to the scene's centre).
({double east, double north}) viewDirection(int azimuth) {
  final theta = azimuthAngleRad(azimuth);
  return (east: -math.sin(theta), north: -math.cos(theta));
}

/// Signed left/right position of ground point `(gx, gy)` as seen by the
/// observer at [azimuth]: positive is to the observer's right.
///
/// Derived once for the whole codebase from the lesson's own left/right
/// rule ("face au nord, l'est est à droite ; face au sud, l'est est à
/// gauche"): the observer's right-hand vector is the view direction rotated
/// -90 deg, i.e. `(d.north, -d.east)`; the lateral coordinate of a point is
/// its dot product with that vector. Because the observer always looks
/// through the origin, this only depends on the *direction* [azimuth],
/// never on the (unmodelled) distance from the objects to the observer.
double lateralOf(int gx, int gy, int azimuth) {
  final d = viewDirection(azimuth);
  return gx * d.north - gy * d.east;
}

/// Signed near/far position of ground point `(gx, gy)` as seen by the
/// observer at [azimuth]: larger is farther from the observer (more in the
/// direction they are looking), smaller is nearer.
double depthOf(int gx, int gy, int azimuth) {
  final d = viewDirection(azimuth);
  return gx * d.east + gy * d.north;
}
