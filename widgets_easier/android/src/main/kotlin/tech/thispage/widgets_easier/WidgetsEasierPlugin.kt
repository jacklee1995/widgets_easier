package tech.thispage.widgets_easier

import android.app.Activity
import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodChannel

/**
 * WidgetsEasierPlugin
 * 
 * 这是一个 Flutter 插件，用于处理与 Android 原生代码的通信。
 * 该插件实现了 FlutterPlugin 和 ActivityAware 接口，以便在 Flutter 引擎和 Activity 生命周期中进行管理。
 */
class WidgetsEasierPlugin : FlutterPlugin, ActivityAware {
    private lateinit var context: Context
    private lateinit var activity: Activity
    private lateinit var privacyGuardHandler: PrivacyGuardHandler
    private lateinit var privacyGuardChannel: MethodChannel

    /**
     * 当插件附加到 Flutter 引擎时调用。
     * 
     * @param flutterPluginBinding 提供 Flutter 引擎的上下文和通道。
     */
    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        privacyGuardChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "privacy_guard_channel")
    }

    /**
     * 当插件从 Flutter 引擎分离时调用。
     * 
     * @param binding 提供 Flutter 引擎的上下文和通道。
     */
    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        privacyGuardChannel.setMethodCallHandler(null)
    }

    /**
     * 当插件附加到 Activity 时调用。
     * 
     * @param binding 提供 Activity 的上下文和通道。
     */
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        privacyGuardHandler = PrivacyGuardHandler(activity)
        privacyGuardChannel.setMethodCallHandler(privacyGuardHandler)
    }

    // 当插件从 Activity 分离时调用（由于配置更改）。
    override fun onDetachedFromActivityForConfigChanges() {
        // 如果需要，可以在此处处理由于配置更改导致的 Activity 分离
    }

    /**
     * 当插件重新附加到 Activity 时调用（由于配置更改）。
     * 
     * @param binding 提供 Activity 的上下文和通道。
     */
    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        // 如果需要，可以在此处处理由于配置更改导致的 Activity 重新附加
    }

    // 当插件从 Activity 分离时调用。
    override fun onDetachedFromActivity() {
        privacyGuardChannel.setMethodCallHandler(null)
    }
}