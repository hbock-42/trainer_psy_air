import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psy_content/psy_content.dart';

import '../../../../core/errors/error_logger.dart';
import '../../../../core/repositories/repositories.dart';
import '../../domain/active_module.dart';

/// US-101: the active module (PSY0/PSY1) shown by the Learn/Train/Exam
/// homes and the dashboard, hydrated once from
/// `UserProfile.settings['module']` (falling back to `targetStage`) and then
/// held synchronously so switching the `ModuleSwitch` control updates every
/// screen immediately while still persisting (same hydration shape as
/// `ExamRealismOptionsController`,
/// `features/exam/presentation/providers/exam_realism_options_provider.dart`).
final NotifierProvider<ActiveModuleController, ActiveModule>
activeModuleProvider = NotifierProvider<ActiveModuleController, ActiveModule>(
  ActiveModuleController.new,
);

class ActiveModuleController extends Notifier<ActiveModule> {
  Completer<ActiveModule>? _hydration;

  ProgressRepository get _repository => ref.read(progressRepositoryProvider);

  @override
  ActiveModule build() {
    _hydration = Completer<ActiveModule>();
    unawaited(_hydrate());
    return ActiveModule.defaults;
  }

  Future<void> _hydrate() async {
    ActiveModule active;
    try {
      active = ActiveModule.fromProfile(await _repository.profile());
    } on Object catch (error, stack) {
      logError(error, stack, context: 'active module hydration');
      active = ActiveModule.defaults;
    }
    state = active;
    final completer = _hydration;
    if (completer != null && !completer.isCompleted) {
      completer.complete(active);
    }
  }

  /// `state` once hydrated: synchronously if already known, otherwise a
  /// future that completes with the first value read from the database.
  FutureOr<ActiveModule> whenHydrated() =>
      _hydration?.isCompleted ?? true ? state : _hydration!.future;

  /// Switches the active module for the session and persists it in
  /// `UserProfile.settings['module']`.
  Future<void> setModule(ModuleId moduleId) async {
    if (moduleId == state.moduleId) return;
    state = ActiveModule(moduleId: moduleId, available: state.available);
    final existing = await _repository.profile();
    await _repository.saveProfile(ActiveModule.applyTo(existing, moduleId));
  }
}
