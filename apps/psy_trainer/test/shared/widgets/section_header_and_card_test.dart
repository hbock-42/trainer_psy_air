import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/theme/app_theme.dart';
import 'package:psy_trainer/shared/widgets/widgets.dart';

import '../../helpers/pump_app.dart';
import '../../helpers/visuals.dart';

void main() {
  final light = AppTheme.light();

  group('SectionHeader', () {
    testWidgets('renders title, subtitle and trailing as a header', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpApp(
        SizedBox(
          width: 320,
          child: SectionHeader(
            title: 'Recent sessions',
            subtitle: 'Practice and exams',
            trailing: SecondaryButton(label: 'See all', onPressed: () {}),
          ),
        ),
      );
      expect(find.text('Recent sessions'), findsOneWidget);
      expect(find.text('Practice and exams'), findsOneWidget);
      expect(find.byType(SecondaryButton), findsOneWidget);
      expect(
        tester.getSemantics(find.text('Recent sessions')),
        matchesSemantics(
          label: 'Recent sessions\nPractice and exams',
          isHeader: true,
        ),
      );
      handle.dispose();
    });

    testWidgets('long title wraps at 1.3x without overflow', (tester) async {
      await tester.pumpApp(
        SizedBox(
          width: 240,
          child: SectionHeader(
            title: 'A long section title that wraps',
            trailing: SecondaryButton(label: 'All', onPressed: () {}),
          ),
        ),
        textScale: 1.3,
      );
      expect(tester.takeException(), isNull);
    });
  });

  group('AppCard', () {
    testWidgets('static card paints a bordered surface with padding', (
      tester,
    ) async {
      await tester.pumpApp(const AppCard(child: Text('Hello')));
      final box = tester.widget<DecoratedBox>(
        find
            .ancestor(
              of: find.text('Hello'),
              matching: find.byType(DecoratedBox),
            )
            .first,
      );
      final decoration = box.decoration as BoxDecoration;
      expect(decoration.color, light.colors.surface);
      expect((decoration.border! as Border).top.color, light.colors.border);
      expect(find.byType(AppPressable), findsNothing);
      final padding = tester.widget<Padding>(
        find
            .ancestor(of: find.text('Hello'), matching: find.byType(Padding))
            .first,
      );
      expect(padding.padding, EdgeInsets.all(light.spacing.lg));
    });

    testWidgets('tappable card reacts to tap, hover and focus', (tester) async {
      final handle = tester.ensureSemantics();
      var taps = 0;
      final node = FocusNode();
      addTearDown(node.dispose);
      await tester.pumpApp(
        AppCard(
          semanticsLabel: 'Open lesson',
          focusNode: node,
          onPressed: () => taps++,
          child: const Text('Lesson 1'),
        ),
      );
      final card = find.byType(AppCard);

      await tester.tap(card);
      expect(taps, 1);
      expect(
        tester.getSemantics(card),
        matchesSemantics(
          label: 'Open lesson',
          isButton: true,
          isEnabled: true,
          hasEnabledState: true,
          hasTapAction: true,
          isFocusable: true,
          hasFocusAction: true,
        ),
      );

      await tester.hover(card);
      expect(tester.backgroundOf(card), light.colors.surfaceRaised);

      node.requestFocus();
      await tester.pumpAndSettle();
      expect(tester.focusRingVisible(card), isTrue);
      handle.dispose();
    });

    test('a tappable card requires a semantics label', () {
      expect(
        () => AppCard(onPressed: () {}, child: const SizedBox()),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
