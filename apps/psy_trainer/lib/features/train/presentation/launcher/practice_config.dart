import 'package:psy_content/psy_content.dart';

/// The launcher's choices for one family's practice session (US-050):
/// how many items, at what difficulty and whether it is timed per item.
///
/// Plain and JSON-serialisable (no freezed) so it is trivial to stash in
/// `UserProfile.settings['practice.<familyId>']` and read back as "the last
/// configuration" the next time the launcher opens for that family.
class PracticeConfig {
  const PracticeConfig({
    required this.itemCount,
    required this.difficulty,
    required this.timed,
  }) : assert(
         difficulty == null || (difficulty >= 1 && difficulty <= 5),
         'difficulty must be 1..5 or null (auto)',
       );

  /// Chip choices offered by the launcher.
  static const List<int> itemCountChoices = [5, 10, 20, 50];

  /// Number of items to play.
  final int itemCount;

  /// A fixed level (1..5), or null for "Auto" (every level).
  final int? difficulty;

  /// Whether each item is timed.
  final bool timed;

  /// Sensible defaults for [family]: 10 items, auto difficulty, timed
  /// following the family's own default (a per-item limit or a fixed
  /// cadence means "timed" by default).
  factory PracticeConfig.defaultsFor(TestFamily family) => PracticeConfig(
    itemCount: 10,
    difficulty: null,
    timed: family.defaultPerItemTimeSec != null || family.defaultCadence != null,
  );

  /// "Quick 5": same as [defaultsFor] but always 5 items, whatever the
  /// current selection was.
  factory PracticeConfig.quick5(TestFamily family) =>
      PracticeConfig.defaultsFor(family).copyWith(itemCount: 5);

  /// Restores a stored config, falling back to [PracticeConfig.defaultsFor]
  /// field by field when [json] is missing, malformed or from an older
  /// shape (never throws).
  factory PracticeConfig.fromJson(
    Map<String, Object?> json,
    TestFamily family,
  ) {
    final fallback = PracticeConfig.defaultsFor(family);
    final rawItemCount = json['itemCount'];
    final itemCount = rawItemCount is int && itemCountChoices.contains(rawItemCount)
        ? rawItemCount
        : fallback.itemCount;
    final rawDifficulty = json['difficulty'];
    final difficulty = rawDifficulty is int && rawDifficulty >= 1 && rawDifficulty <= 5
        ? rawDifficulty
        : null;
    final rawTimed = json['timed'];
    final timed = rawTimed is bool ? rawTimed : fallback.timed;
    return PracticeConfig(
      itemCount: itemCount,
      difficulty: difficulty,
      timed: timed,
    );
  }

  Map<String, Object?> toJson() => {
    'itemCount': itemCount,
    'difficulty': difficulty,
    'timed': timed,
  };

  /// [difficulty] takes a value-returning function so a genuine null (auto)
  /// can be told apart from "leave it as is".
  PracticeConfig copyWith({
    int? itemCount,
    int? Function()? difficulty,
    bool? timed,
  }) => PracticeConfig(
    itemCount: itemCount ?? this.itemCount,
    difficulty: difficulty != null ? difficulty() : this.difficulty,
    timed: timed ?? this.timed,
  );

  @override
  bool operator ==(Object other) =>
      other is PracticeConfig &&
      other.itemCount == itemCount &&
      other.difficulty == difficulty &&
      other.timed == timed;

  @override
  int get hashCode => Object.hash(itemCount, difficulty, timed);

  @override
  String toString() =>
      'PracticeConfig(itemCount: $itemCount, difficulty: $difficulty, '
      'timed: $timed)';
}

/// Where a [PracticeConfig] is remembered in `UserProfile.settings`.
String practiceConfigSettingsKey(String familyId) => 'practice.$familyId';
