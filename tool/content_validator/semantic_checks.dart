/// Semantic checks of the content validator: everything the JSON Schemas
/// cannot express (cross-field, cross-file, file-system references).
///
/// Checks read the raw JSON so they keep working when the Dart parser
/// rejects a file, and they are grouped in one small function per file kind
/// so that a new kind (or new fields from a later contract version) is a
/// local addition.
library;

import 'dart:io';

import 'package:path/path.dart' as p;

import 'content_file.dart';
import 'report.dart';

/// Collects issues for one validator run.
class IssueSink {
  final List<Issue> issues = [];

  void error(
    ContentFile file,
    String message, {
    String? entityId,
    String? path,
  }) => issues.add(
    Issue(
      file: file.displayPath,
      entityId: entityId,
      path: path,
      message: message,
      source: IssueSource.semantic,
    ),
  );

  void warning(
    ContentFile file,
    String message, {
    String? entityId,
    String? path,
  }) => issues.add(
    Issue(
      file: file.displayPath,
      entityId: entityId,
      path: path,
      message: message,
      severity: Severity.warning,
      source: IssueSource.semantic,
    ),
  );
}

// -----------------------------------------------------------------------------
// Per-file checks (run on bundle files and loose files alike).

/// Dispatches to the check function of the file's kind.
void checkFile(ContentFile file, IssueSink sink) {
  checkFrenchText(file, sink);
  switch (file.kind) {
    case 'manifest':
      checkManifest(file, sink);
    case 'bank':
      checkBank(file, sink);
    case 'lesson':
      checkLesson(file, sink);
    case 'deck':
      checkDeck(file, sink);
    case 'blueprint':
      checkBlueprint(file, sink);
    case 'module' || 'family':
      break;
  }
}

/// Every `LocalizedText` / `LocalizedPath` must carry a non-blank `fr`.
/// Walks the whole document so new fields are covered automatically.
void checkFrenchText(ContentFile file, IssueSink sink) {
  void walk(Object? node, String pointer, String? entityId) {
    if (node is Map<String, Object?>) {
      final id = str(node, 'id') ?? entityId;
      if (node.containsKey('fr')) {
        final fr = node['fr'];
        if (fr is! String || fr.trim().isEmpty) {
          sink.error(
            file,
            'French text ("fr") is missing or blank',
            entityId: id,
            path: '$pointer/fr',
          );
        }
        final en = node['en'];
        if (en is String && en.trim().isEmpty) {
          sink.error(
            file,
            'English text ("en") is blank; omit it instead',
            entityId: id,
            path: '$pointer/en',
          );
        }
      }
      for (final entry in node.entries) {
        walk(entry.value, '$pointer/${entry.key}', id);
      }
    } else if (node is List<Object?>) {
      for (final (i, child) in node.indexed) {
        walk(child, '$pointer/$i', entityId);
      }
    }
  }

  walk(file.json, '', null);
}

void checkManifest(ContentFile file, IssueSink sink) {
  final version = integer(file.json, 'contentVersion');
  final changelog = objects(file.json, 'changelog');
  if (version == null || changelog.isEmpty) return;
  final head = integer(changelog.first, 'contentVersion');
  if (head != version) {
    sink.error(
      file,
      'the first changelog entry must describe the current contentVersion '
      '$version (found $head); changelog is newest first',
      path: '/changelog/0/contentVersion',
    );
  }
  var previous = head;
  for (final (i, entry) in changelog.indexed.skip(1)) {
    final v = integer(entry, 'contentVersion');
    if (v != null && previous != null && v >= previous) {
      sink.error(
        file,
        'changelog must be ordered newest first ($v after $previous)',
        path: '/changelog/$i/contentVersion',
      );
    }
    previous = v;
  }
}

