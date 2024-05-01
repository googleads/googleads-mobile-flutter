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

package io.flutter.plugins.googlemobileads.mediation.gma_mediation_inmobi

import androidx.test.ext.junit.runners.AndroidJUnit4
import com.google.ads.mediation.inmobi.InMobiConsent
import com.google.common.truth.Truth.assertThat
import com.inmobi.sdk.InMobiSdk
import org.json.JSONObject
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mockito.mockStatic
import org.mockito.kotlin.argumentCaptor
import org.mockito.kotlin.eq

@RunWith(AndroidJUnit4::class)
public class GmaMediationInmobiPluginTest {
  @Test
  fun updateGDPRConsent_mapsProperFalseValues() {
    val plugin = GmaMediationInMobiPlugin()
    val captor = argumentCaptor<JSONObject>()
    mockStatic(InMobiConsent::class.java).use { mockedInMobiConsent ->

      plugin.updateGDPRConsent(isGDPRApplicable = false, gdprConsent = false)

      mockedInMobiConsent.verify {
        InMobiConsent.updateGDPRConsent(captor.capture())
        val capturedError = captor.firstValue
        assertThat(capturedError["gdpr"]).isEqualTo("0")
        assertThat(capturedError[InMobiSdk.IM_GDPR_CONSENT_AVAILABLE]).isEqualTo(false)
      }
    }
  }

  @Test
  fun updateGDPRConsent_mapsProperTrueValues() {
    val plugin = GmaMediationInMobiPlugin()
    val captor = argumentCaptor<JSONObject>()
    mockStatic(InMobiConsent::class.java).use { mockedInMobiConsent ->

      plugin.updateGDPRConsent(isGDPRApplicable = true, gdprConsent = true)

      mockedInMobiConsent.verify {
        InMobiConsent.updateGDPRConsent(captor.capture())
        val capturedError = captor.firstValue
        assertThat(capturedError["gdpr"]).isEqualTo("1")
        assertThat(capturedError[InMobiSdk.IM_GDPR_CONSENT_AVAILABLE]).isEqualTo(true)
      }
    }
  }
}
