# CHANGELOG

## [1.0.0] - 2026-10-30

### Added

- Phone date picking:
  - `WeDateWheel`: year / month / day wheels (`WeDateWheelType.month`
    drops the day). Out-of-range values are left out, disabled days are
    grey and skipped when the wheel stops, Jan 31 turned to February lands
    on the last day of February. Columns follow `locale` (Y M D in
    Chinese, M D Y in English); ↑ / ↓ turn the focused column and screen
    readers can adjust each column.
  - `WeDateSheet.show` and `WeDateSheet.showRange`: a bottom sheet with
    Cancel · title · OK, optional shortcut chips, and a start / end switch
    in range mode (a backwards range is swapped on OK). At most 640 wide,
    keeps clear of the bottom safe area, scrolls when the screen is short.
  - `WeDateLocale` gains `confirm`, `cancel`, `daySuffix`, `start` and
    `end`.
- `WeTabbar` / `WeTabbarItem`: the bottom tab bar of a phone app, with
  equal-width items, `activeIcon`, a count `badge` (`99+`) or a `dot`,
  `onReselect` for tapping the selected item again, the bottom safe area,
  and items announced as selectable buttons with their position.
- Platform awareness:
  - `WePlatform.isTouch(context)` reads `Theme.of(context).platform`
    (Android, iOS and Fuchsia count as touch), so a local `Theme` can
    simulate a phone and mobile browsers are treated as touch.
  - `WeInteraction` (`auto`, `pointer`, `touch`) on `WeTheme` forces one
    mode or the other.
  - `WePlatformFit` (`universal`, `desktop`, `mobile`) labels which
    platform a component suits, with a Chinese label and an icon.
  - `WeSizeScheme.touch()`: 48 / 44 / 36 controls and 32 / 28 / 24 compact
    parts, with larger text and padding.
  - In debug builds, `WeMenu`, `WeTable`, `WePagination`, `WeCalendar`,
    `WeDatePanel`, `WeCascader` and `WinStyleDialog` print a one-time hint
    with a suggested replacement when used on touch. Turn it off with
    `WePlatform.debugHints = false`.
- `WeTooltip.touchDuration`: how long a long-press tooltip stays up.
- `WeNotification`, after `el-notification`: titled cards that stack in
  any of the four corners, return a `WeNotificationHandle`, and share
  `closeAll`. `Duration.zero` keeps a card until it is closed. Hovering a
  card holds it; leaving starts the countdown again.
- `WeLoading`, after `v-loading`: a region mask (`loading`, `text`,
  `spinner`, `lock`) that fades in and out and keeps no ticker running while
  idle, and `WeLoading.service` for a fullscreen overlay that is not a
  route, so it neither collides with dialogs nor eats the back button.
  Closing its `WeLoadingHandle` twice is harmless.
- `WeTable.loading` keeps the rows on screen and lays a `WeLoading` mask
  over them when there is data, and shows skeleton rows only when the
  table is empty. `loadingText` labels the mask.
- `WeSlider` and `WeSlider.range`, after `el-slider`: `step`, `showStops`,
  `marks`, `showTooltip`, `showInput` (a `CounterInput` on the side),
  `vertical`, and `WeFormItem` integration.
- `WePageHeader`, after `el-page-header`: title, description, back, tag,
  actions, breadcrumb.
- `WeCollapse` / `WeCollapseItem`, after `el-collapse`: `accordion`, an
  `extra` slot at the right of each header, `disabled`, `titleBuilder`,
  animated open and close. Headers take focus and toggle on Enter or
  Space, and a closed panel's content is left out of the Tab order.
- `WeImage`, after `el-image`: network, bytes or any `ImageProvider`, a
  placeholder while loading and a fallback on error. `preview` opens
  `WeImageViewer`; `previewList` with `initialIndex` opens a gallery on
  the tapped image.
- `WeImageViewer`, after `el-image-viewer`, works with a mouse and a
  keyboard as well as touch: side arrows or ← / → to page, a toolbar to
  zoom out, zoom in, reset and rotate either way, the wheel or + / - to
  zoom (0.2× to 8×), 0 to reset, Esc to close. Zoom and rotation reset
  when the page changes.
