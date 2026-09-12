import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../domain/airways_geometry.dart';
import '../domain/airways_simulation.dart';

/// Literal colours of the scene (what the candidate must discriminate),
/// not design-system tokens -- same convention as `attention_rules`'
/// `stimulusColorOf`.
const Color airwaysGreyAircraftColor = Color(0xFF64748B);
const Color airwaysBlueAircraftColor = Color(0xFF2563EB);

/// One colour per route button (never blue: that colour is reserved for
/// blue aircraft, spec §2.4-H's tighter capacity rule).
const List<Color> airwaysRouteColors = [
  Color(0xFFF97316), // orange
  Color(0xFF9333EA), // purple
  Color(0xFF16A34A), // green
  Color(0xFFDC2626), // red
];

/// Draws the scene: zones as circles (flashed red on a fresh violation),
/// route lines from their entry point to the zone they feed, and aircraft
/// as coloured triangles positioned by the simulation.
class AirwaysPainter extends CustomPainter {
  const AirwaysPainter({
    required this.graph,
    required this.zones,
    required this.aircraft,
    required this.flashZones,
    required this.zoneBorderColor,
    required this.zoneLabelColor,
  });

  final AirwaysGraph graph;
  final List<AirwaysZoneSnapshot> zones;
  final List<AirwaysAircraftSnapshot> aircraft;
  final Set<int> flashZones;
  final Color zoneBorderColor;
  final Color zoneLabelColor;

  static const double _zoneRadiusFraction = 0.16;

  @override
  void paint(Canvas canvas, Size size) {
    _paintRoutes(canvas, size);
    _paintZones(canvas, size);
    _paintAircraft(canvas, size);
  }

  Offset _toOffset(AirwaysPoint p, Size size) =>
      Offset(p.x * size.width, p.y * size.height);

  void _paintRoutes(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = zoneBorderColor.withValues(alpha: 0.35)
      ..strokeWidth = 2;
    for (final route in graph.routes) {
      final from = _toOffset(route.entryPoint, size);
      final to = _toOffset(graph.zones[route.defaultZone].center, size);
      canvas.drawLine(from, to, paint);
    }
  }

  void _paintZones(Canvas canvas, Size size) {
    final radius = math.min(size.width, size.height) * _zoneRadiusFraction;
    for (final zone in zones) {
      final center = _toOffset(zone.center, size);
      final flashing = flashZones.contains(zone.id);
      final fillColor = flashing
          ? const Color(0xFFDC2626).withValues(alpha: 0.35)
          : zone.isAtRisk
          ? const Color(0xFFF59E0B).withValues(alpha: 0.25)
          : zoneBorderColor.withValues(alpha: 0.08);
      canvas.drawCircle(center, radius, Paint()..color = fillColor);
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = flashing ? 4 : 2
          ..color = flashing ? const Color(0xFFDC2626) : zoneBorderColor,
      );
      final label = TextPainter(
        text: TextSpan(
          text: '${zone.total}/${zone.blue}',
          style: TextStyle(
            color: zoneLabelColor,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      label.paint(canvas, center - Offset(label.width / 2, label.height / 2));
    }
  }

  void _paintAircraft(Canvas canvas, Size size) {
    final side = math.min(size.width, size.height) * 0.045;
    for (final a in aircraft) {
      final center = _toOffset(a.position, size);
      final color = a.colour == AircraftColour.blue
          ? airwaysBlueAircraftColor
          : airwaysGreyAircraftColor;
      final path = Path()
        ..moveTo(center.dx, center.dy - side)
        ..lineTo(center.dx + side, center.dy + side)
        ..lineTo(center.dx - side, center.dy + side)
        ..close();
      canvas.drawPath(path, Paint()..color = color);
      if (a.diverted) {
        canvas.drawPath(
          path,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2
            ..color = const Color(0xFFFFFFFF),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant AirwaysPainter oldDelegate) => true;
}
