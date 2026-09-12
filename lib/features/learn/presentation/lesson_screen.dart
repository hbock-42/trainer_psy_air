import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/content/content.dart';
import '../../../core/l10n/strings.dart';
import '../../../core/repositories/repository_providers.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/widgets.dart';
import '../../progress/presentation/providers/progress_version_provider.dart';
import 'providers/family_lessons_provider.dart';
import 'providers/lesson_read_provider.dart';

/// A short lesson is marked read after this delay even if its content never
/// needs scrolling (US-044).
const Duration shortLessonReadDelay = Duration(seconds: 20);

/// How close to the bottom of the scroll view counts as "reached the end"
/// (logical pixels), to absorb small overscroll/rounding.
const double _endOfLessonSlack = 4;

/// Lesson viewer (`/learn/family/:familyId/lesson/:lessonId`, US-041): title,
/// reading time, a collapsible table of contents, the markdown body
/// (US-043 worked examples included), previous/next navigation within the
/// family and a "Essayer" action into practice.
///
/// Marks the lesson read (US-044) when the reader scrolls to the end, or
/// after [shortLessonReadDelay] when the content is short enough that it
/// never needs scrolling; a manual toggle in the top bar does the same.
class LessonScreen extends ConsumerStatefulWidget {
  const LessonScreen({
    required this.familyId,
    required this.lessonId,
    super.key,
  });

  final String familyId;
  final String lessonId;

  @override
  ConsumerState<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends ConsumerState<LessonScreen> {
  final ScrollController _scrollController = ScrollController();
  Timer? _shortLessonTimer;
  bool _autoMarkArmed = false;
  bool _tocOpen = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(covariant LessonScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lessonId != widget.lessonId) {
      _shortLessonTimer?.cancel();
      _shortLessonTimer = null;
      _autoMarkArmed = false;
      _tocOpen = false;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _shortLessonTimer?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.maxScrollExtent <= 0) return; // handled by the timer
    if (position.pixels >= position.maxScrollExtent - _endOfLessonSlack) {
      _markRead();
    }
  }

  /// Arms the 20 s fallback the first time a frame reports the content fits
  /// without scrolling (a short lesson).
  void _armShortLessonTimerIfNeeded() {
    if (_autoMarkArmed || !_scrollController.hasClients) return;
    if (_scrollController.position.maxScrollExtent <= 0) {
      _autoMarkArmed = true;
      _shortLessonTimer = Timer(shortLessonReadDelay, _markRead);
    }
  }

  Future<void> _markRead() async {
    await ref.read(progressRepositoryProvider).markLessonRead(widget.lessonId);
    if (!mounted) return;
    ref.read(progressVersionProvider.notifier).bump();
  }

  @override
  Widget build(BuildContext context) {
    final lessons = ref.watch(familyLessonsProvider(widget.familyId));
    return _AsyncValueBuilder<List<Lesson>>(
      value: lessons,
      loading: AppStrings.lessonLoading,
      error: AppStrings.familyLessonsEmpty,
      builder: (context, list) {
        final index = list.indexWhere((l) => l.id == widget.lessonId);
        if (index == -1) {
          return AppScaffold(
            onBack: context.pop,
            body: const Center(child: Text(AppStrings.lessonNotFound)),
          );
        }
        return _LessonBody(
          familyId: widget.familyId,
          lesson: list[index],
          previous: index > 0 ? list[index - 1] : null,
          next: index < list.length - 1 ? list[index + 1] : null,
          scrollController: _scrollController,
          tocOpen: _tocOpen,
          onToggleToc: () => setState(() => _tocOpen = !_tocOpen),
          onFrame: _armShortLessonTimerIfNeeded,
          onMarkRead: _markRead,
        );
      },
    );
  }
}

class _LessonBody extends ConsumerWidget {
  const _LessonBody({
    required this.familyId,
    required this.lesson,
    required this.previous,
    required this.next,
    required this.scrollController,
    required this.tocOpen,
    required this.onToggleToc,
    required this.onFrame,
    required this.onMarkRead,
  });

  final String familyId;
  final Lesson lesson;
  final Lesson? previous;
  final Lesson? next;
  final ScrollController scrollController;
  final bool tocOpen;
  final VoidCallback onToggleToc;
  final VoidCallback onFrame;
  final Future<void> Function() onMarkRead;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppTheme.of(context);
    final blocks = parseMarkdown(lesson.body?.resolve(AppStrings.locale) ?? '');
    final headings = extractHeadings(blocks);
    final read = ref.watch(lessonReadProvider(lesson.id));
    final isRead = read.value ?? false;

    WidgetsBinding.instance.addPostFrameCallback((_) => onFrame());