- `WeCarousel`: autoplay, arrows, indicators, optional `card` type.
- `WeTree` and `WeTreeNode`, after `el-tree`:
  - `showCheckbox` links parents and children: checking a parent checks
    its enabled descendants, a partly checked parent shows the
    indeterminate box, and `onCheck` reports every fully checked node.
    Disabled children keep their state, and a parent whose enabled
    children are all checked unchecks on the next click. `checkStrictly`
    turns the linking off.
  - `filter` keeps matches and their ancestors, opens them, and highlights
    the matched text; `filterMethod` replaces the match.
  - `lazyLoad` fetches children on first expand with a spinner in the row;
    `isLeaf` hides the arrow.
  - `accordion`, `defaultExpandAll`, `defaultExpanded`,
    `expandOnClickNode`, guide lines, `nodeBuilder`, and the keyboard:
    ↑ / ↓ / Home / End move, → opens or steps in, ← closes or steps out,
    Enter selects, Space checks.
  - `WeTree.toggleChecked` and `WeTree.find` apply the same rules outside
    the widget.
- `WeTreeSelect` and `WeTreeSelect.multiple`, after `el-tree-select`: a
  tree in a dropdown. Single choice picks leaves (any node with
  `checkStrictly`); multiple choice shows one tag per topmost checked node
  and folds the rest into `+N` with `collapseTags`. `filterable`,
  `clearable`, `prefixIcon`, Arrow Down into the tree, Backspace to drop
  the last tag, and `WeFormItem` size, status and disabled state.
- `WeFieldBox`, the trigger box shared by `WeSelect`, `WeCascader` and
  `WeTreeSelect`: border, focus glow, status colour, hover clear button
  and the turning arrow. Use it to build another select-like field that
  looks the same.
- `WeUpload`, after `el-upload`, with no native dependency: the app passes
  a `picker` and an `uploader(file, onProgress)`, and the widget does the
  rest.
  - `accept` (extensions or `image/*`), `maxSize`, `limit` with
    `onExceed`, `beforeUpload`, `beforeRemove`, and `onReject`, which
    defaults to a warning message.
  - Three list styles: `text`, `picture` with thumbnails, and a
    `pictureCard` wall whose "+" card hides at the limit. `drag` shows a
    large dashed area instead.
  - Progress per file, failed files that can be retried, image preview,
    and `autoUpload: false` with `WeUploadController.submit()`.
  - `WeUploadController` holds the files, accepts dropped files through
    `addFiles`, and `WeUploadFile.uploaded` seeds files already on the
    server. Inside a `WeFormItem` it follows the item's disabled state and
    triggers change validation.
  - `weFormatBytes` formats sizes such as `1.5 KB`.
- `WeSteps` and `WeStep`, after `el-steps`: horizontal, `alignCenter`,
  vertical and `simple` layouts; `wait` / `process` / `finish` / `error` /
  `success` states from `active`, `finishStatus` and `processStatus`, or
  set on a step; icons, descriptions, a fixed `space` and `onTap`.
- `WeCascader` and `WeCascaderOption`, after `el-cascader`: picks a path
  through a tree one column at a time; the value is the list of values from
  the root.
  - `checkStrictly` puts a radio on every row so any level can be picked;
    `expandTrigger: hover` opens columns on hover.
  - `filterable` searches every path and lists matches as `A / B / C`;
    `filterMethod` replaces the match.
  - `showAllLevels`, `separator`, `clearable`, disabled options, and the
    arrow keys: up and down within a column, right into children, left
    back out, Enter to pick. Inside a `WeFormItem` it takes the item's
    size, error state and disabled flag.
- Date components, shared by one locale table (`WeDateLocale.zh` /
  `WeDateLocale.en`, Monday first in Chinese):
  - `WeDatePicker` and `WeDatePicker.range`: type a date in any form
    (`2026-9-5`, `2026/09/05`, `20260905`) and it commits on Enter or blur,
    or pick in the panel. Arrow Down moves into the panel, `shortcuts` adds
    a side list of presets, and `firstDate` / `lastDate` / `disabledDate`
    limit the choice.
  - `WeDatePanel` and `WeDatePanel.range`, the inline panels behind the
    picker. Clicking the title zooms out to months and years; arrows,
    PageUp / PageDown (with Shift for years), Home / End and T move the
    cursor. The range panel shows two months and previews the band on
    hover.
  - `WeCalendar`, a month board after `el-calendar`: event bars per day,
    "还有 N 项" when they do not fit, dots on narrow cells, week numbers,
    `cellBuilder`, `headerTrailing`, and the same keyboard navigation.
  - `weFormatDate` and `weParseDate`.
