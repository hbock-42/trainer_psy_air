import 'package:flutter/widgets.dart';
import 'package:markdown/markdown.dart' as md;

/// The four callout kinds authored in lesson markdown (`docs/content/
/// AUTHORING.md` §10): `> [!TIP]`, `> [!TRAP]`, `> [!METHOD]`,
/// `> [!EXAMPLE]`.
enum CalloutKind { tip, trap, method, example }

/// One heading found in a lesson, with a [key] the renderer attaches to the
/// heading widget so the table of contents can scroll to it.
@immutable
class MarkdownHeading {
  MarkdownHeading({required this.level, required this.text})
    : key = GlobalKey();

  /// 1..6, from the number of leading `#`.
  final int level;
  final String text;
  final GlobalKey key;
}

/// A step of a worked example (`### Étape n`), revealed one at a time by
/// [RevealSteps] (US-043).
@immutable
class MarkdownStep {
  const MarkdownStep({required this.title, required this.nodes});

  final String title;
  final List<md.Node> nodes;
}

/// One top-level piece of a parsed lesson document.
sealed class MarkdownBlock {
  const MarkdownBlock();
}

/// A `#`..`######` heading, rendered at its level and listed in the TOC.
final class MarkdownHeadingBlock extends MarkdownBlock {
  const MarkdownHeadingBlock(this.heading);

  final MarkdownHeading heading;
}

/// Anything rendered by the generic block dispatcher: paragraph, list,
/// table, fenced code, thematic break, plain blockquote.
final class MarkdownNodeBlock extends MarkdownBlock {
  const MarkdownNodeBlock(this.node);

  final md.Element node;
}

/// A `> [!TIP]`-style callout, the marker line stripped from [children].
final class MarkdownCalloutBlock extends MarkdownBlock {
  const MarkdownCalloutBlock({required this.kind, required this.children});

  final CalloutKind kind;
  final List<md.Node> children;
}

/// A `## Exemple guidé n` section (US-043): the heading, the `[!EXAMPLE]`
/// statement (always visible) and its `### Étape n` steps (revealed one by
/// one by [RevealSteps]).
final class MarkdownWorkedExampleBlock extends MarkdownBlock {
  const MarkdownWorkedExampleBlock({
    required this.heading,
    required this.statement,
    required this.steps,
  });

  final MarkdownHeading heading;
  final List<md.Node> statement;
  final List<MarkdownStep> steps;
}

/// Matches the `## Exemple guidé n` convention (see the real lessons under
/// `assets/content/psy0/lessons/`), case- and accent-insensitive enough to
/// tolerate "guide"/"guidé".
final RegExp _workedExampleHeading = RegExp(
  r'^Exemple\s+guid[ée]',
  caseSensitive: false,
);

final RegExp _calloutMarker = RegExp(r'^\s*\[!([A-Za-z]+)\]');
final RegExp _calloutMarkerStrip = RegExp(r'^\s*\[![A-Za-z]+\]\s*');

/// Parses [source] once and caches the result (keyed by the raw text), so
/// re-rendering the same lesson (e.g. navigating back to it) never
/// re-parses. The cache is small and unbounded eviction never matters at the
/// scale of a lesson bank (a few dozen lessons).
List<MarkdownBlock> parseMarkdown(String source) =>
    _cache.putIfAbsent(source, () => _parse(source));

final Map<String, List<MarkdownBlock>> _cache = {};

/// Headings in document order, including the heading of a worked-example
/// section, for the lesson screen's table of contents.
List<MarkdownHeading> extractHeadings(List<MarkdownBlock> blocks) => [
  for (final block in blocks)
    switch (block) {
      MarkdownHeadingBlock(:final heading) => heading,
      MarkdownWorkedExampleBlock(:final heading) => heading,
      _ => null,
    },
].whereType<MarkdownHeading>().toList();

