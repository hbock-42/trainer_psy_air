import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'content_parse_exception.dart';
import 'model/content_manifest.dart';
import 'model/deck.dart';
import 'model/exam_blueprint.dart';
import 'model/item.dart';
import 'model/lesson.dart';
import 'model/module.dart';
import 'model/test_family.dart';

/// Decodes the JSON files of a content bundle (see `docs/content/CONTRACT.md`)
/// into their Dart models.
///
/// Every `parseXxx` method takes the raw JSON text plus the file it came from
/// (only used in error messages) and throws a [ContentParseException] naming
/// the file and, when it can be determined, the entity id, on any failure.
/// The `xxxFromJson` variants take an already-decoded map.
///
/// The `$schema` editor hint is ignored; `kind` is checked against the
/// expected file kind. Neither is carried by the models.
class ContentBundleParser {
  const ContentBundleParser();

  /// `assets/content/manifest.json`.
  ContentManifest parseManifest(String source, {required String file}) =>
      manifestFromJson(_decode(source, file), file: file);

  /// `<module>/module.json`.
  Module parseModule(String source, {required String file}) =>
      moduleFromJson(_decode(source, file), file: file);

  /// `<module>/<family>/family.json`.
  TestFamily parseFamily(String source, {required String file}) =>
      familyFromJson(_decode(source, file), file: file);

  /// `<module>/<family>/items/*.json`.
  ItemBank parseBank(String source, {required String file}) =>
      bankFromJson(_decode(source, file), file: file);

  /// `<module>/(<family>/)lessons/*.json`.
  Lesson parseLesson(String source, {required String file}) =>
      lessonFromJson(_decode(source, file), file: file);

  /// `<module>/<family>/decks/*.json`.
  Deck parseDeck(String source, {required String file}) =>
      deckFromJson(_decode(source, file), file: file);

  /// `<module>/blueprints/*.json`.
  ExamBlueprint parseBlueprint(String source, {required String file}) =>
      blueprintFromJson(_decode(source, file), file: file);

  ContentManifest manifestFromJson(
    Map<String, Object?> json, {
    required String file,
  }) {
    _checkKind(json, 'manifest', file);
    return _guard(file, () => ContentManifest.fromJson(json));
  }

  Module moduleFromJson(Map<String, Object?> json, {required String file}) {
    _checkKind(json, 'module', file);
    return _guard(file, () => Module.fromJson(json));
  }

  TestFamily familyFromJson(Map<String, Object?> json, {required String file}) {
    _checkKind(json, 'family', file);
    return _guard(file, () => TestFamily.fromJson(json));
  }

  ItemBank bankFromJson(Map<String, Object?> json, {required String file}) {
    _checkKind(json, 'bank', file);
    final bank = _guard(
      file,
      () => ItemBank.fromJson(json),
      onError: () => _locateBadItem(json, file),
    );
    _checkBank(bank, file);
    return bank;
  }

  Lesson lessonFromJson(Map<String, Object?> json, {required String file}) {
    _checkKind(json, 'lesson', file);
    if ((json['body'] == null) == (json['file'] == null)) {
      throw ContentParseException(
        file: file,
        entityId: _idOf(json),
        message: 'a lesson needs exactly one of "body" or "file"',
      );
    }
    return _guard(file, () => Lesson.fromJson(json), entityId: _idOf(json));
  }

  Deck deckFromJson(Map<String, Object?> json, {required String file}) {
    _checkKind(json, 'deck', file);
    final deck = _guard(
      file,
      () => Deck.fromJson(json),
      onError: () => _locateBadListEntry(json, 'cards', file),
      entityId: _idOf(json),
    );
    for (final card in deck.cards) {
      if (card.deckId != deck.id) {
        throw ContentParseException(
          file: file,
          entityId: card.id,
          message:
              'card deckId "${card.deckId}" does not match deck id '
              '"${deck.id}"',
        );
      }
    }
    return deck;
  }

  ExamBlueprint blueprintFromJson(
    Map<String, Object?> json, {
    required String file,
  }) {
    _checkKind(json, 'blueprint', file);
    final blueprint = _guard(
      file,
      () => ExamBlueprint.fromJson(json),
      onError: () => _locateBadListEntry(json, 'sections', file),
      entityId: _idOf(json),
    );
    final seen = <String>{};
    for (final section in blueprint.sections) {
      if (!seen.add(section.id)) {
        throw ContentParseException(
          file: file,
          entityId: section.id,
          message: 'duplicate section id',
        );
      }
    }
    return blueprint;
  }

