import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/l10n/l10n_extensions.dart';
import 'package:psy_trainer/core/theme/app_theme.dart';
import 'package:psy_trainer/shared/widgets/widgets.dart';

import '../../../helpers/pump_app.dart';

final l10nFr = lookupAppLocalizations(const Locale('fr'));

void main() {
  group('block rendering', () {
    testWidgets('renders headings at every level', (tester) async {
      await tester.pumpApp(
        const MarkdownView('# H1\n\n## H2\n\n### H3\n\n#### H4'),
        align: false,
      );

      expect(find.text('H1'), findsOneWidget);
      expect(find.text('H2'), findsOneWidget);
      expect(find.text('H3'), findsOneWidget);
      expect(find.text('H4'), findsOneWidget);
    });

    testWidgets('renders a paragraph with bold, italic and inline code', (
      tester,
    ) async {
      await tester.pumpApp(
        const MarkdownView('Plain **bold** and *italic* and `code` text.'),
        align: false,
      );

      final richText = tester.widget<RichText>(find.byType(RichText).first);
      expect(richText.text.toPlainText(), contains('bold'));
      expect(richText.text.toPlainText(), contains('italic'));
      expect(find.text('code'), findsOneWidget);
    });

    testWidgets('renders unordered and ordered lists', (tester) async {
      await tester.pumpApp(
        const MarkdownView('- one\n- two\n\n1. first\n2. second'),
        align: false,
      );

      expect(find.text('one'), findsOneWidget);
      expect(find.text('two'), findsOneWidget);
      expect(find.text('first'), findsOneWidget);
      expect(find.text('second'), findsOneWidget);
      expect(find.text('1.'), findsOneWidget);
      expect(find.text('2.'), findsOneWidget);
      expect(find.text('•'), findsNWidgets(2));
    });

    testWidgets('renders a table with header and body cells', (tester) async {
      await tester.pumpApp(
        const MarkdownView('| A | B |\n|---|---|\n| 1 | 2 |'),
        align: false,
      );

      expect(find.byType(Table), findsOneWidget);
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('pads a ragged table row instead of throwing', (tester) async {
      await tester.pumpApp(
        const MarkdownView('| A | B | C |\n|---|---|---|\n| 1 | 2 |'),
        align: false,
      );

      expect(tester.takeException(), isNull);
      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('renders fenced code blocks', (tester) async {
      await tester.pumpApp(
        const MarkdownView('```\nsome code\n```'),
        align: false,
      );

      expect(find.textContaining('some code'), findsOneWidget);
    });

    testWidgets('renders a horizontal rule', (tester) async {
      await tester.pumpApp(
        const MarkdownView('Above\n\n---\n\nBelow'),
        align: false,
      );

      expect(find.text('Above'), findsOneWidget);
      expect(find.text('Below'), findsOneWidget);
    });

    testWidgets('renders a plain blockquote without a callout label', (
      tester,
    ) async {
      await tester.pumpApp(const MarkdownView('> Just a quote.'), align: false);

      expect(find.text('Just a quote.'), findsOneWidget);
      expect(find.text(l10nFr.lessonCalloutTip), findsNothing);
    });

    testWidgets('renders an image as an alt-text placeholder', (tester) async {
      await tester.pumpApp(
        const MarkdownView('![a chart](chart.png)'),
        align: false,
      );

      expect(tester.takeException(), isNull);
      expect(find.text('a chart'), findsOneWidget);
    });
  });

  group('callouts', () {
    testWidgets('TIP strips the marker and shows the label', (tester) async {
      await tester.pumpApp(
        const MarkdownView('> [!TIP]\n> Boire de l\'eau.'),
        align: false,
      );

      expect(find.text(l10nFr.lessonCalloutTip), findsOneWidget);
      expect(find.textContaining('[!TIP]'), findsNothing);
      expect(find.textContaining("Boire de l'eau."), findsOneWidget);
    });

    testWidgets('TRAP, METHOD and EXAMPLE each show their own label', (
      tester,
    ) async {
      await tester.pumpApp(
        const MarkdownView(
          '> [!TRAP]\n> Piège.\n\n'
          '> [!METHOD]\n> Méthode.\n\n'
          '> [!EXAMPLE]\n> Exemple.',
        ),
        align: false,
      );

      expect(find.text(l10nFr.lessonCalloutTrap), findsOneWidget);
      expect(find.text(l10nFr.lessonCalloutMethod), findsOneWidget);
      expect(find.text(l10nFr.lessonCalloutExample), findsOneWidget);
    });
  });

  group('worked examples (US-043)', () {
    const lesson = '''
## Exemple guidé 1 — un cas simple

> [!EXAMPLE]
> Énoncé de l'exemple.

### Étape 1

Premier raisonnement.

### Étape 2

Vérification finale.
''';

    testWidgets('the statement is visible but steps start hidden', (
      tester,
    ) async {
      await tester.pumpApp(const MarkdownView(lesson), align: false);

      expect(find.text("Énoncé de l'exemple."), findsOneWidget);
      expect(find.text('Premier raisonnement.'), findsNothing);
      expect(find.text('Vérification finale.'), findsNothing);
      expect(find.text(l10nFr.lessonRevealNextStep), findsOneWidget);
      expect(find.text(l10nFr.lessonRevealAllSteps), findsOneWidget);
    });

    testWidgets('"Étape suivante" reveals one step at a time', (tester) async {
      await tester.pumpApp(const MarkdownView(lesson), align: false);

      await tester.tap(find.text(l10nFr.lessonRevealNextStep));
      await tester.pump();

      expect(find.text('Premier raisonnement.'), findsOneWidget);
      expect(find.text('Vérification finale.'), findsNothing);
      // Last step left: "Tout afficher" no longer offered.
      expect(find.text(l10nFr.lessonRevealAllSteps), findsNothing);

      await tester.tap(find.text(l10nFr.lessonRevealNextStep));
      await tester.pump();

      expect(find.text('Vérification finale.'), findsOneWidget);
      expect(find.text(l10nFr.lessonRevealNextStep), findsNothing);
    });

    testWidgets('"Tout afficher" reveals every remaining step at once', (
      tester,
    ) async {
      await tester.pumpApp(const MarkdownView(lesson), align: false);

      await tester.tap(find.text(l10nFr.lessonRevealAllSteps));
      await tester.pump();

      expect(find.text('Premier raisonnement.'), findsOneWidget);
      expect(find.text('Vérification finale.'), findsOneWidget);
      expect(find.text(l10nFr.lessonRevealNextStep), findsNothing);
    });
  });

  group('1.3x text scale', () {
    testWidgets('a rich lesson survives without overflow', (tester) async {
      await tester.pumpApp(
        const MarkdownView('''
# Titre

Un paragraphe avec **gras** et `code`.

| A | B |
|---|---|
| 1 | 2 |

> [!TIP]
> Astuce.
'''),
        align: false,
        textScale: 1.3,
      );

      expect(tester.takeException(), isNull);
    });
  });

  group('dark mode', () {
    testWidgets('renders every block type without error', (tester) async {
      await tester.pumpApp(
        const MarkdownView('''
# Titre

Un paragraphe avec **gras** et `code`.

- une liste
1. et une ordonnée

| A | B |
|---|---|
| 1 | 2 |

> [!TRAP]
> Piège en thème sombre.
'''),
        align: false,
        theme: AppTheme.dark(),
      );

      expect(tester.takeException(), isNull);
      expect(find.text(l10nFr.lessonCalloutTrap), findsOneWidget);
    });
  });
}
