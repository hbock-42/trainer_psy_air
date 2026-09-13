---
name: design-system
description: Use or add a widget, theme token, chart or gallery entry in the app's Material-free design system — use for any UI/widget work in apps/psy_trainer/lib/shared.
---

# Design system

Calm, high-contrast, aviation-inspired UI on `package:flutter/widgets.dart` **only**. No
Material, no Cupertino — enforced by
`apps/psy_trainer/test/architecture/no_material_cupertino_test.dart`, which fails on any such
import under `lib/` (including `show`/`hide`/`as` forms). Third-party widgets needing a
Material ancestor are not allowed; write it yourself.

- Tokens: `apps/psy_trainer/lib/core/theme/` (`AppTheme`, `AppColors`, `AppTextStyles`,
  `AppSpacing`, `AppRadii`, `AppDurations`)
- Widgets: `apps/psy_trainer/lib/shared/widgets/` (import the barrel `widgets.dart`)
- Charts: no chart package (`fl_chart` needs Material) — `ArcGauge`, `RadarChart`,
  `HorizontalBarChart`, `LineChart` are `CustomPaint` primitives, listed below
- Gallery: `lib/shared/gallery/widget_gallery_screen.dart` (debug-only, or
  `--dart-define=GALLERY=true`)
- Test helpers: `test/helpers/pump_app.dart`, `test/helpers/visuals.dart`

## Using the theme

```dart
final theme = AppTheme.of(context);   // asserts an AppThemeScope ancestor
theme.colors.accent; theme.textStyles.title; theme.spacing.lg; theme.radii.mdAll;
```

There is no `ThemeData`/`Theme.of`. `AppThemeScope` (an `InheritedWidget`, installed once in
`lib/app.dart`'s root `WidgetsApp` builder) also carries `DefaultTextStyle` — anything pushed
outside the app's own navigator (a raw overlay) must sit under that builder too.

## Tokens

- **Colours** (`AppColors.light`/`.dark`): `background`, `surface`/`surfaceRaised`,
  `border`/`borderStrong`, `textPrimary`/`textSecondary`/`textMuted`,
  `accent`/`onAccent`/`accentSubtle` (the single accent, amber), `success`/`error`/`warning`
  (+ `on*`/`*Subtle`), `focusRing`, `scrim`. `x` = a fill, `onX` = foreground on that fill,
  `xSubtle` = low-contrast tint. Never hard-code a `Color`; add a token if one is missing.
- **Typography** (`AppTextStyles`, platform font, no bundled font): `display` 48/700 (scores,
  countdown), `headline` 28/700 (screen titles), `title` 20/600 (section/card titles),
  `body` 16/400 (default, installed as `DefaultTextStyle`), `bodyStrong` 16/600 (answers,
  buttons), `label` 14/600 (badges, tabs), `caption` 12/400 (helper text), `numeric` 22/600
  tabular (keypad, timers). Unscaled sizes; every layout must survive 1.3x text scale.
- **Spacing** (`AppSpacing`): `xs 4`, `sm 8`, `md 12`, `lg 16`, `xl 24`, `xxl 32`,
  `minTouchTarget 48`.
- **Radii** (`AppRadii`): `sm 6` (badges/bars), `md 10` (buttons/tiles/keys), `lg 16` (cards),
  `full` (pills/dots); `*All` getters return a `BorderRadius`.
- **Durations** (`AppDurations`): `fast 90ms` (press/hover), `normal 180ms` (state colours),
  `slow 320ms` (transitions, progress).

## Widget catalogue

Every interactive widget: idle/hover/focus/pressed/disabled visuals, a 48x48 minimum hit
target, a `Semantics` node. Disabled means `onPressed == null`.

| Widget | Purpose |
|---|---|
| `AppPressable` | interaction primitive (gestures, hover/focus, Enter/Space, hit target, semantics) — build custom controls on this |
| `PrimaryButton` / `SecondaryButton` | the one main action / a neutral action |
| `AppIconButton` | square icon-only control |
| `AnswerOptionTile` | MCQ answer, states `idle/selected/correct/wrong/disabled` |
| `AppKeypadButton` | numeric keypad key |
| `CountdownTimerBar` | time-left bar (presentational: `remaining`, `total`) |
| `ProgressDots` | position in a sequence |
| `ScoreCard` | headline figure + delta |
| `SectionHeader`, `AppCard`, `AppScaffold`, `AppTopBar`, `AppTabBar` | layout/chrome primitives |
| `ArcGauge` | one 0..1 value as a 270° arc (readiness) |
| `RadarChart` | 3+ values on spokes; falls back to `HorizontalBarChart` below 3 axes |
| `LineChart` | series over time, hover/press tooltip, `LineChartScale` (pure, unit-tested) |
| `AppIcon` | vector glyph, `AppIconGlyph` enum — add a glyph rather than an icon font |
| `MarkdownView` | our own lesson-markdown renderer (no `flutter_markdown`, Material-only) |
| `RevealSteps` | worked-example steps revealed one at a time |

Full field-by-field spec of every widget: `docs/DESIGN_SYSTEM.md` "Widget catalogue" (keep
consulting it for exact constructor parameters — this skill only orients you to what exists).

## Adding a widget

1. One public widget per file, `lib/shared/widgets/<name>.dart`, exported from `widgets.dart`.
2. Read every colour/size/duration from `AppTheme.of(context)` — no literals.
3. Interactive: build on `AppPressable`, cover all five states, wrap in `AppFocusRing`, pass
   `semanticsLabel` (+ `excludeSemantics: true` when it already says everything). Disabled
   contract stays `onPressed == null`.
4. Presentational: a `Semantics` node with `label`/`value`, `ExcludeSemantics` the decorative
   parts.
5. Let text wrap/ellipsise; never fix heights on text containers (1.3x scaling).
6. Add it to `WidgetGalleryScreen` and write
   `test/shared/widgets/<name>_test.dart`: states, callbacks, semantics, 1.3x-without-overflow.

## Do / don't

- Do: `GestureDetector`, `Listener`, `FocusableActionDetector`, `DecoratedBox`,
  `AnimatedContainer`, `CustomPaint`, `Semantics`, `SafeArea`, `ListView`, `Navigator`,
  `Overlay`; `EditableText` directly for text input (never `TextField`).
- Don't: `material.dart`/`cupertino.dart` imports (architecture test fails), a package whose
  widgets need a Material ancestor, hard-coded colours/sizes, a second accent colour,
  navigation logic inside a widget.

## Testing widgets

```dart
await tester.pumpApp(widget, theme: AppTheme.dark(), textScale: 1.3, align: false);
final gesture = await tester.hover(find.byType(PrimaryButton));
tester.backgroundOf(finder); tester.borderColorOf(finder); tester.focusRingVisible(finder);
```

`pumpApp` reproduces the app root and forces `FocusHighlightStrategy.alwaysTraditional` (the
test platform hides hover/focus highlights otherwise). Semantics assertions need
`tester.ensureSemantics()`. No goldens for widgets (font rendering differs across machines —
goldens are reserved for whole screens, see `docs/TESTING.md` "Goldens"). Every top-level
screen also needs an accessibility-guideline test and a 360dp/1.3x overflow test — see
`docs/TESTING.md` for both templates; that procedure is test-pyramid concern, not design
system, so it stays there.
