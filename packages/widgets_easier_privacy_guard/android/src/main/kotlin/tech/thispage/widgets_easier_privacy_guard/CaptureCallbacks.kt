package tech.thispage.widgets_easier_privacy_guard

import android.app.Activity
import android.os.Build
import android.util.Log
import android.view.WindowManager
import androidx.annotation.RequiresApi
import java.util.function.Consumer

/**
 * Screenshot detection (API 34, DETECT_SCREEN_CAPTURE) and screen recording
 * detection (API 35, DETECT_SCREEN_RECORDING). Both are tied to one Activity
 * and only report while it is visible. On older versions this does nothing.
 */
internal class CaptureCallbacks(private val emit: (Map<String, Any>) -> Unit) {
    private var activity: Activity? = null
    private var screenshotCallback: Any? = null
    private var recordingCallback: Any? = null

    fun register(activity: Activity) {
        if (this.activity === activity) return
        unregister()
        this.activity = activity
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
                registerScreenshot(activity)
            }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.VANILLA_ICE_CREAM) {
                registerRecording(activity)
            }
        } catch (e: SecurityException) {
            Log.w(TAG, "Capture detection needs its permission in the manifest", e)
        }
    }

    fun unregister() {
        val activity = activity ?: return
        this.activity = null
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
                (screenshotCallback as? Activity.ScreenCaptureCallback)?.let {
                    activity.unregisterScreenCaptureCallback(it)
                }
            }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.VANILLA_ICE_CREAM) {
                @Suppress("UNCHECKED_CAST")
                (recordingCallback as? Consumer<Int>)?.let {
                    activity.windowManager.removeScreenRecordingCallback(it)
                }
            }
        } catch (e: RuntimeException) {
            Log.w(TAG, "Could not unregister capture callbacks", e)
        }
        screenshotCallback = null
        recordingCallback = null
    }

    @RequiresApi(Build.VERSION_CODES.UPSIDE_DOWN_CAKE)
    private fun registerScreenshot(activity: Activity) {
        val callback = Activity.ScreenCaptureCallback {
            emit(mapOf("type" to "screenshot"))
        }
        activity.registerScreenCaptureCallback(activity.mainExecutor, callback)
        screenshotCallback = callback
    }

    @RequiresApi(Build.VERSION_CODES.VANILLA_ICE_CREAM)
    private fun registerRecording(activity: Activity) {
        val callback = Consumer<Int> { state -> emitRecording(state) }
        val initial = activity.windowManager.addScreenRecordingCallback(
            activity.mainExecutor,
            callback
        )
        recordingCallback = callback
        emitRecording(initial)
    }

    @RequiresApi(Build.VERSION_CODES.VANILLA_ICE_CREAM)
    private fun emitRecording(state: Int) {
        val active = state == WindowManager.SCREEN_RECORDING_STATE_VISIBLE
        emit(mapOf("type" to "recording", "active" to active))
    }

    private companion object {
        const val TAG = "PrivacyGuard"
    }
}
