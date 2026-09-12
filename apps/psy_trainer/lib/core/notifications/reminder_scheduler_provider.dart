import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'reminder_scheduler.dart';
import 'reminder_scheduler_plugin.dart';
import 'unsupported_reminder_scheduler.dart';

/// The [ReminderScheduler] for this platform (US-092): the real plugin on
/// Android/iOS (phone/tablet — "Learn and practice", `docs/ARCHITECTURE.md`
/// "Platforms"), the no-op stub everywhere else (macOS, Windows, web), so
/// Settings can explain the limitation instead of the scheduler silently
/// failing. Widget tests override this with `InMemoryReminderScheduler`.
final Provider<ReminderScheduler> reminderSchedulerProvider =
    Provider<ReminderScheduler>((ref) {
      if (kIsWeb) return const UnsupportedReminderScheduler();
      return switch (defaultTargetPlatform) {
        TargetPlatform.android ||
        TargetPlatform.iOS => PluginReminderScheduler(),
        _ => const UnsupportedReminderScheduler(),
      };
    });
