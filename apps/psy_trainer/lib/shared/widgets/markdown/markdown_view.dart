import 'package:flutter/widgets.dart';
import 'package:markdown/markdown.dart' as md;

import '../../../core/l10n/l10n_extensions.dart';
import '../../../core/theme/app_theme.dart';
import '../app_icon.dart';
import 'markdown_document.dart';
import 'reveal_steps.dart';

/// Renders lesson markdown (US-041) with our own widgets on
/// `package:flutter/widgets.dart` — no `flutter_markdown` (Material-only
/// dependencies are off-limits, see `docs/ARCHITECTURE.md`).
///
/// Supports headings, paragraphs, bold/italic/inline code, ordered/unordered
/// lists, tables (horizontally scrollable), blockquotes incl. the `[!TIP]` /
/// `[!TRAP]` / `[!METHOD]` / `[!EXAMPLE]` callouts, fenced code, links
/// (underlined for now), horizontal rules, `## Exemple guidé n` worked
/// examples (US-043) and an alt-text placeholder for images (none in the
/// real content today, but authoring allows them).
///
/// Parsing is cached by [parseMarkdown] (keyed by the raw text), so
/// re-rendering the same lesson never re-parses; pass pre-parsed [blocks]
/// (e.g. to share them with a table-of-contents) with [MarkdownView.blocks].
class MarkdownView extends StatelessWidget {
  const MarkdownView(this.markdown, {super.key}) : blocks = null;

  const MarkdownView.blocks(this.blocks, {super.key}) : markdown = null;

  final String? markdown;
  final List<MarkdownBlock>? blocks;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final resolved = blocks ?? parseMarkdown(markdown!);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final block in resolved) buildBlock(context, theme, block),
      ],
    );
  }
}

/// Renders one top-level [MarkdownBlock]. Exposed so the lesson screen can
/// reuse it while building its own layout around the parsed blocks.
Widget buildBlock(BuildContext context, AppTheme theme, MarkdownBlock block) {
  return switch (block) {
    MarkdownHeadingBlock(:final heading) => _heading(theme, heading),
    MarkdownNodeBlock(:final node) => buildGenericNode(context, theme, node),
    MarkdownCalloutBlock(:final kind, :final children) => Padding(
      padding: EdgeInsets.symmetric(vertical: theme.spacing.sm),
      child: buildCallout(context, theme, kind, children),
    ),
    MarkdownWorkedExampleBlock(
      :final heading,
      :final statement,
      :final steps,
    ) =>
      Padding(
        key: heading.key,
        padding: EdgeInsets.symmetric(vertical: theme.spacing.sm),
        child: RevealSteps(
          title: heading.text,
          statement: buildCallout(
            context,
            theme,
            CalloutKind.example,
            statement,
          ),
          steps: [
            for (final step in steps)
              RevealStepData(
                title: step.title,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final n in step.nodes)
                      buildGenericNode(context, theme, n),
                  ],
                ),
              ),
          ],
        ),
      ),
  };
}

Widget _heading(AppTheme theme, MarkdownHeading heading) {
  final style = switch (heading.level) {
    1 => theme.textStyles.headline,
    2 => theme.textStyles.title,
    3 => theme.textStyles.bodyStrong,
    _ => theme.textStyles.label,
  };
  return Padding(
    key: heading.key,
    padding: EdgeInsets.only(top: theme.spacing.lg, bottom: theme.spacing.sm),
    child: Semantics(header: true, child: Text(heading.text, style: style)),
  );
}

/// Dispatches on the tag of a block-level markdown node: `p`, `ul`/`ol`,
/// `table`, `pre` (fenced code), `hr`, a plain `blockquote`, or anything
/// unrecognised (rendered as its text content so parsing never throws).
Widget buildGenericNode(BuildContext context, AppTheme theme, md.Node node) {
  if (node is md.Text) {
    return Text(node.text, style: theme.textStyles.body);
  }
  if (node is! md.Element) return const SizedBox.shrink();

  switch (node.tag) {
    case 'p':
      return Padding(
        padding: EdgeInsets.only(bottom: theme.spacing.sm),
        child: Text.rich(
          TextSpan(
            style: theme.textStyles.body,
            children: _inlineChildren(
              context,
              theme,
              node,
              theme.textStyles.body,
            ),
          ),
        ),
      );
    case 'ul':
    case 'ol':
      return _list(context, theme, node, depth: 0);
    case 'table':
      return Padding(
        padding: EdgeInsets.symmetric(vertical: theme.spacing.sm),
        child: _table(context, theme, node),
      );
    case 'pre':
      return _codeBlock(theme, node);
    case 'hr':
      return Container(
        height: 1,
        margin: EdgeInsets.symmetric(vertical: theme.spacing.lg),
        color: theme.colors.border,
      );
    case 'blockquote':
      return Container(
        margin: EdgeInsets.symmetric(vertical: theme.spacing.sm),
        padding: EdgeInsets.only(left: theme.spacing.md),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: theme.colors.borderStrong, width: 3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final c in node.children ?? const <md.Node>[])
              buildGenericNode(context, theme, c),
          ],
        ),
      );
    default:
      // Headings reaching here (e.g. inside a list item) or any
      // unsupported block-level tag: fall back to its plain text so a
      // lesson never fails to render.
      return Padding(
        padding: EdgeInsets.only(bottom: theme.spacing.xs),
        child: Text(node.textContent, style: theme.textStyles.body),
      );
  }
}

