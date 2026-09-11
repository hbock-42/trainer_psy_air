import 'package:freezed_annotation/freezed_annotation.dart';

part 'common.freezed.dart';
part 'common.g.dart';

/// Difficulty level, 1 (trivial warm-up) to 5 (hardest expected at the real
/// test). See `common.schema.json#/$defs/Difficulty` and AUTHORING.md.
typedef Difficulty = int;

/// Lowest valid [Difficulty].
const int minDifficulty = 1;

/// Highest valid [Difficulty].
const int maxDifficulty = 5;

/// Whether [value] is a valid [Difficulty].
bool isValidDifficulty(int value) =>
    value >= minDifficulty && value <= maxDifficulty;

/// Decodes a [Difficulty] from JSON, rejecting anything outside 1..5.
///
/// Used through `@JsonKey(fromJson: difficultyFromJson)` so that the range is
/// enforced in release builds too (asserts alone would only fire in debug).
Difficulty difficultyFromJson(Object? json) {
  if (json is! int) {
    throw FormatException('difficulty must be an integer, got $json');
  }
  if (!isValidDifficulty(json)) {
    throw FormatException(
      'difficulty must be between $minDifficulty and $maxDifficulty, got $json',
    );
  }
  return json;
}

/// Nullable variant of [difficultyFromJson] for optional difficulty fields.
Difficulty? difficultyFromJsonNullable(Object? json) =>
    json == null ? null : difficultyFromJson(json);

/// Serialises a date-only JSON string (`YYYY-MM-DD`, JSON Schema `format:
/// date`) to a UTC midnight [DateTime] and back.
class DateOnlyConverter implements JsonConverter<DateTime, String> {
  const DateOnlyConverter();

  static final RegExp _pattern = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$');

  @override
  DateTime fromJson(String json) {
    final match = _pattern.firstMatch(json);
    if (match == null) {
      throw FormatException('expected a YYYY-MM-DD date, got "$json"');
    }
    final year = int.parse(match.group(1)!);
    final month = int.parse(match.group(2)!);
    final day = int.parse(match.group(3)!);
    final date = DateTime.utc(year, month, day);
    if (date.year != year || date.month != month || date.day != day) {
      throw FormatException('invalid calendar date "$json"');
    }
    return date;
  }

  @override
  String toJson(DateTime object) {
    final utc = object.toUtc();
    String pad(int value) => value.toString().padLeft(2, '0');
    return '${utc.year.toString().padLeft(4, '0')}-${pad(utc.month)}-'
        '${pad(utc.day)}';
  }
}

/// Selection stage the content belongs to.
enum ModuleId {
  @JsonValue('psy0')
  psy0,
  @JsonValue('psy1')
  psy1,
  @JsonValue('psy2')
  psy2,
}

/// How sure we are that a value mirrors the real test.
enum Confidence {
  @JsonValue('confirmed')
  confirmed,
  @JsonValue('reported')
  reported,
  @JsonValue('assumed')
  assumed,
}

/// Language of the stimulus itself (not of the UI).
enum ContentLang {
  @JsonValue('fr')
  fr,
  @JsonValue('en')
  en,
}

/// `draft` entities pass validation but are not seeded into the app.
enum ContentStatus {
  @JsonValue('draft')
  draft,
  @JsonValue('published')
  published,
}

/// Kind of a bundled media file.
enum MediaKind {
  @JsonValue('image')
  image,
  @JsonValue('audio')
  audio,
}

/// Input device an activity needs to be representative of the real test
/// (contract v2). `keyboard` activities get a touch adaptation labelled
/// "non-representative".
enum InputRequirement {
  @JsonValue('touch')
  touch,
  @JsonValue('keyboard')
  keyboard,
}

/// Language code (`fr`, `en`) extracted from a UI locale such as `en_US` or
/// `fr-CA`.
String _languageOf(String locale) =>
    locale.split(RegExp('[-_]')).first.toLowerCase();

