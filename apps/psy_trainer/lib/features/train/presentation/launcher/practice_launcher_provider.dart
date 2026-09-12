import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

import 'package:psy_content/psy_content.dart';
import '../../../../core/repositories/model/learning.dart';
import '../../../../core/repositories/repository_providers.dart';
import '../../../home/presentation/providers/active_module_provider.dart';
import '../../domain/mistakes/mistake_pool.dart';
import 'practice_config.dart';

/// How long a family's history is searched for un-cleared mistakes
/// ("Reprendre mes erreurs", US-054).
const Duration mistakePoolWindow = Duration(days: 30);

/// How far [PracticeLauncherNotifier] has got loading its family and its
/// last remembered configuration.
enum PracticeLauncherStatus { loading, ready, notFound }

/// State of the practice launcher for one family (US-050).
class PracticeLauncherState {
  const PracticeLauncherState._({
    required this.status,
    this.family,
    this.config,
    this.mistakePool = MistakePool.empty,
  });

  const PracticeLauncherState.loading()
    : this._(status: PracticeLauncherStatus.loading);

  const PracticeLauncherState.notFound()
    : this._(status: PracticeLauncherStatus.notFound);

  const PracticeLauncherState.ready({
    required TestFamily family,
    required PracticeConfig config,
    MistakePool mistakePool = MistakePool.empty,
  }) : this._(
         status: PracticeLauncherStatus.ready,
         family: family,
         config: config,
         mistakePool: mistakePool,
       );

  final PracticeLauncherStatus status;
  final TestFamily? family;
  final PracticeConfig? config;

  /// Family-scoped mistakes ("Reprendre mes erreurs", US-054), loaded once
  /// after the family/config themselves; empty (never null) until then, so
  /// the button stays disabled rather than flash enabled.
  final MistakePool mistakePool;

  bool get isReady => status == PracticeLauncherStatus.ready;

  PracticeLauncherState copyWith({
    PracticeConfig? config,
    MistakePool? mistakePool,
  }) => isReady
      ? PracticeLauncherState.ready(
          family: family!,
          config: config ?? this.config!,
          mistakePool: mistakePool ?? this.mistakePool,
        )
      : this;
}

/// Loads the family and its remembered `PracticeConfig`
/// (`UserProfile.settings['practice.<familyId>']`, defaulting per
/// [PracticeConfig.defaultsFor]) and persists every change back to the
/// profile so the next visit restores it ("last configuration remembered
/// per family", US-050).
class PracticeLauncherNotifier extends Notifier<PracticeLauncherState> {
  PracticeLauncherNotifier(this.familyId);

  final String familyId;

  @override
  PracticeLauncherState build() {
    unawaited(_load());
    return const PracticeLauncherState.loading();
  }

  Future<void> _load() async {
    final family = await ref
        .read(contentRepositoryProvider)
        .familyById(familyId);
    if (family == null) {
      state = const PracticeLauncherState.notFound();
      return;
    }
    // US-101: the launcher only opens on the active module's own families
    // (e.g. a PSY1 family while PSY0 is selected never runs, even by direct
    // navigation to its route).
    final active = await ref.read(activeModuleProvider.notifier).whenHydrated();
    if (family.moduleId != active.moduleId) {
      state = const PracticeLauncherState.notFound();
      return;
    }
    final profile = await ref.read(progressRepositoryProvider).profile();
    final stored = profile?.settings[practiceConfigSettingsKey(familyId)];
    final config = stored is Map
        ? PracticeConfig.fromJson(Map<String, Object?>.from(stored), family)
        : PracticeConfig.defaultsFor(family);
    state = PracticeLauncherState.ready(family: family, config: config);
    unawaited(_loadMistakePool());
  }

  Future<void> _loadMistakePool() async {
    final now = DateTime.now();
    final attempts = await ref
        .read(progressRepositoryProvider)
        .attemptsForFamily(
          familyId: familyId,
          from: now.subtract(mistakePoolWindow),
        );
    if (!state.isReady) return;
    state = state.copyWith(
      mistakePool: MistakePool.fromFamilyHistory(attempts),
    );
  }

  Future<void> _apply(PracticeConfig next) async {
    state = state.copyWith(config: next);
    await _persist(next);
  }

  Future<void> _persist(PracticeConfig config) async {
    final repository = ref.read(progressRepositoryProvider);
    final profile = await repository.profile();
    final base = profile ?? const UserProfile(locale: 'fr');
    final settings = Map<String, Object?>.from(base.settings)
      ..[practiceConfigSettingsKey(familyId)] = config.toJson();
    await repository.saveProfile(base.copyWith(settings: settings));
  }

  void setItemCount(int itemCount) {
    final current = state.config;
    if (current == null) return;
    unawaited(_apply(current.copyWith(itemCount: itemCount)));
  }

  void setDifficulty(int? difficulty) {
    final current = state.config;
    if (current == null) return;
    unawaited(_apply(current.copyWith(difficulty: () => difficulty)));
  }

  void setTimed({required bool timed}) {
    final current = state.config;
    if (current == null) return;
    unawaited(_apply(current.copyWith(timed: timed)));
  }

  /// "Quick 5": sets and persists 5 items / auto difficulty / the family's
  /// default timing, whatever was selected before.
  Future<PracticeConfig?> applyQuick5() async {
    final family = state.family;
    if (family == null) return null;
    final quick5 = PracticeConfig.quick5(family);
    await _apply(quick5);
    return quick5;
  }
}

/// The launcher provider, scoped to a family id. `autoDispose` so leaving
/// the launcher starts fresh next time (a stale in-flight edit never leaks
/// into a later visit).
final NotifierProviderFamily<
  PracticeLauncherNotifier,
  PracticeLauncherState,
  String
>
practiceLauncherProvider =
    NotifierProvider.family<
      PracticeLauncherNotifier,
      PracticeLauncherState,
      String
    >(PracticeLauncherNotifier.new, isAutoDispose: true);
