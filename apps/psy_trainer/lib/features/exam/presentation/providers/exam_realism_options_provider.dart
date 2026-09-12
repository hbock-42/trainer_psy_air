import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/error_logger.dart';
import '../../../../core/repositories/repositories.dart';
import '../../domain/exam_realism_options.dart';

/// US-063: the exam launcher's realism options, hydrated from
/// `UserProfile.settings['exam.realism']` once and then held synchronously
/// (same hydration shape as `AppSettingsController`,
/// `features/settings/presentation/providers/app_settings_provider.dart`) so
/// toggling an option updates the panel immediately while still persisting.
final NotifierProvider<ExamRealismOptionsController, ExamRealismOptions>
examRealismOptionsProvider =
    NotifierProvider<ExamRealismOptionsController, ExamRealismOptions>(
      ExamRealismOptionsController.new,
    );

class ExamRealismOptionsController extends Notifier<ExamRealismOptions> {
  Completer<ExamRealismOptions>? _hydration;

  ProgressRepository get _repository => ref.read(progressRepositoryProvider);

  @override
  ExamRealismOptions build() {
    _hydration = Completer<ExamRealismOptions>();
    unawaited(_hydrate());
    return ExamRealismOptions.defaults;
  }

  Future<void> _hydrate() async {
    ExamRealismOptions options;
    try {
      options = ExamRealismOptions.fromProfile(await _repository.profile());
    } on Object catch (error, stack) {
      logError(error, stack, context: 'exam realism options hydration');
      options = ExamRealismOptions.defaults;
    }
    state = options;
    final completer = _hydration;
    if (completer != null && !completer.isCompleted) {
      completer.complete(options);
    }
  }

  /// `state` once hydrated: synchronously if already known, otherwise a
  /// future that completes with the first value read from the database.
  FutureOr<ExamRealismOptions> whenHydrated() =>
      _hydration?.isCompleted ?? true ? state : _hydration!.future;

  Future<void> setNegativeMarkingCulture({required bool enabled}) =>
      _update((o) => o.copyWith(negativeMarkingCulture: enabled));

  Future<void> setHideRemainingTime({required bool enabled}) =>
      _update((o) => o.copyWith(hideRemainingTime: enabled));

  Future<void> setHideTimerEnglish({required bool enabled}) =>
      _update((o) => o.copyWith(hideTimerEnglish: enabled));

  Future<void> setRandomizeGenerated({required bool enabled}) =>
      _update((o) => o.copyWith(randomizeGenerated: enabled));

  Future<void> setAllowPauseBetweenSections({required bool enabled}) =>
      _update((o) => o.copyWith(allowPauseBetweenSections: enabled));

  Future<void> setImmersiveFullScreen({required bool enabled}) =>
      _update((o) => o.copyWith(immersiveFullScreen: enabled));

  Future<void> setSoundCuesEnabled({required bool enabled}) =>
      _update((o) => o.copyWith(soundCuesEnabled: enabled));

  /// "Conditions réelles" (US-063 point 7): applies every option at once.
  Future<void> applyRealConditionsPreset() =>
      _update((_) => ExamRealismOptions.realConditions);

  Future<void> _update(
    ExamRealismOptions Function(ExamRealismOptions) apply,
  ) async {
    final next = apply(state);
    state = next;
    final existing = await _repository.profile();
    await _repository.saveProfile(next.applyTo(existing));
  }
}
