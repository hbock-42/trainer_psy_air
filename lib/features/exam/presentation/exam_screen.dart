import 'package:flutter/widgets.dart';

import '../../../core/l10n/strings.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/widgets.dart';

/// Placeholder for the Exam tab; replaced by US-060.
class ExamScreen extends StatelessWidget {
  const ExamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return AppScaffold(
      body: Center(
        child: Text(AppStrings.tabExam, style: theme.textStyles.headline),
      ),
    );
  }
}
