import 'package:psy_content/psy_content.dart';
import '../../../../core/l10n/strings.dart';
import '../../domain/engine/engine.dart';

/// Renders one played item as plain text for the summary review (US-052):
/// stem, the candidate's answer, the expected answer and the explanation.
///
/// A renderer-based "review mode" would need each `ActivityRenderer` to
/// accept an initial selection to reconstruct what the candidate actually
/// picked (an MCQ rebuilt at `phase: answered` with no selection only ever
/// highlights the correct option); no renderer does today (out of scope
/// here — see CONTRACT.md gap noted in `mcq_renderer.dart`), so this text
/// fallback is what every family gets for now.
class ItemReviewText {
  const ItemReviewText({
    required this.stem,
    required this.myAnswer,
    required this.expected,
    this.explanation,
  });

  factory ItemReviewText.of(ItemOutcome outcome) {
    const locale = AppStrings.locale;
    final item = outcome.item;
    return ItemReviewText(
      stem: _stem(item, locale),
      myAnswer: _answerText(outcome.answer, item, locale),
      expected: _expected(item, locale),
      explanation: _explanation(item, locale),
    );
  }

  final String stem;
  final String myAnswer;
  final String expected;
  final String? explanation;

  static String _stem(Item item, String locale) => switch (item) {
    McqItem(:final stem) => stem.resolve(locale),
    NumericItem(:final stem) => stem.resolve(locale),
    SequenceItem(:final instructions, :final stimulus) =>
      instructions?.resolve(locale) ?? stimulus.join(' '),
    GeneratedItem() => '',
  };

  static String _expected(Item item, String locale) => switch (item) {
    McqItem(:final correctIndex, :final options) => _optionLabel(
      options,
      correctIndex,
      locale,
    ),
    NumericItem(:final expected, :final unit) =>
      unit == null ? '$expected' : '$expected $unit',
    SequenceItem(:final stimulus, :final recallMode) =>
      recallMode == RecallMode.backward
          ? stimulus.reversed.join(' ')
          : stimulus.join(' '),
    GeneratedItem() => '',
  };

  static String? _explanation(Item item, String locale) => switch (item) {
    McqItem(:final explanation) => explanation.resolve(locale),
    NumericItem(:final explanation) => explanation.resolve(locale),
    SequenceItem(:final explanation) => explanation?.resolve(locale),
    GeneratedItem() => null,
  };

  static String _answerText(Answer answer, Item item, String locale) =>
      switch (answer) {
        ChoiceAnswer(:final index) =>
          item is McqItem
              ? _optionLabel(item.options, index, locale)
              : '#${index + 1}',
        NumericAnswer(:final value) => '$value',
        MultiSelectAnswer(:final indices) =>
          indices.map((i) => '#${i + 1}').join(', '),
        KeyAnswer(:final key) => key,
        SequenceAnswer(:final values) => values.join(' '),
        SkipAnswer() => AppStrings.sessionFeedbackSkipped,
        TimeoutAnswer() => AppStrings.sessionFeedbackTimeout,
        RawAnswer() => AppStrings.summaryReviewRawAnswer,
      };

  static String _optionLabel(
    List<McqOption> options,
    int index,
    String locale,
  ) {
    if (index < 0 || index >= options.length) return '#${index + 1}';
    return options[index].text?.resolve(locale) ?? '#${index + 1}';
  }
}