void checkBank(ContentFile file, IssueSink sink) {
  final familyId = str(file.json, 'familyId');
  final passageIds = <String>{};
  for (final (i, passage) in objects(file.json, 'passages').indexed) {
    final id = str(passage, 'id');
    if (id != null && !passageIds.add(id)) {
      sink.error(
        file,
        'duplicate passage id',
        entityId: id,
        path: '/passages/$i',
      );
    }
  }
  final referencedPassages = <String>{};
  final itemIds = <String>{};
  for (final (i, item) in objects(file.json, 'items').indexed) {
    final pointer = '/items/$i';
    final id = str(item, 'id') ?? 'items[$i]';
    if (str(item, 'id') != null && !itemIds.add(id)) {
      sink.error(file, 'duplicate item id', entityId: id, path: pointer);
    }
    if (familyId != null && str(item, 'familyId') != familyId) {
      sink.error(
        file,
        'item familyId "${str(item, 'familyId')}" does not match the bank '
        'familyId "$familyId"',
        entityId: id,
        path: '$pointer/familyId',
      );
    }
    _checkDifficulty(file, sink, item, id, pointer);
    if (strings(item, 'tags').isEmpty) {
      sink.warning(
        file,
        'item has no tags; add at least its second-level tag '
        '(AUTHORING.md §7)',
        entityId: id,
        path: '$pointer/tags',
      );
    }
    switch (str(item, 'type')) {
      case 'mcq':
        _checkMcq(
          file,
          sink,
          item,
          id,
          pointer,
          passageIds,
          referencedPassages,
        );
      case 'numeric':
        _checkExplanation(file, sink, item, id, pointer);
      case 'sequence':
        _checkSequence(file, sink, item, id, pointer);
      case 'generated':
        if (item.containsKey('explanation')) {
          sink.error(
            file,
            'a generated item must not carry an explanation '
            '(the generator writes it)',
            entityId: id,
            path: '$pointer/explanation',
          );
        }
    }
  }
  for (final id in passageIds.difference(referencedPassages)) {
    sink.warning(
      file,
      'passage is not referenced by any item of this file',
      entityId: id,
    );
  }
}

void _checkDifficulty(
  ContentFile file,
  IssueSink sink,
  Map<String, Object?> entity,
  String id,
  String pointer,
) {
  final difficulty = entity['difficulty'];
  if (difficulty is! int || difficulty < 1 || difficulty > 5) {
    sink.error(
      file,
      'difficulty must be an integer between 1 and 5 (got $difficulty)',
      entityId: id,
      path: '$pointer/difficulty',
    );
  }
}

void _checkExplanation(
  ContentFile file,
  IssueSink sink,
  Map<String, Object?> item,
  String id,
  String pointer,
) {
  final explanation = obj(item, 'explanation');
  final fr = explanation == null ? null : str(explanation, 'fr');
  if (fr == null || fr.trim().isEmpty) {
    sink.error(
      file,
      'explanation is mandatory for ${str(item, 'type')} items '
      '(French text, teaching the method)',
      entityId: id,
      path: '$pointer/explanation',
    );
  }
}

void _checkMcq(
  ContentFile file,
  IssueSink sink,
  Map<String, Object?> item,
  String id,
  String pointer,
  Set<String> passageIds,
  Set<String> referencedPassages,
) {
  _checkExplanation(file, sink, item, id, pointer);
  final options = list(item, 'options');
  final correct = item['correctIndex'];
  if (correct is int && options.isNotEmpty) {
    if (correct < 0 || correct >= options.length) {
      sink.error(
        file,
        'correctIndex $correct is out of range: the item has '
        '${options.length} options (indexes 0-${options.length - 1})',
        entityId: id,
        path: '$pointer/correctIndex',
      );
    }
  }
  for (final (i, option) in options.indexed) {
    if (option is! Map<String, Object?>) continue;
    final text = obj(option, 'text');
    if (text == null && obj(option, 'media') == null) {
      sink.error(
        file,
        'option $i needs a text and/or a media',
        entityId: id,
        path: '$pointer/options/$i',
      );
    }
  }
  final texts = options
      .whereType<Map<String, Object?>>()
      .map((o) => obj(o, 'text'))
      .map((t) => t == null ? null : str(t, 'fr')?.trim())
      .whereType<String>()
      .toList();
  if (texts.toSet().length != texts.length) {
    sink.error(
      file,
      'two options have the same text',
      entityId: id,
      path: '$pointer/options',
    );
  }
  final passageId = str(item, 'passageId');
  if (passageId != null) {
    referencedPassages.add(passageId);
    if (!passageIds.contains(passageId)) {
      sink.error(
        file,
        'passageId "$passageId" is not declared in the "passages" of this '
        'file',
        entityId: id,
        path: '$pointer/passageId',
      );
    }
  }
}

