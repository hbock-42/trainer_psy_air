import 'package:freezed_annotation/freezed_annotation.dart';

part 'recommendation.freezed.dart';

/// What a [Recommendation] points the candidate at.
enum RecommendationKind {
  /// A weak family: practise it (`RecommendationService.trainNext`).
  family,

  /// A weak item tag: same idea, no dedicated launcher target (US-072
  /// deviation, see the story's final report).
  tag,

  /// No completed simulation recently, readiness is high enough to try one.
  examSim,

  /// A practised family whose lesson has not been read.
  lesson,

  /// More than `RecommendationService.dueFlashcardsThreshold` cards are due.
  flashcards,
}

/// One "what to do next" suggestion (US-072): either a ranked weak
/// family/tag (`kind == family || kind == tag`, `isTrainNext`) or a
/// rule-based nudge (simulate / read a lesson / review flashcards).
///
/// [reason] is a ready-to-show, lower-case FR explanation built from the
/// underlying numbers (e.g. "précision 62 % sur les pourcentages, en
/// baisse"); [title] is the label of the thing to do (a family/tag name, or
/// a fixed imperative for the rule-based kinds). [severity] ranks the
/// train-next entries against each other (0 for the rule-based ones, which
/// are not compared).
@freezed
abstract class Recommendation with _$Recommendation {
  const factory Recommendation({
    required RecommendationKind kind,
    required String title,
    required String reason,
    required double severity,

    /// The family id ([RecommendationKind.family] and
    /// [RecommendationKind.lesson]) or the tag ([RecommendationKind.tag]);
    /// null for [RecommendationKind.examSim] and
    /// [RecommendationKind.flashcards].
    String? targetId,

    /// The lesson id, only set for [RecommendationKind.lesson].
    String? secondaryId,
  }) = _Recommendation;

  const Recommendation._();

  /// Whether this is one of the top-3 ranked weak areas (as opposed to a
  /// rule-based nudge).
  bool get isTrainNext =>
      kind == RecommendationKind.family || kind == RecommendationKind.tag;
}
