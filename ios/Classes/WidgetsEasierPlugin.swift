import Flutter
import UIKit

/**
 * WidgetsEasierPlugin
 *
 * 这是一个 Flutter 插件，用于处理与 iOS 原生代码的通信。
 * 该插件实现了 FlutterPlugin 接口，以便在 Flutter 引擎中进行注册和管理。
 */
public class WidgetsEasierPlugin: NSObject, FlutterPlugin {

    /**
     * 注册插件并初始化通信通道。
     *
     * @param registrar 提供 Flutter 插件注册的上下文。
     */
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "widgets_easier", binaryMessenger: registrar.messenger())
        let instance = WidgetsEasierPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)

        // 注册 PrivacyGuardHandler 以处理隐私保护相关的通信
        PrivacyGuardHandler.register(with: registrar)
    }

    /**
     * 处理来自 Flutter 端的调用。
     *
     * @param call 包含方法名和参数的 FlutterMethodCall 对象。
     * @param result 用于返回调用结果的 FlutterResult 对象。
     */
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}