import Flutter
import UIKit

/// iOS has no public API to block screenshots, so `setSecure` is accepted and
/// ignored. What iOS does offer is reporting: a notification after each
/// screenshot and `UIScreen.isCaptured` for recording and mirroring. The
/// opt-in secure-layer workaround lives in `SecureLayer`.
public class WidgetsEasierPrivacyGuardPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
  private var events: FlutterEventSink?
  private var observers: [NSObjectProtocol] = []
  private let secureLayer = SecureLayer()

  public static func register(with registrar: FlutterPluginRegistrar) {
    let instance = WidgetsEasierPrivacyGuardPlugin()
    let channel = FlutterMethodChannel(
      name: "tech.thispage.widgets_easier_privacy_guard",
      binaryMessenger: registrar.messenger())
    registrar.addMethodCallDelegate(instance, channel: channel)
    let events = FlutterEventChannel(
      name: "tech.thispage.widgets_easier_privacy_guard/events",
      binaryMessenger: registrar.messenger())
    events.setStreamHandler(instance)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "setSecure", "setHideInRecents":
      result(nil)
    case "setIosSecureLayer":
      guard let enabled = call.arguments as? Bool else {
        result(FlutterError(
          code: "INVALID_ARGUMENTS",
          message: "setIosSecureLayer expects a bool",
          details: nil))
        return
      }
      secureLayer.setEnabled(enabled)
      result(nil)
    case "getCapabilities":
      result([
        "preventScreenshot": false,
        "hideInRecents": false,
        "screenshotDetection": true,
        "recordingDetection": true,
        "iosSecureLayer": secureLayer.isAvailable,
      ])
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  public func onListen(withArguments arguments: Any?, eventSink: @escaping FlutterEventSink)
    -> FlutterError?
  {
    events = eventSink
    let center = NotificationCenter.default
    observers = [
      center.addObserver(
        forName: UIApplication.userDidTakeScreenshotNotification, object: nil, queue: .main
      ) { [weak self] _ in
        self?.events?(["type": "screenshot"])
      },
      center.addObserver(
        forName: UIScreen.capturedDidChangeNotification, object: nil, queue: .main
      ) { [weak self] _ in
        self?.sendRecordingState()
      },
    ]
    sendRecordingState()
    return nil
  }

  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    observers.forEach(NotificationCenter.default.removeObserver)
    observers = []
    events = nil
    return nil
  }

  private func sendRecordingState() {
    let captured = SecureLayer.keyWindow()?.screen.isCaptured ?? UIScreen.main.isCaptured
    events?(["type": "recording", "active": captured])
  }
}
