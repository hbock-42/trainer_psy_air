import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/onboarding/presentation/providers/onboarding_completed_provider.dart';
import '../db/seed/content_ready_provider.dart';
import '../l10n/l10n_extensions.dart';
import '../theme/app_theme.dart';
import 'error_screen.dart';

/// Holds the router back until the app can show its first screen (US-013).
///
/// Installed by the root `builder` in `lib/app.dart`, *around* the `Router`
/// widget, so no route is resolved (and no screen built) before:
///
/// - the content is seeded ([contentReadyProvider]);
/// - the onboarding flag is hydrated ([onboardingCompletedProvider]), started
///   here so it runs in parallel with the seeding rather than after it.
///
/// Until then it paints the page background and, after [splashDelay], a
/// "Chargement du contenu…" splash: a warm launch (content up to date) takes
/// a few milliseconds and never shows the splash, a first launch or a
/// content update shows it for the seeding time. A seeding failure shows
/// [ErrorScreen] with a retry that re-runs the seeder.
class StartupGate extends ConsumerWidget {
  const StartupGate({required this.child, super.key});

  /// How long the gate stays blank before the splash text appears.
  static const Duration splashDelay = Duration(milliseconds: 250);

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final content = ref.watch(contentReadyProvider);
    final onboarding = ref.watch(onboardingCompletedProvider);
    return switch (content) {
      AsyncError(:final error) => ErrorScreen(
        error: error,
        onRetry: () => ref.invalidate(contentReadyProvider),
      ),
      AsyncData() when onboarding != null => child,
      _ => const SplashScreen(),
    };
  }
}

/// The startup splash: app name and a status line, fading in after
/// [StartupGate.splashDelay] so a fast startup shows only the background.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer(StartupGate.splashDelay, () {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return ColoredBox(
      color: theme.colors.background,
      child: SafeArea(
        child: AnimatedOpacity(
          opacity: _visible ? 1 : 0,
          duration: theme.durations.slow,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(context.l10n.appName, style: theme.textStyles.display),
                SizedBox(height: theme.spacing.md),
                Text(
                  context.l10n.startupLoadingContent,
                  style: theme.textStyles.body.copyWith(
                    color: theme.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