List<MarkdownBlock> _parse(String source) {
  final document = md.Document(extensionSet: md.ExtensionSet.gitHubFlavored);
  final nodes = document.parse(source);
  final blocks = <MarkdownBlock>[];

  var i = 0;
  while (i < nodes.length) {
    final node = nodes[i];
    if (node is md.Element &&
        _headingLevel(node.tag) == 2 &&
        _workedExampleHeading.hasMatch(node.textContent)) {
      final consumed = _parseWorkedExample(nodes, i);
      blocks.add(consumed.block);
      i = consumed.next;
      continue;
    }
    if (node is md.Element && _headingLevel(node.tag) != null) {
      blocks.add(
        MarkdownHeadingBlock(
          MarkdownHeading(
            level: _headingLevel(node.tag)!,
            text: node.textContent,
          ),
        ),
      );
      i++;
      continue;
    }
    if (node is md.Element && node.tag == 'blockquote') {
      final kind = _calloutKind(node);
      if (kind != null) {
        blocks.add(
          MarkdownCalloutBlock(kind: kind, children: node.children ?? []),
        );
        i++;
        continue;
      }
    }
    if (node is md.Element) {
      blocks.add(MarkdownNodeBlock(node));
    }
    i++;
  }
  return blocks;
}

({MarkdownBlock block, int next}) _parseWorkedExample(
  List<md.Node> nodes,
  int headingIndex,
) {
  final headingNode = nodes[headingIndex] as md.Element;
  final heading = MarkdownHeading(level: 2, text: headingNode.textContent);
  var i = headingIndex + 1;

  var statement = const <md.Node>[];
  if (i < nodes.length) {
    final next = nodes[i];
    if (next is md.Element &&
        next.tag == 'blockquote' &&
        _calloutKind(next) == CalloutKind.example) {
      statement = next.children ?? const [];
      i++;
    }
  }

  final steps = <MarkdownStep>[];
  while (i < nodes.length) {
    final n = nodes[i];
    if (n is md.Element && (_headingLevel(n.tag) ?? 99) <= 2) break;
    if (n is md.Element && n.tag == 'h3') {
      final title = n.textContent;
      i++;
      final content = <md.Node>[];
      while (i < nodes.length) {
        final m = nodes[i];
        if (m is md.Element && (_headingLevel(m.tag) ?? 99) <= 3) break;
        content.add(m);
        i++;
      }
      steps.add(MarkdownStep(title: title, nodes: content));
    } else {
      // Stray content between the statement and the first step: ignore
      // rather than throw so a lightly malformed lesson still renders.
      i++;
    }
  }

  return (
    block: MarkdownWorkedExampleBlock(
      heading: heading,
      statement: statement,
      steps: steps,
    ),
    next: i,
  );
}

int? _headingLevel(String tag) {
  if (tag.length != 2 || tag[0] != 'h') return null;
  final level = int.tryParse(tag[1]);
  return level != null && level >= 1 && level <= 6 ? level : null;
}

/// The callout kind of a blockquote whose first line is `[!KIND]`, or null
/// when it is a plain quote.
CalloutKind? _calloutKind(md.Element blockquote) {
  final match = _calloutMarker.firstMatch(blockquote.textContent);
  if (match == null) return null;
  return switch (match.group(1)!.toUpperCase()) {
    'TIP' => CalloutKind.tip,
    'TRAP' => CalloutKind.trap,
    'METHOD' => CalloutKind.method,
    'EXAMPLE' => CalloutKind.example,
    _ => null,
  };
}

/// Strips the leading `[!KIND]` marker from the first text run of a
/// callout's children so it is never rendered.
List<md.Node> stripCalloutMarker(List<md.Node> children) {
  if (children.isEmpty) return children;
  final first = children.first;
  if (first is md.Element && first.tag == 'p') {
    return [
      md.Element('p', _stripLeadingText(first.children ?? const [])),
      ...children.skip(1),
    ];
  }
  return children;
}

List<md.Node> _stripLeadingText(List<md.Node> inline) {
  if (inline.isEmpty) return inline;
  final first = inline.first;
  if (first is md.Text) {
    final replaced = first.text.replaceFirst(_calloutMarkerStrip, '');
    return [if (replaced.isNotEmpty) md.Text(replaced), ...inline.skip(1)];
  }
  return inline;
}
