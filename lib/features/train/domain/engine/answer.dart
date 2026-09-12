import 'package:freezed_annotation/freezed_annotation.dart';

part 'answer.freezed.dart';
part 'answer.g.dart';

/// What the candidate did on one item, discriminated by `kind`.
///
/// The runtime never interprets an answer: it hands it to
/// `ActivityEngine.score` and stores its JSON in `NewAttempt.answer`
/// (`null` for [TimeoutAnswer], which the stats service counts as a
/// timeout). Engines with a richer payload (drag positions, click paths,
/// tracking error) use [RawAnswer].
@Freezed(unionKey: 'kind')
sealed class Answer with _$Answer {
  const Answer._();

  /// One option of an MCQ / domino / viewpoint item.
  @FreezedUnionValue('choice')
  const factory Answer.choice(int index) = ChoiceAnswer;

  /// Free numeric input (tubes, arithmetic drills).
  @FreezedUnionValue('numeric')
  const factory Answer.numeric(num value) = NumericAnswer;

  /// A set of selected indices (arithmetic grid cells).
  @FreezedUnionValue('multiSelect')
  const factory Answer.multiSelect(List<int> indices) = MultiSelectAnswer;

  /// A key press (rules S-R, multitask), as a `LogicalKeyboardKey.keyLabel`
  /// or the engine's own key name.
  @FreezedUnionValue('key')
  const factory Answer.key(String key) = KeyAnswer;

  /// An ordered list of tokens (sequence recall, parity clicks).
  @FreezedUnionValue('sequence')
  const factory Answer.sequence(List<String> values) = SequenceAnswer;

  /// The explicit "je ne sais pas" of `McqItem.allowSkip`; scored with
  /// `ScoringPolicy.skip`.
  @FreezedUnionValue('skip')
  const factory Answer.skip() = SkipAnswer;

  /// No answer before the item or cadence window expired. Only the runtime
  /// produces it.
  @FreezedUnionValue('timeout')
  const factory Answer.timeout() = TimeoutAnswer;

  /// Engine-specific payload (JSON-encodable values only).
  @FreezedUnionValue('raw')
  const factory Answer.raw(Map<String, Object?> payload) = RawAnswer;

  factory Answer.fromJson(Map<String, Object?> json) => _$AnswerFromJson(json);

  bool get isTimeout => this is TimeoutAnswer;
  bool get isSkip => this is SkipAnswer;
}
