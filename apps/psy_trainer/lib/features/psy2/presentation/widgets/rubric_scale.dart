import 'package:flutter/widgets.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/widgets.dart';

/// One self-assessment row: a label and a 1..[max] [SegmentedChoice] (both
/// the interview rubric, US-111, and the group-exercise CRM checklist,
/// US-112, are "score this dimension 1-4").
class RubricScale<T> extends StatelessWidget {
  const RubricScale({
    required this.criterion,
    required this.label,
    required this.value,
    required this.onChanged,
    this.min = 1,
    this.max = 4,
    super.key,
  });

  final T criterion;
  final String label;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textStyles.bodyStrong),
        SizedBox(height: theme.spacing.xs),
        SegmentedChoice<int>(
          semanticsLabel: label,
          selected: value,
          onSelected: onChanged,
          options: [
            for (var v = min; v <= max; v++)
              SegmentedOption(value: v, label: '$v'),
          ],
        ),
      ],
    );
  }
}
