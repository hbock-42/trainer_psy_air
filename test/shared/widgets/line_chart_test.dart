import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/theme/app_theme.dart';
import 'package:psy_trainer/shared/widgets/widgets.dart';

import '../../helpers/pump_app.dart';

void main() {
  const plot = Rect.fromLTWH(10, 5, 100, 50);
  const accuracy = LineChartSeries(
    label: 'Réussite',
    points: [
      LineChartPoint(0, 0.4),
      LineChartPoint(1, 0.6),
      LineChartPoint(2, 0.5),
      LineChartPoint(3, 0.9),
    ],
  );
  const speed = LineChartSeries(
    label: 'Temps',
    points: [LineChartPoint(0, 900), LineChartPoint(2, 700)],
  );

  group('LineChartScale', () {
    test('maps the corners of the data range to the plot corners', () {
      const scale = LineChartScale(
        xMin: 0,
        xMax: 10,
        yMin: 0,
        yMax: 1,
        plot: plot,
      );
      expect(scale.toOffset(const LineChartPoint(0, 0)), plot.bottomLeft);
      expect(scale.toOffset(const LineChartPoint(10, 1)), plot.topRight);
      expect(scale.toOffset(const LineChartPoint(5, 0.5)), plot.center);
      // Inverse mapping.
      expect(scale.xAt(plot.left), 0);
      expect(scale.xAt(plot.right), 10);
      expect(scale.xAt(plot.center.dx), 5);
    });

    test('fit takes the x range from the data and fixed y bounds', () {
      final scale = LineChartScale.fit(
        series: const [accuracy],
        plot: plot,
        yMin: 0,
        yMax: 1,
      );
      expect(scale.xMin, 0);
      expect(scale.xMax, 3);
      expect(scale.yMin, 0);
      expect(scale.yMax, 1);
      expect(scale.dy(1), plot.top);
      expect(scale.dy(0), plot.bottom);
    });

    test('fit pads an automatic y range by 10 % on each side', () {
      final scale = LineChartScale.fit(series: const [speed], plot: plot);
      // 700..900, span 200, pad 20.
      expect(scale.yMin, closeTo(680, 1e-9));
      expect(scale.yMax, closeTo(920, 1e-9));
      // A fixed bound is kept as is, the other one is still padded.
      final floor = LineChartScale.fit(
        series: const [speed],
        plot: plot,
        yMin: 0,
      );
      expect(floor.yMin, 0);
      expect(floor.yMax, closeTo(990, 1e-9));
    });

    test('fit widens degenerate ranges so a single point still maps', () {
      final scale = LineChartScale.fit(
        series: const [
          LineChartSeries(label: 's', points: [LineChartPoint(4, 0.5)]),
        ],
        plot: plot,
      );
      expect(scale.xMin, 3.5);
      expect(scale.xMax, 4.5);
      expect(scale.yMin, 0);
      expect(scale.yMax, 1);
      expect(scale.toOffset(const LineChartPoint(4, 0.5)), plot.center);
    });

    test('fit without any point maps a unit square', () {
      final scale = LineChartScale.fit(
        series: const [LineChartSeries(label: 's', points: [])],
        plot: plot,
      );
      expect(scale.xMax, greaterThan(scale.xMin));
      expect(scale.yMax, greaterThan(scale.yMin));
      expect(scale.nearest(const [accuracy], 0), isNotNull);
    });

    test('nearest picks the closest x across every series', () {
      final scale = LineChartScale.fit(
        series: const [accuracy, speed],
        plot: plot,
        yMin: 0,
        yMax: 1,
      );
      // x = 2 sits at 2/3 of the plot; a little to its right is still 2.
      final hit = scale.nearest(const [accuracy, speed], scale.dx(2) + 5)!;
      expect(hit.x, 2);
      expect(hit.entries.map((e) => e.seriesIndex), [0, 1]);
      expect(hit.entries.map((e) => e.pointIndex), [2, 1]);
      expect(hit.entries.first.point.y, 0.5);
      expect(hit.entries.last.point.y, 700);

      // x = 1 exists only in the first series.
      final only = scale.nearest(const [accuracy, speed], scale.dx(1))!;
      expect(only.x, 1);
      expect(only.entries.map((e) => e.seriesIndex), [0]);

      // Far past the end still snaps to the last point.
      expect(scale.nearest(const [accuracy], 10000)!.x, 3);
      expect(scale.nearest(const [], 0), isNull);
    });

    test('evenTicks spaces count ticks between the bounds', () {
      final ticks = LineChart.evenTicks(
        0,
        1,
        count: 3,
        format: (v) => '${(v * 100).round()} %',
      );
      expect(ticks, const [
        LineChartTick(0, '0 %'),
        LineChartTick(0.5, '50 %'),
        LineChartTick(1, '100 %'),
      ]);
    });
  });

  group('LineChart', () {
    Widget chart({
      List<LineChartSeries> series = const [accuracy],
      ValueChanged<LineChartHit>? onPointSelected,
      LineChartTooltipBuilder? tooltipBuilder,
      double? selectedX,
    }) => SizedBox(
      width: 320,
      child: LineChart(
        series: series,
        semanticsLabel: 'Réussite',
        semanticsValue: 'de 40 % à 90 % sur 4 sessions',
        yMin: 0,
        yMax: 1,
        yTicks: LineChart.evenTicks(
          0,
          1,
          count: 3,
          format: (v) => '${(v * 100).round()} %',
        ),
        xTicks: const [
          LineChartTick(0, '01/09'),
          LineChartTick(3, '04/09'),
        ],
        formatX: (x) => 'session ${x.round() + 1}',
        formatY: (y) => '${(y * 100).round()} %',
        tooltipBuilder: tooltipBuilder,
        onPointSelected: onPointSelected,
        selectedX: selectedX,
      ),
    );

    testWidgets('is one semantics node with the summary as value', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpApp(chart());
      final node = tester.getSemantics(find.bySemanticsLabel('Réussite'));
      expect(node.value, 'de 40 % à 90 % sur 4 sessions');
      expect(tester.takeException(), isNull);
      expect(find.byType(CustomPaint), findsOneWidget);
      handle.dispose();
    });

    testWidgets('needs at least one series', (tester) async {
      await tester.pumpApp(
        const LineChart(series: [], semanticsLabel: 'l', semanticsValue: 'v'),
      );
      expect(tester.takeException(), isAssertionError);
    });

    testWidgets('hovering shows the default tooltip at the nearest point', (
      tester,
    ) async {
      await tester.pumpApp(chart(series: const [accuracy, speed]));
      expect(find.byType(LineChartTooltip), findsNothing);

      final box = tester.getRect(find.byType(LineChart));
      final gesture = await tester.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      // Right edge of the chart: the last point (x = 3).
      await gesture.moveTo(Offset(box.right - 2, box.center.dy));
      await tester.pumpAndSettle();
      expect(find.byType(LineChartTooltip), findsOneWidget);
      expect(find.text('session 4'), findsOneWidget);
      expect(find.text('Réussite : 90 %'), findsOneWidget);
      // The second series has no point at x = 3.
      expect(find.textContaining('Temps'), findsNothing);

      // Middle-left: x = 1 (accuracy only) or x = 0 / 2 (both).
      await gesture.moveTo(Offset(box.left + box.width * 0.6, box.center.dy));
      await tester.pumpAndSettle();
      expect(find.text('session 3'), findsOneWidget);
      expect(find.text('Réussite : 50 %'), findsOneWidget);
      // One formatter for every series: 700 goes through the percentage.
      expect(find.text('Temps : 70000 %'), findsOneWidget);

      await gesture.moveTo(Offset(box.left - 20, box.top - 20));
      await tester.pumpAndSettle();
      expect(find.byType(LineChartTooltip), findsNothing);
    });

    testWidgets('a custom tooltip builder receives the hit', (tester) async {
      await tester.pumpApp(
        chart(
          tooltipBuilder: (context, hit) => LineChartTooltip(
            child: Text('x=${hit.x.round()} y=${hit.entries.single.point.y}'),
          ),
        ),
      );
      await tester.hover(find.byType(LineChart));
      // Centre of a 4-point chart is between x = 1 and x = 2.
      expect(find.textContaining(RegExp(r'x=[12] y=0\.[56]')), findsOneWidget);
    });

    testWidgets('a tap reports the hit and keeps the tooltip visible', (
      tester,
    ) async {
      LineChartHit? selected;
      await tester.pumpApp(chart(onPointSelected: (hit) => selected = hit));
      final box = tester.getRect(find.byType(LineChart));
      await tester.tapAt(Offset(box.left + 4, box.center.dy));
      await tester.pumpAndSettle();
      expect(selected, isNotNull);
      expect(selected!.x, 0);
      expect(selected!.entries.single.pointIndex, 0);
      expect(find.byType(LineChartTooltip), findsOneWidget);
      expect(find.text('session 1'), findsOneWidget);
    });

    testWidgets('paints a persistent selection without error', (tester) async {
      await tester.pumpApp(chart(selectedX: 2));
      expect(tester.takeException(), isNull);
    });

    testWidgets('single point, dark theme and 1.3x paint without error', (
      tester,
    ) async {
      await tester.pumpApp(
        chart(
          series: const [
            LineChartSeries(label: 's', points: [LineChartPoint(0, 0.5)]),
          ],
        ),
        theme: AppTheme.dark(),
        textScale: 1.3,
      );
      expect(tester.takeException(), isNull);
      await tester.hover(find.byType(LineChart));
      expect(find.byType(LineChartTooltip), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('the tooltip disappears when its point leaves the data', (
      tester,
    ) async {
      await tester.pumpApp(chart());
      final box = tester.getRect(find.byType(LineChart));
      await tester.tapAt(Offset(box.right - 2, box.center.dy));
      await tester.pumpAndSettle();
      expect(find.text('session 4'), findsOneWidget);

      await tester.pumpApp(
        chart(
          series: const [
            LineChartSeries(
              label: 'Réussite',
              points: [LineChartPoint(0, 0.4), LineChartPoint(1, 0.6)],
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(LineChartTooltip), findsNothing);
    });
  });
}
