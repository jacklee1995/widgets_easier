import 'package:flutter/services.dart';

class PrivacyGuardChannel {
  static const MethodChannel _channel = MethodChannel('privacy_guard_channel');

  static Future<void> preventScreenshot(bool prevent) async {
    await _channel.invokeMethod('preventScreenshot', prevent);
  }
}