void _checkSequence(
  ContentFile file,
  IssueSink sink,
  Map<String, Object?> item,
  String id,
  String pointer,
) {
  final kind = str(item, 'stimulusKind');
  final grid = obj(item, 'grid');
  final stimulus = strings(item, 'stimulus');
  if (kind == 'gridCells') {
    if (grid == null) {
      sink.error(
        file,
        'stimulusKind "gridCells" requires a "grid" ({rows, cols})',
        entityId: id,
        path: '$pointer/grid',
      );
      return;
    }
    final rows = integer(grid, 'rows');
    final cols = integer(grid, 'cols');
    final cell = RegExp(r'^(\d+),(\d+)$');
    for (final (i, s) in stimulus.indexed) {
      final match = cell.firstMatch(s);
      if (match == null) {
        sink.error(
          file,
          'grid cell "$s" must be written "row,col" (zero-based)',
          entityId: id,
          path: '$pointer/stimulus/$i',
        );
        continue;
      }
      final r = int.parse(match.group(1)!);
      final c = int.parse(match.group(2)!);
      if (rows != null && cols != null && (r >= rows || c >= cols)) {
        sink.error(
          file,
          'grid cell "$s" is outside the ${rows}x$cols grid',
          entityId: id,
          path: '$pointer/stimulus/$i',
        );
      }
    }
    if (stimulus.toSet().length != stimulus.length) {
      sink.error(
        file,
        'grid cells are repeated in the stimulus',
        entityId: id,
        path: '$pointer/stimulus',
      );
    }
  } else if (grid != null) {
    sink.warning(
      file,
      '"grid" is only used with stimulusKind "gridCells"',
      entityId: id,
      path: '$pointer/grid',
    );
  }
  if (kind == 'digits') {
    for (final (i, s) in stimulus.indexed) {
      if (!RegExp(r'^\d$').hasMatch(s)) {
        sink.error(
          file,
          'stimulusKind "digits" expects single digits (got "$s")',
          entityId: id,
          path: '$pointer/stimulus/$i',
        );
      }
    }
  }
}

void checkLesson(ContentFile file, IssueSink sink) {
  final hasBody = file.json.containsKey('body');
  final hasFile = file.json.containsKey('file');
  if (hasBody == hasFile) {
    sink.error(
      file,
      'a lesson needs exactly one of "body" (inline markdown) or "file" '
      '(sibling .md files)',
      entityId: file.id,
    );
  }
}

void checkDeck(ContentFile file, IssueSink sink) {
  final deckId = file.id;
  final cardIds = <String>{};
  for (final (i, card) in objects(file.json, 'cards').indexed) {
    final pointer = '/cards/$i';
    final id = str(card, 'id') ?? 'cards[$i]';
    if (str(card, 'id') != null && !cardIds.add(id)) {
      sink.error(file, 'duplicate card id', entityId: id, path: pointer);
    }
    if (deckId != null && str(card, 'deckId') != deckId) {
      sink.error(
        file,
        'card deckId "${str(card, 'deckId')}" does not match the deck id '
        '"$deckId"',
        entityId: id,
        path: '$pointer/deckId',
      );
    }
    _checkDifficulty(file, sink, card, id, pointer);
  }
}

void checkBlueprint(ContentFile file, IssueSink sink) {
  final sectionIds = <String>{};
  for (final (i, section) in objects(file.json, 'sections').indexed) {
    final pointer = '/sections/$i';
    final id = str(section, 'id') ?? 'sections[$i]';
    if (str(section, 'id') != null && !sectionIds.add(id)) {
      sink.error(file, 'duplicate section id', entityId: id, path: pointer);
    }
    final perItem = integer(section, 'perItemTimeSec');
    final count = integer(section, 'itemCount');
    final duration = integer(section, 'durationSec');
    if (perItem != null &&
        count != null &&
        duration != null &&
        perItem * count > duration) {
      sink.warning(
        file,
        'perItemTimeSec x itemCount (${perItem * count} s) exceeds '
        'durationSec ($duration s): the section will end before the last '
        'item',
        entityId: id,
        path: '$pointer/durationSec',
      );
    }
    final selection = obj(section, 'itemSelection');
    final range = selection == null ? null : obj(selection, 'difficulty');
    if (range != null) {
      final min = integer(range, 'min');
      final max = integer(range, 'max');
      if (min != null && max != null && min > max) {
        sink.error(
          file,
          'difficulty range min ($min) is greater than max ($max)',
          entityId: id,
          path: '$pointer/itemSelection/difficulty',
        );
      }
    }
  }
}

