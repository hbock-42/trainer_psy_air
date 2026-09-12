import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/l10n/l10n_extensions.dart';
import 'package:psy_trainer/features/onboarding/domain/onboarding_answers.dart';
import 'package:psy_trainer/features/onboarding/domain/target_stage.dart';
import 'package:psy_trainer/features/onboarding/presentation/widgets/accept_toggle.dart';
import 'package:psy_trainer/features/onboarding/presentation/widgets/exam_date_step.dart';
import 'package:psy_trainer/features/onboarding/presentation/widgets/onboarding_flow.dart';
import 'package:psy_trainer/features/onboarding/presentation/widgets/target_stage_step.dart';
import 'package:psy_trainer/features/onboarding/presentation/widgets/welcome_step.dart';
import 'package:psy_trainer/shared/widgets/widgets.dart';

import '../../../../helpers/onboarding_fakes.dart';
import '../../../../helpers/pump_app.dart';

/// A Saturday in September 2026, one week after the 2026 PSY0 session, so
/// the suggested date is Saturday 4 September 2027.
final DateTime now = DateTime(2026, 9, 12, 10);

class _Harness {
  final List<OnboardingAnswers> submitted = [];
  int exits = 0;

  Widget build({OnboardingAnswers? initial}) => OnboardingFlow(
    initial: initial,
    clock: () => now,
    // Only the edit flow can leave from the first step.
    onExit: initial == null ? null : () => exits++,
    onSubmit: (answers) async => submitted.add(answers),
  );
}

VoidCallback? primaryAction(WidgetTester tester, String label) => tester
    .widget<PrimaryButton>(find.widgetWithText(PrimaryButton, label))
    .onPressed;

/// The disclaimer card pushes the toggle below the fold on the default test
/// surface, like on a small phone.
Future<void> toggleAccept(WidgetTester tester) async {
  await tester.ensureVisible(find.byType(AcceptToggle));
  await tester.tap(find.byType(AcceptToggle));
  await tester.pumpAndSettle();
}

Future<void> acceptAndContinue(WidgetTester tester) async {
  await toggleAccept(tester);
  await tester.tap(find.text(l10nFr.actionContinue));
  await tester.pumpAndSettle();
}

/// The [AppPressable] announced as [label] (buttons, steppers, back chevron).
Finder pressable(String label) => find.byWidgetPredicate(
  (widget) => widget is AppPressable && widget.semanticsLabel == label,
);

/// Scrolls [label] into view (steps scroll on a small surface) and taps it.
Future<void> tapPressable(WidgetTester tester, String label) async {
  await tester.ensureVisible(pressable(label));
  await tester.tap(pressable(label));
  await tester.pumpAndSettle();
}

final l10nFr = lookupAppLocalizations(const Locale('fr'));

