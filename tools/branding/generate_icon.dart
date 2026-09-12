// Generates the PSY Trainer app icon and splash logo (US-122).
//
// The design is a stylised aircraft climbing through a target ring — cadet
// selection ("target") plus the aircraft the Air France PSY0 test trains
// towards — on the app's deep-blue design token background
// (`AppColors.dark.background` / `textPrimary`, see
// apps/psy_trainer/lib/core/theme/app_colors.dart) with the accent orange
// token for the ring and aircraft outline.
//
// `icon.svg` in this folder is the readable reference for the same design;
// this script draws it with `package:image` instead of rasterising the SVG
// because no SVG renderer (rsvg-convert, ImageMagick, Inkscape, cairosvg) is
// guaranteed to be available in CI or agent sandboxes. Keep the two in sync
// by hand if the design changes.
//
// Usage (from the repo root):
//   dart run tools/branding/generate_icon.dart
//
// Writes:
//   tools/branding/out/icon_1024.png   — full square icon (opaque background),
//                                        source for flutter_launcher_icons.
//   tools/branding/out/splash_1024.png — aircraft + ring only, transparent
//                                        background, source for
//                                        flutter_native_splash (which paints
//                                        its own background colour).
//
// `tools/test/generate_icon_test.dart` exercises the pure drawing functions
// on small canvases so the test suite doesn't depend on image codecs.

import 'dart:io';

import 'package:image/image.dart' as img;

/// Deep-blue background token (`AppColors.dark.background`).
const int backgroundColor = 0xFF0B1D3A;

/// Accent orange token (`AppColors.light.accent` / `AppColors.dark.accent`
/// family; 0xFFE08A1E is the light-theme accent, used here for contrast
/// against the deep-blue background regardless of system theme).
const int accentColor = 0xFFE08A1E;

/// Off-white token used for the aircraft body (`AppColors.light.background`).
const int aircraftColor = 0xFFF5F7FA;

img.Color _c(int argb, {int alpha = 255}) =>
    img.ColorRgba8((argb >> 16) & 0xFF, (argb >> 8) & 0xFF, argb & 0xFF, alpha);

/// Draws a filled ring (annulus) of [thickness] at [outerRadius] centred on
/// ([cx], [cy]) by filling two concentric circles: the outer one with
/// [color], then the inner one with [eraseColor] using [img.BlendMode.direct]
/// so the erase overwrites pixels instead of alpha-blending over them (a
/// transparent erase colour would otherwise be a no-op under normal
/// alpha blending).
void drawRing(
  img.Image image, {
  required int cx,
  required int cy,
  required int outerRadius,
  required int thickness,
  required img.Color color,
  required img.Color eraseColor,
}) {
  img.fillCircle(image, x: cx, y: cy, radius: outerRadius, color: color);
  final inner = outerRadius - thickness;
  if (inner > 0) {
    img.fillCircle(
      image,
      x: cx,
      y: cy,
      radius: inner,
      color: eraseColor,
      blend: img.BlendMode.direct,
    );
  }
}

/// Aircraft silhouette polygon, scaled to fit a [size] x [size] canvas
/// (designed on a 1024x1024 grid in icon.svg; scale = size / 1024).
List<img.Point> aircraftPolygon(int size) {
  const points = <List<double>>[
    [512, 180],
    [560, 330],
    [560, 520],
    [760, 660],
    [760, 720],
    [562, 650],
    [548, 800],
    [610, 860],
    [610, 900],
    [512, 868],
    [414, 900],
    [414, 860],
    [476, 800],
    [462, 650],
    [264, 720],
    [264, 660],
    [464, 520],
    [464, 330],
  ];
  final scale = size / 1024;
  return points
      .map((p) => img.Point(p[0] * scale, p[1] * scale))
      .toList(growable: false);
}

/// Draws the two target rings centred in a [size] x [size] canvas, erasing
/// each ring's interior back to [eraseColor] (the canvas background —
/// opaque deep-blue for the icon, transparent for the splash logo).
void drawTargetRings(
  img.Image image,
  int size, {
  required img.Color eraseColor,
}) {
  final cx = size ~/ 2;
  final cy = size ~/ 2;
  drawRing(
    image,
    cx: cx,
    cy: cy,
    outerRadius: (size * 360 / 1024).round(),
    thickness: (size * 28 / 1024).round().clamp(1, size),
    color: _c(accentColor),
    eraseColor: eraseColor,
  );
  drawRing(
    image,
    cx: cx,
    cy: cy,
    outerRadius: (size * 250 / 1024).round(),
    thickness: (size * 16 / 1024).round().clamp(1, size),
    color: _c(accentColor, alpha: 140),
    eraseColor: eraseColor,
  );
}

/// Builds the opaque app icon (background + rings + aircraft) at [size].
img.Image buildIcon(int size) {
  final image = img.Image(width: size, height: size, numChannels: 3);
  final background = _c(backgroundColor);
  img.fill(image, color: background);
  drawTargetRings(image, size, eraseColor: background);
  img.fillPolygon(
    image,
    vertices: aircraftPolygon(size),
    color: _c(aircraftColor),
  );
  return image;
}

/// Builds the transparent splash logo (rings + aircraft only) at [size].
img.Image buildSplashLogo(int size) {
  final image = img.Image(width: size, height: size, numChannels: 4);
  final transparent = img.ColorRgba8(0, 0, 0, 0);
  img.fill(image, color: transparent);
  drawTargetRings(image, size, eraseColor: transparent);
  img.fillPolygon(
    image,
    vertices: aircraftPolygon(size),
    color: _c(aircraftColor),
  );
  return image;
}

void main(List<String> args) {
  const size = 1024;
  final outDir = Directory('tools/branding/out');
  outDir.createSync(recursive: true);

  final icon = buildIcon(size);
  File('${outDir.path}/icon_1024.png').writeAsBytesSync(img.encodePng(icon));

  final splash = buildSplashLogo(size);
  File(
    '${outDir.path}/splash_1024.png',
  ).writeAsBytesSync(img.encodePng(splash));

  stdout.writeln('Wrote ${outDir.path}/icon_1024.png');
  stdout.writeln('Wrote ${outDir.path}/splash_1024.png');
}
