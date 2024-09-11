import Flutter
import UIKit

/**
 * PrivacyGuardHandler
 * 
 * 这是一个用于处理与 Flutter 端通信的类，主要用于控制是否允许截屏。
 * 该类实现了 FlutterPlugin 接口，以处理来自 Flutter 端的调用。
 */
class PrivacyGuardHandler: NSObject, FlutterPlugin {
    
    /**
     * 注册插件并初始化通信通道。
     * 
     * @param registrar 提供 Flutter 插件注册的上下文。
     */
    static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "privacy_guard_channel", binaryMessenger: registrar.messenger())
        let instance = PrivacyGuardHandler()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    /**
     * 处理来自 Flutter 端的调用。
     * 
     * @param call 包含方法名和参数的 FlutterMethodCall 对象。
     * @param result 用于返回调用结果的 FlutterResult 对象。
     */
    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "preventScreenshot":
            if let args = call.arguments as? [String: Any],
               let prevent = args["prevent"] as? Bool {
                preventScreenshot(prevent: prevent)
                result(nil)
            } else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    /**
     * 设置是否禁止截屏。
     * 
     * @param prevent 如果为 true，则禁止截屏；否则允许截屏。
     */
    private func preventScreenshot(prevent: Bool) {
        DispatchQueue.main.async {
            if let window = UIApplication.shared.windows.first {
                if prevent {
                    window.windowLevel = UIWindow.Level.statusBar + 1
                } else {
                    window.windowLevel = UIWindow.Level.normal
                }
            }
        }
    }
}