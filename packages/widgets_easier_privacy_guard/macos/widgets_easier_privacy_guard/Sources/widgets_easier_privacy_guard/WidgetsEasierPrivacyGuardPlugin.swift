import Cocoa
import FlutterMacOS

/// Keeps the Flutter window out of screenshots, recordings and screen
/// sharing by setting `NSWindow.sharingType` to `.none`. macOS offers no
/// screenshot notification, so there is no event channel here.
public class WidgetsEasierPrivacyGuardPlugin: NSObject, FlutterPlugin {
  private weak var registrar: FlutterPluginRegistrar?

  init(registrar: FlutterPluginRegistrar) {
    self.registrar = registrar
  }

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "tech.thispage.widgets_easier_privacy_guard",
      binaryMessenger: registrar.messenger)
    let instance = WidgetsEasierPrivacyGuardPlugin(registrar: registrar)
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "setSecure":
      guard let secure = call.arguments as? Bool else {
        result(FlutterError(
          code: "INVALID_ARGUMENTS", message: "setSecure expects a bool", details: nil))
        return
      }
      guard let window = registrar?.view?.window else {
        result(FlutterError(
          code: "UNAVAILABLE", message: "The Flutter view has no window yet", details: nil))
        return
      }
      window.sharingType = secure ? .none : .readOnly
      result(nil)
    case "getCapabilities":
      result([
        "preventScreenshot": true,
        "hideInRecents": false,
        "screenshotDetection": false,
        "recordingDetection": false,
        "iosSecureLayer": false,
      ])
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
