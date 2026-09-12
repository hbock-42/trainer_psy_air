import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/strings.dart';
import '../../../../core/repositories/repository_providers.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../engines/english/presentation/english_passage_cache.dart';
import '../../domain/mistakes/mistake_pool.dart';
import '../../domain/mistakes/mistake_session_builder.dart';
import '../engine/engine_ui.dart';
import '../summary/session_summary_screen.dart';
import 'reseed.dart';

/// `/train/session/:sessionId` (US-051): the chrome around `SessionHost` —
/// a title bar whose back arrow confirms before quitting and an Esc key
/// that pauses — then, once the activity finishes, the summary (US-052) in
/// its place. "Recommencer" on the summary rebuilds this same screen with a
/// fresh [ActivitySessionRequest] (new seed, no session id).
///
/// `SessionHost` already draws the progress dots and the per-item/section
/// countdowns for the state it is in; this screen only frames it and never
/// duplicates that chrome.
class PracticeSessionScreen extends ConsumerStatefulWidget {
  const PracticeSessionScreen({required this.request, super.key});

  final ActivitySessionRequest request;

  static const Key quitConfirmKey = Key('practice_session.quit_confirm');
  static const Key quitCancelKey = Key('practice_session.quit_cancel');

  @override
  ConsumerState<PracticeSessionScreen> createState() =>
      _PracticeSessionScreenState();
}

class _PracticeSessionScreenState extends ConsumerState<PracticeSessionScreen> {
  late ActivitySessionRequest _request = widget.request;
  SessionResult? _result;
  bool _confirmingQuit = false;

  @override
  void initState() {
    super.initState();
    // A `Focus`/`KeyboardListener` in the widget tree would compete with
    // every autofocus button the renderers and `SessionHost` itself use
    // (Start, Next...), which reclaim primary focus on every item; Esc is a
    // screen-level shortcut, so it listens at the hardware level instead,
    // independent of whatever currently holds focus.
    HardwareKeyboard.instance.addHandler(_handleHardwareKey);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleHardwareKey);
    super.dispose();
  }

  bool _handleHardwareKey(KeyEvent event) {
    if (event is! KeyDownEvent ||
        event.logicalKey != LogicalKeyboardKey.escape) {
      return false;
    }
    if (_result != null || _confirmingQuit) return false;
    final controller = ref.read(
      activitySessionControllerProvider(_request).notifier,
    );
    if (!controller.config.canPause) return false;
    controller.pause();
    return true;
  }

  ActivitySessionConfig get _config => switch (_request) {
    FreshSessionRequest(:final config) => config,
    ResumeSessionRequest(:final session) => ActivitySessionConfig.fromJson(
      session.config,
    ),
  };

  void _onFinished(SessionResult result) {
    if (!mounted) return;
    setState(() {
      _result = result;
      _confirmingQuit = false;
    });
  }

  void _restart() {
    setState(() {
      _request = ActivitySessionRequest.fresh(reseeded(_config));
      _result = null;
    });
  }

  void _askQuit() => setState(() => _confirmingQuit = true);

  void _cancelQuit() => setState(() => _confirmingQuit = false);

  void _confirmQuit() {
    ref.read(activitySessionControllerProvider(_request).notifier).abort();
  }

  @override
  Widget build(BuildContext context) {
    final result = _result;
    if (result != null) {
      final hasMistakes =
          result.section.wrong +
              result.section.timeouts +
              result.section.skipped >
          0;
      return SessionSummaryScreen(
        result: result,
        config: _config,
        onRestart: _restart,
        onBack: () => context.pop(),
        onRetryMistakes: hasMistakes
            ? () => unawaited(_retryMistakes(result))
            : null,
      );
    }

    final theme = AppTheme.of(context);
    final title = _config.title?.resolve(AppStrings.locale) ?? _config.familyId;

    return Stack(
      children: [
        AppScaffold(
          title: title,
          onBack: _askQuit,
          body: SessionHost(request: _request, onFinished: _onFinished),
        ),
        if (_confirmingQuit)
          _QuitConfirmOverlay(
            theme: theme,
            onConfirm: _confirmQuit,
            onCancel: _cancelQuit,
          ),
      ],
    );
  }

  /// "Refaire les erreurs" (US-054): a fresh session over the items [result]
  /// got wrong, timed out on or skipped, same family/timing/title as this
  /// one. [MistakePool.fromSessionOutcomes] needs the session's own
  /// `GeneratorParams` for a generated family (the concrete `Item` only
  /// carries its `generatorId`/`seed`, not the params that produced it).
  Future<void> _retryMistakes(SessionResult result) async {
    final config = _config;
    final pool = MistakePool.fromSessionOutcomes(
      result.outcomes,
      sessionParams: switch (config.source) {
        GeneratorSource(:final params) => params,
        _ => null,
      },
    );
    if (pool.isEmpty) return;
    final retryConfig = await buildMistakeSessionConfig(
      familyId: config.familyId,
      pool: pool,
      contentRepository: ref.read(contentRepositoryProvider),
      timing: config.timing,
      title: config.title,
      onPassagesLoaded: ref.read(englishPassageCacheProvider).addAll,
    );
    if (!mounted) return;
    setState(() {
      _request = ActivitySessionRequest.fresh(retryConfig);
      _result = null;
    });
  }
}

class _QuitConfirmOverlay extends StatelessWidget {
  const _QuitConfirmOverlay({
    required this.theme,
    required this.onConfirm,
    required this.onCancel,
  });

  final AppTheme theme;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ColoredBox(
        color: theme.colors.background.withValues(alpha: 0.92),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Padding(
              padding: EdgeInsets.all(theme.spacing.lg),
              child: AppCard(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      AppStrings.sessionQuitConfirmTitle,
                      style: theme.textStyles.title,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: theme.spacing.sm),
                    Text(
                      AppStrings.sessionQuitConfirmBody,
                      style: theme.textStyles.body,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: theme.spacing.lg),
                    PrimaryButton(
                      key: PracticeSessionScreen.quitConfirmKey,
                      label: AppStrings.sessionQuitConfirmAction,
                      expand: true,
                      onPressed: onConfirm,
                    ),
                    SizedBox(height: theme.spacing.sm),
                    SecondaryButton(
                      key: PracticeSessionScreen.quitCancelKey,
                      label: AppStrings.sessionQuitCancelAction,
                      expand: true,
                      onPressed: onCancel,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
