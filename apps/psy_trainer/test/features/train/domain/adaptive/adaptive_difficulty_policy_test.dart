import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/features/train/domain/adaptive/adaptive_difficulty_policy.dart';

void main() {
  const policy = AdaptiveDifficultyPolicy.standard;

  group('AdaptiveDifficultyPolicy.update', () {
    test('3 consecutive correct-and-fast answers level up by 1 and reset '
        'the streak', () {
      var state = policy.initial(2);
      for (var i = 0; i < 2; i++) {
        state = policy.update(
          state,
          correct: true,
          responseMs: 100,
          fastThresholdMs: 500,
        );
        expect(state.level, 2, reason: 'not yet at the streak threshold');
      }
      state = policy.update(
        state,
        correct: true,
        responseMs: 100,
        fastThresholdMs: 500,
      );
      expect(state.level, 3);
      expect(state.correctFastStreak, 0);
      expect(state.wrongStreak, 0);
    });

    test(
      '2 consecutive wrong answers level down by 1 and reset the streak',
      () {
        var state = policy.initial(3);
        state = policy.update(state, correct: false, responseMs: 100);
        expect(state.level, 3, reason: 'not yet at the streak threshold');
        state = policy.update(state, correct: false, responseMs: 100);
        expect(state.level, 2);
        expect(state.wrongStreak, 0);
      },
    );

    test('a correct-but-slow answer breaks the fast streak without '
        'levelling down', () {
      var state = policy.initial(3);
      state = policy.update(
        state,
        correct: true,
        responseMs: 100,
        fastThresholdMs: 500,
      );
      state = policy.update(
        state,
        correct: true,
        responseMs: 100,
        fastThresholdMs: 500,
      );
      expect(state.correctFastStreak, 2);
      // Correct, but over the threshold: breaks the streak, no level move.
      state = policy.update(
        state,
        correct: true,
        responseMs: 900,
        fastThresholdMs: 500,
      );
      expect(state.level, 3);
      expect(state.correctFastStreak, 0);
      expect(state.wrongStreak, 0);
    });

    test('the level clamps at maxLevel and does not overshoot', () {
      var state = policy.initial(5);
      for (var i = 0; i < 3; i++) {
        state = policy.update(
          state,
          correct: true,
          responseMs: 100,
          fastThresholdMs: 500,
        );
      }
      expect(state.level, 5);
    });

    test('the level clamps at minLevel and does not undershoot', () {
      var state = policy.initial(1);
      for (var i = 0; i < 2; i++) {
        state = policy.update(state, correct: false, responseMs: 100);
      }
      expect(state.level, 1);
    });

    test('a wrong answer resets an in-progress correct-fast streak', () {
      var state = policy.initial(3);
      state = policy.update(
        state,
        correct: true,
        responseMs: 100,
        fastThresholdMs: 500,
      );
      expect(state.correctFastStreak, 1);
      state = policy.update(state, correct: false, responseMs: 100);
      expect(state.correctFastStreak, 0);
      expect(state.wrongStreak, 1);
    });

    test('a correct answer resets an in-progress wrong streak', () {
      var state = policy.initial(3);
      state = policy.update(state, correct: false, responseMs: 100);
      expect(state.wrongStreak, 1);
      // Correct but slow (no threshold given -> null cutoff -> always
      // "fast"); still resets the wrong streak either way.
      state = policy.update(state, correct: true, responseMs: 100);
      expect(state.wrongStreak, 0);
    });

    test('with no threshold at all (untimed, no history), every correct '
        'answer counts as fast', () {
      var state = policy.initial(2);
      for (var i = 0; i < 3; i++) {
        state = policy.update(state, correct: true, responseMs: 999999);
      }
      expect(state.level, 3);
    });
  });

  group('AdaptiveDifficultyPolicy.fastCutoffMs', () {
    test('prefers the family threshold over the item-limit fallback', () {
      expect(policy.fastCutoffMs(fastThresholdMs: 800, itemLimitMs: 5000), 800);
    });

    test('falls back to fastFactorOfLimit of the per-item limit', () {
      expect(policy.fastCutoffMs(itemLimitMs: 5000), 3000);
    });

    test('is null when neither is known', () {
      expect(policy.fastCutoffMs(), isNull);
    });
  });
}
