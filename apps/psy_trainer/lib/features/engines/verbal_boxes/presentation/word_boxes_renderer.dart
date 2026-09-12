import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:psy_content/psy_content.dart';
import '../../../../core/l10n/strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../train/domain/engine/engine.dart';
import '../../../train/presentation/engine/activity_renderer.dart';
import '../domain/word_box_series.dart';
import '../domain/word_boxes_engine.dart';

/// The widget half of `verbal_boxes` (US-030): shows the series's word
/// stream one word at a time and lets the candidate claim a box for it.
///
/// Timing note (see the PR description): the blueprint's
/// `perItemTimeSec`/`ExamSection.perItemTimeSec` is the runtime's per-*item*
/// deadline, and one item here is a whole series (spec §2.4-I: "timed per
/// word" within "4-5 series"); the runtime has no notion of a deadline per
/// word inside one item. `params.wordTimeMs` (`family.json`'s per-word
/// pacing) therefore drives its own countdown here, entirely inside this
/// widget -- an engine-owned pacing rule, not a runtime limit, so it does
/// not conflict with "never run your own timers for the runtime's limits"
/// (ARCHITECTURE.md): `SessionHost` still owns the series-level deadline.
class WordBoxesRenderer extends ActivityRenderer {
  const WordBoxesRenderer(this._fields);

  final LexicalFieldSource _fields;

  @override
  String get familyId => 'verbal_boxes';

  @override
  Widget build(BuildContext context, ActivityRenderContext render) =>
      _WordBoxesView(
        key: ValueKey(render.item.id),
        render: render,
        fields: _fields,
      );

  @override
  Widget? buildExample(BuildContext context, [RunExampleContext? run]) => null;
}

class _WordBoxesView extends StatefulWidget {
  const _WordBoxesView({required this.render, required this.fields, super.key});

  final ActivityRenderContext render;
  final LexicalFieldSource fields;

  @override
  State<_WordBoxesView> createState() => _WordBoxesViewState();
}

class _WordBoxesViewState extends State<_WordBoxesView> {
  final FocusNode _focusNode = FocusNode();
  late final WordBoxSeries _series;
  late final List<String?> _placements;
  int _index = 0;
  int _errors = 0;
  bool _submitted = false;
  Timer? _wordTimer;
  Duration _remaining = Duration.zero;
  Timer? _tick;
  DateTime? _wordDeadline;

  GeneratedItem get _item => widget.render.item as GeneratedItem;
  WordBoxesParams get _params => _item.params as WordBoxesParams;

  @override
  void initState() {
    super.initState();
    _series = WordBoxSeries.build(
      catalogue: widget.fields.all,
      params: _params,
      seed: _item.seed,
      difficulty: _item.difficulty,
    );
    _placements = List<String?>.filled(_series.events.length, null);
    _startWordTimer();
  }

  @override
  void dispose() {
    _wordTimer?.cancel();
    _tick?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  void _startWordTimer() {
    _wordTimer?.cancel();
    _tick?.cancel();
    final duration = Duration(milliseconds: _params.wordTimeMs);
    _wordDeadline = DateTime.now().add(duration);
    _remaining = duration;
    _wordTimer = Timer(duration, _onWordTimeout);
    _tick = Timer.periodic(const Duration(milliseconds: 100), (_) {
      final left = _wordDeadline!.difference(DateTime.now());
      setState(() => _remaining = left.isNegative ? Duration.zero : left);
    });
  }

  void _onWordTimeout() {
    if (_submitted) return;
    _place(null);
  }

  void _place(int? boxIndex) {
    if (_submitted || _index >= _series.events.length) return;
    final event = _series.events[_index];
    final answer = boxIndex?.toString();
    _placements[_index] = answer;
    if (answer != event.fieldIndex.toString()) {
      setState(() => _errors++);
    }
    _index++;
    if (_index >= _series.events.length) {
      _submit();
    } else {
      setState(_startWordTimer);
    }
  }

  void _submit() {
    if (_submitted) return;
    _submitted = true;
    _wordTimer?.cancel();
    _tick?.cancel();
    widget.render.onAnswer(
      Answer.sequence([for (final p in _placements) p ?? '']),
    );
  }

  void _onKey(KeyEvent event) {
    if (event is! KeyDownEvent) return;
    final digit = _digitOf(event.logicalKey);
    if (digit != null && digit < _series.fields.length) _place(digit);
  }

  static int? _digitOf(LogicalKeyboardKey key) {
    const digits = [
      LogicalKeyboardKey.digit1,
      LogicalKeyboardKey.digit2,
      LogicalKeyboardKey.digit3,
      LogicalKeyboardKey.digit4,
      LogicalKeyboardKey.digit5,
      LogicalKeyboardKey.digit6,
    ];
    final index = digits.indexOf(key);
    return index == -1 ? null : index;
  }

  /// The index in [WordBoxSeries.events] at which box [boxIndex] was first
  /// shown (claimed), or null if it has not appeared yet.
  int? _claimedAt(int boxIndex) {
    for (var i = 0; i < _series.events.length; i++) {
      if (_series.events[i].fieldIndex == boxIndex) return i;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    if (widget.render.isAnswered) return _buildRecap(context, theme);

    final currentWord = _index < _series.events.length
        ? _series.events[_index].word
        : '';

    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _onKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppStrings.wordBoxesErrorCount(_errors),
            style: theme.textStyles.label,
          ),
          SizedBox(height: theme.spacing.sm),
          CountdownTimerBar(
            remaining: _remaining,
            total: Duration(milliseconds: _params.wordTimeMs),
            showLabel: false,
          ),
          SizedBox(height: theme.spacing.xl),
          Expanded(
            child: Center(
              child: Text(
                currentWord,
                textAlign: TextAlign.center,
                style: theme.textStyles.headline,
              ),
            ),
          ),
          SizedBox(height: theme.spacing.xl),
          Wrap(
            spacing: theme.spacing.sm,
            runSpacing: theme.spacing.sm,
            children: [
              for (var i = 0; i < _series.fields.length; i++)
                SizedBox(
                  width: 140,
                  child: AppKeypadButton(
                    key: ValueKey('word-box-$i'),
                    label: _boxLabel(i),
                    semanticsLabel: AppStrings.wordBoxesBoxSemantics(
                      i + 1,
                      _boxLabel(i),
                    ),
                    onPressed: () => _place(i),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _boxLabel(int i) {
    final claimedAt = _claimedAt(i);
    if (claimedAt == null || claimedAt > _index) {
      return AppStrings.wordBoxesEmptyBox;
    }
    return _series.events[claimedAt].word;
  }

  Widget _buildRecap(BuildContext context, AppTheme theme) {
    final missed = [
      for (var i = 0; i < _series.events.length; i++)
        if (_placements[i] != _series.events[i].fieldIndex.toString())
          _series.events[i],
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          AppStrings.wordBoxesResultSummary(_errors, _series.events.length),
          style: theme.textStyles.bodyStrong,
        ),
        if (missed.isNotEmpty) ...[
          SizedBox(height: theme.spacing.md),
          Text(AppStrings.wordBoxesMissedTitle, style: theme.textStyles.label),
          SizedBox(height: theme.spacing.xs),
          for (final event in missed)
            Text(
              AppStrings.wordBoxesMissedWord(
                event.word,
                _series.fields[event.fieldIndex].name.fr,
              ),
              style: theme.textStyles.body,
            ),
        ],
      ],
    );
  }
}