- `WeBadge.radius`, for square badges in square layouts.
- `WePopper`, the floating-panel base after Element Plus's popper, with
  `WePlacement` (12 placements), `WePopperTrigger` (`hover` / `click` /
  `focus` / `manual`), `WePopperController` and `WePopperStyle`:
  - The panel follows its trigger through scrolling, flips to the opposite
    side when it does not fit, slides along the cross axis to stay on
    screen, and its optional arrow keeps pointing at the trigger.
  - It closes on a tap outside and on Escape. `WePopper.escapeHandled`
    tells dialogs that the Escape was already used, so one press closes
    only the topmost layer.
  - `WePopper.builder` hands a `toggle` callback to a button trigger.
- `WeTooltip` (`dark` / `light` effect), `WePopover` (title, text or any
  widget, click or hover) and `WePopconfirm`, whose confirm button spins
  while an async `onConfirm` runs and keeps the bubble open if it throws.
- `WeSelect.multiple`: values as tags, `collapseTags` with a `+N` tag (and
  `collapseTagsTooltip` listing the rest), `multipleLimit`, Backspace
  removes the last tag.
- `WeSelect` gained `filterable` with `filterMethod`, `remoteMethod`
  (debounced, with loading, no-data and no-match lines), `groups` of
  `WeSelectGroup`, and keyboard navigation: arrow keys move the highlight
  past disabled options, Enter picks, Escape closes.
