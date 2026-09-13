import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n_extensions.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/widgets.dart';
import 'providers/psy2_lessons_provider.dart';

/// "Comment se passe le PSY2" (US-111/US-112): the module-level overview
/// lesson(s) -- structure of the final selection stage, what the app can
/// (and cannot) help prepare, the ethics/confidentiality note.
class Psy2HowItWorksScreen extends ConsumerWidget {
  const Psy2HowItWorksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppTheme.of(context);
    final lessons = ref.watch(psy2OverviewLessonsProvider);

    return AppScaffold(
      title: context.l10n.psy2HowItWorksTitle,
      onBack: context.pop,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(theme.spacing.lg),
        child: switch (lessons) {
          AsyncData(value: final list) when list.isEmpty => Text(
            context.l10n.psy2HowItWorksEmpty,
            style: theme.textStyles.body,
          ),
          AsyncData(value: final list) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final lesson in list) ...[
                Text(lesson.title.fr, style: theme.textStyles.headline),
                SizedBox(height: theme.spacing.md),
                MarkdownView(lesson.body?.fr ?? ''),
                SizedBox(height: theme.spacing.xl),
              ],
            ],
          ),
          _ => const SizedBox.shrink(),
        },
      ),
    );
  }
}
