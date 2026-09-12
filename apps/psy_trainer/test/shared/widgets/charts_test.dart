import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/theme/app_theme.dart';
import 'package:psy_trainer/shared/widgets/widgets.dart';

import '../../helpers/pump_app.dart';

void main() {
  final light = AppTheme.light();

  group('ArcGauge', () {
    testWidgets('announces label and value, hides the painted parts', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpApp(
        const ArcGauge(
          value: 0.62,
          semanticsLabel: 'Readiness',
          semanticsValue: '62 out of 100',
          child: Text('62'),
        ),
      );
      final node = tester.getSemantics(find.bySemanticsLabel('Readiness'));
      expect(node.value, '62 out of 100');
      expect(find.text('62'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('paints without error at the extremes and at 1.3x', (
      tester,
    ) async {
      for (final value in [-1.0, 0.0, 1.0, 2.0]) {
        await tester.pumpApp(
          ArcGauge(
            value: value,
            size: 120,
            semanticsLabel: 'g',
            semanticsValue: '$value',
            child: const Text('100'),
          ),
          textScale: 1.3,
        );
        expect(tester.takeException(), isNull, reason: '$value');
        expect(
          tester.getSize(find.byType(ArcGauge)),
          const Size(120, 120),
          reason: '$value',
        );
      }
    });
  });

  group('RadarChart', () {
    const axes = [
      RadarChartAxis(label: 'Calcul', value: 0.5, valueLabel: 'niveau 3'),
      RadarChartAxis(label: 'Logique', value: 1),
      RadarChartAxis(label: 'Mémoire', value: 0),
    ];

    testWidgets('needs at least three axes', (tester) async {
      expect(RadarChart.minAxes, 3);
      await tester.pumpApp(
        RadarChart(axes: axes.take(2).toList(), semanticsLabel: 'r'),
      );
      expect(tester.takeException(), isAssertionError);
    });

    test('describe lists every axis with its value label or a percentage', () {
      expect(
        RadarChart.describe(axes),
        'Calcul : niveau 3, Logique : 100 %, Mémoire : 0 %',
      );
    });

    testWidgets('is one semantics node with the description as value', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpApp(
        const SizedBox(
          width: 300,
          child: RadarChart(axes: axes, semanticsLabel: 'Levels'),
        ),
      );
      final node = tester.getSemantics(find.bySemanticsLabel('Levels'));
      expect(node.value, RadarChart.describe(axes));
      expect(tester.takeException(), isNull);
      handle.dispose();
    });

    testWidgets('fills the width up to maxSize and stays square', (
      tester,
    ) async {
      await tester.pumpApp(
        const SizedBox(
          width: 200,
          child: RadarChart(axes: axes, semanticsLabel: 'r'),
        ),
      );
      expect(tester.getSize(find.byType(CustomPaint)), const Size(200, 200));

      await tester.pumpApp(
        const SizedBox(
          width: 500,
          child: RadarChart(axes: axes, semanticsLabel: 'r'),
        ),
      );
      expect(tester.getSize(find.byType(CustomPaint)), const Size(320, 320));
    });

    testWidgets('many long labels at 1.3x paint without error', (tester) async {
      await tester.pumpApp(
        SizedBox(
          width: 320,
          child: RadarChart(
            semanticsLabel: 'r',
            axes: [
              for (var i = 0; i < 15; i++)
                RadarChartAxis(
                  label: 'Une famille au nom vraiment long $i',
                  value: i / 14,
                ),
            ],
          ),
        ),
        textScale: 1.3,
      );
      expect(tester.takeException(), isNull);
    });
  });

  group('HorizontalBarChart', () {
    testWidgets('needs at least one entry', (tester) async {
      await tester.pumpApp(
        const HorizontalBarChart(entries: [], semanticsLabel: 'b'),
      );
      expect(tester.takeException(), isAssertionError);
    });

    testWidgets('shows labels and values, one semantics node', (tester) async {
      final handle = tester.ensureSemantics();
      final entries = [
        const BarChartEntry(
          label: 'Calcul',
          value: 0.6,
          valueLabel: 'niveau 3',
        ),
        BarChartEntry(label: 'Anglais', value: 0.2, color: light.colors.error),
      ];
      await tester.pumpApp(
        SizedBox(
          width: 300,
          child: HorizontalBarChart(entries: entries, semanticsLabel: 'Levels'),
        ),
      );
      expect(find.text('Calcul'), findsOneWidget);
      expect(find.text('niveau 3'), findsOneWidget);
      expect(find.text('20 %'), findsOneWidget);
      final node = tester.getSemantics(find.bySemanticsLabel('Levels'));
      expect(node.value, 'Calcul : niveau 3, Anglais : 20 %');
      expect(find.byType(CustomPaint), findsNWidgets(2));
      handle.dispose();
    });

    testWidgets('narrow at 1.3x does not overflow', (tester) async {
      await tester.pumpApp(
        const SizedBox(
          width: 160,
          child: HorizontalBarChart(
            semanticsLabel: 'b',
            entries: [
              BarChartEntry(
                label: 'Une famille au nom vraiment très long',
                value: 1,
                valueLabel: 'niveau 5 sur 5',
              ),
              BarChartEntry(label: 'Vide', value: 0),
            ],
          ),
        ),
        textScale: 1.3,
      );
      expect(tester.takeException(), isNull);
    });
  });
}
