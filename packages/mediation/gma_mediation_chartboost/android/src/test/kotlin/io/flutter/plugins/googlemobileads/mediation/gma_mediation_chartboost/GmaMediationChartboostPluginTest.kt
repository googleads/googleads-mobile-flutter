// Copyright 2024 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package io.flutter.plugins.googlemobileads.mediation.gma_mediation_chartboost

import android.content.Context
import androidx.test.core.app.ApplicationProvider
import androidx.test.ext.junit.runners.AndroidJUnit4
import com.chartboost.sdk.Chartboost
import com.chartboost.sdk.privacy.model.CCPA
import com.chartboost.sdk.privacy.model.GDPR
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mockito.mockStatic
import org.mockito.kotlin.doReturn
import org.mockito.kotlin.eq
import org.mockito.kotlin.mock

@RunWith(AndroidJUnit4::class)
internal class GmaMediationChartboostPluginTest {
  private val context = ApplicationProvider.getApplicationContext<Context>()
  private val mockBinaryMessenger = mock<BinaryMessenger>()
  private val mockFlutterPluginBinding =
    mock<FlutterPlugin.FlutterPluginBinding> {
      on { applicationContext } doReturn context
      on { binaryMessenger } doReturn mockBinaryMessenger
    }

  @Test
  fun setGDPRConsent_withTrueValue_addsDataUserConsentAsBehavioral() {
    val plugin = GmaMediationChartboostPlugin()
    mockStatic(ChartboostSDKApi::class.java).use { mockedchartboostSDKApi ->
      plugin.onAttachedToEngine(mockFlutterPluginBinding)
      val expectedDataUserConsent = GDPR(GDPR.GDPR_CONSENT.BEHAVIORAL)

      plugin.setGDPRConsent(true)

      mockedchartboostSDKApi.verify {
        Chartboost.addDataUseConsent(eq(context), eq(expectedDataUserConsent))
      }
    }
  }

  @Test
  fun setGDPRConsent_withFalseValue_addsDataUserConsentAsNonBehavioral() {
    val plugin = GmaMediationChartboostPlugin()
    mockStatic(ChartboostSDKApi::class.java).use { mockedchartboostSDKApi ->
      plugin.onAttachedToEngine(mockFlutterPluginBinding)
      val expectedDataUserConsent = GDPR(GDPR.GDPR_CONSENT.NON_BEHAVIORAL)

      plugin.setGDPRConsent(false)

      mockedchartboostSDKApi.verify {
        Chartboost.addDataUseConsent(eq(context), eq(expectedDataUserConsent))
      }
    }
  }

  @Test
  fun setCCPAConsent_withTrueValue_addsDataUserConsentAsOptInSale() {
    val plugin = GmaMediationChartboostPlugin()
    mockStatic(ChartboostSDKApi::class.java).use { mockedchartboostSDKApi ->
      plugin.onAttachedToEngine(mockFlutterPluginBinding)
      val expectedDataUserConsent = CCPA(CCPA.CCPA_CONSENT.OPT_IN_SALE)

      plugin.setCCPAConsent(true)

      mockedchartboostSDKApi.verify {
        Chartboost.addDataUseConsent(eq(context), eq(expectedDataUserConsent))
      }
    }
  }

  @Test
  fun setCCPAConsent_withFalseValue_addsDataUserConsentAsOptOutSale() {
    val plugin = GmaMediationChartboostPlugin()
    mockStatic(ChartboostSDKApi::class.java).use { mockedchartboostSDKApi ->
      plugin.onAttachedToEngine(mockFlutterPluginBinding)
      val expectedDataUserConsent = CCPA(CCPA.CCPA_CONSENT.OPT_OUT_SALE)

      plugin.setCCPAConsent(false)

      mockedchartboostSDKApi.verify {
        Chartboost.addDataUseConsent(eq(context), eq(expectedDataUserConsent))
      }
    }
  }
}
