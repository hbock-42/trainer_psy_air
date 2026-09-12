import '../../../core/repositories/model/learning.dart';

/// US-063 "realism options": how closely a simulation mimics the real PSY0
/// session (`docs/content/psy0-spec.md` §2.1/§2.2), tunable because several
/// of those conditions are only **[reported]**/**[open question]** there
/// (negative marking on culture was removed at some point; whether the app
/// allows pausing between activities is unknown).
///
/// Persisted as a nested JSON object at `UserProfile.settings['exam.realism']`
/// (see `docs/ARCHITECTURE.md`, "Data layer" -> `user_profile`), the same
/// pattern as `AppSettings` but scoped to the exam feature instead of shared
/// with the rest of the app.
class ExamRealismOptions {
  const ExamRealismOptions({
    this.negativeMarkingCulture = false,
    this.hideRemainingTime = false,
    this.hideTimerEnglish = false,
    this.randomizeGenerated = true,
    this.allowPauseBetweenSections = true,
    this.immersiveFullScreen = false,
    this.soundCuesEnabled = false,
  });

  /// Culture aéro scored `+3` correct / `-1` wrong / `0` "Je ne sais pas",
  /// with the skip option itself offered on every item (2018-2020 rules,
  /// spec §2.2). Applied by `planExamSections` overriding the section's
  /// `scoringPolicy` and each bank item's `allowSkip`.
  final bool negativeMarkingCulture;

  /// Hide every countdown bar (`SessionHost`'s `_Countdowns`) until under a
  /// minute is left, instead of showing the running time throughout.
  final bool hideRemainingTime;

  /// Hide the timer entirely for the `english` section: candidates report
  /// "no visible timer in the English test" (spec §2.4, activity O).
  final bool hideTimerEnglish;

  /// Draw a fresh seed per run (spec: "shapes/colours vary between
  /// sessions"). Off fixes every generated section to [canonicalSeed] so
  /// the same run replays identically -- useful to compare attempts, not a
  /// realism condition by itself.
  final bool randomizeGenerated;

  /// Allow skipping a between-sections break early ("Continuer") in
  /// addition to it auto-continuing after `ExamSection.breakAfterSec`. Off
  /// hides "Continuer": the candidate must wait out the break, matching
  /// "no pause allowed" real conditions (spec §2.2: whether the app allows
  /// pausing is an open question, kept configurable).
  final bool allowPauseBetweenSections;

  /// Full-screen immersive chrome + portrait orientation lock on phones
  /// during the run (`SystemChrome`, `ExamRunScreen`).
  final bool immersiveFullScreen;

  /// A short beep at the start/end of each section (`SystemSound.play`),
  /// gated on this flag AND the global `soundEnabledProvider` mute.
  final bool soundCuesEnabled;

  /// `Random(seed)`/`ItemSource.generator.seed` used for every generated
  /// section when [randomizeGenerated] is off: fixed so re-running an exam
  /// under "conditions réelles off-randomise" reproduces the same items.
  static const int canonicalSeed = 63;

  static const String settingsKey = 'exam.realism';

  static const String _keyNegativeMarking = 'negativeMarkingCulture';
  static const String _keyHideRemainingTime = 'hideRemainingTime';
  static const String _keyHideTimerEnglish = 'hideTimerEnglish';
  static const String _keyRandomizeGenerated = 'randomizeGenerated';
  static const String _keyAllowPause = 'allowPauseBetweenSections';
  static const String _keyImmersive = 'immersiveFullScreen';
  static const String _keySoundCues = 'soundCuesEnabled';

  static const ExamRealismOptions defaults = ExamRealismOptions();

  /// "Conditions réelles": every option set to the strictest / most
  /// faithful value in one tap (US-063 point 7).
  static const ExamRealismOptions realConditions = ExamRealismOptions(
    negativeMarkingCulture: true,
    hideRemainingTime: true,
    hideTimerEnglish: true,
    allowPauseBetweenSections: false,
    immersiveFullScreen: true,
    soundCuesEnabled: true,
  );

