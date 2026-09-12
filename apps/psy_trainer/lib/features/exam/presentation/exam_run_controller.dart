import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/repositories/model/session.dart';
import '../../../core/repositories/repository_providers.dart';
import '../../train/domain/engine/engine.dart';
import '../../train/presentation/engine/activity_session_controller.dart';
import '../../train/presentation/engine/engine_registry_provider.dart';
import '../domain/exam_section_planner.dart';
import 'exam_run_state.dart';

/// One controller per running exam, keyed by the blueprint id.
///
/// Sequences the blueprint's available sections (US-060/061): loads the
/// blueprint, skips sections whose engine is not registered, opens one
/// `TrainingSession` (storing every section's `ActivitySessionConfig` in its
/// `config` so the report, US-062, can rebuild the review later), then runs
/// each section's `ActivitySessionRequest` through the screen's
/// `SessionHost`. Between sections it inserts an optional break
/// (`ExamSection.breakAfterSec`); any section that ends aborted (the
/// candidate quit) abandons the whole exam.
///
/// Auto-disposed like `activitySessionControllerProvider`: leaving mid-exam
/// marks the session abandoned.
final examRunControllerProvider = NotifierProvider.autoDispose
    .family<ExamRunController, ExamRunState, String>(ExamRunController.new);

class ExamRunController extends Notifier<ExamRunState> {
  ExamRunController(this.blueprintId);

  final String blueprintId;

  List<PlannedExamSection> _sections = const [];
  final List<SessionResult> _results = [];
  String? _sessionId;
  int _planIndex = 0;
  late EngineClock _clock;
  ScheduledTask? _breakTask;
  DateTime? _breakDeadline;
  bool _finished = false;

  @override
  ExamRunState build() {
    _clock = ref.watch(engineClockProvider);
    ref.onDispose(_onDispose);
    unawaited(_load());
    return const ExamRunState.loading();
  }

  Future<void> _load() async {
    final content = ref.read(contentRepositoryProvider);
    final progress = ref.read(progressRepositoryProvider);
    final engines = ref.read(engineRegistryProvider);

    final blueprint = await content.blueprintById(blueprintId);
    if (blueprint == null) {
      state = const ExamRunState.error('blueprint introuvable');
      return;
    }

    // Planned once, with a placeholder session id: `startSession` needs the
    // finished plan up front (its `config` is fixed at creation, there is no
    // update call) but only knows the real id once it returns. The
    // placeholder never leaves this method — every config below is patched
    // to the real id before it runs or is stored.
    final planned = await planExamSections(
      blueprint: blueprint,
      engines: engines,
      content: content,
      progress: progress,
      sessionId: '',
      random: Random(),
    );
    if (planned.isEmpty) {
      state = const ExamRunState.unavailable();
      return;
    }

    final started = await progress.startSession(
      mode: SessionMode.exam,
      blueprintId: blueprint.id,
      config: {
        'sections': [for (final p in planned) p.config.toJson()],
      },
    );
    _sessionId = started.id;
    _sections = [
      for (final p in planned)
        PlannedExamSection(
          sectionIndex: p.sectionIndex,
          section: p.section,
          config: p.config.copyWith(sessionId: started.id),
        ),
    ];
    _planIndex = 0;
    _emitRunning();
  }

  void _emitRunning() {
    final planned = _sections[_planIndex];
    state = ExamRunState.running(
      planIndex: _planIndex,
      totalSections: _sections.length,
      request: ActivitySessionRequest.fresh(planned.config),
    );
  }

  /// Called by the runner screen when the current section's `SessionHost`
  /// reports its result.
  Future<void> handleSectionFinished(SessionResult result) async {
    _results.add(result);
    if (result.isAborted) {
      await _finish(SessionStatus.abandoned);
      return;
    }
    await _advance();
  }

  Future<void> _advance() async {
    final finishedSection = _sections[_planIndex].section;
    _planIndex++;
    if (_planIndex >= _sections.length) {
      await _finish(SessionStatus.completed);
      return;
    }
    if (finishedSection.breakAfterSec > 0) {
      _startBreak(finishedSection.breakAfterSec);
    } else {
      _emitRunning();
    }
  }

  void _startBreak(int seconds) {
    final duration = Duration(seconds: seconds);
    _breakDeadline = _clock.now().add(duration);
    state = ExamRunState.onBreak(
      nextPlanIndex: _planIndex,
      totalSections: _sections.length,
    );
    _breakTask = _clock.schedule(duration, () {
      _breakDeadline = null;
      _emitRunning();
    });
  }

  /// Time left on the current break, or null outside `onBreak`.
  Duration? breakRemaining(DateTime now) {
    final deadline = _breakDeadline;
    if (deadline == null) return null;
    final left = deadline.difference(now);
    return left.isNegative ? Duration.zero : left;
  }

  /// "Continuer" on the break screen: starts the next section right away.
  void skipBreak() {
    if (_breakDeadline == null) return;
    _breakTask?.cancel();
    _breakDeadline = null;
    _emitRunning();
  }

  /// Aborts the whole exam from the break screen (no section is running to
  /// abort there). During a running section, the screen instead aborts that
  /// section's own `ActivitySessionController`, which reports back through
  /// [handleSectionFinished].
  Future<void> abortFromBreak() async {
    _breakTask?.cancel();
    _breakDeadline = null;
    await _finish(SessionStatus.abandoned);
  }

  Future<void> _finish(SessionStatus status) async {
    if (_finished) return;
    _finished = true;
    state = const ExamRunState.finishing();
    final sessionId = _sessionId;
    if (sessionId == null) {
      state = const ExamRunState.aborted();
      return;
    }
    final progress = ref.read(progressRepositoryProvider);
    await progress.finishSession(
      sessionId,
      status: status,
      score: status == SessionStatus.completed ? _score() : null,
    );
    state = status == SessionStatus.completed
        ? ExamRunState.done(sessionId: sessionId)
        : const ExamRunState.aborted();
  }

  double _score() {
    var weighted = 0.0;
    var weights = 0.0;
    for (final result in _results) {
      final index = result.sectionIndex;
      final planned = _sections.firstWhere(
        (p) => p.sectionIndex == index,
        orElse: () => _sections[0],
      );
      final weight = planned.section.weight;
      weighted += result.section.accuracy * weight;
      weights += weight;
    }
    return weights == 0 ? 0 : weighted / weights;
  }

  void _onDispose() {
    _breakTask?.cancel();
    if (_finished) return;
    final sessionId = _sessionId;
    if (sessionId == null) return;
    unawaited(_abandon(sessionId));
  }

  Future<void> _abandon(String sessionId) async {
    final progress = ref.read(progressRepositoryProvider);
    try {
      await progress.finishSession(sessionId, status: SessionStatus.abandoned);
    } on Object {
      // Best-effort: the container may already be torn down.
    }
  }
}
