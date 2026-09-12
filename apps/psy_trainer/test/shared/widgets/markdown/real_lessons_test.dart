import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/shared/widgets/widgets.dart';

import '../../../helpers/pump_app.dart';

/// Every real lesson under `assets/content/psy0/lessons/` must parse and
/// render without throwing: the callouts, tables, lists and worked examples
/// authored there (`docs/content/AUTHORING.md` §10) are the actual contract
/// [MarkdownView] has to support, not just the synthetic fixtures in
/// `markdown_view_test.dart`.
void main() {
  final lessonFiles =
      Directory('assets/content/psy0/lessons')
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.fr.md'))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));

  test('at least one real lesson file is found', () {
    expect(lessonFiles, isNotEmpty);
  });

  for (final file in lessonFiles) {
    testWidgets('renders ${file.path} without throwing', (tester) async {
      final markdown = file.readAsStringSync();

      // Scrollable, like the real lesson screen: a long lesson must not be
      // judged an "overflow" just because it is taller than the viewport.
      await tester.pumpApp(
        SingleChildScrollView(child: MarkdownView(markdown)),
        align: false,
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('renders ${file.path} at 1.3x text scale without overflow', (
      tester,
    ) async {
      final markdown = file.readAsStringSync();

      await tester.pumpApp(
        SingleChildScrollView(child: MarkdownView(markdown)),
        align: false,
        textScale: 1.3,
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  }
}
