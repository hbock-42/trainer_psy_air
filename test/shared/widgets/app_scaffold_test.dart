import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/theme/app_theme.dart';
import 'package:psy_trainer/shared/widgets/widgets.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('paints the theme background and installs the body text style', (
    tester,
  ) async {
    final dark = AppTheme.dark();
    late TextStyle style;
    await tester.pumpApp(
      AppScaffold(
        body: Builder(
          builder: (context) {
            style = DefaultTextStyle.of(context).style;
            return const Text('Body');
          },
        ),
      ),
      theme: dark,
      align: false,
    );

    expect(find.byType(AppTopBar), findsNothing);
    expect(find.byType(SafeArea), findsOneWidget);
    expect(style.color, dark.colors.textPrimary);
    final box = tester.widget<ColoredBox>(
      find
          .ancestor(of: find.text('Body'), matching: find.byType(ColoredBox))
          .first,
    );
    expect(box.color, dark.colors.background);
  });

  testWidgets('shows a top bar with title, back button and actions', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    var backs = 0;
    await tester.pumpApp(
      AppScaffold(
        title: 'Mental arithmetic',
        onBack: () => backs++,
        actions: [
          AppIconButton(
            glyph: AppIconGlyph.settings,
            semanticsLabel: 'Settings',
            onPressed: () {},
          ),
        ],
        body: const SizedBox.expand(),
      ),
      align: false,
    );

    expect(find.text('Mental arithmetic'), findsOneWidget);
    expect(
      tester.getSemantics(find.text('Mental arithmetic')),
      matchesSemantics(label: 'Mental arithmetic', isHeader: true),
    );
    expect(find.bySemanticsLabel('Settings'), findsOneWidget);

    final back = find.bySemanticsLabel('Back');
    expect(back, findsOneWidget);
    expect(tester.getSize(back).width, greaterThanOrEqualTo(48));
    expect(tester.getSize(back).height, greaterThanOrEqualTo(48));
    await tester.tap(back);
    expect(backs, 1);
    handle.dispose();
  });

  testWidgets('safe area and body padding can be configured', (tester) async {
    await tester.pumpApp(
      const AppScaffold(
        safeArea: false,
        bodyPadding: EdgeInsets.all(20),
        body: Text('Body'),
      ),
      align: false,
    );
    expect(find.byType(SafeArea), findsNothing);
    expect(tester.getTopLeft(find.text('Body')), const Offset(20, 20));
  });

  testWidgets('long title is ellipsised at 1.3x rather than overflowing', (
    tester,
  ) async {
    await tester.pumpApp(
      AppScaffold(
        title: 'A very long screen title that cannot fit in the bar',
        onBack: () {},
        body: const SizedBox.expand(),
      ),
      align: false,
      textScale: 1.3,
    );
    expect(tester.takeException(), isNull);
  });
}
