package tech.thispage.widgets_easier_privacy_guard

import android.app.Activity
import android.view.Window
import android.view.WindowManager
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.mockito.Mockito
import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertTrue

/*
 * Run with `./gradlew :widgets_easier_privacy_guard:testDebugUnitTest` in
 * `example/android/`. Build.VERSION.SDK_INT is 0 in local unit tests, which
 * is what lets the version-gated tests below check the "too old" path.
 */
internal class WidgetsEasierPrivacyGuardPluginTest {
    private val flag = WindowManager.LayoutParams.FLAG_SECURE

    private fun result() = Mockito.mock(MethodChannel.Result::class.java)

    private fun activityWith(window: Window): ActivityPluginBinding {
        val activity = Mockito.mock(Activity::class.java)
        Mockito.`when`(activity.window).thenReturn(window)
        val binding = Mockito.mock(ActivityPluginBinding::class.java)
        Mockito.`when`(binding.activity).thenReturn(activity)
        return binding
    }

    @Test
    fun setSecure_withoutAnActivity_isKeptForLater() {
        val plugin = WidgetsEasierPrivacyGuardPlugin()
        val result = result()
        plugin.onMethodCall(MethodCall("setSecure", true), result)
        Mockito.verify(result).success(null)

        val window = Mockito.mock(Window::class.java)
        plugin.onAttachedToActivity(activityWith(window))
        Mockito.verify(window).setFlags(flag, flag)
    }

    @Test
    fun setSecure_isReappliedAfterAConfigurationChange() {
        val plugin = WidgetsEasierPrivacyGuardPlugin()
        val first = Mockito.mock(Window::class.java)
        plugin.onAttachedToActivity(activityWith(first))
        plugin.onMethodCall(MethodCall("setSecure", true), result())
        Mockito.verify(first).setFlags(flag, flag)

        plugin.onDetachedFromActivityForConfigChanges()
        val recreated = Mockito.mock(Window::class.java)
        plugin.onReattachedToActivityForConfigChanges(activityWith(recreated))
        Mockito.verify(recreated).setFlags(flag, flag)
    }

    @Test
    fun setSecure_false_clearsTheFlag() {
        val plugin = WidgetsEasierPrivacyGuardPlugin()
        val window = Mockito.mock(Window::class.java)
        plugin.onAttachedToActivity(activityWith(window))
        plugin.onMethodCall(MethodCall("setSecure", false), result())
        Mockito.verify(window, Mockito.atLeastOnce()).clearFlags(flag)
    }

    @Test
    fun hideInRecents_belowApi33_neverTouchesTheActivity() {
        val plugin = WidgetsEasierPrivacyGuardPlugin()
        val binding = activityWith(Mockito.mock(Window::class.java))
        plugin.onAttachedToActivity(binding)
        plugin.onMethodCall(MethodCall("setHideInRecents", true), result())

        assertTrue(plugin.desiredHideInRecents)
        Mockito.verify(binding.activity, Mockito.never())
            .setRecentsScreenshotEnabled(Mockito.anyBoolean())
    }

    @Test
    fun capabilities_followTheSdkLevel() {
        val old = WidgetsEasierPrivacyGuardPlugin.capabilities(30)
        assertEquals(false, old["hideInRecents"])
        assertEquals(false, old["screenshotDetection"])
        val new = WidgetsEasierPrivacyGuardPlugin.capabilities(35)
        assertEquals(true, new["hideInRecents"])
        assertEquals(true, new["screenshotDetection"])
        assertEquals(true, new["recordingDetection"])
    }

    @Test
    fun rejectsANonBooleanArgument() {
        val plugin = WidgetsEasierPrivacyGuardPlugin()
        val result = result()
        plugin.onMethodCall(MethodCall("setSecure", mapOf("prevent" to true)), result)
        Mockito.verify(result).error(
            Mockito.eq("INVALID_ARGUMENTS"),
            Mockito.anyString(),
            Mockito.isNull()
        )
    }

    @Test
    fun unknownMethods_areNotImplemented() {
        val result = result()
        WidgetsEasierPrivacyGuardPlugin().onMethodCall(MethodCall("nope", null), result)
        Mockito.verify(result).notImplemented()
    }
}