/// Text shown to the user, keyed by UI locale. `fr` is mandatory and is the
/// fallback for every other locale.
@freezed
abstract class LocalizedText with _$LocalizedText {
  const factory LocalizedText({required String fr, String? en}) =
      _LocalizedText;

  const LocalizedText._();

  factory LocalizedText.fromJson(Map<String, Object?> json) =>
      _$LocalizedTextFromJson(json);

  /// Text for the given UI locale (a language code such as `en` or `en_US`),
  /// falling back to `fr` when no translation exists.
  String resolve(String locale) => _languageOf(locale) == 'en' ? en ?? fr : fr;
}

/// Same shape as [LocalizedText] but each value is a path to a file relative
/// to the module folder (used by lessons).
@freezed
abstract class LocalizedPath with _$LocalizedPath {
  const factory LocalizedPath({required String fr, String? en}) =
      _LocalizedPath;

  const LocalizedPath._();

  factory LocalizedPath.fromJson(Map<String, Object?> json) =>
      _$LocalizedPathFromJson(json);

  /// Path for the given UI locale, falling back to `fr`.
  String resolve(String locale) => _languageOf(locale) == 'en' ? en ?? fr : fr;
}

/// Reference to a bundled media file.
@freezed
abstract class MediaRef with _$MediaRef {
  const factory MediaRef({
    required MediaKind kind,
    required String path,
    LocalizedText? alt,
    int? width,
    int? height,
    int? durationMs,
  }) = _MediaRef;

  factory MediaRef.fromJson(Map<String, Object?> json) =>
      _$MediaRefFromJson(json);
}

/// Authoring metadata, never shown to the user.
@freezed
abstract class ContentMeta with _$ContentMeta {
  const factory ContentMeta({
    String? author,
    String? source,
    List<ContentSource>? sources,
    String? reviewedBy,
    @DateOnlyConverter() DateTime? reviewedAt,
    String? notes,
  }) = _ContentMeta;

  factory ContentMeta.fromJson(Map<String, Object?> json) =>
      _$ContentMetaFromJson(json);
}

/// One dated reference in [ContentMeta.sources] (contract v2).
@freezed
abstract class ContentSource with _$ContentSource {
  const factory ContentSource({
    required String title,
    String? url,
    @DateOnlyConverter() DateTime? accessedOn,
  }) = _ContentSource;

  factory ContentSource.fromJson(Map<String, Object?> json) =>
      _$ContentSourceFromJson(json);
}

/// Rows x columns of a grid (memory patterns, overlay boards, arithmetic
/// grids).
@freezed
abstract class GridSize with _$GridSize {
  const factory GridSize({required int rows, required int cols}) = _GridSize;

  factory GridSize.fromJson(Map<String, Object?> json) =>
      _$GridSizeFromJson(json);
}

/// Fixed inter-stimulus rhythm (contract v2): each stimulus is shown for
/// [stimulusMs], then an answer is accepted for [answerWindowMs]; no answer
/// counts as an error. Used by `memory_nback` and `attention_rules`.
@freezed
abstract class Cadence with _$Cadence {
  const factory Cadence({
    required int stimulusMs,
    required int answerWindowMs,
  }) = _Cadence;

  factory Cadence.fromJson(Map<String, Object?> json) =>
      _$CadenceFromJson(json);
}

/// Points per item outcome (contract v2). Defaults to `{1, 0, 0}`; the
/// historical culture test used `{3, -1, 0}` with a "je ne sais pas" skip.
@freezed
abstract class ScoringPolicy with _$ScoringPolicy {
  const factory ScoringPolicy({
    @Default(1) num correct,
    @Default(0) num wrong,
    @Default(0) num skip,
  }) = _ScoringPolicy;

  factory ScoringPolicy.fromJson(Map<String, Object?> json) =>
      _$ScoringPolicyFromJson(json);
}
