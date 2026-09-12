import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/l10n/l10n_extensions.dart';
import 'package:psy_trainer/features/learn/presentation/how_it_works_screen.dart';
import 'package:psy_trainer/features/learn/presentation/selection_stages.dart';
import 'package:psy_trainer/features/learn/presentation/widgets/confidence_chip.dart';
import 'package:psy_trainer/features/learn/presentation/widgets/selection_stage_card.dart';

import '../../../helpers/pump_app.dart';

final l10nFr = lookupAppLocalizations(const Locale('fr'));

void main() {
  testWidgets('lists the stages PSY0 → PSY1 → PSY2 → medical in order', (
    tester,
  ) async {
    await pumpApp(tester, const HowItWorksScreen());
    await tester.pumpAndSettle();

    final cards = find.byType(SelectionStageCard, skipOffstage: false);
    final context = tester.element(find.byType(HowItWorksScreen));
    final stages = selectionStagesOf(context);
    expect(cards, findsNWidgets(stages.length));
    final titles = tester
        .widgetList<SelectionStageCard>(cards)
        .map((c) => c.stage.title)
        .toList();
    expect(
      titles,
      containsAllInOrder([
        l10nFr.stagePsy0Title,
        l10nFr.stagePsy1Title,
        l10nFr.stagePsy2Title,
        l10nFr.stageMedicalTitle,
      ]),
    );
    expect(stages.where((s) => s.isTarget).map((s) => s.title), [
      l10nFr.stagePsy0Title,
    ]);
  });

  testWidgets('renders confidence chips for facts', (tester) async {
    await pumpApp(tester, const HowItWorksScreen());
    await tester.pumpAndSettle();

    final chips = tester.widgetList<ConfidenceChip>(
      find.byType(ConfidenceChip, skipOffstage: false),
    );
    expect(chips.map((c) => c.confidence), contains(Confidence.reported));
    expect(chips.map((c) => c.confidence), contains(Confidence.confirmed));
    expect(
      find.descendant(
        of: find.byType(ConfidenceChip, skipOffstage: false),
        matching: find.textContaining(
          l10nFr.stagePsy1FactVenue,
          skipOffstage: false,
        ),
      ),
      findsOneWidget,
    );
  });

  testWidgets('ends with the full disclaimer', (tester) async {
    await pumpApp(tester, const HowItWorksScreen());
    await tester.pumpAndSettle();

    expect(
      find.text(l10nFr.disclaimerParagraph2, skipOffstage: false),
      findsOneWidget,
    );
  });

  testWidgets('survives 1.3x text scaling on a phone', (tester) async {
    tester.view.physicalSize = const Size(360, 780);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await pumpApp(tester, const HowItWorksScreen(), textScale: 1.3);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
