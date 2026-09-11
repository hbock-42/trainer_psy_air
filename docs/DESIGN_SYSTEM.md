# Design system

Calm, high-contrast, aviation-inspired UI built on `package:flutter/widgets.dart` only.
No Material, no Cupertino (enforced by `test/architecture/no_material_cupertino_test.dart`).

- Tokens: `lib/core/theme/` (`AppTheme`, `AppColors`, `AppTextStyles`, `AppSpacing`, `AppRadii`,
  `AppDurations`)
- Widgets: `lib/shared/widgets/` (import the barrel `widgets.dart`)
- Gallery: `lib/shared/gallery/widget_gallery_screen.dart` (debug only)
- Test helpers: `test/helpers/pump_app.dart`, `test/helpers/visuals.dart`

## Using the theme

```dart
final theme = AppTheme.of(context);          // asserts an AppThemeScope ancestor
theme.colors.accent; theme.textStyles.title; theme.spacing.lg; theme.radii.mdAll;
```

`AppThemeScope` is an `InheritedWidget` that also installs `DefaultTextStyle` (body) so plain
`Text` renders correctly under `WidgetsApp`. Wrap the app once, in the root `builder`:

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
| `AppScaffold` | page frame | background + `SafeArea` + optional `AppTopBar` (title, back chevron, actions) + body; no bottom nav (US-005) |
| `AppTopBar` | header row used by `AppScaffold` | reusable in custom layouts |
| `AppIcon` | vector glyph painted with `CustomPaint` | `AppIconGlyph.check, cross, chevronLeft, chevronRight, clock, play, pause, settings, chart, book, target`; follows the text colour; decorative unless `semanticsLabel` is given |

## Gallery

`WidgetGalleryScreen` shows every widget in every state with light/dark and 1.0x/1.3x toggles.
It is compiled in when `kWidgetGalleryEnabled` is true: debug builds, or any build run with
`--dart-define=GALLERY=true`. Register it in the router (US-002) under `widgetGalleryRoutePath`:

```dart
if (kWidgetGalleryEnabled)
  GoRoute(path: widgetGalleryRoutePath, builder: (_, _) => const WidgetGalleryScreen()),
```

The screen brings its own `AppThemeScope`, so it works from any route.

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
