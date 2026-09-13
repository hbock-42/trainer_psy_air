/// The 4 simultaneous channels of the Psychomoteur activity (spec §2.3 row
/// 13, US-102): left stick + 2 thumb buttons null 4 drifting gauges, right
/// stick tracks a moving target inside a circle, F1-F9 cancel target
/// letters, the numpad answers a periodic arithmetic problem.
enum P1PsychomotorChannel { gauges, tracking, letters, arithmetic }

/// A channel's live 0-100 score and whether it has ever dropped into its
/// red zone. Spec §2.2: "the instant any one sub-task's score enters the
/// red zone, the whole test's total score drops to 0" — [redZoneThreshold]
/// is this engine's own choice of where that line sits (not spec'd more
/// precisely than "red zone"), documented here and in the story's final
/// report.
abstract final class P1PsychomotorScoring {
  /// A channel is "in its red zone" once its score drops below this.
  static const double redZoneThreshold = 30;
}
