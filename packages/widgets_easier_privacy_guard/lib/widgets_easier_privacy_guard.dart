/// Hides sensitive content when your app leaves the foreground, blocks
/// screenshots where the platform allows it, and reports screenshots and
/// screen recording.
///
/// This lives in its own package because it ships native code. The rest of
/// Widgets Easier is pure Dart, and pulling in native build steps for
/// everyone who just wants a button would be rude.
library;

export 'src/privacy_guard.dart';
export 'src/privacy_guard_noop_plugin.dart';
export 'src/privacy_guard_platform.dart';
