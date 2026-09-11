import 'package:flutter/widgets.dart';

import '../../../core/l10n/strings.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/widgets.dart';

/// Placeholder for the Settings tab; replaced by US-091.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return AppScaffold(
      body: Center(
        child: Text(AppStrings.tabSettings, style: theme.textStyles.headline),
      ),
    );
  }
}
