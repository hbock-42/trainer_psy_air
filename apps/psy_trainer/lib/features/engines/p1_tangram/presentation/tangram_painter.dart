import 'package:flutter/widgets.dart';

import '../domain/tangram_board.dart';
import '../domain/tangram_geometry.dart';
import '../domain/tangram_piece.dart';

/// The 7 pieces' own fill colours -- like `spatial_overlay`'s navy/grey
/// (`_OverlayColours`), this is the activity's own fixed visual semantics
/// (telling the 7 shapes apart at a glance), not a design-system token, so
/// it stays the same in light and dark theme.
abstract final class TangramColours {
  static const Map<TangramPieceKind, Color> byKind = {
    TangramPieceKind.smallTriangle1: Color(0xFFE0745C),
    TangramPieceKind.smallTriangle2: Color(0xFF4C9F70),
    TangramPieceKind.mediumTriangle: Color(0xFF4C7FE0),
    TangramPieceKind.largeTriangle1: Color(0xFFD6B33C),
    TangramPieceKind.largeTriangle2: Color(0xFF9A5CC7),
    TangramPieceKind.square: Color(0xFF3FB6C4),
    TangramPieceKind.parallelogram: Color(0xFFE0679E),
  };

  static const Color silhouette = Color(0xFF6B7280);

  static Color of(TangramPieceKind kind) => byKind[kind] ?? silhouette;
}

/// Paints one piece's polygon (already transformed to board coordinates by
/// the caller), scaled by [pixelsPerUnit] and shifted so [originX]/[originY]
/// (board coordinates) sit at the canvas origin -- shared by the tray icon,
/// the placed-piece box and the solution view.
class TangramPiecePainter extends CustomPainter {
  const TangramPiecePainter({
    required this.vertices,
    required this.color,
    required this.pixelsPerUnit,
    this.originX = 0,
    this.originY = 0,
    this.strokeOnly = false,
  });

  final List<Point2> vertices;
  final Color color;
  final double pixelsPerUnit;
  final double originX;
  final double originY;

  /// Outline-only (used for the "hint" internal edges over a filled
  /// silhouette, see [TangramFigurePainter]).
  final bool strokeOnly;

  Path _path() {
    final path = Path();
    for (var i = 0; i < vertices.length; i++) {
      final (x, y) = vertices[i];
      final point = Offset(
        (x - originX) * pixelsPerUnit,
        (y - originY) * pixelsPerUnit,
      );
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final path = _path();
    if (strokeOnly) {
      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..color = color,
      );
    } else {
      canvas.drawPath(path, Paint()..color = color);
      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = const Color(0x33000000),
      );
    }
  }

  @override
  bool shouldRepaint(TangramPiecePainter oldDelegate) =>
      oldDelegate.vertices != vertices ||
      oldDelegate.color != color ||
      oldDelegate.pixelsPerUnit != pixelsPerUnit ||
      oldDelegate.originX != originX ||
      oldDelegate.originY != originY ||
      oldDelegate.strokeOnly != strokeOnly;
}

/// Paints a whole figure: a rasterised cell set filled as one silhouette,
/// with each piece's own outline drawn on top when [showPieceEdges] --
/// the "hide internal edges at higher difficulty" behaviour
/// (`TangramBoard.hideInternalEdges`).
class TangramFigurePainter extends CustomPainter {
  const TangramFigurePainter({
    required this.cells,
    required this.cellSize,
    required this.pixelsPerUnit,
    required this.originX,
    required this.originY,
    required this.fillColor,
    this.pieces = const [],
    this.placements = const [],
    this.showPieceEdges = false,
  });

  final Set<CellIndex> cells;
  final double cellSize;
  final double pixelsPerUnit;
  final double originX;
  final double originY;
  final Color fillColor;
  final List<TangramPiece> pieces;
  final List<PlacedPiece> placements;
  final bool showPieceEdges;

  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()..color = fillColor;
    final unit = cellSize * pixelsPerUnit;
    for (final (i, j) in cells) {
      final left = (i * cellSize - originX) * pixelsPerUnit;
      final top = (j * cellSize - originY) * pixelsPerUnit;
      canvas.drawRect(Rect.fromLTWH(left, top, unit + 0.5, unit + 0.5), fill);
    }
    if (showPieceEdges) {
      final stroke = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = const Color(0x66000000);
      for (var i = 0; i < pieces.length; i++) {
        final path = Path();
        final vertices = placements[i].absoluteVertices(pieces[i]);
        for (var v = 0; v < vertices.length; v++) {
          final (x, y) = vertices[v];
          final point = Offset(
            (x - originX) * pixelsPerUnit,
            (y - originY) * pixelsPerUnit,
          );
          if (v == 0) {
            path.moveTo(point.dx, point.dy);
          } else {
            path.lineTo(point.dx, point.dy);
          }
        }
        path.close();
        canvas.drawPath(path, stroke);
      }
    }
  }

  @override
  bool shouldRepaint(TangramFigurePainter oldDelegate) =>
      oldDelegate.cells != cells ||
      oldDelegate.cellSize != cellSize ||
      oldDelegate.pixelsPerUnit != pixelsPerUnit ||
      oldDelegate.originX != originX ||
      oldDelegate.originY != originY ||
      oldDelegate.fillColor != fillColor ||
      oldDelegate.showPieceEdges != showPieceEdges;
}
