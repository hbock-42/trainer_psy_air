import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../core/theme/app_theme.dart';
import '../widgets/widgets.dart';

/// Whether the gallery is reachable in this build: debug builds, or any build
/// compiled with `--dart-define=GALLERY=true`.
const bool kWidgetGalleryEnabled =
    kDebugMode || bool.fromEnvironment('GALLERY');

/// Route path to register in the router when [kWidgetGalleryEnabled]:
///
/// ```dart
/// if (kWidgetGalleryEnabled)
///   GoRoute(
///     path: widgetGalleryRoutePath,
///     builder: (_, _) => const WidgetGalleryScreen(),
///   ),
/// ```
const String widgetGalleryRoutePath = '/gallery';

/// Debug-only catalogue of every shared widget in every state, with light /
/// dark and text-scale toggles. Never linked from production navigation.
class WidgetGalleryScreen extends StatefulWidget {
  const WidgetGalleryScreen({this.onBack, super.key});

  final VoidCallback? onBack;

  @override
  State<WidgetGalleryScreen> createState() => _WidgetGalleryScreenState();
}

class _WidgetGalleryScreenState extends State<WidgetGalleryScreen> {
  bool _dark = false;
  bool _largeText = false;
  int _selectedOption = 2;
  Duration _remaining = const Duration(seconds: 42);
  int _step = 3;
  int _selectedTab = 0;

