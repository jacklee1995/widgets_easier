# widgets_easier_privacy_guard

Hides sensitive content when your app leaves the foreground, blocks
screenshots and screen recording where the platform allows it, and tells you
when the user takes a screenshot or starts recording.

This is the only part of [Widgets Easier][we] that ships native code. It is a
separate package so that the main `widgets_easier` package can stay pure Dart:
depending on it should never drag native build steps into a project that only
wanted a button.

## Install

```yaml
dependencies:
  widgets_easier_privacy_guard: ^1.0.0
```

## Use

Wrap whatever should be protected:

```dart
PrivacyGuard(
  preventScreenshot: true,
  onScreenshot: () => showWarning(),
  child: const CreditCardForm(),
)
```

What it does:

- **Background overlay.** When the app is paused, hidden or detached, a blur
  covers the child, including the thumbnail the OS shows in the task switcher.
  By default `inactive` also triggers it, because iOS takes that thumbnail
  while inactive. Set `blurWhenInactive: false` if the overlay flashing over
  Control Center, permission prompts or Face ID bothers you more. While the
  overlay is up, the child is hidden from screen readers and ignores taps.
  Tune it with `blurRadius` and `blurColor`, or replace it entirely with
  `overlayBuilder`.
- **Screenshot blocking** with `preventScreenshot: true`.
- **Recents only** with `hideInRecents: true`: the task switcher thumbnail is
  hidden but screenshots still work (Android 13+).
- **Capture events** through `onScreenshot` and `onScreenRecordingChanged`.
  `blurWhileRecording: true` shows the overlay while the screen is recorded or
  mirrored.
- `enabled: false` turns the guard off without removing it from the tree, and
  `onEnterPrivacyMode` / `onExitPrivacyMode` fire once per change.

Outside a widget tree, use `PrivacyGuardPlatform`: `setSecure`,
`getCapabilities()`, `onScreenshot` and `onScreenRecordingChanged`.

## Platform support

| | Background overlay | Block screenshots | Hide in recents only | Screenshot events | Recording events |
|---|---|---|---|---|---|
| Android | yes | yes (`FLAG_SECURE`) | 13+ | 14+ | 15+ |
| iOS | yes | opt-in workaround, see below | no | yes | yes |
| macOS | yes | yes (`NSWindow.sharingType`) | no | no | no |
| Windows | yes | yes (`SetWindowDisplayAffinity`) | no | no | no |
| Linux | yes | no | no | no | no |
| Web | yes (hidden tab) | no | no | no | no |

Several features depend on the OS version, so check at runtime with
`await PrivacyGuardPlatform.getCapabilities()` before showing a setting the
device cannot honour.

Notes per platform:

- **Shared flag.** Blocking screenshots applies to the whole window, not one
  widget. Every guard with `preventScreenshot: true` (and
  `PrivacyGuardPlatform.setSecure(true)`) takes a hold on the flag, and it is
  only cleared once the last hold is released, so several guards can be on
  screen at once.
- **Android permissions.** Screenshot and recording events need
  `DETECT_SCREEN_CAPTURE` (Android 14) and `DETECT_SCREEN_RECORDING`
  (Android 15). The plugin's manifest declares both; they are install-time
  permissions with no prompt. If you do not use the events, you can drop them
  from your app's manifest with `tools:node="remove"`.
- **iOS screenshots** cannot be blocked with public API. `onScreenshot` fires
  after the screenshot was taken.
- **Windows** before 10 version 2004 falls back to `WDA_MONITOR`, which shows
  the window as a black rectangle in captures instead of leaving it out.
- **macOS** capture tools built on ScreenCaptureKit may not honour
  `sharingType` on every macOS version. Treat it as a deterrent.

## The iOS screenshot workaround

`PrivacyGuard(preventScreenshot: true, iosSecureLayerHack: true)` moves the
app's window layer into the secure layer of a password text field, which iOS
blanks in screenshots and recordings. It is **off by default** because it
depends on private UIKit structure: the layer it needs moved between iOS 16
and 17, and a future version may move it again. The plugin checks for the
layer and does nothing if it is missing (`getCapabilities()` reports
`iosSecureLayer: false`), so the app will not crash, but the protection may
silently stop working after an OS update. Test on every iOS version you
support.

## Testing on a device

`example/integration_test` checks that every call reaches the native side
without an error (`flutter test integration_test -d <device>`). The visual
part needs a person:

1. Run the example, enable "Block screenshots", take a screenshot. Android,
   macOS and Windows should produce a black or missing window.
2. Send the app to the background and open the task switcher: the preview
   should be blurred.
3. On iOS and Android 14+, take a screenshot and watch the event log.
4. Start a screen recording (iOS, Android 15+) with "Blur while recording" on.

[we]: https://github.com/jacklee1995/widgets_easier
