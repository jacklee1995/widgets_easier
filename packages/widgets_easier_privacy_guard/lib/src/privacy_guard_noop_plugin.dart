/// Plugin registration for Linux, which has no native side.
///
/// Linux has no API to block screen capture, so only the Dart background blur
/// works there and nothing needs registering. Flutter calls [registerWith]
/// from the generated plugin registrant; you never need to call it yourself.
abstract final class PrivacyGuardNoopPlugin {
  /// Called by the generated plugin registrant.
  static void registerWith() {}
}
