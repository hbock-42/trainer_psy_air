import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/shared/gallery/widget_gallery_screen.dart';
import 'package:psy_trainer/shared/widgets/widgets.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets(
    'gallery renders every widget and survives theme and scale toggles',
    (tester) async {
      tester.view.physicalSize = const Size(800, 3000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpApp(const WidgetGalleryScreen(), align: false);
      expect(find.text('Widget gallery'), findsOneWidget);
      expect(find.byType(PrimaryButton), findsWidgets);
      expect(find.byType(AnswerOptionTile), findsWidgets);
      expect(find.byType(CountdownTimerBar), findsWidgets);
      expect(find.byType(ProgressDots), findsWidgets);
      expect(find.byType(ScoreCard), findsWidgets);
      expect(find.byType(AppKeypadButton), findsWidgets);

      await tester.tap(find.text('Dark theme'));
      await tester.pumpAndSettle();
      expect(find.text('Light theme'), findsOneWidget);

      await tester.tap(find.text('Text 1.3x'));
      await tester.pumpAndSettle();
      expect(find.text('Text 1.0x'), findsOneWidget);

      await tester.tap(find.text('Interactive option 4'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('scrolls to the bottom without layout errors at 1.3x', (
    tester,
  ) async {
    await tester.pumpApp(
      const WidgetGalleryScreen(),
      align: false,
      textScale: 1.3,
    );
    await tester.fling(find.byType(ListView), const Offset(0, -6000), 4000);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  test('gallery is enabled in debug builds and has a route path', () {
    expect(kWidgetGalleryEnabled, isTrue);
    expect(widgetGalleryRoutePath, '/gallery');
  });
}
