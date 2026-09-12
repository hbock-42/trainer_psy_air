import 'package:flutter/widgets.dart';

import '../../../core/l10n/strings.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/widgets.dart';

/// Placeholder for the Train tab; replaced by US-050.
class TrainScreen extends StatelessWidget {
  const TrainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return AppScaffold(
      body: Center(
        child: Text(AppStrings.tabTrain, style: theme.textStyles.headline),
      ),
    );
  }
}
