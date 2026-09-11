import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/shared/widgets/widgets.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('every glyph paints at the requested size without error', (
    tester,
  ) async {
    await tester.pumpApp(
      Wrap(
        children: [
          for (final glyph in AppIconGlyph.values) AppIcon(glyph, size: 32),
        ],
      ),
    );
    expect(find.byType(AppIcon), findsNWidgets(AppIconGlyph.values.length));
    expect(tester.getSize(find.byType(AppIcon).first), const Size(32, 32));
    expect(tester.takeException(), isNull);
  });

  testWidgets('is decorative unless a semantics label is given', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpApp(const AppIcon(AppIconGlyph.check));
    expect(find.bySemanticsLabel('Done'), findsNothing);
    expect(tester.getSemantics(find.byType(AppIcon)).label, isEmpty);

    await tester.pumpApp(
      const AppIcon(AppIconGlyph.check, semanticsLabel: 'Done'),
    );
    expect(
      tester.getSemantics(find.byType(AppIcon)),
      matchesSemantics(label: 'Done', isImage: true),
    );
    handle.dispose();
  });
}