    return AppScaffold(
      title: lesson.title.resolve(AppStrings.locale),
      onBack: context.pop,
      actions: [
        AppIconButton(
          glyph: AppIconGlyph.check,
          semanticsLabel: isRead
              ? AppStrings.lessonMarkedRead
              : AppStrings.lessonMarkRead,
          onPressed: isRead ? null : onMarkRead,
        ),
      ],
      body: SingleChildScrollView(
        controller: scrollController,
        padding: EdgeInsets.all(theme.spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (lesson.estimatedReadMin != null)
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: theme.spacing.xs,
                runSpacing: theme.spacing.xs,
                children: [
                  AppIcon(
                    AppIconGlyph.clock,
                    size: 16,
                    color: theme.colors.textSecondary,
                  ),
                  Text(
                    AppStrings.lessonReadTime(lesson.estimatedReadMin!),
                    style: theme.textStyles.caption,
                  ),
                  if (isRead) ...[
                    AppIcon(
                      AppIconGlyph.check,
                      size: 16,
                      color: theme.colors.success,
                      semanticsLabel: AppStrings.lessonMarkedRead,
                    ),
                    Text(
                      AppStrings.lessonMarkedRead,
                      style: theme.textStyles.caption.copyWith(
                        color: theme.colors.success,
                      ),
                    ),
                  ],
                ],
              ),
            if (headings.isNotEmpty) ...[
              SizedBox(height: theme.spacing.md),
              _Toc(headings: headings, open: tocOpen, onToggle: onToggleToc),
            ],
            SizedBox(height: theme.spacing.lg),
            MarkdownView.blocks(blocks),
            SizedBox(height: theme.spacing.xl),
            PrimaryButton(
              label: AppStrings.lessonTryIt,
              icon: AppIconGlyph.target,
              expand: true,
              onPressed: () => context.go(AppRoutes.trainFamily(familyId)),
            ),
            SizedBox(height: theme.spacing.lg),
            _PrevNextRow(familyId: familyId, previous: previous, next: next),
          ],
        ),
      ),
    );
  }
}

class _Toc extends StatelessWidget {
  const _Toc({
    required this.headings,
    required this.open,
    required this.onToggle,
  });

  final List<MarkdownHeading> headings;
  final bool open;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return AppCard(
      padding: EdgeInsets.all(theme.spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Semantics(
                  header: true,
                  child: Text(
                    AppStrings.lessonTocTitle,
                    style: theme.textStyles.title,
                  ),
                ),
              ),
              SizedBox(width: theme.spacing.sm),
              // Flexible (not SectionHeader's fixed trailing slot): the
              // label is long enough to overflow a narrow phone otherwise.
              Flexible(
                child: SecondaryButton(
                  label: open
                      ? AppStrings.lessonTocHide
                      : AppStrings.lessonTocShow,
                  onPressed: onToggle,
                ),
              ),
            ],
          ),
          if (open) ...[
            SizedBox(height: theme.spacing.sm),
            for (final h in headings)
              Padding(
                padding: EdgeInsets.only(
                  top: theme.spacing.xs,
                  left: theme.spacing.md * (h.level - 1).clamp(0, 3),
                ),
                child: AppPressable(
                  onPressed: () => Scrollable.ensureVisible(
                    h.key.currentContext!,
                    duration: theme.durations.normal,
                    alignment: 0.05,
                  ),
                  semanticsLabel: h.text,
                  excludeSemantics: true,
                  builder: (context, state) => Text(
                    h.text,
                    style: theme.textStyles.body.copyWith(
                      color: state.hovered
                          ? theme.colors.textPrimary
                          : theme.colors.textSecondary,
                    ),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _PrevNextRow extends StatelessWidget {
  const _PrevNextRow({
    required this.familyId,
    required this.previous,
    required this.next,
  });

  final String familyId;
  final Lesson? previous;
  final Lesson? next;

  @override
  Widget build(BuildContext context) {
    if (previous == null && next == null) return const SizedBox.shrink();
    final theme = AppTheme.of(context);
    return Row(
      children: [
        if (previous != null)
          Expanded(
            child: SecondaryButton(
              label: AppStrings.lessonPrevious,
              icon: AppIconGlyph.chevronLeft,
              onPressed: () =>
                  context.go(AppRoutes.learnLesson(familyId, previous!.id)),
            ),
          ),
        if (previous != null && next != null) SizedBox(width: theme.spacing.sm),
        if (next != null)
          Expanded(
            child: SecondaryButton(
              label: AppStrings.lessonNext,
              icon: AppIconGlyph.chevronRight,
              onPressed: () =>
                  context.go(AppRoutes.learnLesson(familyId, next!.id)),
            ),
          ),
      ],
    );
  }
}

/// Small `AsyncValue` -> widget switch for this screen's loading/error/data
/// states (data is handed to [builder]).
class _AsyncValueBuilder<T> extends StatelessWidget {
  const _AsyncValueBuilder({
    required this.value,
    required this.loading,
    required this.error,
    required this.builder,
  });

  final AsyncValue<T> value;
  final String loading;
  final String error;
  final Widget Function(BuildContext, T) builder;

  @override
  Widget build(BuildContext context) {
    return switch (value) {
      AsyncData(:final value) => builder(context, value),
      AsyncError() => AppScaffold(
        onBack: context.pop,
        body: Center(child: Text(error)),
      ),
      _ => AppScaffold(
        onBack: context.pop,
        body: Center(child: Text(loading)),
      ),
    };
  }
}
