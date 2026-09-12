import 'dart:ui';

import 'package:flutter/foundation.dart';

/// Colour tokens of the design system.
///
/// Two palettes exist ([AppColors.light] and [AppColors.dark]); widgets never
/// hard-code a colour, they read one of these tokens through `AppTheme.of`.
///
/// Naming: `x` is a fill, `onX` is the foreground drawn on top of that fill,
/// `xSubtle` is a low-contrast tint of `x` used for backgrounds.
@immutable
class AppColors {
  const AppColors({
    required this.brightness,
    required this.background,
    required this.surface,
    required this.surfaceRaised,
    required this.border,
    required this.borderStrong,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.accent,
    required this.onAccent,
    required this.accentSubtle,
    required this.success,
    required this.onSuccess,
    required this.successSubtle,
    required this.error,
    required this.onError,
    required this.errorSubtle,
    required this.warning,
    required this.onWarning,
    required this.warningSubtle,
    required this.focusRing,
    required this.scrim,
  });

  /// Whether this palette is meant for a light or dark background.
  final Brightness brightness;

  /// Page background.
  final Color background;

  /// Cards, tiles, keypad keys.
  final Color surface;

  /// Hovered or slightly emphasised surfaces.
  final Color surfaceRaised;

  /// Hairline borders and dividers.
  final Color border;

  /// Borders that must stay visible (secondary button outline, idle tiles).
  final Color borderStrong;

  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;

  /// The single accent of the app: primary actions, selection, progress.
  final Color accent;
  final Color onAccent;
  final Color accentSubtle;

  final Color success;
  final Color onSuccess;
  final Color successSubtle;

  final Color error;
  final Color onError;
  final Color errorSubtle;

  final Color warning;
  final Color onWarning;
  final Color warningSubtle;

  /// Outline drawn around the focused interactive widget.
  final Color focusRing;

  /// Overlay behind sheets and dialogs.
  final Color scrim;

  /// Light palette: off-white ground, deep blue text, amber accent.
  static const AppColors light = AppColors(
    brightness: Brightness.light,
    background: Color(0xFFF5F7FA),
    surface: Color(0xFFFFFFFF),
    surfaceRaised: Color(0xFFEDF1F6),
    border: Color(0xFFD9DFE7),
    borderStrong: Color(0xFF9AA5B5),
    textPrimary: Color(0xFF0B1D3A),
    textSecondary: Color(0xFF3F4D63),
    textMuted: Color(0xFF6B7788),
    accent: Color(0xFFE08A1E),
    onAccent: Color(0xFF0B1D3A),
    accentSubtle: Color(0xFFFCEFD9),
    // Darker than a naive "success green" so `success`-on-`successSubtle`
    // text (e.g. `ConfidenceChip`) clears the WCAG AA 4.5:1 contrast ratio
    // for small text (was 4.29:1; `textContrastGuideline` caught it, US-123).
    success: Color(0xFF156B42),
    onSuccess: Color(0xFFFFFFFF),
    successSubtle: Color(0xFFDDF3E6),
    error: Color(0xFFB3261E),
    onError: Color(0xFFFFFFFF),
    errorSubtle: Color(0xFFF9DEDC),
    warning: Color(0xFFB26A00),
    onWarning: Color(0xFFFFFFFF),
    warningSubtle: Color(0xFFFCEBD2),
    focusRing: Color(0xFF1F5FBF),
    scrim: Color(0x990B1D3A),
  );

  /// Dark palette: near-black blue ground, off-white text, amber accent.
  static const AppColors dark = AppColors(
    brightness: Brightness.dark,
    background: Color(0xFF070F1E),
    surface: Color(0xFF0F1F3A),
    surfaceRaised: Color(0xFF17294A),
    border: Color(0xFF243656),
    borderStrong: Color(0xFF4C5F80),
    textPrimary: Color(0xFFF5F7FA),
    textSecondary: Color(0xFFC3CBD8),
    textMuted: Color(0xFF8A96AA),
    accent: Color(0xFFF2A93B),
    onAccent: Color(0xFF0B1D3A),
    accentSubtle: Color(0xFF3B2E14),
    success: Color(0xFF3DBB7A),
    onSuccess: Color(0xFF05130C),
    successSubtle: Color(0xFF10301F),
    error: Color(0xFFF2726A),
    onError: Color(0xFF1B0605),
    errorSubtle: Color(0xFF3F1715),
    warning: Color(0xFFF0B04A),
    onWarning: Color(0xFF1B1100),
    warningSubtle: Color(0xFF3A2A0C),
    focusRing: Color(0xFF7FB2FF),
    scrim: Color(0xB3000000),
  );
}