  static const List<AppTabItem> _tabs = [
    AppTabItem(label: 'Learn', glyph: AppIconGlyph.book),
    AppTabItem(label: 'Train', glyph: AppIconGlyph.target),
    AppTabItem(label: 'Exam', glyph: AppIconGlyph.clock),
    AppTabItem(label: 'Progress', glyph: AppIconGlyph.chart),
    AppTabItem(label: 'Settings', glyph: AppIconGlyph.settings),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = _dark ? AppTheme.dark() : AppTheme.light();
    final media = MediaQuery.of(context);

    return MediaQuery(
      data: media.copyWith(
        textScaler: TextScaler.linear(_largeText ? 1.3 : 1.0),
      ),
      child: AppThemeScope(
        theme: theme,
        child: AppScaffold(
          title: 'Widget gallery',
          onBack: widget.onBack,
          actions: [
            AppIconButton(
              glyph: AppIconGlyph.settings,
              semanticsLabel: _dark
                  ? 'Switch to light theme'
                  : 'Switch to dark theme',
              onPressed: () => setState(() => _dark = !_dark),
            ),
          ],
          body: ListView(
            padding: EdgeInsets.all(theme.spacing.lg),
            children: [
              _Section(
                title: 'Toggles',
                children: [
                  Wrap(
                    spacing: theme.spacing.sm,
                    runSpacing: theme.spacing.sm,
                    children: [
                      SecondaryButton(
                        label: _dark ? 'Light theme' : 'Dark theme',
                        onPressed: () => setState(() => _dark = !_dark),
                      ),
                      SecondaryButton(
                        label: _largeText ? 'Text 1.0x' : 'Text 1.3x',
                        onPressed: () =>
                            setState(() => _largeText = !_largeText),
                      ),
                    ],
                  ),
                ],
              ),
              _Section(
                title: 'Typography',
                children: [
                  Text('Display 48', style: theme.textStyles.display),
                  Text('Headline 28', style: theme.textStyles.headline),
                  Text('Title 20', style: theme.textStyles.title),
                  Text(
                    'Body 16 — the quick brown fox',
                    style: theme.textStyles.body,
                  ),
                  Text('Body strong 16', style: theme.textStyles.bodyStrong),
                  Text('Label 14', style: theme.textStyles.label),
                  Text('Caption 12', style: theme.textStyles.caption),
                  Text('Numeric 0123456789', style: theme.textStyles.numeric),
                ],
              ),
              _Section(
                title: 'Colours',
                children: [
                  Wrap(
                    spacing: theme.spacing.sm,
                    runSpacing: theme.spacing.sm,
                    children: [
                      _Swatch('background', theme.colors.background),
                      _Swatch('surface', theme.colors.surface),
                      _Swatch('surfaceRaised', theme.colors.surfaceRaised),
                      _Swatch('border', theme.colors.border),
                      _Swatch('borderStrong', theme.colors.borderStrong),
                      _Swatch('textPrimary', theme.colors.textPrimary),
                      _Swatch('textSecondary', theme.colors.textSecondary),
                      _Swatch('textMuted', theme.colors.textMuted),
                      _Swatch('accent', theme.colors.accent),
                      _Swatch('accentSubtle', theme.colors.accentSubtle),
                      _Swatch('success', theme.colors.success),
                      _Swatch('error', theme.colors.error),
                      _Swatch('warning', theme.colors.warning),
                      _Swatch('focusRing', theme.colors.focusRing),
                    ],
                  ),
                ],
              ),
              _Section(
                title: 'Icons',
                children: [
                  Wrap(
                    spacing: theme.spacing.lg,
                    runSpacing: theme.spacing.lg,
                    children: [
                      for (final glyph in AppIconGlyph.values)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppIcon(glyph, size: 32),
                            SizedBox(height: theme.spacing.xs),
                            Text(glyph.name, style: theme.textStyles.caption),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
              _Section(
                title: 'Buttons',
                children: [
                  Wrap(
                    spacing: theme.spacing.sm,
                    runSpacing: theme.spacing.sm,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      PrimaryButton(label: 'Primary', onPressed: () {}),
                      PrimaryButton(
                        label: 'With icon',
                        icon: AppIconGlyph.play,
                        onPressed: () {},
                      ),
                      const PrimaryButton(label: 'Disabled'),
                      SecondaryButton(label: 'Secondary', onPressed: () {}),
                      SecondaryButton(
                        label: 'With icon',
                        icon: AppIconGlyph.chevronLeft,
                        onPressed: () {},
                      ),
                      const SecondaryButton(label: 'Disabled'),
                      AppIconButton(
                        glyph: AppIconGlyph.settings,
                        semanticsLabel: 'Settings',
                        onPressed: () {},
                      ),
                      const AppIconButton(
                        glyph: AppIconGlyph.settings,
                        semanticsLabel: 'Settings (disabled)',
                      ),
                    ],
                  ),
                  SizedBox(height: theme.spacing.md),
                  PrimaryButton(
                    label: 'Expanded primary',
                    expand: true,
                    onPressed: () {},
                  ),
                ],
              ),
              _Section(
                title: 'Answer option tiles',
                children: [
                  for (var i = 1; i <= 4; i++) ...[
                    AnswerOptionTile(
                      index: i,
                      label: 'Interactive option $i',
                      state: i == _selectedOption
                          ? AnswerOptionState.selected
                          : AnswerOptionState.idle,
                      onPressed: () => setState(() => _selectedOption = i),
                    ),
                    SizedBox(height: theme.spacing.sm),
                  ],
                  const AnswerOptionTile(
                    index: 5,
                    label: 'Correct answer',
                    state: AnswerOptionState.correct,
                  ),
                  SizedBox(height: theme.spacing.sm),
                  const AnswerOptionTile(
                    index: 6,
                    label: 'Wrong answer',
                    state: AnswerOptionState.wrong,
                  ),
                  SizedBox(height: theme.spacing.sm),
                  const AnswerOptionTile(
                    label: 'Disabled, no index',
                    state: AnswerOptionState.disabled,
                  ),
                ],
              ),
              _Section(
                title: 'Countdown timer bar',
                children: [
                  CountdownTimerBar(
                    remaining: _remaining,
                    total: const Duration(minutes: 1),
                  ),
                  SizedBox(height: theme.spacing.md),
                  const CountdownTimerBar(
                    remaining: Duration(seconds: 9),
                    total: Duration(minutes: 1),
                  ),
                  SizedBox(height: theme.spacing.md),
                  const CountdownTimerBar(
                    remaining: Duration(minutes: 12, seconds: 5),
                    total: Duration(minutes: 20),
                    showLabel: false,
                  ),
                  SizedBox(height: theme.spacing.md),
                  Wrap(
                    spacing: theme.spacing.sm,
                    children: [
                      SecondaryButton(
                        label: '-10 s',
                        onPressed: () => setState(() {
                          _remaining -= const Duration(seconds: 10);
                          if (_remaining.isNegative) _remaining = Duration.zero;
                        }),
                      ),
                      SecondaryButton(
                        label: 'Reset',
                        onPressed: () => setState(
                          () => _remaining = const Duration(seconds: 42),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              _Section(
                title: 'Progress dots',
                children: [
                  ProgressDots(current: _step, total: 10),
                  SizedBox(height: theme.spacing.md),
                  const ProgressDots(current: 17, total: 40),
                  SizedBox(height: theme.spacing.md),
                  Wrap(
                    spacing: theme.spacing.sm,
                    children: [
                      SecondaryButton(
                        label: 'Previous',
                        icon: AppIconGlyph.chevronLeft,
                        onPressed: _step > 1
                            ? () => setState(() => _step--)
                            : null,
                      ),
                      SecondaryButton(
                        label: 'Next',
                        icon: AppIconGlyph.chevronRight,
                        onPressed: _step < 10
                            ? () => setState(() => _step++)
                            : null,
                      ),
                    ],
                  ),
                ],
              ),
              _Section(
                title: 'Score cards',
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(
                        child: ScoreCard(
                          title: 'Accuracy',
                          value: '87 %',
                          subtitle: 'Last 7 days',
                          delta: 3.5,
                          deltaSuffix: '%',
                        ),
                      ),
                      SizedBox(width: theme.spacing.md),
                      const Expanded(
                        child: ScoreCard(
                          title: 'Mental arithmetic',
                          value: '12/20',
                          subtitle: 'Best 15/20',
                          delta: -2,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: theme.spacing.md),
                  const ScoreCard(title: 'Streak', value: '6 days', delta: 0),
                ],
              ),
              _Section(
                title: 'Section header & card',
                children: [
                  SectionHeader(
                    title: 'Recent sessions',
                    subtitle: 'Practice and exams',
                    trailing: SecondaryButton(
                      label: 'See all',
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(height: theme.spacing.md),
                  const AppCard(child: Text('A static card with some text.')),
                  SizedBox(height: theme.spacing.md),
                  AppCard(
                    semanticsLabel: 'Tappable card',
                    onPressed: () {},
                    child: Row(
                      children: [
                        const AppIcon(AppIconGlyph.book),
                        SizedBox(width: theme.spacing.md),
                        const Expanded(
                          child: Text('A tappable card (hover, press, focus).'),
                        ),
                        const AppIcon(AppIconGlyph.chevronRight),
                      ],
                    ),
                  ),
                ],
              ),
              _Section(
                title: 'Keypad',
                children: [
                  for (final row in const [
                    ['7', '8', '9'],
                    ['4', '5', '6'],
                    ['1', '2', '3'],
                  ]) ...[
                    Row(
                      children: [
                        for (final key in row) ...[
                          Expanded(
                            child: AppKeypadButton(
                              label: key,
                              onPressed: () {},
                            ),
                          ),
                          if (key != row.last)
                            SizedBox(width: theme.spacing.sm),
                        ],
                      ],
                    ),
                    SizedBox(height: theme.spacing.sm),
                  ],
                  Row(
                    children: [
                      Expanded(
                        child: AppKeypadButton(
                          label: '⌫',
                          icon: AppIconGlyph.cross,
                          semanticsLabel: 'Delete',
                          onPressed: () {},
                        ),
                      ),
                      SizedBox(width: theme.spacing.sm),
                      Expanded(
                        child: AppKeypadButton(label: '0', onPressed: () {}),
                      ),
                      SizedBox(width: theme.spacing.sm),
                      Expanded(
                        child: AppKeypadButton(
                          label: 'OK',
                          icon: AppIconGlyph.check,
                          semanticsLabel: 'Validate',
                          emphasized: true,
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: theme.spacing.sm),
                  const Row(
                    children: [
                      Expanded(child: AppKeypadButton(label: 'Disabled')),
                    ],
                  ),
                ],
              ),
              _Section(
                title: 'Charts',
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ArcGauge(
                        value: 0.62,
                        size: 140,
                        color: theme.colors.warning,
                        semanticsLabel: 'Readiness',
                        semanticsValue: '62 out of 100',
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('62', style: theme.textStyles.display),
                              Text('/ 100', style: theme.textStyles.caption),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: theme.spacing.lg),
                      Expanded(
                        child: HorizontalBarChart(
                          semanticsLabel: 'Levels',
                          entries: [
                            BarChartEntry(
                              label: 'Arithmetic',
                              value: 0.8,
                              valueLabel: 'level 4 / 5',
                              color: theme.colors.success,
                            ),
                            BarChartEntry(
                              label: 'English',
                              value: 0.4,
                              valueLabel: 'level 2 / 5',
                              color: theme.colors.error,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: theme.spacing.lg),
                  const RadarChart(
                    semanticsLabel: 'Levels',
                    maxSize: 280,
                    axes: [
                      RadarChartAxis(label: 'Arithmetic', value: 1),
                      RadarChartAxis(label: 'Dominoes', value: 0.5),
                      RadarChartAxis(label: 'N-back', value: 0.25),
                      RadarChartAxis(label: 'Rules', value: 0.75),
                      RadarChartAxis(label: 'English', value: 0),
                    ],
                  ),
                ],
              ),
              _Section(
                title: 'Tab bar',
                children: [
                  AppTabBar(
                    items: _tabs,
                    selectedIndex: _selectedTab,
                    onSelected: (i) => setState(() => _selectedTab = i),
                  ),
                  SizedBox(height: theme.spacing.md),
                  SizedBox(
                    height: 360,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AppTabBar(
                          items: _tabs,
                          selectedIndex: _selectedTab,
                          layout: AppTabBarLayout.rail,
                          onSelected: (i) => setState(() => _selectedTab = i),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: theme.spacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: theme.spacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionHeader(title: title),
          SizedBox(height: theme.spacing.md),
          ...children,
        ],
      ),
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch(this.name, this.color);

  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 56,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: theme.radii.smAll,
            border: Border.all(color: theme.colors.borderStrong),
          ),
        ),
        SizedBox(height: theme.spacing.xs),
        Text(name, style: theme.textStyles.caption),
      ],
    );
  }
}
