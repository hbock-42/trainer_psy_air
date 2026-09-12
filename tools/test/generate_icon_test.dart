import 'package:image/image.dart' as img;
import 'package:test/test.dart';

import '../branding/generate_icon.dart';

void main() {
  group('buildIcon', () {
    test('has the requested square size and no transparency', () {
      final icon = buildIcon(128);
      expect(icon.width, 128);
      expect(icon.height, 128);
      expect(icon.numChannels, 3);
    });

    test('corners are the deep-blue background', () {
      final icon = buildIcon(256);
      final corner = icon.getPixel(0, 0);
      expect(corner.r, (backgroundColor >> 16) & 0xFF);
      expect(corner.g, (backgroundColor >> 8) & 0xFF);
      expect(corner.b, backgroundColor & 0xFF);
    });

    test('the outer accent ring is drawn at its expected radius', () {
      final size = 512;
      final icon = buildIcon(size);
      final cx = size ~/ 2;
      final outerRadius = (size * 360 / 1024).round();
      final thickness = (size * 28 / 1024).round().clamp(1, size);
      // Sample the middle of the ring stroke (a few pixels in from its
      // outer edge), where the accent colour is guaranteed to be painted
      // regardless of rounding at the exact boundary.
      final ringY = cx - outerRadius + (thickness ~/ 2);
      final pixel = icon.getPixel(cx, ringY);
      // On the ring stroke the pixel should carry the accent's red channel,
      // not the plain background.
      expect(pixel.r, greaterThan((backgroundColor >> 16) & 0xFF));
    });
  });

  group('buildSplashLogo', () {
    test('has an alpha channel and a transparent background', () {
      final logo = buildSplashLogo(128);
      expect(logo.numChannels, 4);
      final corner = logo.getPixel(0, 0);
      expect(corner.a, 0);
    });

    test('the aircraft nose is opaque', () {
      final size = 1024;
      final logo = buildSplashLogo(size);
      // The nose tip from the polygon is at (512, 180).
      final nose = logo.getPixel(512, 190);
      expect(nose.a, greaterThan(0));
    });
  });

  test('aircraftPolygon scales with size', () {
    final full = aircraftPolygon(1024);
    final half = aircraftPolygon(512);
    expect(full.length, half.length);
    for (var i = 0; i < full.length; i++) {
      expect(half[i].x, closeTo(full[i].x / 2, 0.001));
      expect(half[i].y, closeTo(full[i].y / 2, 0.001));
    }
  });

  test('drawRing erases its interior back to the erase colour', () {
    final image = img.Image(width: 64, height: 64, numChannels: 3);
    final bg = img.ColorRgba8(10, 20, 30, 255);
    img.fill(image, color: bg);
    drawRing(
      image,
      cx: 32,
      cy: 32,
      outerRadius: 30,
      thickness: 6,
      color: img.ColorRgba8(255, 0, 0, 255),
      eraseColor: bg,
    );
    final center = image.getPixel(32, 32);
    expect(center.r, bg.r);
    expect(center.g, bg.g);
    expect(center.b, bg.b);
  });
}
