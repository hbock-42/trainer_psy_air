import 'package:flutter/widgets.dart';

import '../../../core/l10n/strings.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/widgets.dart';

/// Placeholder for the Progress tab; replaced by US-070.
class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return AppScaffold(
      body: Center(
        child: Text(AppStrings.tabProgress, style: theme.textStyles.headline),
      ),
    );
  }
}
