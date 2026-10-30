import 'package:flutter_web_plugins/flutter_web_plugins.dart';

/// Plugin registration for the web.
///
/// Browsers offer no way to block screen capture, so only the Dart background
/// blur works there (it shows when the tab is hidden). The Dart side never
/// calls the method channel on the web, so nothing needs registering.
class PrivacyGuardWebPlugin {
  /// Called by the generated web plugin registrant.
  static void registerWith(Registrar registrar) {}
}
