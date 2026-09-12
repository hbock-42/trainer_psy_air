import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/repositories/repository_providers.dart';
import 'progress_version_provider.dart';

/// The candidate's exam date (`UserProfile.examDate`), or null when none is
/// set. Drives the "days until exam" chip of the dashboard (US-070).
///
/// Reads the profile straight from the repository and refreshes with
/// [progressVersionProvider]. When US-090 (onboarding / settings) introduces
/// a profile provider, point this one at it so an edited date shows up
/// without a version bump.
final FutureProvider<DateTime?> examDateProvider = FutureProvider<DateTime?>((
  ref,
) async {
  ref.watch(progressVersionProvider);
  final profile = await ref.watch(progressRepositoryProvider).profile();
  return profile?.examDate;
});

/// Whole days from [now] (local date) to [examDate] (local date): 0 on the
/// day itself, negative once it has passed.
int daysUntil(DateTime examDate, DateTime now) {
  final localNow = now.toLocal();
  final today = DateTime(localNow.year, localNow.month, localNow.day);
  final local = examDate.toLocal();
  final day = DateTime(local.year, local.month, local.day);
  return day.difference(today).inDays;
}
