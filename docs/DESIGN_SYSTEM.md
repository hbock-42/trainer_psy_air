# Design system

Calm, high-contrast, aviation-inspired UI built on `package:flutter/widgets.dart` only.
No Material, no Cupertino (enforced by `test/architecture/no_material_cupertino_test.dart`).

- Tokens: `lib/core/theme/` (`AppTheme`, `AppColors`, `AppTextStyles`, `AppSpacing`, `AppRadii`,
  `AppDurations`)
- Charts: no chart package (`fl_chart` needs Material); `ArcGauge`, `RadarChart`,
  `HorizontalBarChart` and `LineChart` are `CustomPaint` primitives in the catalogue below
- Widgets: `lib/shared/widgets/` (import the barrel `widgets.dart`)
- Gallery: `lib/shared/gallery/widget_gallery_screen.dart` (debug only)
- Test helpers: `test/helpers/pump_app.dart`, `test/helpers/visuals.dart`

## Using the theme

```dart
final theme = AppTheme.of(context);          // asserts an AppThemeScope ancestor
theme.colors.accent; theme.textStyles.title; theme.spacing.lg; theme.radii.mdAll;
```

`AppThemeScope` is an `InheritedWidget` that also installs `DefaultTextStyle` (body) so plain
`Text` renders correctly under `WidgetsApp`. The app wraps itself once, in the root `builder` of
`lib/app.dart` (light or dark follows the platform brightness until US-091 adds a setting):

```dart
WidgetsApp(
  builder: (context, child) => AppThemeScope(
    theme: AppTheme.forBrightness(MediaQuery.platformBrightnessOf(context)),
    child: ColoredBox(color: ..., child: child!),
  ),
)
```

Dependents rebuild when the theme instance changes (light/dark switch). There is no
`ThemeData`, no `Theme.of`, no `IconTheme` from Material.

## Tokens

### Colours (`AppColors.light` / `AppColors.dark`)

| Token | Use |
|---|---|
| `background` | page ground (off-white / near-black blue) |
| `surface`, `surfaceRaised` | cards, tiles, keys; raised = hover tint |
| `border`, `borderStrong` | hairlines; strong = must stay visible (outlines, idle tiles on hover) |
| `textPrimary`, `textSecondary`, `textMuted` | deep blue / off-white text hierarchy |
| `accent`, `onAccent`, `accentSubtle` | the single accent (amber): primary action, selection, progress |
| `success`, `error`, `warning` (+ `on*`, `*Subtle`) | semantic states: correct / wrong / running out of time |
| `focusRing` | keyboard focus outline |
| `scrim` | overlay behind sheets and dialogs |

`x` is a fill, `onX` the foreground on that fill, `xSubtle` a low-contrast tint for backgrounds.
Never hard-code a `Color` in a widget or a feature; add a token if one is missing.

### Typography (`AppTextStyles`, platform font, no bundled font)

| Style | Size / weight | Use |
|---|---|---|
| `display` | 48 / 700, tabular figures | score values, exam countdown |
| `headline` | 28 / 700 | screen titles |
| `title` | 20 / 600 | section and card titles, top bar |
| `body` | 16 / 400 | default reading text (installed as `DefaultTextStyle`) |
| `bodyStrong` | 16 / 600 | answer options, button labels |
| `label` | 14 / 600 | badges, tabs, uppercase card titles |
| `caption` | 12 / 400, secondary colour | helper text |
| `numeric` | 22 / 600, tabular figures | keypad, timers, inline numbers |

Sizes are unscaled; `Text` applies `MediaQuery.textScaler`. Every layout must survive 1.3x
(tests pump at `textScale: 1.3` and assert no overflow).

### Spacing, radii, motion

- `AppSpacing`: `xs 4`, `sm 8`, `md 12`, `lg 16`, `xl 24`, `xxl 32`, `minTouchTarget 48`
- `AppRadii`: `sm 6` (badges, bars), `md 10` (buttons, tiles, keys), `lg 16` (cards), `full`
  (pills, dots); `*All` getters return a `BorderRadius`
- `AppDurations`: `fast 90 ms` (press, hover), `normal 180 ms` (state colours), `slow 320 ms`
  (page transitions, progress)

## Widget catalogue

Every interactive widget has idle / hover / focus / pressed / disabled visuals, a 48x48 minimum
hit target and a `Semantics` node (button flag, label, enabled/selected state). Disabled means
`onPressed == null`.

