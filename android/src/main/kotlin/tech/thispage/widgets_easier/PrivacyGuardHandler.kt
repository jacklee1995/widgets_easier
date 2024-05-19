package tech.thispage.widgets_easier

import android.app.Activity
import android.view.WindowManager
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * PrivacyGuardHandler
 * 
 * 这是一个用于处理与 Flutter 端通信的类，主要用于控制是否允许截屏。
 * 该类实现了 MethodChannel.MethodCallHandler 接口，以处理来自 Flutter 端的调用。
 * 
 * @param activity 当前的 Activity 实例，用于设置窗口标志。
 */
class PrivacyGuardHandler(private val activity: Activity) : MethodChannel.MethodCallHandler {

    /**
     * 处理来自 Flutter 端的调用。
     * 
     * @param call 包含方法名和参数的 MethodCall 对象。
     * @param result 用于返回调用结果的 MethodChannel.Result 对象。
     */
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "preventScreenshot" -> {
                val prevent = call.arguments as Boolean
                preventScreenshot(prevent)
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    /**
     * 设置是否禁止截屏。
     * 
     * @param prevent 如果为 true，则禁止截屏；否则允许截屏。
     */
    private fun preventScreenshot(prevent: Boolean) {
        if (prevent) {
            activity.window.setFlags(WindowManager.LayoutParams.FLAG_SECURE, WindowManager.LayoutParams.FLAG_SECURE)
        } else {
            activity.window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
        }
    }
}