- `WeForm`, `WeFormItem`, `WeRule` and `WeFormController`, after `el-form`:
  - `labelWidth`, `labelPosition` (`left` / `right` / `top`), `size`,
    `disabled`, `inline`, and a red asterisk for required items.
  - Rules check `required`, `min` / `max` (string length, number value or
    collection size), `pattern` and a `validator` that may be async; each
    runs on `change`, `blur` or only on `submit`.
  - `validate()` completes with a `bool` and scrolls to the topmost error;
    `validateField`, `resetFields` (through each item's `onReset`),
    `clearValidate`, `scrollToField` and `errorOf`.
  - `WeInput` and `WeSelect` inside an item turn red on error and inherit
    its `disabled` and `size`.
- `WeDrawer` and `WeDrawer.show`, after `el-drawer`: four directions,
  `size` as a screen fraction or in pixels, `withHeader`, footer `actions`,
  `resizable` by dragging the inner edge, and `beforeClose`, which can keep
  the drawer open when the mask, Escape, the close button or the back
  gesture would close it.
- `WeDialog`, a web-style modal after `el-dialog`, and `WeDialog.show` to
  open one:
  - **Draggable by the header**, which is what an in-page dialog was
    missing. It can be dragged almost off screen — a strip always stays
    inside so it can be dragged back — and a double click on the header
    snaps it home. Resizing the window pulls a stranded dialog back.
    `draggable: false` restores the plain centred modal.
  - Header with icon, title and close button; body that scrolls once it
    passes `maxHeightFactor` of the viewport; footer that lays out
    `actions` on the right. Every slot (`header`, `titleWidget`, `footer`)
    can be replaced.
  - `width`, `fullscreen`, `top` (distance from the top, like `el-dialog`),
    `modal`, `closeOnClickModal`, `closeOnEscape`, `dividers` and a custom
    `transitionBuilder`; the default transition is Element's fade-scale.
- `WeMessageBox`, the `ElMessageBox` trio, built on `WeDialog` and
  therefore draggable as well:
  - `alert` and `confirm` complete with a `bool`; `prompt` completes with
    the entered text, or `null` when cancelled, and keeps the confirm
    button disabled until `validator` passes.
- `WeDialogDragHandle`, `WeDialogDragScope` and `WeMovableDialog`, the
  pieces behind the dragging, so custom dialogs can opt in with one
  wrapper.
- A second wave of components closing the gap to Element Plus. All of them
  read every colour and dimension from `WeTheme` and are exported from the
  umbrella as well as from the new narrow barrels `navigation.dart`,
  `feedback.dart`, `form.dart` and `data.dart`:
  - **Buttons**: `WeButton` (`solid` / `plain` / `text` / `link` variants,
    `round`, `circle`, `loading`, `disabled`, `block`, icon-only via
    `WeButton.icon`) and `WeButtonGroup`.
  - **Navigation**: `WeMenu` (`WeMenuItem` / `WeSubMenu` / `WeMenuGroup`,
    collapsed mode with popups, controlled or auto-opening branches,
    badges), `WeBreadcrumb`, `WeDropdown`, `WeTabs` (`line` / `card` /
    `borderCard`) and `WeSegmented`.
  - **Basics**: `WeBadge`, `WeAvatar` / `WeAvatarGroup`, `WeLink`,
    `WeDivider` (captioned, dashed, vertical), `WeCard`, `WeStatistic` and
    `WeText`.
  - **Feedback**: `WeAlert` (`light` / `dark`), `WeEmpty`, `WeMessage`
    (top-centre stacking messages like `ElMessage`), `WeSkeleton` and
    `WeResult`.
  - **Form**: `WeInput` (prefix / suffix icons, clearable, password toggle,
    word limit, `prepend` / `append` slots), `WeSelect`, `WeCheckbox` /
    `WeCheckboxGroup` (indeterminate, `min` / `max`), `WeRadioGroup`
    (dot or button style), `WeSwitch` (inline prompt, `beforeChange`) and
    `WeRate` (half stars, texts).
  - **Data**: `WeTable` (typed `WeColumn`s, selection with indeterminate
    header, sorting, striped, bordered, hover, loading and empty states,
    fixed header with `maxHeight`, footer slot), `WePagination` (ellipsis
    collapsing, page-size picker, jumper, total), `WeDescriptions`
    (bordered or plain, `span`), `WeTimeline` and `WeProgress` (`line` /
    `circle` / `dashboard`, status colours, colour stops, striped,
    indeterminate).
- `WeCaptcha`, a rewritten slide-to-fit puzzle captcha, plus
  `WeCaptchaController` (`refresh`, `reset`, `status`, `solved`) and
  `WeCaptchaStatus`. It replaces the old `SlidingCaptcha`:
  - Takes any `ImageProvider` (`WeCaptcha.network` / `WeCaptcha.asset` for
    the common cases) and falls back to a seeded generated pattern when no
    image is given or the download fails, so it works offline and in tests.
  - The gap and the piece share one jigsaw `Path`, so the cut-out and the
    piece always line up; both are painted from a single decoded frame
    instead of downloading the image twice.
  - Sizes itself from the incoming constraints rather than
    `MediaQuery.size.width`, so it no longer breaks inside dialogs and
    panels.
  - Drag handle instead of a Material `Slider`: no teleporting on tap,
    a shake on a miss, an automatic retry, optional `maxAttempts` with a
    locked state, and a refresh button on the board.
  - `humanCheck` rejects drags that finish in one jump or under 240 ms.
  - `onVerify` hands the final distance to a server and shows a spinner
    while the future runs; arrow keys nudge the handle and Enter submits.
  - `tolerance` is per instance; the old global `SlidingCaptcha.deviation`
    is gone with the deprecated widget.
- `WeColorShades`, an extension on `WeColorScheme` that derives the Element
  Plus tint ramp: `light(type, 1…9)`, `dark(type)`, `lighten`, `darken` and
  `ramp`. The new components use it for hover, pressed, plain and light
  backgrounds so custom palettes get the whole ramp for free.

- `CheckTag`, a tag that behaves like a checkbox, after Element Plus'
  `el-check-tag`. Checked it looks like a normal `Tag` of its `type` and
  `theme`; unchecked it flattens to a grey fill with grey text and no outline.
  It works uncontrolled (`initialChecked`) or controlled (`checked`), reports
  through `onChanged`, `onChecked` and `onUnchecked`, supports `disabled`, an
  optional leading check mark (`showCheckIcon`), keyboard toggling with Space
  and Enter, and animates between the two states.

### Deprecated

- `SlidingCaptcha` is now a thin wrapper around `WeCaptcha` and will be removed
  in 1.0.0. Replace `SlidingCaptcha(imageUrl: url, onSuccess: …, onFail: …)`
  with `WeCaptcha.network(url, onSuccess: …, onFail: …)`. The static
  `SlidingCaptcha.deviation` becomes the per-instance `WeCaptcha.tolerance`.
- `SemanticButton` → `WeButton`: `onTap` becomes `onPressed`,
  `isOutlined: true` becomes `variant: WeButtonVariant.plain`, `radius`
  becomes `round: true`, `prefixIcon` (a widget) becomes `icon` (an
  `IconData`), and `shrink` is no longer needed.
- `ButtonGroup` → `WeButtonGroup`.
- `InfoDialogs` → `WeMessageBox.alert`, `ConfirmDialogs` →
  `WeMessageBox.confirm`; both complete with a `bool` instead of taking
  dismiss callbacks.
- All four still work and will be removed in 1.0.0.
- `NotifyToasts` → `WeNotification` (`showTopRight` becomes
  `WeNotification.show`, `showTopLeft` needs
  `position: WeNotificationPosition.topLeft`).
- `TipToasts` → `WeMessage`.
- `SliderWidget` / `SliderInputWidget` → `WeSlider`.
- `FutureDialogs` / `LoadingDialogs` → `WeLoading` (region or
  `WeLoading.service`).
- `PercentIndicator` → `WeProgress`.
- `Picture` → `WeImage`.

### Changed

- The example now shows a small booking form (input, select, date picker,
  switch, confirm box) and a basics page behind a `WeTabbar`.
- The pub.dev screenshot is WebP (199 KB instead of 1.7 MB), which brings
  the published archive from 2 MB down to under 800 KB.
- `WeDatePicker` is now universal: on touch it opens `WeDateSheet` instead
  of the calendar panel, and its field is read-only so no keyboard pops
  up. Keep the panel with `touchMode: WeDatePickerTouchMode.panel`. It no
  longer prints the desktop-only hint; `WeDatePanel` and `WeCalendar` now
  suggest `WeDateSheet`, and `WeMenu` suggests `WeTabbar`.
- On touch platforms `WeTheme.of` returns `WeSizeScheme.touch()` sizes
  unless you passed your own `sizes`, so buttons and fields are 44 px tall
  instead of 32. Keep the compact sizes with
  `WeTheme.light(interaction: WeInteraction.pointer)`.
- On touch, `WePopper` treats a hover trigger as click, which carries over
  to `WePopover` and `WeDropdown`. `WeTooltip` opens on long press and
  closes itself after 1.5 s; a tap still goes to its child.
- `WeNotification`, `WeDialog`, `WinStyleDialog` and `WePopper` panels are
  no wider than the screen, whatever width is set.
- `WeImageViewer` leaves keyboard shortcuts out of its button tooltips on
  touch.
- `WeSelect` and `WeCascader` draw their field with `WeFieldBox`; nothing
  changes for callers. Their panels no longer close when a search box
  inside them is clicked on desktop.
- `WeUpload` previews page through every image in the list, starting from
  the one that was clicked.
- `WeSelect` and `WeDropdown` open a `WePopper` instead of a Material
  menu route, so their panels follow the field while scrolling and nest
  inside dialogs; their constructors are unchanged. `WeDropdown` also
  takes `trigger` and `placement`. The static `WeDropdown.open` still
  shows the old route-based menu.
- `WeButton.tooltip` shows a themed `WeTooltip` instead of Material's.
- `WeDialog` and `WinDialogs` ignore an Escape that already closed a
  floating panel inside them.
- The Windows-style dialog was rewritten. It reads every colour from
  `WeTheme` instead of the four hard-coded greys it used to paint with, so
  it finally works in dark mode; the title bar drags the dialog, the body
  scrolls, and the command bar spaces its buttons itself.
- **Breaking**: `WinDialogs.show`, `zoomIn` and `showWinDialog` take
  `actions` as a `List<Widget> Function(BuildContext)` rather than a
  `List<Widget>`, so buttons can pop the dialog's own route. `show` and
  `showWinDialog` are generic in the popped value; `zoomIn` no longer
  claims to return `Map<String, dynamic>`. `text` now defaults to `''` and
  `icon` is optional, for dialogs that only carry `contents`.
- **Breaking**: `WinStyleDialog` dropped `textWidth` and `bottomWidget`,
  which were declared but never used, and gained `draggable`, `showClose`
  and `bodyPadding`.
- **Breaking**: the `CloseButton` exported by the Windows dialog header is
  now `WinCloseButton`. Under its old name it clashed with
  `CloseButton` from `package:flutter/material.dart`, making the two
  ambiguous in any file importing both.
- `WinDialogs` now honours `barrierDismissible` — `showWinDialog` hard-coded
  it to `false` and ignored the argument — and closes on Escape.
- `SemanticButton` and `Tag` now take their colours and dimensions from
  `WeTheme` instead of hard-coded constants, so they follow dark mode and any
  palette you derive with `WeColorScheme.copyWith`. Install the extension with
  `ThemeData.copyWith(extensions: [WeTheme.light()])`; without it they fall
  back to a palette matching `ThemeData.brightness`, as before.
- **Breaking (visual)**: `SemanticButton` now uses the shared size scale, which
  is the Element Plus one. Heights go from 20/30/40 to 24/32/40 and font sizes
  from 13/16/19 to 12/14/16 for small/default/large. Pass `height` and
  `fontSize` explicitly to keep the old metrics.
- **Breaking**: `SemanticButton.fontSize` is now `double?` and defaults to
  `null`. It previously defaulted to `18` and was ignored entirely — the button
  always used a size-derived value. It is now honoured when set, and falls back
  to the `size` token when not.
- A plain `Tag` with no `type` and no `color` now draws its border in the
  theme's `baseBorder` rather than pure black (or white in dark mode).
- `CounterInput` reads its colours and metrics from `WeTheme` too. The value
  text, which used to be hard-coded black, now follows `primaryText`, and the
  disabled state uses the theme's `disabledText` and `baseFill` instead of
  `Colors.grey`.
- **Breaking (visual)**: `CounterInput` font and icon sizes come from the size
  tokens rather than from `height * 0.6`, and the value is centred instead of
  right-aligned. Pass `height` to scale everything proportionally.
- **Breaking**: `CounterInput.radius` is now `double?` and falls back to
  `WeTheme.radius.base`, which is the old default of `4`.
- **Breaking**: `CounterInput` asserts `minValue <= maxValue` and `step > 0`.
  An inverted range used to take a separate, incoherent code path that could
  spin forever; ranges are now simply ordered.
- `CounterInput` no longer clamps while you type. Input is validated on
  submit or when the field loses focus, so intermediate values such as the
  `1` in `15` survive on a counter whose minimum is `10`.

### Fixed

- Narrow screens no longer overflow in these places:
  - `WeTabs` heads that do not fit scroll sideways.
  - A `Tag` squeezed into a narrow table cell ends in an ellipsis.
  - The `WeStatistic` trend label ends in an ellipsis.
  - The `WeSlider` side input no longer sits in a fixed 108 px box; its
    number field is 56 px wide at every size.
- Text in a `WePopper` panel lost the app's font family: the panel replaced
  the inherited text style instead of merging with it.
- On desktop, a searchable `WeSelect.multiple` closed its panel after every
  pick: the search field unfocused on any tap outside it, the panel
  included, and losing focus hides the panel.
- `CounterInput` threw a `LateInitializationError` when a disabled counter was
  long-pressed, because the repeat timer was only created on long-press start,
  which the disabled path skipped, while long-press end cancelled it
  unconditionally.
- `CounterInput`'s repeat timer was never cancelled in `dispose`, nor when a
  press was cancelled rather than ended. Holding a button and navigating away
  left a timer stepping a disposed controller forever.
- `CounterInputController` never disposed its `TextEditingController`.
- Typing in `CounterInput` moved the caret to the end of the field after every
  keystroke, which made it impossible to edit a value in the middle. The text
  is now only rewritten when it no longer spells the current value.
- `CounterInput` could not accept negative input even with a negative
  `minValue`: the input filter stripped the minus sign, which emptied the
  field, which snapped the value to the minimum. Clearing the field no longer
  snaps to the minimum either.
- `CounterInput` accumulated binary floating point error, so ten steps of
  `0.1` landed on `0.9999999999999999`. Values are now rounded to the
  precision implied by `step`, `minValue` and `maxValue`, or to `decimals`
  when you set it.
- `CounterInput.onMin` and `onMax` never fired for fractional steps, because
  they compared the value to the bound with `==` on drifting floats. They now
  fire exactly once when a bound is reached, and the matching overflow
  callback fires once per attempt to go past it, including while a button is
  held down.
- `CounterInput.onValueChanged` was skipped on some code paths that still
  fired `onIncrement` and `onDecrement`. All three now agree.
- An outlined `CounterInput` drew its button outlines in white by default,
  which made them invisible on a light background. They use the semantic
  colour now, matching the field's outline.

- `GrooveBorder`, `RidgeBorder`, `InsetBorder` and `OutsetBorder` painted
  cracks at their corners and spilled roughly half their thickness outside
  the box they framed. They are now filled as mitred trapezoids, so the frame
  lands entirely inside the rect and matches the `dimensions` they report.
  `GrooveBorder` and `RidgeBorder` also render both of their bevels, which
  previously collapsed into one.
- The four borders above now implement `==`, `hashCode`, `lerpFrom` and
  `lerpTo`, so they animate and stop repainting needlessly.

### Added

- `WeBevelBorder` and `WeBevelStyle`, the shared base the four borders above
  are built on. Use it when the style has to be picked at runtime.
- Narrow barrels so you can import only what you need:
  `package:widgets_easier/theme.dart` for the design tokens and
  `package:widgets_easier/basics.dart` for the basic building blocks.
  `package:widgets_easier/widgets_easier.dart` still exports everything.
- `WeTheme`, a `ThemeExtension` holding the colour, size, radius, spacing and
  shadow tokens every component reads. `WeTheme.of(context)` and the
  `context.weTheme` / `context.weColors` shorthands give access to it.
- `example/lib/main.dart`, a runnable minimal integration.
- `CounterInput.decimals`, fixing how many fraction digits the value is
  rounded to and padded with, and `CounterInput.readOnly`, which keeps the
  buttons live while blocking the keyboard.
- `CounterInput.focusNode`, plus arrow up / down stepping while the field has
  focus and proper button semantics for screen readers.
- `CounterInputChanged`, the typedef the counter's value callbacks use, and
  `DecimalTextInputFormatter`, which validates a decimal number as a whole
  instead of filtering it character by character.

### Removed

- **Breaking**: `PrivacyGuard` moved to the new `widgets_easier_privacy_guard`
  package. It was the only thing in here with Android and iOS code, and its
  presence made this a Flutter *plugin*, forcing native build steps on every
  consumer. This package is now pure Dart. If you use `PrivacyGuard`, add
  `widgets_easier_privacy_guard: ^1.0.0` and import
  `package:widgets_easier_privacy_guard/widgets_easier_privacy_guard.dart`;
  the widget's API is unchanged. Everyone else gets a lighter build.
- **Breaking**: the `depth` parameter on `GrooveBorder`, `RidgeBorder`,
  `InsetBorder` and `OutsetBorder`. It never affected painting. Delete it
  from your call sites; nothing else changes.

### Toolchain update

The package is brought up to date with the current Flutter / Dart toolchain.
None of the changes below touch widget APIs.

#### Changed

- Requires Dart `^3.9.0` and Flutter `>=3.35.0`.
- Upgraded `flutter_svg` to `^2.3.0` and `flutter_lints` to `^6.0.0`.
- Replaced deprecated Flutter APIs: `Color.withOpacity` → `Color.withValues`,
  `ThemeData.dialogBackgroundColor` → `DialogThemeData.backgroundColor`,
  `MaterialStateProperty` → `WidgetStateProperty`,
  `ShowValueIndicator.always` → `ShowValueIndicator.onDrag`.
- `Write.header1`…`header6` and `Write.paragraph` now declare `Widget` return
  types and `String` parameters.
- `NotifyToasts.show*` methods now declare `BuildContext` for their first
  parameter.

#### Removed

- Dependency on `flutter_easy_animations`. The entrance animations used by
  toasts and dialogs (`fadeIn`, `zoomIn`, `zoomInRight`, `slideInUp/Down/Left/Right`,
  `bounceIn`, `backInDown`, `flipInX`, `rollIn`) are now shipped inside this
  package as `AnimateStyles` and exported from `widgets_easier.dart`.
  If you imported `flutter_easy_animations` only for `AnimateStyles`, you can
  drop that import.
- Invalid `default_package` plugin declarations for linux / macos / web /
  windows that made `flutter pub get` fail on recent Flutter versions.

#### Fixed

- `FutureDialog` no longer pops a disposed route after its delay.

## [0.0.10] - 2023-10-03

### Added

- `PrivacyGuard` component to enhance privacy features within the app.
  - Automatically enables a privacy screen when the app goes into the background.
  - Provides blur effects (`blurRadius` and `blurColor`) to obscure the app's content when in privacy mode.
  - Supports disabling screenshot and recording functionalities with optional callbacks (`onScreenshot` and `onRecordingAttempt`) when such actions are attempted.
  - Callbacks for entering (`onEnterPrivacyMode`) and exiting (`onExitPrivacyMode`) privacy mode.
  - Configurable options to prevent screenshots and recordings, enhancing security and privacy compliance.

## 0.0.9

### Added

- Introduced `CascadeBottomSheet` to handle multi-level cascading menus dynamically based on the depth of the provided data.
- Added `showCascadeSheet` method in `BottomSheets` class to display cascading selection sheets.
- Implemented dynamic scroll controllers and selection lists in `CascadeBottomSheet` to support variable depth of data without causing range errors.

### Updated

- Enhanced `BottomSheets` class with additional methods `showInfoSheet` and `showConfirmSheet` for displaying informational and confirmation dialogs respectively.
- Each method now supports customization of text, colors, padding, margins, and dismissibility.
- Added error handling for depth calculations in cascading menus to prevent out-of-range access.

### Fixed

- Fixed an issue where `CascadeBottomSheet` would throw a `RangeError` when the data exceeded four levels of depth by dynamically adjusting the number of scroll controllers and selection lists based on the maximum depth of the data.

### UI Improvements

- Updated UI components in `ConfirmBottomSheet` and `IofoBottomSheet` to include optional images, customizable button texts, and improved layout handling.
- Enhanced visual feedback in `CascadeBottomSheet` with better alignment and color distinction between selected and unselected items.

### Performance

- Optimized the initialization process for `CascadeBottomSheet` to reduce setup time by calculating the maximum depth once during the initial state setup.

### Documentation

- Updated documentation and inline comments for better clarity on how the new dynamic depth handling works in `CascadeBottomSheet`.

## 0.0.8

### Added

**Tag** class, which is a Widget class designed for labeling and selection purposes. It features a `type` attribute that allows users to choose the type of tag they want to use.

## 0.0.7

Bugs Fixed.

## 0.0.6

### Added

**TipToasts** class, which is a utility class used to display temporary notifications or messages in Flutter. It can show custom toast messages at the top, center, or bottom of the screen that automatically disappear after a certain period of time. These types of notifications are commonly referred to as "toast" messages, originating from a similar concept in Android development.

## 0.0.5

### Changes

Fixes were made to the behavior of the `fit` and `alignment` properties of the Picture class. The constraints using BoxConstraints.expand() for images were removed. The method of size limitation was adjusted, as well as the arrangement within the parent container.

### Added

**NotifyToasts** class, which provides a simple and flexible way to display message notifications in your application. By customizing styles, animation effects and interactions, you can create message notifications that conform to the application design style.

## 0.0.4

### Changes

A new `width` property has been added to the **SemanticButton** widget, which is used to forcibly limit the width of the component. If a specific value is specified for this property, the `shrink` property will not occupy the entire container width even if it is set to `false`.

### Added

#### FutureDialogs

**FutureDialogs** is a type of promissory dialog that can help handle dialog application scenarios where the content of different dialogs needs to be determined by future results in a very simple way.

#### WinDialogs

**WinDialogs** is a type of dialog that mimics the Windows style.

## 0.0.3

### Added

CounterInput, which is a **Flutter** widget for numerical input and adjustment. It provides an intuitive interface that allows users to change the current value by clicking plus and minus buttons or directly inputting numbers.

## 0.0.2

### Added

#### ButtonGroup

ButtonGroup Widget is a button combination based on **SemanticButton**.

### Changes

- Added custom color and gradient color functionality to **SemanticButton**.
- Added debugging information to **SemanticButton**.
- Added the borderRadius property to **SemanticButton**, which is used to specify a finer border radius than the radius property.

## 0.0.1

- initial release.
