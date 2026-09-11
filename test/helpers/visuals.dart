import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/shared/widgets/widgets.dart';

/// Reads the visuals a design-system control is currently showing.
extension ControlVisuals on WidgetTester {
  /// Background colour of the first `AnimatedContainer` under [finder].
  Color? backgroundOf(Finder finder) {
    final container = widget<AnimatedContainer>(
      find
          .descendant(of: finder, matching: find.byType(AnimatedContainer))
          .first,
    );
    return (container.decoration as BoxDecoration?)?.color;
  }

  /// Border colour of the first `AnimatedContainer` under [finder].
  Color? borderColorOf(Finder finder) {
    final container = widget<AnimatedContainer>(
      find
          .descendant(of: finder, matching: find.byType(AnimatedContainer))
          .first,
    );
    final border = (container.decoration as BoxDecoration?)?.border as Border?;
    return border?.top.color;
  }

  /// Whether the focus ring under [finder] is visible.
  bool focusRingVisible(Finder finder) {
    return widget<AppFocusRing>(
      find.descendant(of: finder, matching: find.byType(AppFocusRing)).first,
    ).visible;
  }
}
