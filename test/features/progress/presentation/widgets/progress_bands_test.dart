import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/theme/app_theme.dart';
import 'package:psy_trainer/features/progress/domain/progress_domain.dart';
import 'package:psy_trainer/features/progress/presentation/widgets/progress_bands.dart';

FamilyProgress family(
  String id, {
  int attempts = 10,
  TrendDirection trend = TrendDirection.flat,
}) => FamilyProgress(
  familyId: id,
  attempts: attempts,
  correct: attempts,
  sessions: attempts > 0 ? 1 : 0,
  level: 1,
  trend7d: Trend.none,
  trend30d: Trend(direction: trend, slope: 0, delta: 0, sessions: 2),
);

void main() {
  final theme = AppTheme.light();

  test('readiness bands: error below 40, warning below 70, success above', () {
    expect(ProgressBands.readiness(theme, 0), theme.colors.error);
    expect(ProgressBands.readiness(theme, 39.9), theme.colors.error);
    expect(ProgressBands.readiness(theme, 40), theme.colors.warning);
    expect(ProgressBands.readiness(theme, 69.9), theme.colors.warning);
    expect(ProgressBands.readiness(theme, 70), theme.colors.success);
    expect(ProgressBands.score(theme, 0.7), theme.colors.success);
    expect(ProgressBands.score(theme, 0.5), theme.colors.warning);
  });

  test('level bands: 1-2 error, 3 warning, 4-5 success', () {
    expect(ProgressBands.level(theme, 1), theme.colors.error);
    expect(ProgressBands.level(theme, 2), theme.colors.error);
    expect(ProgressBands.level(theme, 3), theme.colors.warning);
    expect(ProgressBands.level(theme, 4), theme.colors.success);
    expect(ProgressBands.level(theme, 5), theme.colors.success);
  });

  test('overallTrend follows the majority of practised families', () {
    expect(overallTrend(const []), TrendDirection.flat);
    expect(
      overallTrend([
        family('a', trend: TrendDirection.up),
        family('b', trend: TrendDirection.down),
      ]),
      TrendDirection.flat,
    );
    expect(
      overallTrend([
        family('a', trend: TrendDirection.up),
        family('b', trend: TrendDirection.up),
        family('c', trend: TrendDirection.down),
      ]),
      TrendDirection.up,
    );
    expect(
      overallTrend([
        family('a', trend: TrendDirection.down),
        family('b'),
        // Never practised: ignored even with a direction.
        family('c', attempts: 0, trend: TrendDirection.up),
      ]),
      TrendDirection.down,
    );
  });
}