// -----------------------------------------------------------------------------
// Bundle checks (need every file of a bundle).

/// Where each file kind must live inside a bundle (AUTHORING.md §1).
const Map<String, String> expectedLocation = {
  'manifest': 'manifest.json',
  'module': '<module>/module.json',
  'family': '<module>/<family>/family.json',
  'bank': '<module>/<family>/items/*.json',
  'lesson':
      '<module>/lessons/**.json (module-level, or grouped per family) or '
      '<module>/<family>/lessons/*.json',
  'deck': '<module>/<family>/decks/*.json',
  'blueprint': '<module>/blueprints/*.json',
};

bool _isAtExpectedLocation(ContentFile file) {
  final s = file.bundlePath.split('/');
  return switch (file.kind) {
    'manifest' => s.length == 1 && s[0] == 'manifest.json',
    'module' => s.length == 2 && s[1] == 'module.json',
    'family' =>
      s.length == 3 && file.familyDir != null && s[2] == 'family.json',
    'bank' => s.length == 4 && file.familyDir != null && s[2] == 'items',
    'lesson' =>
      (s.length >= 3 && s[1] == 'lessons') ||
          (s.length == 4 && file.familyDir != null && s[2] == 'lessons'),
    'deck' => s.length == 4 && file.familyDir != null && s[2] == 'decks',
    'blueprint' => s.length == 3 && s[1] == 'blueprints',
    _ => true,
  };
}

