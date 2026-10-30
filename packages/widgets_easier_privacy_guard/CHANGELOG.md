# CHANGELOG

## [1.0.0] - 2026-10-30

First release. `PrivacyGuard` was extracted from the `widgets_easier`
package, which is now pure Dart.

### Migrating from `widgets_easier`

`PrivacyGuard` used to come from `package:widgets_easier/widgets_easier.dart`.
Add this package and change the import:

```diff
+dependencies:
+  widgets_easier_privacy_guard: ^1.0.0

-import 'package:widgets_easier/widgets_easier.dart';
+import 'package:widgets_easier_privacy_guard/widgets_easier_privacy_guard.dart';
```

Existing `PrivacyGuard(...)` calls keep working. Projects that never used
`PrivacyGuard` no longer build any native code.

### Added

- `PrivacyGuard` parameters: `enabled`, `overlayBuilder`, `blurWhenInactive`,
  `blurWhileRecording`, `hideInRecents` (Android 13+), `iosSecureLayerHack`,
  `onScreenshot` and `onScreenRecordingChanged`.
- Screenshot events on iOS and Android 14+, and screen recording events on
  iOS and Android 15+. The Android permissions they need are declared in the
  plugin manifest.
- Screenshot blocking on macOS (`NSWindow.sharingType`) and Windows
  (`SetWindowDisplayAffinity`). Linux and the web get the background overlay.
- An opt-in iOS screenshot block that uses the secure text field layer. It is
  off by default; see the README for the risks.
- `PrivacyGuardPlatform` for use outside a widget tree: `setSecure`,
  `requestSecure`, `getCapabilities` and the capture event streams.
- The iOS and macOS pods ship a privacy manifest.

### Fixed

- After a configuration change such as rotation, Android recreated the
  Activity without `FLAG_SECURE`. The flag is now reapplied to every Activity.
- With several guards on screen, disposing one cleared `FLAG_SECURE` for all.
  The flag is now reference counted.
- The blur was not clipped to the child, and the overlay had no reliable size.
- `onEnterPrivacyMode` fired twice when going from inactive to paused, and
  `onExitPrivacyMode` fired on every resume even without an overlay.
- `AppLifecycleState.hidden` (desktop minimise, hidden web tab) did not show
  the overlay, and an overlay set up while frames were paused was not painted.
- Content under the overlay stayed visible to screen readers and tappable.
- Platform errors surfaced as uncaught async errors; they now go to
  `FlutterError.reportError`.
- iOS never actually handled the screenshot call: Dart sent a bare boolean
  while Swift read a map, so every call failed with `INVALID_ARGUMENTS`.
- `FLAG_SECURE` stayed on the Activity after the guard was disposed.
