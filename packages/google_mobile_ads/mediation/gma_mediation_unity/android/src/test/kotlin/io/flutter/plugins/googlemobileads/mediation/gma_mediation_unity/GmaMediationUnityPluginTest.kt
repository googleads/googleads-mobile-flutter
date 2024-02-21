package io.flutter.plugins.googlemobileads.mediation.gma_mediation_unity

import com.unity3d.ads.metadata.MetaData
import kotlin.test.Test
import org.mockito.Mockito.mockStatic
import org.mockito.kotlin.eq
import org.mockito.kotlin.verify
import org.mockito.kotlin.whenever

/*
 * This demonstrates a simple unit test of the Kotlin portion of this plugin's implementation.
 *
 * Once you have built the plugin's example app, you can run these tests from the command
 * line by running `./gradlew testDebugUnitTest` in the `example/android/` directory, or
 * you can run them directly from IDEs that support JUnit such as Android Studio.
 */

internal class GmaMediationUnityPluginTest {
  private val mockMetaData = mock<MetaData>
  @Test
  fun setGDPRConsent_setsGDPRAndCommitsIt() {
    mockStatic(MetaData::class.java).use {
      whenever(createMetaData(any())) doReturn mockMetaData
      val plugin = GmaMediationUnityPlugin()

      plugin.setGDPRConsent(true)

      verify(mockMetaData).set(eq("gdpr.consent"), eq(true))
      verify(mockMetaData).commit()
    }
  }

  @Test
  fun setCCPAConsent_setsCCPAAndCommitsIt() {
    mockStatic(MetaData::class.java).use {
      whenever(createMetaData(any())) doReturn mockMetaData
      val plugin = GmaMediationUnityPlugin()

      plugin.setCCPAConsent(true)

      verify(mockMetaData).set(eq("privacy.consent"), eq(true))
      verify(mockMetaData).commit()
    }
  }
}
