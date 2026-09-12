import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psy_content/psy_content.dart';

import '../../../core/repositories/model/session.dart';
import '../../../core/repositories/progress_repository.dart';
import '../../../core/repositories/repository_providers.dart';
import '../../train/domain/engine/engine.dart';
import '../../train/presentation/engine/activity_session_controller.dart';
import '../../train/presentation/engine/engine_registry_provider.dart';
import '../domain/exam_realism_options.dart';
import '../domain/exam_resume.dart';
import '../domain/exam_review.dart';
import '../domain/exam_section_planner.dart';
import 'exam_run_state.dart';
import 'providers/exam_realism_options_provider.dart';

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
/// Before starting fresh, `_load` looks for an interrupted `inProgress`
/// exam session of this same blueprint still worth resuming
/// (`findResumableExamSession`, US-064: within 10 minutes of its last
/// attempt) and, when there is one, rebuilds the plan from its stored
/// section configs and resumes the section it was on instead -- older
/// leftovers are marked abandoned in the same pass.
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

  // Read once in `build()`, not through `ref` again later: `_onDispose`
  // (and the `_abandon` it kicks off) runs during the provider's own
  // teardown, where reading another provider is invalid.
  late ProgressRepository _progress;

  // Read once in `build()` too: the realism panel lives on the exam
  // launcher, before this controller exists, so its value is already
  // hydrated by the time a run starts and does not need to react to later
  // changes mid-run.
  late ExamRealismOptions _realism;

  ScheduledTask? _breakTask;
  DateTime? _breakDeadline;
  bool _finished = false;

  @override
  ExamRunState build() {
    _clock = ref.watch(engineClockProvider);
    _progress = ref.read(progressRepositoryProvider);
    _realism = ref.read(examRealismOptionsProvider);
    ref.onDispose(_onDispose);
    unawaited(_load());
    return const ExamRunState.loading();
  }

  Future<void> _load() async {
    final content = ref.read(contentRepositoryProvider);
    final progress = _progress;
    final engines = ref.read(engineRegistryProvider);

    final blueprint = await content.blueprintById(blueprintId);
    if (blueprint == null) {
      state = const ExamRunState.error('blueprint introuvable');
      return;
    }

    final inProgress = await progress.sessions(
      mode: SessionMode.exam,
      status: SessionStatus.inProgress,
    );
    final resumable = await findResumableExamSession(
      sessions: inProgress.where((s) => s.blueprintId == blueprintId).toList(),
      progress: progress,
      now: _clock.now(),
    );
    if (resumable != null) {
      _resumeFrom(resumable, blueprint);
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
      options: _realism,
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
      familyId: planned.section.familyId,
    );
  }

  /// Rebuilds the plan from [candidate]'s stored section configs (the same
  /// ones `_load` would compute fresh, `sectionConfigsOf` reads them back)
  /// and resumes at `candidate.sectionIndex`: the rest of the exam continues
  /// exactly as a fresh run would once that section reports back through
  /// `handleSectionFinished`.
  void _resumeFrom(ExamResumeCandidate candidate, ExamBlueprint blueprint) {
    final session = candidate.session;
    final configs = [
      for (final config in sectionConfigsOf(session))
        config.copyWith(sessionId: session.id),
    ];
    _sections = [
      for (final config in configs)
        PlannedExamSection(
          sectionIndex: config.sectionIndex!,
          section: blueprint.sections[config.sectionIndex!],
          config: config,
        ),
    ];
    _sessionId = session.id;
    _planIndex = _sections.indexWhere(
      (p) => p.sectionIndex == candidate.sectionIndex,
    );
    if (_planIndex < 0) _planIndex = 0;

    final resumingConfig = _sections[_planIndex].config;
    state = ExamRunState.running(
      planIndex: _planIndex,
      totalSections: _sections.length,
      request: ActivitySessionRequest.resume(
        // `ActivitySession.resume` decodes `session.config` as one
        // `ActivitySessionConfig` (unlike the stored `{'sections': [...]}`
        // wrapper): hand it the resuming section's own config instead.
        session: session.copyWith(config: resumingConfig.toJson()),
        attempts: candidate.attempts,
      ),
      familyId: _sections[_planIndex].section.familyId,
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

  /// Whether the break screen offers "Continuer" (US-063 point 5): off
  /// forces the candidate to wait out `ExamSection.breakAfterSec` in full,
  /// matching "no pause allowed" real conditions.
  bool get allowsSkippingBreak => _realism.allowPauseBetweenSections;

  /// "Continuer" on the break screen: starts the next section right away.
  /// A no-op when [allowsSkippingBreak] is off (the screen does not offer
  /// the button then, but guard here too in case a stale key event reaches
  /// it).
  void skipBreak() {
    if (_breakDeadline == null || !allowsSkippingBreak) return;
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
    await _progress.finishSession(
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
    try {
      await _progress.finishSession(sessionId, status: SessionStatus.abandoned);
    } on Object {
      // Best-effort: the container may already be torn down.
    }
  }
}
