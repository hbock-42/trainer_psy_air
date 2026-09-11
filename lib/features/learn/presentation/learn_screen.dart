import 'package:flutter/widgets.dart';

import '../../../core/l10n/strings.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/widgets.dart';

/// Placeholder for the Learn (home) tab; replaced by US-040.
///
/// Shows the app name and the unofficial-trainer disclaimer required by the
/// PSY0 spec (§7): the app must state that it is not affiliated with Air
/// France and that its content is estimated.
class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return AppScaffold(
      body: ListView(
        padding: EdgeInsets.all(theme.spacing.lg),
        children: [
          Semantics(
            header: true,
            child: Text(AppStrings.appName, style: theme.textStyles.headline),
          ),
          SizedBox(height: theme.spacing.sm),
          Text(AppStrings.disclaimerShort, style: theme.textStyles.caption),
          SizedBox(height: theme.spacing.xl),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.disclaimerTitle,
                  style: theme.textStyles.bodyStrong,
                ),
                SizedBox(height: theme.spacing.sm),
                const Text(AppStrings.disclaimerParagraph1),
                SizedBox(height: theme.spacing.sm),
                const Text(AppStrings.disclaimerParagraph2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
