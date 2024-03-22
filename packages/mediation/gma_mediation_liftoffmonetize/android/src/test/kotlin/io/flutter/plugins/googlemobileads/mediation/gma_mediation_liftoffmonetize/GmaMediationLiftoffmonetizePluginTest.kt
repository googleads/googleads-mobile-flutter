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

package io.flutter.plugins.googlemobileads.mediation.gma_mediation_liftoffmonetize

import androidx.test.ext.junit.runners.AndroidJUnit4
import com.vungle.ads.VunglePrivacySettings
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mockito.mockStatic

@RunWith(AndroidJUnit4::class)
internal class GmaMediationLiftoffmonetizePluginTest {
  @Test
  fun setGDPRStatus_withTruValue_invokesLiftoffSetGDPRStatus() {
    val plugin = GmaMediationLiftoffmonetizePlugin()
    mockStatic(VunglePrivacySettings::class.java).use { mockVunglePrivacySettings ->

      plugin.setGDPRStatus(optedIn= true, consentMessageVersion= TEST_CONSENT_STRING)

      mockVunglePrivacySettings.verify {
        VunglePrivacySettings.setGDPRStatus(true, TEST_CONSENT_STRING)
      }
    }
  }

  @Test
  fun setCCPAStatus_withTruValue_invokesLiftoffSetCCPAStatus() {
    val plugin = GmaMediationLiftoffmonetizePlugin()
    mockStatic(VunglePrivacySettings::class.java).use { mockVunglePrivacySettings ->

      plugin.setCCPAStatus(optedIn= true)

      mockVunglePrivacySettings.verify {
        VunglePrivacySettings.setCCPAStatus(true)
      }
    }
  }

  companion object {
    private const val TEST_CONSENT_STRING = "testConsentString"
  }
}