/// Styled panel for a `[!TIP]` / `[!TRAP]` / `[!METHOD]` / `[!EXAMPLE]`
/// callout: an icon, a label and the marker-stripped content.
Widget buildCallout(
  BuildContext context,
  AppTheme theme,
  CalloutKind kind,
  List<md.Node> content,
) {
  final (label, color, subtle, glyph) = switch (kind) {
    CalloutKind.tip => (
      context.l10n.lessonCalloutTip,
      theme.colors.success,
      theme.colors.successSubtle,
      AppIconGlyph.check,
    ),
    CalloutKind.trap => (
      context.l10n.lessonCalloutTrap,
      theme.colors.error,
      theme.colors.errorSubtle,
      AppIconGlyph.cross,
    ),
    CalloutKind.method => (
      context.l10n.lessonCalloutMethod,
      theme.colors.warning,
      theme.colors.warningSubtle,
      AppIconGlyph.target,
    ),
    CalloutKind.example => (
      context.l10n.lessonCalloutExample,
      theme.colors.accent,
      theme.colors.accentSubtle,
      AppIconGlyph.book,
    ),
  };
  final stripped = stripCalloutMarker(content);
  return Semantics(
    container: true,
    label: label,
    child: Container(
      width: double.infinity,
      padding: EdgeInsets.all(theme.spacing.md),
      decoration: BoxDecoration(
        color: subtle,
        borderRadius: theme.radii.mdAll,
        border: Border.all(color: color),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExcludeSemantics(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppIcon(glyph, size: 16, color: color),
                SizedBox(width: theme.spacing.xs),
                Text(
                  label,
                  style: theme.textStyles.label.copyWith(color: color),
                ),
              ],
            ),
          ),
          SizedBox(height: theme.spacing.xs),
          for (final c in stripped) buildGenericNode(context, theme, c),
        ],
      ),
    ),
  );
}

Widget _list(
  BuildContext context,
  AppTheme theme,
  md.Element list, {
  required int depth,
}) {
  final ordered = list.tag == 'ol';
  final items = (list.children ?? const <md.Node>[])
      .whereType<md.Element>()
      .toList();
  return Padding(
    padding: EdgeInsets.only(
      left: depth == 0 ? 0 : theme.spacing.md,
      bottom: depth == 0 ? theme.spacing.sm : 0,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (i, item) in items.indexed)
          Padding(
            padding: EdgeInsets.only(bottom: theme.spacing.xs),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 22,
                  child: Text(
                    ordered ? '${i + 1}.' : '•',
                    style: theme.textStyles.body,
                  ),
                ),
                Expanded(child: _listItemContent(context, theme, item, depth)),
              ],
            ),
          ),
      ],
    ),
  );
}

Widget _listItemContent(
  BuildContext context,
  AppTheme theme,
  md.Element li,
  int depth,
) {
  final children = li.children ?? const <md.Node>[];
  final blocks = <Widget>[];
  final inline = <md.Node>[];

  void flush() {
    if (inline.isEmpty) return;
    blocks.add(
      Text.rich(
        TextSpan(
          style: theme.textStyles.body,
          children: _inlineNodes(context, theme, inline, theme.textStyles.body),
        ),
      ),
    );
    inline.clear();
  }

  for (final child in children) {
    if (child is md.Element && (child.tag == 'ul' || child.tag == 'ol')) {
      flush();
      blocks.add(_list(context, theme, child, depth: depth + 1));
    } else if (child is md.Element && child.tag == 'p') {
      flush();
      blocks.add(
        Text.rich(
          TextSpan(
            style: theme.textStyles.body,
            children: _inlineChildren(
              context,
              theme,
              child,
              theme.textStyles.body,
            ),
          ),
        ),
      );
    } else {
      inline.add(child);
    }
  }
  flush();
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: blocks);
}