void main() {
  Future<_Harness> pumpFlow(
    WidgetTester tester, {
    OnboardingAnswers? initial,
  }) async {
    final harness = _Harness();
    await pumpApp(tester, harness.build(initial: initial));
    await tester.pumpAndSettle();
    return harness;
  }

  group('step 1 (welcome + disclaimer)', () {
    testWidgets('shows the disclaimer and blocks until it is accepted', (
      tester,
    ) async {
      await pumpFlow(tester);

      expect(find.byType(WelcomeStep), findsOneWidget);
      expect(find.text(l10nFr.disclaimerTitle), findsOneWidget);
      expect(find.text(l10nFr.disclaimerParagraph1), findsOneWidget);
      expect(find.text(l10nFr.onboardingDisclaimerRequired), findsOneWidget);
      expect(primaryAction(tester, l10nFr.actionContinue), isNull);
      // No skip and no back on the first step of a first run.
      expect(find.text(l10nFr.actionSkip), findsNothing);
      expect(pressable('Back'), findsNothing);

      await toggleAccept(tester);

      expect(find.text(l10nFr.onboardingDisclaimerRequired), findsNothing);
      expect(primaryAction(tester, l10nFr.actionContinue), isNotNull);

      // Toggling back off disables the button again.
      await toggleAccept(tester);
      expect(primaryAction(tester, l10nFr.actionContinue), isNull);
    });

    testWidgets('continue moves to the exam date step', (tester) async {
      await pumpFlow(tester);

      await acceptAndContinue(tester);

      expect(find.byType(ExamDateStep), findsOneWidget);
      expect(find.text(l10nFr.actionSkip), findsOneWidget);
      expect(pressable('Back'), findsOneWidget);
    });
  });

  group('step 2 (exam date)', () {
    testWidgets('suggests the next first Saturday of September', (
      tester,
    ) async {
      await pumpFlow(tester);
      await acceptAndContinue(tester);

      // Suggestion line and the stepper's own read-back.
      expect(find.text('samedi 4 septembre 2027'), findsWidgets);
      expect(find.text('2027'), findsOneWidget);
      expect(find.text('sept.'), findsOneWidget);
      expect(find.text('4'), findsOneWidget);
      expect(primaryAction(tester, l10nFr.actionContinue), isNotNull);
    });

    testWidgets('refuses a past date and accepts it again once fixed', (
      tester,
    ) async {
      await pumpFlow(tester);
      await acceptAndContinue(tester);

      // 4 September 2026 is before "today" (12 September 2026).
      await tapPressable(tester, 'Année, Précédent');

      expect(find.text('vendredi 4 septembre 2026'), findsOneWidget);
      expect(find.text(l10nFr.onboardingExamDateInThePast), findsOneWidget);
      expect(primaryAction(tester, l10nFr.actionContinue), isNull);
      // The year cannot go below the current one.
      expect(pressable('Année, Précédent'), findsOneWidget);

      // Move the month forward: October 2026 is in the future again.
      await tapPressable(tester, 'Mois, Suivant');

      expect(find.text('dimanche 4 octobre 2026'), findsOneWidget);
      expect(find.text(l10nFr.onboardingExamDateInThePast), findsNothing);
      expect(primaryAction(tester, l10nFr.actionContinue), isNotNull);
    });

    testWidgets('day and month wrap, the day is clamped to the month', (
      tester,
    ) async {
      await pumpFlow(tester);
      await acceptAndContinue(tester);

      // 4 Sept 2027 -> day 3, 2, 1, then wraps to 30.
      for (var i = 0; i < 4; i++) {
        await tapPressable(tester, 'Jour, Précédent');
      }
      expect(find.text('jeudi 30 septembre 2027'), findsOneWidget);

      // Then forward one: 31 is not in September, wraps to 1.
      await tapPressable(tester, 'Jour, Suivant');
      expect(find.text('mercredi 1 septembre 2027'), findsOneWidget);

      // Month wraps December -> January (next month steps stay in the year).
      for (var i = 0; i < 4; i++) {
        await tapPressable(tester, 'Mois, Suivant');
      }
      expect(find.text('vendredi 1 janvier 2027'), findsOneWidget);
    });

    testWidgets('the chosen date is submitted with the answers', (
      tester,
    ) async {
      final harness = await pumpFlow(tester);
      await acceptAndContinue(tester);

      await tapPressable(tester, 'Année, Suivant');
      await tester.tap(find.text(l10nFr.actionContinue));
      await tester.pumpAndSettle();
      expect(find.byType(TargetStageStep), findsOneWidget);
      await tester.tap(find.text(l10nFr.actionFinish));
      await tester.pumpAndSettle();

      expect(harness.submitted, hasLength(1));
      final answers = harness.submitted.single;
      expect(answers.examDate, DateTime.utc(2028, 9, 4));
      expect(answers.targetStage, TargetStage.psy0);
      expect(answers.disclaimerAcceptedAt, now.toUtc());
    });

    testWidgets('"I don\'t know yet" continues without a date', (tester) async {
      final harness = await pumpFlow(tester);
      await acceptAndContinue(tester);

      await tester.tap(find.text(l10nFr.onboardingExamDateUnknown));
      await tester.pumpAndSettle();
      expect(find.byType(TargetStageStep), findsOneWidget);
      await tester.tap(find.text(l10nFr.actionFinish));
      await tester.pumpAndSettle();

      expect(harness.submitted.single.examDate, isNull);
    });

    testWidgets('back returns to the welcome step, acceptance kept', (
      tester,
    ) async {
      await pumpFlow(tester);
      await acceptAndContinue(tester);

      await tapPressable(tester, 'Back');

      expect(find.byType(WelcomeStep), findsOneWidget);
      expect(primaryAction(tester, l10nFr.actionContinue), isNotNull);
    });
  });

  group('step 3 (target stage)', () {
    testWidgets('PSY0 is selected by default; PSY1/PSY2 are coming soon', (
      tester,
    ) async {
      final harness = await pumpFlow(tester);
      await acceptAndContinue(tester);
      await tester.tap(find.text(l10nFr.onboardingExamDateUnknown));
      await tester.pumpAndSettle();

      final tiles = tester
          .widgetList<AnswerOptionTile>(find.byType(AnswerOptionTile))
          .toList();
      expect(tiles, hasLength(3));
      expect(tiles[0].state, AnswerOptionState.selected);
      expect(tiles[1].state, AnswerOptionState.disabled);
      expect(tiles[2].state, AnswerOptionState.disabled);
      expect(find.text(l10nFr.stageComingSoon), findsNWidgets(2));

      // Tapping a disabled stage changes nothing.
      await tester.tap(find.text(l10nFr.stagePsy1Title));
      await tester.pumpAndSettle();
      await tester.tap(find.text(l10nFr.actionFinish));
      await tester.pumpAndSettle();
      expect(harness.submitted.single.targetStage, TargetStage.psy0);
    });
  });

  group('skip', () {
    testWidgets('submits the defaults but keeps the disclaimer accepted', (
      tester,
    ) async {
      final harness = await pumpFlow(tester);
      await acceptAndContinue(tester);

      await tester.tap(find.text(l10nFr.actionSkip));
      await tester.pumpAndSettle();

      expect(
        harness.submitted.single,
        OnboardingAnswers.skipped(disclaimerAcceptedAt: now.toUtc()),
      );
    });
  });

  group('editing', () {
    testWidgets('prefills the answers, no skip, saves, exits from step 1', (
      tester,
    ) async {
      final harness = await pumpFlow(tester, initial: completedAnswers);

      // Already accepted: continue is enabled; back on step 1 exits.
      expect(find.text(l10nFr.onboardingEditTitle), findsOneWidget);
      expect(primaryAction(tester, l10nFr.actionContinue), isNotNull);
      await tapPressable(tester, 'Back');
      expect(harness.exits, 1);

      await tester.tap(find.text(l10nFr.actionContinue));
      await tester.pumpAndSettle();
      expect(find.text(l10nFr.actionSkip), findsNothing);
      expect(find.text('samedi 4 septembre 2027'), findsWidgets);
      await tester.tap(find.text(l10nFr.actionContinue));
      await tester.pumpAndSettle();
      expect(find.text(l10nFr.actionFinish), findsNothing);
      await tester.tap(find.text(l10nFr.actionSave));
      await tester.pumpAndSettle();

      expect(harness.submitted.single, completedAnswers);
    });
  });
}
