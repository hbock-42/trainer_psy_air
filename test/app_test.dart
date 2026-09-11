import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/app.dart';

void main() {
  testWidgets('root is a WidgetsApp and renders the placeholder screen', (
    tester,
  ) async {
    await tester.pumpWidget(const PsyTrainerApp());

    expect(find.byType(WidgetsApp), findsOneWidget);
    expect(find.byType(PlaceholderScreen), findsOneWidget);
    expect(find.text('PSY Trainer'), findsOneWidget);
  });
}
