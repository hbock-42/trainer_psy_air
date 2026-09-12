import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../../../core/theme/app_theme.dart';

/// A minimal multi-line text field built on `EditableText` directly (no
/// Material `TextField`/Cupertino field, see `docs/ARCHITECTURE.md`, "No
/// Material, no Cupertino"). Used by the settings backup screen (US-074) to
/// paste a backup JSON document; kept generic enough for any future
/// "paste some text" need on the widgets layer.
class PlainTextArea extends StatefulWidget {
  const PlainTextArea({
    required this.controller,
    this.hintText,
    this.minLines = 6,
    this.maxLines = 12,
    this.semanticsLabel,
    super.key,
  });

  final TextEditingController controller;
  final String? hintText;
  final int minLines;
  final int maxLines;
  final String? semanticsLabel;

  @override
  State<PlainTextArea> createState() => _PlainTextAreaState();
}

class _PlainTextAreaState extends State<PlainTextArea> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final lineHeight = theme.textStyles.body.fontSize! * 1.4;

    return Semantics(
      label: widget.semanticsLabel,
      textField: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _focusNode.requestFocus,
        child: Container(
          padding: EdgeInsets.all(theme.spacing.sm),
          constraints: BoxConstraints(minHeight: widget.minLines * lineHeight),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: theme.radii.mdAll,
            border: Border.all(color: colors.border),
          ),
          child: ValueListenableBuilder<TextEditingValue>(
            valueListenable: widget.controller,
            builder: (context, value, _) {
              return Stack(
                children: [
                  if (value.text.isEmpty && widget.hintText != null)
                    Text(
                      widget.hintText!,
                      style: theme.textStyles.body.copyWith(
                        color: colors.textMuted,
                      ),
                    ),
                  EditableText(
                    controller: widget.controller,
                    focusNode: _focusNode,
                    style: theme.textStyles.body,
                    cursorColor: colors.accent,
                    backgroundCursorColor: colors.textMuted,
                    selectionColor: colors.accentSubtle,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    maxLines: widget.maxLines,
                    minLines: widget.minLines,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
