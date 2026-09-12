import '../../../core/content/content.dart';

/// One stage of the Air France cadet selection (spec §1), shown on the
/// "how the selection works" page.
class SelectionStage {
  const SelectionStage({
    required this.title,
    required this.when,
    required this.body,
    required this.confidence,
    this.facts = const [],
    this.eliminatory = true,
    this.isTarget = false,
  });

  final String title;

  /// Where and when, one line.
  final String when;
  final String body;

  /// How sure we are about the stage as a whole.
  final Confidence confidence;

  /// Short facts rendered as chips, each with its own confidence.
  final List<StageFact> facts;
  final bool eliminatory;

  /// True for the stage this app prepares (PSY0).
  final bool isTarget;
}

/// A short fact about a stage with its confidence tag.
class StageFact {
  const StageFact(this.text, this.confidence);

  final String text;
  final Confidence confidence;
}
