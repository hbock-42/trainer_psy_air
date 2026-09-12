import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

// Golden tests
// ------------
//
// A golden test renders a widget to an image and compares it pixel-for-pixel
// with a PNG committed under `test/goldens/`. The rendering is deterministic
// because `flutter test`:
//   * uses the bundled "Ahem" font (every glyph is a solid box) instead of
//     platform fonts, unless real fonts are loaded explicitly;
//   * runs the software rasteriser, so no GPU differences;
//   * uses the fixed surface size, pixel ratio and text scale set below.
//
// Goldens can still differ across Flutter versions (renderer changes), so the
// PNGs are tied to the Flutter version CI uses. Bump both together.
//
// Text anti-aliasing also differs slightly between macOS (where goldens are
// usually generated) and the Linux CI runner: every glyph edge differs by a
// pixel or so, which is ~0.3 % of a phone surface for a sparse screen but
// close to 4 % for a screen full of text (measured on the learn placeholder).
// The comparator below therefore tolerates a small fraction of differing
// pixels (`goldenPixelTolerance`); anything above it still fails. A
// text-dense golden can raise its own budget with `expectGolden(...,
// tolerance:)`, keeping it well below what a layout change would produce.
//
// Updating goldens after an intentional UI change:
//
//     flutter test --update-goldens test/path/to/the_test.dart
//
// Then review the PNG diff in the PR. Never update goldens to make a red test
// green without looking at the image.
//
// Writing one:
//
//     testWidgets('placeholder screen matches golden', (tester) async {
//       await pumpGolden(tester, const PlaceholderScreen());
//       await expectGolden(tester, 'placeholder_screen');
//     });

/// Logical size of the golden surface: a phone-ish portrait viewport.
const Size goldenSurfaceSize = Size(390, 844);

/// Device pixel ratio for goldens. 1.0 keeps PNGs small and diffs readable.
const double goldenDevicePixelRatio = 1.0;

/// Directory holding every golden PNG, relative to the package root.
const String goldenDirectory = 'test/goldens';

/// Maximum fraction of differing pixels accepted by [expectGolden]
/// (absorbs cross-platform text rasterisation noise, see header comment).
const double goldenPixelTolerance = 0.01;

/// A [LocalFileComparator] that accepts up to [tolerance] differing pixels.
class TolerantGoldenComparator extends LocalFileComparator {
  TolerantGoldenComparator(
    super.testFile, {
    this.tolerance = goldenPixelTolerance,
  });

  final double tolerance;

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    final result = await GoldenFileComparator.compareLists(
      imageBytes,
      await getGoldenBytes(golden),
    );
    if (result.passed || result.diffPercent <= tolerance) {
      result.dispose();
      return true;
    }
    final error = await generateFailureOutput(result, golden, basedir);
    result.dispose();
    throw FlutterError(error);
  }
}

/// Configures the test view for deterministic rendering and pumps [child].
///
/// By default the widget is pumped as-is, so pass a full app (`PsyTrainerApp`)
/// or wrap the widget yourself; for a bare widget use
/// `pump: pumpApp` (from `pump_app.dart`) to get the standard ancestors.
///
/// [size] and [textScale] can be overridden per test (e.g. to snapshot a
/// tablet layout or a large-font accessibility setting). The view settings
/// are reset when the test ends.
Future<void> pumpGolden(
  WidgetTester tester,
  Widget child, {
  Size size = goldenSurfaceSize,
  double textScale = 1.0,
  Future<void> Function(WidgetTester tester, Widget child)? pump,
}) async {
  configureGoldenView(tester, size: size, textScale: textScale);
  if (pump != null) {
    await pump(tester, child);
  } else {
    await tester.pumpWidget(child);
  }
  await tester.pumpAndSettle();
}

/// Sets a fixed surface size, pixel ratio and text scale on the test view,
/// points the golden comparator (accepting [tolerance] differing pixels) at
/// [goldenDirectory], and registers a teardown that restores everything.
void configureGoldenView(
  WidgetTester tester, {
  Size size = goldenSurfaceSize,
  double textScale = 1.0,
  double tolerance = goldenPixelTolerance,
}) {
  final view = tester.view;
  view.physicalSize = size * goldenDevicePixelRatio;
  view.devicePixelRatio = goldenDevicePixelRatio;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;

  // `matchesGoldenFile` resolves paths relative to the *test file*; swap in a
  // comparator rooted at the shared goldens folder so every test, wherever it
  // lives under test/, writes to and reads from the same place.
  final previousComparator = goldenFileComparator;
  goldenFileComparator = TolerantGoldenComparator(
    Directory.current.uri.resolve('$goldenDirectory/_'),
    tolerance: tolerance,
  );

  addTearDown(() {
    view.resetPhysicalSize();
    view.resetDevicePixelRatio();
    tester.platformDispatcher.clearTextScaleFactorTestValue();
    goldenFileComparator = previousComparator;
  });
}

/// Compares the whole test surface with `test/goldens/<name>.png`.
///
/// Pass a [finder] to snapshot a single widget instead of the full screen.
/// [tolerance] overrides [goldenPixelTolerance] for this comparison (see the
/// header comment: text-dense screens need a larger anti-aliasing budget).
Future<void> expectGolden(
  WidgetTester tester,
  String name, {
  Finder? finder,
  double? tolerance,
}) async {
  if (tolerance != null) {
    final comparator = goldenFileComparator;
    if (comparator is TolerantGoldenComparator) {
      goldenFileComparator = TolerantGoldenComparator(
        comparator.basedir.resolve('_'),
        tolerance: tolerance,
      );
    }
  }
  await expectLater(
    finder ?? find.byType(View).first,
    matchesGoldenFile('$name.png'),
  );
}
