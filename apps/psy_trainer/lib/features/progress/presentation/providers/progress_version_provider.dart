import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Cache key of every stats provider. The snapshot, time-series and exam
/// history providers `watch` it, so bumping it recomputes them once and
/// keeps the results cached until the next bump.
///
/// Bump it after a session is finished (US-051 practice runner, US-061 exam
/// runner) and after a lesson is marked read (US-044):
///
/// ```dart
/// await ref.read(progressRepositoryProvider).finishSession(...);
/// ref.read(progressVersionProvider.notifier).bump();
/// ```
///
/// `ref.invalidate(progressSnapshotProvider)` would also work for one
/// provider; the version covers all of them at once.
final NotifierProvider<ProgressVersionNotifier, int> progressVersionProvider =
    NotifierProvider<ProgressVersionNotifier, int>(ProgressVersionNotifier.new);

class ProgressVersionNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void bump() => state = state + 1;
}
