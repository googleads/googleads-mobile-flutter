package io.flutter.plugins.googlemobileads.mediation.gma_mediation_unity

import android.content.Context
import androidx.test.core.app.ApplicationProvider
import androidx.test.ext.junit.runners.AndroidJUnit4
import com.unity3d.ads.metadata.MetaData
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugins.googlemobileads.mediation.gma_mediation_unity.UnityApiWrapper.createMetaData
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mockito.mockStatic
import org.mockito.kotlin.doReturn
import org.mockito.kotlin.eq
import org.mockito.kotlin.mock
import org.mockito.kotlin.verify
import org.mockito.kotlin.whenever

/*
 * This demonstrates a simple unit test of the Kotlin portion of this plugin's implementation.
 *
 * Once you have built the plugin's example app, you can run these tests from the command
 * line by running `./gradlew testDebugUnitTest` in the `example/android/` directory, or
 * you can run them directly from IDEs that support JUnit such as Android Studio.
 */
@RunWith(AndroidJUnit4::class)
internal class GmaMediationUnityPluginTest {
  private val context = ApplicationProvider.getApplicationContext<Context>()
  private val mockMetaData = mock<MetaData>()
  private val mockBinaryMessenger = mock<BinaryMessenger>()
  private val mockFlutterPluginBinding = mock<FlutterPlugin.FlutterPluginBinding> {
    on { applicationContext } doReturn context
    on { binaryMessenger } doReturn mockBinaryMessenger
  }
  @Test
  fun setGDPRConsent_withTrueValue_setsGDPRAndCommitsIt() {
    val plugin = GmaMediationUnityPlugin()
    mockStatic(UnityApiWrapper::class.java).use {
      whenever(createMetaData(context)) doReturn mockMetaData
      plugin.onAttachedToEngine(mockFlutterPluginBinding)

      plugin.setGDPRConsent(true)

      verify(mockMetaData).set(eq("gdpr.consent"), eq(true))
      verify(mockMetaData).commit()
    }
  }

  @Test
  fun setGDPRConsent_withFalseValue_setsGDPRAndCommitsIt() {
    val plugin = GmaMediationUnityPlugin()
    mockStatic(UnityApiWrapper::class.java).use {
      whenever(createMetaData(context)) doReturn mockMetaData
      plugin.onAttachedToEngine(mockFlutterPluginBinding)

      plugin.setGDPRConsent(false)

      verify(mockMetaData).set(eq("gdpr.consent"), eq(false))
      verify(mockMetaData).commit()
    }
  }

  @Test
  fun setCCPAConsent_withTrueValue_setsCCPAAndCommitsIt() {
    val plugin = GmaMediationUnityPlugin()
    mockStatic(UnityApiWrapper::class.java).use {
      whenever(createMetaData(context)) doReturn mockMetaData
      plugin.onAttachedToEngine(mockFlutterPluginBinding)

      plugin.setCCPAConsent(true)

      verify(mockMetaData).set(eq("privacy.consent"), eq(true))
      verify(mockMetaData).commit()
    }
  }

  @Test
  fun setCCPAConsent_withFalseValue_setsCCPAAndCommitsIt() {
    val plugin = GmaMediationUnityPlugin()
    mockStatic(UnityApiWrapper::class.java).use {
      whenever(createMetaData(context)) doReturn mockMetaData
      plugin.onAttachedToEngine(mockFlutterPluginBinding)

      plugin.setCCPAConsent(false)

      verify(mockMetaData).set(eq("privacy.consent"), eq(false))
      verify(mockMetaData).commit()
    }
  }
}
