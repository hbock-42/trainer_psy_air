import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/error_logger.dart';
import '../../../../core/repositories/repositories.dart';
import '../../../progress/presentation/providers/progress_version_provider.dart';
import '../../domain/engine/engine.dart';
import 'engine_registry_provider.dart';

part 'activity_session_controller.freezed.dart';

/// What a screen asks the controller to run: a fresh configuration or an
/// interrupted session to resume. Value-equal, so the same request shares
/// one controller.
@freezed
sealed class ActivitySessionRequest with _$ActivitySessionRequest {
  const factory ActivitySessionRequest.fresh(ActivitySessionConfig config) =
      FreshSessionRequest;

  const factory ActivitySessionRequest.resume({
    required TrainingSession session,
    required List<Attempt> attempts,
  }) = ResumeSessionRequest;
}

/// One controller per running activity, keyed by its request.
///
/// ```dart
/// final state = ref.watch(activitySessionControllerProvider(request));
/// ref.read(activitySessionControllerProvider(request).notifier).answer(a);
/// ```
///
/// Auto-disposed when the screen leaves: a session still running is
/// aborted (saved as abandoned) so it never lingers in progress.
final activitySessionControllerProvider = NotifierProvider.autoDispose
    .family<
      ActivitySessionController,
      ActivitySessionState,
      ActivitySessionRequest
    >(ActivitySessionController.new);

/// Riverpod face of [ActivitySession]: exposes its state and forwards the
/// commands. Bumps `progressVersionProvider` once the finished session is
/// persisted so the dashboard recomputes.
class ActivitySessionController extends Notifier<ActivitySessionState> {
  ActivitySessionController(this.request);

  final ActivitySessionRequest request;
  late ActivitySession _session;

  @override
  ActivitySessionState build() {
    final registry = ref.watch(engineRegistryProvider);
    final repository = ref.watch(progressRepositoryProvider);
    final clock = ref.watch(engineClockProvider);
    final version = ref.read(progressVersionProvider.notifier);

    _session = switch (request) {
      FreshSessionRequest(:final config) => ActivitySession(
        config: config,
        registry: registry,
        repository: repository,
        clock: clock,
        onPersistenceError: _logPersistenceError,
      ),
      ResumeSessionRequest(:final session, :final attempts) =>
        ActivitySession.resume(
          session: session,
          attempts: attempts,
          registry: registry,
          repository: repository,
          clock: clock,
          onPersistenceError: _logPersistenceError,
        ),
    };

    final subscription = _session.states.listen((next) {
      state = next;
      if (next.isFinished) {
        unawaited(_session.idle.then((_) => _bump(version)));
      }
    });
    ref.onDispose(() {
      subscription.cancel();
      if (!_session.state.isFinished) {
        _session.abort();
        unawaited(_session.idle.then((_) => _bump(version)));
      }
      _session.dispose();
    });
    return _session.state;
  }

  /// Bumps once the writes settled. The container may be gone by then
  /// (app shutdown, test teardown): nothing is left to refresh.
  static void _bump(ProgressVersionNotifier version) {
    try {
      version.bump();
    } on Exception {
      // Unmounted ref: the app (or test) is shutting down.
    }
  }

  static void _logPersistenceError(Object error, StackTrace stackTrace) =>
      logError(error, stackTrace, context: 'activity session persistence');

  /// The underlying session (items, outcomes, config).
  ActivitySession get session => _session;

  ActivitySessionConfig get config => _session.config;

  /// Completes when every queued repository write has settled.
  Future<void> get idle => _session.idle;

  void start() => _session.start();

  void answer(Answer answer) => _session.answer(answer);

  void next() => _session.next();

  void pause() => _session.pause();

  void resume() => _session.resume();

  void abort() => _session.abort();
}
