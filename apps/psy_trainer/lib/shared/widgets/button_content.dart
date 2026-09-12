import 'package:flutter/widgets.dart';

import '../../core/theme/app_theme.dart';
import 'app_icon.dart';

/// Icon + label row shared by [PrimaryButton] and [SecondaryButton].
/// Internal to the design system; do not use it directly.
class ButtonContent extends StatelessWidget {
  const ButtonContent({
    required this.label,
    required this.icon,
    required this.color,
    required this.expand,
    required this.style,
    super.key,
  });

  final String label;
  final AppIconGlyph? icon;
  final Color color;
  final bool expand;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final spacing = AppTheme.of(context).spacing;
    return Row(
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          AppIcon(icon!, size: 20, color: color),
          SizedBox(width: spacing.sm),
        ],
        Flexible(
          child: Text(
            label,
            style: style.copyWith(color: color),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ],
    );
  }
}