/// Runs the cross-file checks on the files of one bundle.
void checkBundle(String bundleRoot, List<ContentFile> files, IssueSink sink) {
  final byKind = <String, List<ContentFile>>{};
  for (final file in files) {
    byKind.putIfAbsent(file.kind ?? '', () => []).add(file);
  }
  List<ContentFile> ofKind(String kind) => byKind[kind] ?? const [];

  // Layout.
  for (final file in files) {
    final expected = expectedLocation[file.kind];
    if (expected != null && !_isAtExpectedLocation(file)) {
      sink.error(
        file,
        'a ${file.kind} file must live at $expected',
        entityId: file.id,
      );
    }
  }

  // Global id uniqueness.
  final owners = <String, ContentFile>{};
  void claim(ContentFile file, String? id, String what, {String? path}) {
    if (id == null) return;
    final owner = owners[id];
    if (owner == null) {
      owners[id] = file;
      return;
    }
    sink.error(
      file,
      'duplicate id: this $what id is already used in ${owner.displayPath}',
      entityId: id,
      path: path,
    );
  }

  for (final file in files) {
    switch (file.kind) {
      case 'module' || 'family' || 'lesson' || 'blueprint':
        claim(file, file.id, file.kind!);
      case 'deck':
        claim(file, file.id, 'deck');
        for (final (i, card) in objects(file.json, 'cards').indexed) {
          claim(file, str(card, 'id'), 'card', path: '/cards/$i');
        }
      case 'bank':
        for (final (i, passage) in objects(file.json, 'passages').indexed) {
          claim(file, str(passage, 'id'), 'passage', path: '/passages/$i');
        }
        for (final (i, item) in objects(file.json, 'items').indexed) {
          claim(file, str(item, 'id'), 'item', path: '/items/$i');
        }
    }
  }

  // Modules and families declared by their files.
  final modules = <String, ContentFile>{
    for (final m in ofKind('module'))
      if (m.moduleDir != null) m.moduleDir!: m,
  };
  final families = <String, ContentFile>{}; // "<module>/<family>" -> file
  for (final f in ofKind('family')) {
    if (f.moduleDir != null && f.familyDir != null) {
      families['${f.moduleDir}/${f.familyDir}'] = f;
    }
  }
  bool familyExists(String? module, String? familyId) =>
      module != null && families.containsKey('$module/$familyId');
  final deckIds = {for (final d in ofKind('deck')) d.id};
  final blueprintIds = <String, String?>{
    for (final b in ofKind('blueprint'))
      if (b.id != null) b.id!: b.moduleDir,
  };

  // Manifest <-> module folders.
  final manifests = ofKind('manifest');
  if (manifests.isEmpty) {
    // Cannot happen (a bundle is defined by its manifest) unless the manifest
    // failed to decode; the file layer already reported that.
  } else {
    final manifest = manifests.first;
    final listed = strings(manifest.json, 'modules');
    for (final (i, id) in listed.indexed) {
      if (!modules.containsKey(id)) {
        sink.error(
          manifest,
          'module "$id" is listed in the manifest but "$id/module.json" was '
          'not found',
          path: '/modules/$i',
        );
      }
    }
    for (final entry in modules.entries) {
      if (!listed.contains(entry.key)) {
        sink.error(
          entry.value,
          'module "${entry.key}" is not listed in manifest.json "modules"',
          entityId: entry.value.id,
        );
      }
    }
  }

  // Modules <-> family folders, default blueprint.
  for (final entry in modules.entries) {
    final dir = entry.key;
    final module = entry.value;
    if (module.id != dir) {
      sink.error(
        module,
        'module id "${module.id}" does not match its folder "$dir"',
        entityId: module.id,
        path: '/id',
      );
    }
    final listed = strings(module.json, 'familyIds');
    for (final (i, familyId) in listed.indexed) {
      if (!familyExists(dir, familyId)) {
        sink.error(
          module,
          'family "$familyId" is listed in familyIds but '
          '"$dir/$familyId/family.json" was not found',
          entityId: module.id,
          path: '/familyIds/$i',
        );
      }
    }
    for (final family in ofKind('family')) {
      if (family.moduleDir == dir && !listed.contains(family.familyDir)) {
        sink.error(
          family,
          'family "${family.familyDir}" is not listed in '
          '$dir/module.json "familyIds"',
          entityId: family.id,
        );
      }
    }
    final defaultBlueprint = str(module.json, 'defaultBlueprintId');
    if (defaultBlueprint != null && blueprintIds[defaultBlueprint] != dir) {
      sink.error(
        module,
        'defaultBlueprintId "$defaultBlueprint" does not match a blueprint '
        'under $dir/blueprints/',
        entityId: module.id,
        path: '/defaultBlueprintId',
      );
    }
  }
  for (final file in files) {
    final module = file.moduleDir;
    if (module != null &&
        file.kind != 'manifest' &&
        !modules.containsKey(module)) {
      sink.error(
        file,
        'folder "$module" has no module.json',
        entityId: file.id,
      );
    }
  }

  // Per-kind references.
  for (final file in files) {
    switch (file.kind) {
      case 'family':
        _checkFamilyRefs(file, sink);
      case 'bank':
        _checkBankRefs(file, sink, familyExists);
      case 'lesson':
        _checkLessonRefs(file, sink, familyExists, deckIds);
      case 'deck':
        _checkDeckRefs(file, sink, familyExists);
      case 'blueprint':
        _checkBlueprintRefs(file, sink, familyExists);
    }
    _checkMediaRefs(file, sink);
  }
}

void _checkModuleId(ContentFile file, IssueSink sink) {
  final moduleId = str(file.json, 'moduleId');
  if (moduleId != null && moduleId != file.moduleDir) {
    sink.error(
      file,
      'moduleId "$moduleId" does not match the module folder '
      '"${file.moduleDir}"',
      entityId: file.id,
      path: '/moduleId',
    );
  }
}

void _checkFamilyRefs(ContentFile file, IssueSink sink) {
  _checkModuleId(file, sink);
  if (file.familyDir != null && file.id != file.familyDir) {
    sink.error(
      file,
      'family id "${file.id}" does not match its folder "${file.familyDir}"',
      entityId: file.id,
      path: '/id',
    );
  }
}

typedef FamilyExists = bool Function(String? module, String? familyId);