  // ---------------------------------------------------------------------------

  Map<String, Object?> _decode(String source, String file) {
    final Object? decoded;
    try {
      decoded = jsonDecode(source);
    } on FormatException catch (e) {
      throw ContentParseException(
        file: file,
        message: 'invalid JSON',
        cause: e,
      );
    }
    if (decoded is! Map<String, Object?>) {
      throw ContentParseException(
        file: file,
        message: 'expected a JSON object at the top level',
      );
    }
    return decoded;
  }

  void _checkKind(Map<String, Object?> json, String expected, String file) {
    final kind = json['kind'];
    if (kind != expected) {
      throw ContentParseException(
        file: file,
        message: 'expected "kind": "$expected", got ${jsonEncode(kind)}',
      );
    }
  }

  /// Runs [build], converting any decoding failure into a
  /// [ContentParseException]. [onError] may throw a more precise exception
  /// (with an entity id) before the generic one is raised.
  T _guard<T>(
    String file,
    T Function() build, {
    void Function()? onError,
    String? entityId,
  }) {
    try {
      return build();
    } on ContentParseException {
      rethrow;
    } catch (e) {
      // Errors we translate: CheckedFromJsonException, FormatException,
      // TypeError, ArgumentError, AssertionError. Anything else is a bug.
      if (e is! CheckedFromJsonException &&
          e is! FormatException &&
          e is! TypeError &&
          e is! ArgumentError &&
          e is! AssertionError) {
        rethrow;
      }
      onError?.call();
      throw ContentParseException(
        file: file,
        entityId: entityId,
        message: _describe(e),
        cause: e,
      );
    }
  }

  /// Re-parses each bank item on its own to name the one that failed.
  void _locateBadItem(Map<String, Object?> json, String file) {
    final items = json['items'];
    if (items is! List<Object?>) return;
    for (final (index, raw) in items.indexed) {
      if (raw is! Map<String, Object?>) {
        throw ContentParseException(
          file: file,
          entityId: 'items[$index]',
          message: 'item is not a JSON object',
        );
      }
      try {
        Item.fromJson(raw);
      } catch (e) {
        throw ContentParseException(
          file: file,
          entityId: _idOf(raw) ?? 'items[$index]',
          message: _describe(e),
          cause: e,
        );
      }
    }
  }

  /// Names the entry of [key] (cards, sections) that fails to decode, if any.
  void _locateBadListEntry(Map<String, Object?> json, String key, String file) {
    final entries = json[key];
    if (entries is! List<Object?>) return;
    for (final (index, raw) in entries.indexed) {
      if (raw is! Map<String, Object?>) continue;
      try {
        switch (key) {
          case 'cards':
            Flashcard.fromJson(raw);
          case 'sections':
            ExamSection.fromJson(raw);
        }
      } catch (e) {
        throw ContentParseException(
          file: file,
          entityId: _idOf(raw) ?? '$key[$index]',
          message: _describe(e),
          cause: e,
        );
      }
    }
  }

  void _checkBank(ItemBank bank, String file) {
    final passageIds = bank.passages.map((p) => p.id).toSet();
    final seen = <String>{};
    for (final item in bank.items) {
      if (!seen.add(item.id)) {
        throw ContentParseException(
          file: file,
          entityId: item.id,
          message: 'duplicate item id',
        );
      }
      if (item.familyId != bank.familyId) {
        throw ContentParseException(
          file: file,
          entityId: item.id,
          message:
              'item familyId "${item.familyId}" does not match bank familyId '
              '"${bank.familyId}"',
        );
      }
      if (item is McqItem) {
        final passageId = item.passageId;
        if (passageId != null && !passageIds.contains(passageId)) {
          throw ContentParseException(
            file: file,
            entityId: item.id,
            message: 'unknown passageId "$passageId"',
          );
        }
      }
    }
  }

  static String? _idOf(Map<String, Object?> json) {
    final id = json['id'];
    return id is String ? id : null;
  }

  static String _describe(Object error) {
    if (error is CheckedFromJsonException) {
      final key = error.key;
      final inner = error.innerError;
      final detail = error.message ?? (inner == null ? '' : _describe(inner));
      final where = key == null ? '' : 'field "$key": ';
      return '$where$detail'.trim();
    }
    if (error is FormatException) return error.message;
    if (error is AssertionError) return error.message?.toString() ?? '$error';
    return '$error';
  }
}