Widget _table(BuildContext context, AppTheme theme, md.Element table) {
  final sections = (table.children ?? const <md.Node>[])
      .whereType<md.Element>();
  final headRow = sections
      .where((s) => s.tag == 'thead')
      .expand((s) => s.children ?? const <md.Node>[])
      .whereType<md.Element>()
      .firstOrNull;
  final bodyRows = sections
      .where((s) => s.tag == 'tbody')
      .expand((s) => s.children ?? const <md.Node>[])
      .whereType<md.Element>()
      .toList();
  final rows = [?headRow, ...bodyRows];
  if (rows.isEmpty) return const SizedBox.shrink();

  final columnCount = rows
      .map((r) => (r.children ?? const <md.Node>[]).length)
      .fold<int>(0, (a, b) => a > b ? a : b);

  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Table(
      border: TableBorder.all(color: theme.colors.border),
      defaultColumnWidth: const IntrinsicColumnWidth(),
      children: [
        for (final row in rows)
          TableRow(
            decoration: identical(row, headRow)
                ? BoxDecoration(color: theme.colors.surfaceRaised)
                : null,
            children: [
              for (var c = 0; c < columnCount; c++)
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.top,
                  child: Padding(
                    padding: EdgeInsets.all(theme.spacing.sm),
                    child: c < (row.children ?? const []).length
                        ? Text.rich(
                            TextSpan(
                              style: identical(row, headRow)
                                  ? theme.textStyles.bodyStrong
                                  : theme.textStyles.body,
                              children: _inlineChildren(
                                context,
                                theme,
                                row.children![c] as md.Element,
                                identical(row, headRow)
                                    ? theme.textStyles.bodyStrong
                                    : theme.textStyles.body,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
            ],
          ),
      ],
    ),
  );
}

Widget _codeBlock(AppTheme theme, md.Element pre) {
  final code = pre.textContent;
  return Container(
    width: double.infinity,
    margin: EdgeInsets.symmetric(vertical: theme.spacing.sm),
    padding: EdgeInsets.all(theme.spacing.md),
    decoration: BoxDecoration(
      color: theme.colors.surfaceRaised,
      borderRadius: theme.radii.mdAll,
      border: Border.all(color: theme.colors.border),
    ),
    child: Text(
      code,
      style: theme.textStyles.body.copyWith(fontFamily: 'monospace'),
    ),
  );
}

List<InlineSpan> _inlineChildren(
  BuildContext context,
  AppTheme theme,
  md.Element element,
  TextStyle style,
) => _inlineNodes(context, theme, element.children ?? const [], style);

List<InlineSpan> _inlineNodes(
  BuildContext context,
  AppTheme theme,
  List<md.Node> nodes,
  TextStyle style,
) => [for (final n in nodes) _inlineSpan(context, theme, n, style)];

InlineSpan _inlineSpan(
  BuildContext context,
  AppTheme theme,
  md.Node node,
  TextStyle style,
) {
  if (node is md.Text) return TextSpan(text: node.text, style: style);
  if (node is! md.Element) return const TextSpan();

  switch (node.tag) {
    case 'em':
      final s = style.copyWith(fontStyle: FontStyle.italic);
      return TextSpan(
        style: s,
        children: _inlineChildren(context, theme, node, s),
      );
    case 'strong':
      final s = style.copyWith(fontWeight: FontWeight.w700);
      return TextSpan(
        style: s,
        children: _inlineChildren(context, theme, node, s),
      );
    case 'del':
      final s = style.copyWith(decoration: TextDecoration.lineThrough);
      return TextSpan(
        style: s,
        children: _inlineChildren(context, theme, node, s),
      );
    case 'a':
      final s = style.copyWith(decoration: TextDecoration.underline);
      return TextSpan(
        style: s,
        children: _inlineChildren(context, theme, node, s),
      );
    case 'code':
      return WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: theme.spacing.xs),
          decoration: BoxDecoration(
            color: theme.colors.surfaceRaised,
            borderRadius: theme.radii.smAll,
          ),
          child: Text(
            node.textContent,
            style: style.copyWith(fontFamily: 'monospace'),
          ),
        ),
      );
    case 'img':
      return WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: _ImagePlaceholder(alt: node.attributes['alt'] ?? ''),
      );
    default:
      return TextSpan(
        style: style,
        children: _inlineChildren(context, theme, node, style),
      );
  }
}

/// Images are never bundled in the real lesson content today, but authoring
/// allows them: a bordered box with the alt text stands in for the asset.
class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder({required this.alt});

  final String alt;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Container(
      padding: EdgeInsets.all(theme.spacing.sm),
      decoration: BoxDecoration(
        color: theme.colors.surfaceRaised,
        borderRadius: theme.radii.mdAll,
        border: Border.all(color: theme.colors.border),
      ),
      child: Text(
        alt.isEmpty ? context.l10n.lessonImagePlaceholder : alt,
        style: theme.textStyles.caption,
      ),
    );
  }
}
