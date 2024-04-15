package io.flutter.plugins.googlemobileads.mediation.gma_mediation_dtexchange

import androidx.test.ext.junit.runners.AndroidJUnit4
import com.fyber.inneractive.sdk.external.InneractiveAdManager
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mockito.mockStatic
import org.mockito.kotlin.eq

@RunWith(AndroidJUnit4::class)
internal class GmaMediationDtexchangePluginTest {
  @Test
  fun setGDPRConsent_withTrueValue_invokesSetGdprConsentWithTrueValue() {
    val plugin = GmaMediationDTExchangePlugin()
    mockStatic(InneractiveAdManager::class.java).use { mockedDTExchangeAdManager ->

      plugin.setGDPRConsent(true)

      mockedDTExchangeAdManager.verify {
        InneractiveAdManager.setGdprConsent(eq(true))
      }
    }
  }

  @Test
  fun setGDPRConsent_withFalseValue_invokesSetGdprConsentWithFalseValue() {
    val plugin = GmaMediationDTExchangePlugin()
    mockStatic(InneractiveAdManager::class.java).use { mockedDTExchangeAdManager ->

      plugin.setGDPRConsent(false)

      mockedDTExchangeAdManager.verify {
        InneractiveAdManager.setGdprConsent(eq(false))
      }
    }
  }

  @Test
  fun setGDPRConsentString_invokesSetGdprConsentString() {
    val plugin = GmaMediationDTExchangePlugin()
    mockStatic(InneractiveAdManager::class.java).use { mockedDTExchangeAdManager ->

      plugin.setGDPRConsentString(TEST_CONSENT_STRING)

      mockedDTExchangeAdManager.verify {
        InneractiveAdManager.setGdprConsentString(eq(TEST_CONSENT_STRING))
      }
    }
  }

  @Test
  fun setUSPrivacyString_invokesSetUSPrivacyString() {
    val plugin = GmaMediationDTExchangePlugin()
    mockStatic(InneractiveAdManager::class.java).use { mockedDTExchangeAdManager ->

      plugin.setUSPrivacyString(TEST_CONSENT_STRING)

      mockedDTExchangeAdManager.verify {
        InneractiveAdManager.setUSPrivacyString(eq(TEST_CONSENT_STRING))
      }
    }
  }

  companion object {
    const val TEST_CONSENT_STRING = "testConsentString"
  }
}
