import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/theme/app_theme.dart';
import 'package:psy_trainer/shared/widgets/widgets.dart';

import '../../helpers/pump_app.dart';
import '../../helpers/visuals.dart';

const List<AppTabItem> _items = [
  AppTabItem(label: 'Apprendre', glyph: AppIconGlyph.book),
  AppTabItem(label: 'Pratique', glyph: AppIconGlyph.target),
  AppTabItem(label: 'Examen', glyph: AppIconGlyph.clock),
  AppTabItem(label: 'Progrès', glyph: AppIconGlyph.chart),
  AppTabItem(label: 'Réglages', glyph: AppIconGlyph.settings),
];

/// The pressable of the tab labelled [label].
Finder _tab(String label) =>
    find.ancestor(of: find.text(label), matching: find.byType(AppPressable));

void main() {
  final light = AppTheme.light();

  testWidgets('renders every tab with glyph and label, reports taps', (
    tester,
  ) async {
    final taps = <int>[];
    await tester.pumpApp(
      AppTabBar(items: _items, selectedIndex: 0, onSelected: taps.add),
      align: false,
    );

    for (final item in _items) {
      expect(find.text(item.label), findsOneWidget);
    }
    expect(find.byType(AppIcon), findsNWidgets(_items.length));

    await tester.tap(find.text('Examen'));
    await tester.tap(
      find.text('Apprendre'),
    ); // already selected: still reported
    await tester.pumpAndSettle();
    expect(taps, [2, 0]);
  });

  testWidgets('bottom layout lays tabs out in a row, rail in a column', (
    tester,
  ) async {
    await tester.pumpApp(
      AppTabBar(items: _items, selectedIndex: 0, onSelected: (_) {}),
      align: false,
    );
    final rowFirst = tester.getTopLeft(_tab('Apprendre'));
    final rowLast = tester.getTopLeft(_tab('Réglages'));
    expect(rowFirst.dy, rowLast.dy);
    expect(rowFirst.dx, lessThan(rowLast.dx));

    await tester.pumpApp(
      Row(
        children: [
          AppTabBar(
            items: _items,
            selectedIndex: 0,
            layout: AppTabBarLayout.rail,
            onSelected: (_) {},
          ),
        ],
      ),
      align: false,
    );
    final railFirst = tester.getTopLeft(_tab('Apprendre'));
    final railLast = tester.getTopLeft(_tab('Réglages'));
    expect(railFirst.dx, railLast.dx);
    expect(railFirst.dy, lessThan(railLast.dy));
    expect(tester.getSize(find.byType(AppTabBar)).width, AppTabBar.railWidth);
  });

  testWidgets('every tab meets the 48dp target and survives 1.3x text', (
    tester,
  ) async {
    for (final scale in [1.0, 1.3]) {
      await tester.pumpApp(
        AppTabBar(items: _items, selectedIndex: 1, onSelected: (_) {}),
        align: false,
        textScale: scale,
      );
      for (final item in _items) {
        final size = tester.getSize(_tab(item.label));
        expect(size.height, greaterThanOrEqualTo(48), reason: item.label);
        expect(size.width, greaterThanOrEqualTo(48), reason: item.label);
      }
      expect(tester.takeException(), isNull, reason: 'scale $scale');
    }
  });

  testWidgets('exposes a button per tab with label and selected flag', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpApp(
      AppTabBar(
        items: _items,
        selectedIndex: 2,
        semanticsLabel: 'Navigation principale',
        onSelected: (_) {},
      ),
      align: false,
    );

    expect(find.bySemanticsLabel('Navigation principale'), findsOneWidget);
    expect(
      tester.getSemantics(_tab('Examen')),
      matchesSemantics(
        label: 'Examen',
        isButton: true,
        isEnabled: true,
        hasEnabledState: true,
        isSelected: true,
        hasSelectedState: true,
        hasTapAction: true,
        isFocusable: true,
        hasFocusAction: true,
      ),
    );
    expect(
      tester.getSemantics(_tab('Apprendre')),
      matchesSemantics(
        label: 'Apprendre',
        isButton: true,
        isEnabled: true,
        hasEnabledState: true,
        hasSelectedState: true,
        hasTapAction: true,
        isFocusable: true,
        hasFocusAction: true,
      ),
    );
    handle.dispose();
  });

  testWidgets('selected tab is drawn in the accent, others are not', (
    tester,
  ) async {
    await tester.pumpApp(
      AppTabBar(items: _items, selectedIndex: 3, onSelected: (_) {}),
      align: false,
    );

    Color? colorOf(String label) =>
        tester.widget<Text>(find.text(label)).style?.color;
    expect(colorOf('Progrès'), light.colors.accent);
    expect(colorOf('Apprendre'), light.colors.textSecondary);
    // Selected glyph sits on the accent pill.
    final pill = tester.widget<AnimatedContainer>(
      find
          .descendant(
            of: _tab('Progrès'),
            matching: find.byType(AnimatedContainer),
          )
          .last,
    );
    expect(
      (pill.decoration as BoxDecoration?)?.color,
      light.colors.accentSubtle,
    );
  });

  testWidgets('hover and press tint the tab, focus shows the ring', (
    tester,
  ) async {
    await tester.pumpApp(
      AppTabBar(items: _items, selectedIndex: 0, onSelected: (_) {}),
      align: false,
    );
    final tab = _tab('Pratique');
    final idle = tester.backgroundOf(tab);

    final gesture = await tester.hover(tab);
    final hovered = tester.backgroundOf(tab);
    expect(hovered, light.colors.surfaceRaised);
    await gesture.moveTo(Offset.zero);
    await tester.pumpAndSettle();
    expect(tester.backgroundOf(tab), idle);

    final press = await tester.startGesture(tester.getCenter(tab));
    await tester.pumpAndSettle();
    final pressed = tester.backgroundOf(tab);
    expect(pressed, isNot(idle));
    expect(pressed, isNot(hovered));
    await press.up();
    await tester.pumpAndSettle();
    expect(tester.backgroundOf(tab), idle);
  });

  testWidgets('tabs are keyboard reachable and Enter selects', (tester) async {
    final taps = <int>[];
    await tester.pumpApp(
      AppTabBar(items: _items, selectedIndex: 0, onSelected: taps.add),
      align: false,
    );
    final second = _tab('Pratique');
    expect(tester.focusRingVisible(second), isFalse);

    // Focus the first tab, then Tab moves to the next one.
    Focus.of(tester.element(find.text('Apprendre'))).requestFocus();
    await tester.pumpAndSettle();
    expect(tester.focusRingVisible(_tab('Apprendre')), isTrue);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();
    expect(tester.focusRingVisible(_tab('Apprendre')), isFalse);
    expect(tester.focusRingVisible(second), isTrue);

    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(taps, [1]);
  });

  testWidgets('rejects an out-of-range selectedIndex', (tester) async {
    expect(
      () => AppTabBar(items: _items, selectedIndex: 5, onSelected: (_) {}),
      throwsAssertionError,
    );
  });
}
