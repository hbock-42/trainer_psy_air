/// The static route graph of one Airways run (spec §2.4-H, US-032): a row
/// of grey "zones" and a handful of "lines" (routes) that fly aircraft into
/// them, plus the alternate zone each line's colour button diverts to.
///
/// Pure Dart (no `dart:ui`, forbidden in `domain/`): positions are normalised
/// to a 0..1 square that the renderer maps to the canvas size.
library;

/// A point in the normalised 0..1 scene square.
class AirwaysPoint {
  const AirwaysPoint(this.x, this.y);

  final double x;
  final double y;

  AirwaysPoint lerp(AirwaysPoint other, double t) =>
      AirwaysPoint(x + (other.x - x) * t, y + (other.y - y) * t);
}

/// One grey zone: aircraft accumulate here for a while before leaving.
class AirwaysZoneSpec {
  const AirwaysZoneSpec({required this.id, required this.center});

  final int id;
  final AirwaysPoint center;
}

/// One line: aircraft spawned on it head for [defaultZone]; the colour
/// button of this route diverts the next eligible one to [altZone] instead.
class AirwaysRouteSpec {
  const AirwaysRouteSpec({
    required this.id,
    required this.defaultZone,
    required this.altZone,
    required this.entryPoint,
  });

  final int id;
  final int defaultZone;
  final int altZone;

  /// Where the aircraft appears (scene edge) before it reaches its zone.
  final AirwaysPoint entryPoint;
}

/// The whole scene graph for a run: [zoneCount] zones in a row, [routeCount]
/// lines feeding them. Deterministic function of the two counts alone (no
/// randomness): only the spawn schedule (`AirwaysSimulation`) is seeded.
class AirwaysGraph {
  const AirwaysGraph({required this.zones, required this.routes});

  final List<AirwaysZoneSpec> zones;
  final List<AirwaysRouteSpec> routes;

  factory AirwaysGraph.build({
    required int zoneCount,
    required int routeCount,
  }) {
    assert(zoneCount >= 1, 'zoneCount must be at least 1');
    assert(routeCount >= 1, 'routeCount must be at least 1');
    final zones = [
      for (var i = 0; i < zoneCount; i++)
        AirwaysZoneSpec(
          id: i,
          center: AirwaysPoint((i + 1) / (zoneCount + 1), 0.5),
        ),
    ];
    final routes = [
      for (var r = 0; r < routeCount; r++) _buildRoute(r, zoneCount, zones),
    ];
    return AirwaysGraph(zones: zones, routes: routes);
  }

  static AirwaysRouteSpec _buildRoute(
    int r,
    int zoneCount,
    List<AirwaysZoneSpec> zones,
  ) {
    final defaultZone = r % zoneCount;
    final altZone = zoneCount > 1 ? (r + 1) % zoneCount : defaultZone;
    final entry = AirwaysPoint(
      zones[defaultZone].center.x,
      r.isEven ? 0.08 : 0.92,
    );
    return AirwaysRouteSpec(
      id: r,
      defaultZone: defaultZone,
      altZone: altZone,
      entryPoint: entry,
    );
  }
}