  /// Reads `profile.settings['exam.realism']`; [defaults] for a missing
  /// profile, a missing key or a value of the wrong shape.
  factory ExamRealismOptions.fromProfile(UserProfile? profile) {
    final raw = profile?.settings[settingsKey];
    if (raw is! Map) return defaults;
    return ExamRealismOptions.fromJson(raw.cast<String, Object?>());
  }

  factory ExamRealismOptions.fromJson(
    Map<String, Object?> json,
  ) => ExamRealismOptions(
    negativeMarkingCulture:
        json[_keyNegativeMarking] as bool? ?? defaults.negativeMarkingCulture,
    hideRemainingTime:
        json[_keyHideRemainingTime] as bool? ?? defaults.hideRemainingTime,
    hideTimerEnglish:
        json[_keyHideTimerEnglish] as bool? ?? defaults.hideTimerEnglish,
    randomizeGenerated:
        json[_keyRandomizeGenerated] as bool? ?? defaults.randomizeGenerated,
    allowPauseBetweenSections:
        json[_keyAllowPause] as bool? ?? defaults.allowPauseBetweenSections,
    immersiveFullScreen:
        json[_keyImmersive] as bool? ?? defaults.immersiveFullScreen,
    soundCuesEnabled: json[_keySoundCues] as bool? ?? defaults.soundCuesEnabled,
  );

  Map<String, Object?> toJson() => {
    _keyNegativeMarking: negativeMarkingCulture,
    _keyHideRemainingTime: hideRemainingTime,
    _keyHideTimerEnglish: hideTimerEnglish,
    _keyRandomizeGenerated: randomizeGenerated,
    _keyAllowPause: allowPauseBetweenSections,
    _keyImmersive: immersiveFullScreen,
    _keySoundCues: soundCuesEnabled,
  };

  /// The profile to save: [existing] (if any) with these options applied
  /// under [settingsKey]; every other `settings` entry and profile field is
  /// preserved.
  UserProfile applyTo(UserProfile? existing) {
    if (existing == null) {
      return UserProfile(locale: 'fr', settings: {settingsKey: toJson()});
    }
    return existing.copyWith(
      settings: {...existing.settings, settingsKey: toJson()},
    );
  }

  ExamRealismOptions copyWith({
    bool? negativeMarkingCulture,
    bool? hideRemainingTime,
    bool? hideTimerEnglish,
    bool? randomizeGenerated,
    bool? allowPauseBetweenSections,
    bool? immersiveFullScreen,
    bool? soundCuesEnabled,
  }) {
    return ExamRealismOptions(
      negativeMarkingCulture:
          negativeMarkingCulture ?? this.negativeMarkingCulture,
      hideRemainingTime: hideRemainingTime ?? this.hideRemainingTime,
      hideTimerEnglish: hideTimerEnglish ?? this.hideTimerEnglish,
      randomizeGenerated: randomizeGenerated ?? this.randomizeGenerated,
      allowPauseBetweenSections:
          allowPauseBetweenSections ?? this.allowPauseBetweenSections,
      immersiveFullScreen: immersiveFullScreen ?? this.immersiveFullScreen,
      soundCuesEnabled: soundCuesEnabled ?? this.soundCuesEnabled,
    );
  }

  /// Whether this equals [realConditions] (the panel highlights the preset
  /// button as "already applied" when true).
  bool get isRealConditions => this == realConditions;

  @override
  bool operator ==(Object other) =>
      other is ExamRealismOptions &&
      other.negativeMarkingCulture == negativeMarkingCulture &&
      other.hideRemainingTime == hideRemainingTime &&
      other.hideTimerEnglish == hideTimerEnglish &&
      other.randomizeGenerated == randomizeGenerated &&
      other.allowPauseBetweenSections == allowPauseBetweenSections &&
      other.immersiveFullScreen == immersiveFullScreen &&
      other.soundCuesEnabled == soundCuesEnabled;

  @override
  int get hashCode => Object.hash(
    negativeMarkingCulture,
    hideRemainingTime,
    hideTimerEnglish,
    randomizeGenerated,
    allowPauseBetweenSections,
    immersiveFullScreen,
    soundCuesEnabled,
  );
}