| Widget | Purpose | Notes |
|---|---|---|
| `AppPressable` | interaction primitive: gestures, hover/focus (`FocusableActionDetector`), Enter/Space activation, min hit target, semantics | you decide the look in `builder(context, PressableState)`; `AppFocusRing` draws the focus outline |
| `PrimaryButton` | the one main action of a screen | accent fill; `icon`, `expand` |
| `SecondaryButton` | neutral / secondary action | outlined; `icon`, `expand` |
| `AppIconButton` | square icon-only control (top bar) | `semanticsLabel` required |
| `AnswerOptionTile` | MCQ answer | `AnswerOptionState.idle/selected/correct/wrong/disabled`; optional `index` 1..6 badge; `child` replaces the text while `label` stays the semantics; only idle/selected accept taps |
| `AppKeypadButton` | numeric keypad key (US-022) | `label` or `icon`, `emphasized` for validate, 56 min size, stretches to parent width |
| `CountdownTimerBar` | time left | pure presentational (`remaining`, `total`); accent fill, error colour under 20 %; `m:ss` label; announces "Time remaining, m:ss of m:ss" |
| `ProgressDots` | position in a sequence | `current` 1-based; segmented bar above `maxDots` (20) |
| `ScoreCard` | headline figure | `title`, `value`, `subtitle`, `delta` (+green / -red / 0 muted) + `deltaSuffix` |
| `SectionHeader` | title of a content group | `subtitle`, `trailing`; semantics header |
| `AppCard` | bordered surface | tappable when `onPressed` is set (then `semanticsLabel` is required) |
| `AppScaffold` | page frame | background + `SafeArea` + optional `AppTopBar` (title, back chevron, actions) + body; no bottom nav (the tab shell owns it) |
| `AppTopBar` | header row used by `AppScaffold` | reusable in custom layouts |
| `AppTabBar` | main navigation (the shell's five tabs) | `items` (`AppTabItem` glyph + label), `selectedIndex`, `onSelected` (also fired on the active tab, so the shell can pop it to root); `layout: bottom` (row, phones) or `rail` (left column, windows >= `railBreakpoint` 900 dp); handles the safe-area inset on its own edge; each tab is an `AppPressable` with selected flag and label; bottom labels use the caption size so five fit on a phone, rail labels use `label` |
| `ArcGauge` | one 0..1 figure as a 270° arc (readiness score) | `value`, `color` (pass a semantic band: `success` / `warning` / `error`), `size`, `child` centred inside the arc (the formatted value); `semanticsLabel` + `semanticsValue` required, the painting is excluded from semantics |
| `RadarChart` | 3+ values on spokes (family levels in real-test order) | `axes` (`RadarChartAxis(label, value 0..1, valueLabel?)`), `rings`, `maxSize`; square, fills the width up to `maxSize`; accent polygon on grey rings, labels painted around; one semantics node whose value is `RadarChart.describe(axes)` (`label : valueLabel`, ...) |
| `HorizontalBarChart` | 1+ values as horizontal bars, the fallback of `RadarChart` below 3 axes | `entries` (`BarChartEntry(label, value 0..1, valueLabel?, color?)`), `barHeight`; label and value are text (they wrap at 1.3x), the bar is a `CustomPaint`; per-entry `color` for level bands; one semantics node, `HorizontalBarChart.describe(entries)` |
| `LineChart` | one or more series over time (accuracy / speed per session, exam scores) | `series` (`LineChartSeries(label, points: [LineChartPoint(x, y)], color?)`, `x` ascending), `yMin` / `yMax` (null fits the data with 10 % headroom), `xTicks` / `yTicks` (`LineChartTick(value, label)`, `LineChart.evenTicks(...)` helper; `y` ticks draw gridlines), `height`, `showPoints`; hover (`MouseRegion`) or press (`Listener`) snaps to the nearest `x` and shows a tooltip (`tooltipBuilder(context, LineChartHit)`, default: `x` then `label : y` with `formatX` / `formatY`) plus a dashed guide; a release calls `onPointSelected(hit)`; `selectedX` paints a persistent guide and ring; colours: accent then `success` / `warning` / `error` per series (`LineChart.defaultColor`); range / mode selectors stay outside; `LineChartScale` is the pure pixel mapping (unit-tested); one semantics node, `semanticsLabel` + caller-written `semanticsValue` ("accuracy from 40 % to 70 % over 6 sessions"), painting and tooltip excluded |
| `AppIcon` | vector glyph painted with `CustomPaint` | `AppIconGlyph.check, cross, chevronLeft, chevronRight, clock, play, pause, settings, chart, book, target`; follows the text colour; decorative unless `semanticsLabel` is given |
| `MarkdownView` | renders lesson markdown (US-041) with our own widgets — no `flutter_markdown` (Material-only) | `MarkdownView(markdown)` parses (and caches, `parseMarkdown`) then renders; `MarkdownView.blocks(blocks)` renders pre-parsed blocks (e.g. shared with a table of contents, see `extractHeadings`); headings, paragraphs (bold/italic/inline code/links), ordered/unordered lists, tables (`Table` in a horizontal `SingleChildScrollView`), fenced code, thematic breaks, an alt-text placeholder for images; blockquotes render as a quote bar, or, when the first line is `[!TIP]` / `[!TRAP]` / `[!METHOD]` / `[!EXAMPLE]`, a coloured callout box with an `AppIcon` (marker stripped); a `## Exemple guidé n` section (statement + `### Étape n` steps) renders as `RevealSteps` (US-043) |
| `RevealSteps` | worked-example steps revealed one at a time | `title`, `statement` (always visible), `steps` (`RevealStepData(title, content)`); "Étape suivante" reveals the next one, "Tout afficher" (hidden once only one step remains) reveals the rest |

## Gallery

`WidgetGalleryScreen` shows every widget in every state with light/dark and 1.0x/1.3x toggles.
It is compiled in when `kWidgetGalleryEnabled` is true: debug builds, or any build run with
`--dart-define=GALLERY=true`. Register it in the router (US-002) under `widgetGalleryRoutePath`:

```dart
if (kWidgetGalleryEnabled)
  GoRoute(path: widgetGalleryRoutePath, builder: (_, _) => const WidgetGalleryScreen()),
```

The screen brings its own `AppThemeScope`, so it works from any route.

## Strings

No literal copy in widgets or screens: user-facing text comes from `AppStrings`
(`lib/core/l10n/strings.dart`, French only). US-091 replaces it with ARB localisation; keeping
every string there today makes that migration a rename.

## Testing widgets

```dart
await tester.pumpApp(widget, theme: AppTheme.dark(), textScale: 1.3, align: false);
final gesture = await tester.hover(find.byType(PrimaryButton));
tester.backgroundOf(finder); tester.borderColorOf(finder); tester.focusRingVisible(finder);
```

`pumpApp` reproduces the app root (`WidgetsApp` + `AppThemeScope`) and forces
`FocusHighlightStrategy.alwaysTraditional`, because the test platform is Android where Flutter
hides hover and focus highlights until a key event arrives. Semantics assertions need
`tester.ensureSemantics()`. Golden tests are not used (font rendering differs across machines).

## Adding a widget

1. One public widget per file in `lib/shared/widgets/<name>.dart`, exported from `widgets.dart`.
2. Read every colour, size and duration from `AppTheme.of(context)`; no literals.
3. Interactive? Build on `AppPressable` and cover all five states in the builder; wrap in
   `AppFocusRing`; pass a `semanticsLabel` (and `excludeSemantics: true` when the label already
   says everything). Keep `onPressed == null` as the disabled contract.
4. Presentational? Give it a `Semantics` node with `label`/`value` and `ExcludeSemantics` the
   decorative parts.
5. Let text wrap or ellipsise; never fix heights on text containers (1.3x scaling).
6. Add it to `WidgetGalleryScreen` and write `test/shared/widgets/<name>_test.dart`: states,
   callbacks, semantics, 1.3x without overflow.
7. Document it in the catalogue above.

## Do / don't

- Do use `GestureDetector`, `Listener`, `FocusableActionDetector`, `DecoratedBox`,
  `AnimatedContainer`, `CustomPaint`, `Semantics`, `SafeArea`, `ListView`, `Navigator`, `Overlay`.
- Do use `AppIcon` for icons; add a glyph to `AppIconGlyph` rather than an icon font.
- Do keep widgets presentational: timers, scoring and state machines live in the feature's
  domain/presentation layer, the widget only receives values and reports taps.
- Don't import `package:flutter/material.dart` or `cupertino.dart` (the architecture test fails).
  No `Scaffold`, `AppBar`, `ThemeData`, `Icons`, `InkWell`, `TextButton`, `Dialog`, `SnackBar`.
- Don't pull a package whose widgets need a Material ancestor.
- Don't hard-code colours, font sizes or paddings; don't add a second accent colour.
- Don't put navigation logic in a widget (`AppScaffold.onBack` is a callback for that reason).
