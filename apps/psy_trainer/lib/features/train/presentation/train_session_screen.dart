import 'package:flutter/widgets.dart';

import '../../../core/l10n/l10n_extensions.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/widgets.dart';
import '../domain/engine/activity_session_config.dart';

/// Placeholder for a training session; replaced by the real runner in
/// US-051.
///
/// The practice launcher (US-050) already navigates here with a fully
/// built [config] (passed as `extra` on the route, since no session id
/// exists yet): this shows a French summary of what would run so the whole
/// launcher flow is testable end to end. Without a [config] (a bare
/// `/train/session/:sessionId`, kept for the nested-route pattern
/// demonstrated before US-050) it falls back to showing the raw
/// [sessionId].
class TrainSessionScreen extends StatelessWidget {
  const TrainSessionScreen({required this.sessionId, this.config, super.key});

  final String sessionId;
  final ActivitySessionConfig? config;

  @override
  Widget build(BuildContext context) {
    final config = this.config;
    if (config == null) {
      return SafeArea(child: Center(child: Text('Session $sessionId')));
    }
    final theme = AppTheme.of(context);
    final familyName =
        config.title?.resolve(context.l10n.localeName) ?? config.familyId;
    return AppScaffold(
      title: context.l10n.trainSessionPlaceholderTitle,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(theme.spacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.trainSessionPlaceholderTitle,
                style: theme.textStyles.headline,
              ),
              SizedBox(height: theme.spacing.md),
              Text(context.l10n.trainSessionSummaryFamily(familyName)),
              Text(context.l10n.trainSessionSummaryItemCount(config.itemCount)),
              Text(
                config.timing.isUntimed
                    ? context.l10n.trainSessionSummaryUntimed
                    : context.l10n.trainSessionSummaryTimed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
