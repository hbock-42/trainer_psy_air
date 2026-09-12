import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n_extensions.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/widgets.dart';
import 'providers/package_info_provider.dart';

/// "À propos" (US-091): app version, the unofficial-trainer disclaimer
/// (verbatim from `docs/content/psy0-spec.md` §7, same text as onboarding)
/// and a short source list (§6 of the same document).
class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppTheme.of(context);
    final packageInfo = ref.watch(packageInfoProvider);

    return AppScaffold(
      title: context.l10n.aboutTitle,
      onBack: context.pop,
      bodyPadding: EdgeInsets.all(theme.spacing.lg),
      body: ListView(
        children: [
          Text(
            '${context.l10n.aboutVersionLabel}: '
            '${packageInfo.value?.version ?? context.l10n.aboutVersionUnknown}',
            style: theme.textStyles.bodyStrong,
          ),
          SizedBox(height: theme.spacing.xl),
          SectionHeader(title: context.l10n.disclaimerTitle),
          SizedBox(height: theme.spacing.sm),
          Text(context.l10n.disclaimerParagraph1),
          SizedBox(height: theme.spacing.sm),
          Text(context.l10n.disclaimerParagraph2),
          SizedBox(height: theme.spacing.xl),
          SectionHeader(title: context.l10n.aboutSourcesTitle),
          SizedBox(height: theme.spacing.sm),
          Text(
            '• ${context.l10n.aboutSourceAirFranceCorporate}\n'
            'corporate.airfrance.com/fr/pilote-de-ligne',
            style: theme.textStyles.caption,
          ),
          SizedBox(height: theme.spacing.sm),
          Text(
            '• ${context.l10n.aboutSourceAirFranceRecruitment}\n'
            'recrutement.airfrance.com',
            style: theme.textStyles.caption,
          ),
          SizedBox(height: theme.spacing.sm),
          Text(
            '• ${context.l10n.aboutSourceAirFranceNews}\n'
            'corporate.airfrance.com/fr/actualites',
            style: theme.textStyles.caption,
          ),
        ],
      ),
    );
  }
}
