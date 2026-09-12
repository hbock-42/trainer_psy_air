import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../shared/widgets/primary_button.dart';
import '../../shared/widgets/secondary_button.dart';
import '../l10n/strings.dart';
import '../theme/app_theme.dart';
import 'app_routes.dart';

/// Shown by go_router when a location does not match any route or a route
/// throws while being resolved (`errorBuilder`), and by the startup gate
/// when the content cannot be seeded (US-013).
///
/// With [onRetry] a primary "Réessayer" button is shown. The "back to home"
/// action only appears when a router is available in [context] (it is not
/// under the startup gate, which sits above the router).
class ErrorScreen extends StatelessWidget {
  const ErrorScreen({this.error, this.onRetry, super.key});

  /// The error to describe, if any.
  final Object? error;

  /// Called by the retry button; no button without it.
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final router = GoRouter.maybeOf(context);
    return ColoredBox(
      color: theme.colors.background,
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(theme.spacing.xl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    AppStrings.errorTitle,
                    style: theme.textStyles.headline,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: theme.spacing.md),
                  Text(
                    error?.toString() ?? AppStrings.errorUnknown,
                    style: theme.textStyles.body.copyWith(
                      color: theme.colors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: theme.spacing.xl),
                  if (onRetry != null)
                    PrimaryButton(
                      label: AppStrings.actionRetry,
                      onPressed: onRetry,
                    ),
                  if (onRetry != null && router != null)
                    SizedBox(height: theme.spacing.sm),
                  if (router != null)
                    SecondaryButton(
                      label: AppStrings.errorBackHome,
                      onPressed: () => router.go(AppRoutes.initial),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
