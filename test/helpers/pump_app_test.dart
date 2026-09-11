import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'pump_app.dart';

final _greetingProvider = Provider<String>((ref) => 'hello');

void main() {
  testWidgets('pumpApp provides Directionality, MediaQuery and text style', (
    tester,
  ) async {
    late BuildContext captured;
    await pumpApp(
      tester,
      Builder(
        builder: (context) {
          captured = context;
          return const Text('probe');
        },
      ),
    );

    expect(Directionality.of(captured), TextDirection.ltr);
    expect(MediaQuery.maybeOf(captured), isNotNull);
    expect(DefaultTextStyle.of(captured).style.color, testForeground);
    expect(find.text('probe'), findsOneWidget);
  });

  testWidgets('pumpApp applies Riverpod overrides', (tester) async {
    await pumpApp(
      tester,
      Consumer(
        builder: (context, ref, _) => Text(ref.watch(_greetingProvider)),
      ),
      overrides: [_greetingProvider.overrideWithValue('bonjour')],
    );

    expect(find.text('bonjour'), findsOneWidget);
    expect(find.text('hello'), findsNothing);
  });
}
