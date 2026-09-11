import 'package:flutter_test/flutter_test.dart';

/// Keys the models emit even when the source file omitted them, with the
/// default value the JSON contract assigns. Anything else that appears in the
/// output but not in the source is a round-trip failure.
const Map<String, Object?> schemaDefaults = <String, Object?>{
  'status': 'published',
  'shuffleOptions': true,
  'allowSkip': false,
  'inputFormat': 'decimal',
  'decimals': 2,
  'presentationMs': 1000,
  'gapMs': 250,
  'passages': <Object?>[],
  'changelog': <Object?>[],
  'tags': <Object?>[],
  'practiceTags': <Object?>[],
  'deckIds': <Object?>[],
  'traps': <Object?>[],
  'incompatibleWith': <Object?>[],
  'lang': 'fr',
  'briefingSec': 0,
  'breakAfterSec': 0,
  'weight': 1,
  'avoidRecentSessions': 3,
  'liveFeedback': false,
  'inputRequirement': 'touch',
  'scoringPolicy': <String, Object?>{'correct': 1, 'wrong': 0, 'skip': 0},
};

/// Keys a content file may carry that the models deliberately do not.
const Set<String> fileOnlyKeys = <String>{r'$schema', 'kind'};

/// Generator `params` are typed: the models fill every omitted key with the
/// generator's real-test default, so extra keys under a `params` object (or
/// a whole `params` object the source omitted) are expected.
bool _isParams(String path) => path.endsWith('/params');

/// Asserts that [actual] is the same JSON document as [expected], ignoring key
/// order, the file-only keys, keys that [actual] fills with the schema's
/// default value, and generator params filled with their defaults.
void expectJsonRoundTrip(Object? expected, Object? actual, [String path = '']) {
  if (expected is Map<String, Object?>) {
    expect(actual, isA<Map<String, Object?>>(), reason: '$path: object');
    final actualMap = actual! as Map<String, Object?>;
    for (final entry in expected.entries) {
      if (fileOnlyKeys.contains(entry.key)) continue;
      final childPath = '$path/${entry.key}';
      expect(
        actualMap.containsKey(entry.key),
        isTrue,
        reason: '$childPath missing from output',
      );
      expectJsonRoundTrip(entry.value, actualMap[entry.key], childPath);
    }
    for (final entry in actualMap.entries) {
      if (expected.containsKey(entry.key)) continue;
      final childPath = '$path/${entry.key}';
      if (_isParams(path)) continue; // a typed default inside params
      if (_isParams(childPath)) {
        expect(entry.value, isA<Map<String, Object?>>(), reason: childPath);
        continue;
      }
      expect(
        schemaDefaults.containsKey(entry.key),
        isTrue,
        reason: '$childPath is in the output but not in the source',
      );
      expect(
        entry.value,
        equals(schemaDefaults[entry.key]),
        reason: '$childPath was filled with a non-default value',
      );
    }
    return;
  }
  if (expected is List<Object?>) {
    expect(actual, isA<List<Object?>>(), reason: '$path: array');
    final actualList = actual! as List<Object?>;
    expect(actualList.length, expected.length, reason: '$path: length');
    for (var i = 0; i < expected.length; i++) {
      expectJsonRoundTrip(expected[i], actualList[i], '$path[$i]');
    }
    return;
  }
  expect(actual, equals(expected), reason: path);
}
