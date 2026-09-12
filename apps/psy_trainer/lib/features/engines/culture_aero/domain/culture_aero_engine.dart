import '../../../train/domain/engine/engine.dart';

/// US-028, spec §2.4-N: the aeronautical general-culture MCQ.
///
/// Bank-driven, like `english` — every item is authored (US-083), tagged
/// `culture.<topic>` across 14/15 topic areas (BIA/PPL theory, aviation
/// history, airports/codes, network geography, Air France–Transavia fleet
/// and news, the cadet path itself). There is no generator: [generatorId]
/// stays null and the default `ActivityEngine.score` already handles an
/// `McqItem` answer (a choice, or a [SkipAnswer] scored as a skip via
/// `Scorer.scoreItem`); per-item timing (`family.json`'s
/// `defaultPerItemTimeSec`, 18 s) and the exam scoring policy
/// (`blueprints/psy0_full.json`'s `scoringPolicy`) are read by the runtime,
/// not by this engine.
class CultureAeroEngine extends ActivityEngine {
  const CultureAeroEngine();

  @override
  String get familyId => 'culture_aero';
}