void _checkFamilyId(
  ContentFile file,
  IssueSink sink,
  FamilyExists familyExists, {
  required bool mustMatchFolder,
}) {
  final familyId = str(file.json, 'familyId');
  if (familyId == null) return;
  if (mustMatchFolder && familyId != file.familyDir) {
    sink.error(
      file,
      'familyId "$familyId" does not match the family folder '
      '"${file.familyDir ?? '(none)'}"',
      entityId: file.id,
      path: '/familyId',
    );
  } else if (!familyExists(file.moduleDir, familyId)) {
    sink.error(
      file,
      'familyId "$familyId" does not reference an existing family '
      '(${file.moduleDir}/$familyId/family.json)',
      entityId: file.id,
      path: '/familyId',
    );
  }
}

void _checkBankRefs(
  ContentFile file,
  IssueSink sink,
  FamilyExists familyExists,
) {
  _checkFamilyId(
    file,
    sink,
    familyExists,
    mustMatchFolder: file.familyDir != null,
  );
}

void _checkLessonRefs(
  ContentFile file,
  IssueSink sink,
  FamilyExists familyExists,
  Set<String?> deckIds,
) {
  _checkModuleId(file, sink);
  _checkFamilyId(
    file,
    sink,
    familyExists,
    mustMatchFolder: file.familyDir != null,
  );
  if (file.familyDir != null && str(file.json, 'familyId') == null) {
    sink.error(
      file,
      'a lesson inside a family folder must carry familyId '
      '"${file.familyDir}"',
      entityId: file.id,
    );
  }
  for (final (i, deckId) in strings(file.json, 'deckIds').indexed) {
    if (!deckIds.contains(deckId)) {
      sink.error(
        file,
        'deckIds references unknown deck "$deckId"',
        entityId: file.id,
        path: '/deckIds/$i',
      );
    }
  }
  final paths = obj(file.json, 'file');
  final moduleRoot = file.moduleRoot;
  if (paths != null && moduleRoot != null) {
    for (final lang in const ['fr', 'en']) {
      final rel = str(paths, lang);
      if (rel == null) continue;
      if (!File(p.join(moduleRoot, rel)).existsSync()) {
        sink.error(
          file,
          'lesson file "$rel" not found under ${file.moduleDir}/',
          entityId: file.id,
          path: '/file/$lang',
        );
      }
    }
  }
}

void _checkDeckRefs(
  ContentFile file,
  IssueSink sink,
  FamilyExists familyExists,
) {
  _checkModuleId(file, sink);
  _checkFamilyId(
    file,
    sink,
    familyExists,
    mustMatchFolder: file.familyDir != null,
  );
}

void _checkBlueprintRefs(
  ContentFile file,
  IssueSink sink,
  FamilyExists familyExists,
) {
  _checkModuleId(file, sink);
  for (final (i, section) in objects(file.json, 'sections').indexed) {
    final familyId = str(section, 'familyId');
    if (familyId != null && !familyExists(file.moduleDir, familyId)) {
      sink.error(
        file,
        'section familyId "$familyId" does not reference an existing family '
        'of module ${file.moduleDir}',
        entityId: str(section, 'id'),
        path: '/sections/$i/familyId',
      );
    }
  }
}

/// Every `MediaRef` (`{kind: image|audio, path}`) anywhere in the file must
/// point to an existing file under the module folder.
void _checkMediaRefs(ContentFile file, IssueSink sink) {
  final moduleRoot = file.moduleRoot;
  if (moduleRoot == null) return;
  void walk(Object? node, String pointer, String? entityId) {
    if (node is Map<String, Object?>) {
      final id = str(node, 'id') ?? entityId;
      final kind = str(node, 'kind');
      final path = str(node, 'path');
      if ((kind == 'image' || kind == 'audio') && path != null) {
        if (!File(p.join(moduleRoot, path)).existsSync()) {
          sink.error(
            file,
            'media file "$path" not found under ${file.moduleDir}/',
            entityId: id,
            path: '$pointer/path',
          );
        }
      }
      for (final entry in node.entries) {
        walk(entry.value, '$pointer/${entry.key}', id);
      }
    } else if (node is List<Object?>) {
      for (final (i, child) in node.indexed) {
        walk(child, '$pointer/$i', entityId);
      }
    }
  }

  walk(file.json, '', null);
}
