import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/widgets.dart' show Locale;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/learn/presentation/providers/flashcards_queue_provider.dart';
import '../../features/progress/domain/recommendation.dart';
import '../../features/progress/presentation/providers/exam_date_provider.dart';
import '../../features/progress/presentation/providers/recommendations_provider.dart';
import '../../features/settings/presentation/providers/app_settings_provider.dart';
import '../../features/settings/presentation/providers/reminder_settings_provider.dart';
import '../l10n/l10n_extensions.dart';
import 'reminder_content.dart';
import 'reminder_scheduler_provider.dart';

/// US-092: (re)schedules the daily reminder whenever anything it depends on
/// changes — the reminder settings themselves, the exam date, the due
/// flashcard count or the weakest family (both folded into
/// `recommendationsProvider`, which already reacts to every attempt through
/// `progressVersionProvider`) — and once at app start, since the first
/// `ref.watch` of a provider runs it.
///
/// Watched from `PsyTrainerApp` (`lib/app.dart`) purely for its side effect;
/// nothing reads its value. Composed here rather than in `features/settings`
/// because it reaches into `features/learn` and `features/progress` too —
/// the same reason `StartupGate` (`core/router/startup_gate.dart`) already
/// imports a feature provider for app-wide orchestration.
final FutureProvider<void> reminderCoordinatorProvider = FutureProvider<void>((
  ref,
) async {
  final scheduler = ref.watch(reminderSchedulerProvider);
  if (!scheduler.isSupported) return;

  final settings = ref.watch(reminderSettingsProvider);
  if (!settings.enabled) {
    await scheduler.cancel();
    return;
  }

  final l10n = await _loadL10n(ref);
  final examDate = await ref.watch(examDateProvider.future);
  final examDaysLeft = examDate == null
      ? null
      : daysUntil(examDate, DateTime.now());
  final dueFlashcards = await ref.watch(flashcardsDueTodayProvider.future);
  final recommendations = await ref.watch(recommendationsProvider.future);

  String? weakestFamilyName;
  for (final recommendation in recommendations) {
    if (recommendation.kind == RecommendationKind.family ||
        recommendation.kind == RecommendationKind.tag) {
      weakestFamilyName = recommendation.title;
      break;
    }
  }

  final content = const ReminderContentBuilder().build(
    inputs: ReminderContentInputs(
      dueFlashcards: dueFlashcards,
      weakestFamilyName: weakestFamilyName,
      examDaysLeft: examDaysLeft,
    ),
    lines: ReminderLines(
      title: l10n.reminderNotificationTitle,
      flashcardsDue: l10n.reminderFlashcardsDue,
      weakestFamily: l10n.reminderWeakestFamily,
      examToday: l10n.reminderExamToday,
      examCountdown: l10n.reminderExamCountdown,
      fallback: l10n.reminderFallback,
    ),
  );

  await scheduler.requestPermission();
  await scheduler.scheduleDaily(
    hour: settings.hour,
    minute: settings.minute,
    content: content,
  );
});

/// The `AppLocalizations` for the effective app language, without a
/// `BuildContext` (there is none at this point — this runs from a provider,
/// not a widget): [localeProvider] gives the explicit choice, or `null` for
/// "system", in which case the platform locale is used instead, clamped to
/// a supported language (falling back to French, the app's own default).
Future<AppLocalizations> _loadL10n(Ref ref) {
  final explicit = ref.watch(localeProvider);
  final locale = explicit ?? PlatformDispatcher.instance.locale;
  final supported = AppLocalizations.supportedLocales.any(
    (l) => l.languageCode == locale.languageCode,
  );
  final resolved = supported ? Locale(locale.languageCode) : const Locale('fr');
  return AppLocalizations.delegate.load(resolved);
}
