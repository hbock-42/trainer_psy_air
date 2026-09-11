import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/app.dart';
import 'package:psy_trainer/features/learn/presentation/learn_screen.dart';

void main() {
  testWidgets('root is a WidgetsApp under a ProviderScope and shows a tab', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: PsyTrainerApp()));
    await tester.pumpAndSettle();

    expect(find.byType(WidgetsApp), findsOneWidget);
    expect(find.byType(LearnScreen), findsOneWidget);
    expect(find.text('Learn'), findsOneWidget);
  });
}
