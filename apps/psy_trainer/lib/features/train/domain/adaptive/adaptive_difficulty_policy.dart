import 'package:freezed_annotation/freezed_annotation.dart';

part 'adaptive_difficulty_policy.freezed.dart';
part 'adaptive_difficulty_policy.g.dart';

/// In-session difficulty adaptation for generated families (US-053).
///
/// - after [correctStreakToLevelUp] consecutive answers that are both
///   correct and *fast*, the level goes up by 1 and both streaks reset;
/// - after [wrongStreakToLevelDown] consecutive wrong answers (a timeout
///   counts as wrong: `ItemResult.timedOut` implies `correct: false`), the
///   level goes down by 1 and both streaks reset;
/// - a correct-but-slow answer resets the correct-fast streak (it is not
///   itself a "fast" answer) but does *not* count towards the wrong streak;
/// - the level is always clamped to [minLevel]..[maxLevel].
///
/// "Fast" means the response time is at or under a threshold: the family's
/// own median response time when one is known (`fastThresholdMs`, from
/// `StatsService`/`FamilyProgress.medianResponseMs` — "recent speed", one
/// half of US-075's "accuracy & speed"), or, failing that, [fastFactorOfLimit]
/// of the activity's per-item time limit (documented fallback for a family
/// with no history yet: "answered within 60% of the time allotted" reads as
/// comfortably fast without needing any history). Untimed practice with no
/// history at all has no threshold at all: every correct answer counts as
/// fast (an untimed drill only ever has accuracy to go on).
@freezed
abstract class AdaptiveDifficultyPolicy with _$AdaptiveDifficultyPolicy {
  const factory AdaptiveDifficultyPolicy({
    @Default(3) int correctStreakToLevelUp,
    @Default(2) int wrongStreakToLevelDown,
    @Default(1) int minLevel,
    @Default(5) int maxLevel,
    @Default(0.6) double fastFactorOfLimit,
  }) = _AdaptiveDifficultyPolicy;

  const AdaptiveDifficultyPolicy._();

  factory AdaptiveDifficultyPolicy.fromJson(Map<String, Object?> json) =>
      _$AdaptiveDifficultyPolicyFromJson(json);

  /// The thresholds this story ships with.
  static const AdaptiveDifficultyPolicy standard = AdaptiveDifficultyPolicy();

  /// The initial state at [level] (clamped), no streak in progress.
  AdaptiveDifficultyState initial(int level) =>
      AdaptiveDifficultyState(level: _clamp(level));

  /// The cutoff below (or at) which a response counts as "fast"; see the
  /// class doc. Null means untimed-and-no-history: every correct answer is
  /// fast.
  int? fastCutoffMs({int? fastThresholdMs, int? itemLimitMs}) {
    if (fastThresholdMs != null) return fastThresholdMs;
    if (itemLimitMs != null) return (itemLimitMs * fastFactorOfLimit).round();
    return null;
  }

  /// Folds one outcome into [state]: advances the streak that applies and,
  /// once a threshold is reached, changes the level and resets both
  /// streaks. Pure and deterministic — same [state] and inputs, same result.
  AdaptiveDifficultyState update(
    AdaptiveDifficultyState state, {
    required bool correct,
    required int responseMs,
    int? fastThresholdMs,
    int? itemLimitMs,
  }) {
    if (correct) {
      final cutoff = fastCutoffMs(
        fastThresholdMs: fastThresholdMs,
        itemLimitMs: itemLimitMs,
      );
      final fast = cutoff == null || responseMs <= cutoff;
      if (!fast) {
        return state.copyWith(correctFastStreak: 0, wrongStreak: 0);
      }
      final streak = state.correctFastStreak + 1;
      if (streak >= correctStreakToLevelUp) {
        return AdaptiveDifficultyState(level: _clamp(state.level + 1));
      }
      return state.copyWith(correctFastStreak: streak, wrongStreak: 0);
    }
    final streak = state.wrongStreak + 1;
    if (streak >= wrongStreakToLevelDown) {
      return AdaptiveDifficultyState(level: _clamp(state.level - 1));
    }
    return state.copyWith(wrongStreak: streak, correctFastStreak: 0);
  }

  int _clamp(int level) =>
      level < minLevel ? minLevel : (level > maxLevel ? maxLevel : level);
}

/// The running tally an [AdaptiveDifficultyPolicy] carries between items:
/// the current level and how far each streak has got.
@freezed
abstract class AdaptiveDifficultyState with _$AdaptiveDifficultyState {
  const factory AdaptiveDifficultyState({
    required int level,
    @Default(0) int correctFastStreak,
    @Default(0) int wrongStreak,
  }) = _AdaptiveDifficultyState;
}

/// One in-session difficulty change: the level moved from [from] to [to]
/// right before item [atItemIndex] was shown. Recorded by `ActivitySession`
/// for an [AdaptiveDifficultyPolicy]-driven source so the summary can show
/// "niveau [from] → [to]" discreetly (US-053).
@freezed
abstract class LevelChange with _$LevelChange {
  const factory LevelChange({
    required int atItemIndex,
    required int from,
    required int to,
  }) = _LevelChange;

  factory LevelChange.fromJson(Map<String, Object?> json) =>
      _$LevelChangeFromJson(json);
}
