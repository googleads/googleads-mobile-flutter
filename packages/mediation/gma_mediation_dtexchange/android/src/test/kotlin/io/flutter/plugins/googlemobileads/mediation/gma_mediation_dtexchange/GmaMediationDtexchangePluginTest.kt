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
  fun setLgpdConsent_withTrueValue_invokesSetLgpdConsentWithTrueValue() {
    val plugin = GmaMediationDTExchangePlugin()
    mockStatic(InneractiveAdManager::class.java).use { mockedDTExchangeAdManager ->

      plugin.setLgpdConsent(true)

      mockedDTExchangeAdManager.verify {
        InneractiveAdManager.setLgpdConsent(eq(true))
      }
    }
  }

  @Test
  fun setLgpdConsent_withFalseValue_invokesSetLgpdConsentWithFalseValue() {
    val plugin = GmaMediationDTExchangePlugin()
    mockStatic(InneractiveAdManager::class.java).use { mockedDTExchangeAdManager ->

      plugin.setLgpdConsent(false)

      mockedDTExchangeAdManager.verify {
        InneractiveAdManager.setLgpdConsent(eq(false))
      }
    }
  }

  @Test
  fun clearLgpdConsentData_invokesClearLgpdConsentData() {
    val plugin = GmaMediationDTExchangePlugin()
    mockStatic(InneractiveAdManager::class.java).use { mockedDTExchangeAdManager ->

      plugin.clearLgpdConsentData()

      mockedDTExchangeAdManager.verify {
        InneractiveAdManager.clearLgpdConsentData()
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

  @Test
  fun clearUSPrivacyString_invokesClearUSPrivacyString() {
    val plugin = GmaMediationDTExchangePlugin()
    mockStatic(InneractiveAdManager::class.java).use { mockedDTExchangeAdManager ->

      plugin.clearUSPrivacyString()

      mockedDTExchangeAdManager.verify {
        InneractiveAdManager.clearUSPrivacyString()
      }
    }
  }

  companion object {
    const val TEST_CONSENT_STRING = "testConsentString"
  }
}
