package tech.thispage.widgets_easier_privacy_guard

import android.app.Activity
import android.os.Build
import android.view.WindowManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

private const val CHANNEL = "tech.thispage.widgets_easier_privacy_guard"
private const val EVENTS = "$CHANNEL/events"

/**
 * FLAG_SECURE, the recents thumbnail and the capture callbacks all belong to
 * an Activity, and a configuration change hands us a new one. So the plugin
 * keeps the requested state and applies it to every Activity it is given.
 */
class WidgetsEasierPrivacyGuardPlugin :
    FlutterPlugin, ActivityAware, MethodChannel.MethodCallHandler, EventChannel.StreamHandler {

    private var channel: MethodChannel? = null
    private var eventChannel: EventChannel? = null
    private var activity: Activity? = null
    private var events: EventChannel.EventSink? = null
    private val capture = CaptureCallbacks { event -> events?.success(event) }

    internal var desiredSecure = false
        private set
    internal var desiredHideInRecents = false
        private set

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, CHANNEL).apply {
            setMethodCallHandler(this@WidgetsEasierPrivacyGuardPlugin)
        }
        eventChannel = EventChannel(binding.binaryMessenger, EVENTS).apply {
            setStreamHandler(this@WidgetsEasierPrivacyGuardPlugin)
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel?.setMethodCallHandler(null)
        channel = null
        eventChannel?.setStreamHandler(null)
        eventChannel = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "setSecure", "setHideInRecents" -> {
                val value = call.arguments as? Boolean
                if (value == null) {
                    result.error(
                        "INVALID_ARGUMENTS",
                        "${call.method} expects a bool, got ${call.arguments}",
                        null
                    )
                    return
                }
                if (call.method == "setSecure") desiredSecure = value
                else desiredHideInRecents = value
                activity?.let(::apply)
                result.success(null)
            }
            "getCapabilities" -> result.success(capabilities(Build.VERSION.SDK_INT))
            else -> result.notImplemented()
        }
    }

    private fun apply(activity: Activity) {
        val window = activity.window ?: return
        if (desiredSecure) {
            window.setFlags(
                WindowManager.LayoutParams.FLAG_SECURE,
                WindowManager.LayoutParams.FLAG_SECURE
            )
        } else {
            window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            activity.setRecentsScreenshotEnabled(!desiredHideInRecents)
        }
    }

    override fun onListen(arguments: Any?, sink: EventChannel.EventSink?) {
        events = sink
        activity?.let(capture::register)
    }

    override fun onCancel(arguments: Any?) {
        events = null
        capture.unregister()
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        apply(binding.activity)
        if (events != null) capture.register(binding.activity)
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) =
        onAttachedToActivity(binding)

    override fun onDetachedFromActivityForConfigChanges() = onDetachedFromActivity()

    override fun onDetachedFromActivity() {
        capture.unregister()
        activity = null
    }

    internal companion object {
        fun capabilities(sdk: Int): Map<String, Boolean> = mapOf(
            "preventScreenshot" to true,
            "hideInRecents" to (sdk >= Build.VERSION_CODES.TIRAMISU),
            "screenshotDetection" to (sdk >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE),
            "recordingDetection" to (sdk >= Build.VERSION_CODES.VANILLA_ICE_CREAM),
            "iosSecureLayer" to false
        )
    }
}
