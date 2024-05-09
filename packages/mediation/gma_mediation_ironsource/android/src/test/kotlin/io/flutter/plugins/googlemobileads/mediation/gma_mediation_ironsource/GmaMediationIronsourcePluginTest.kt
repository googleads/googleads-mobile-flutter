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

package io.flutter.plugins.googlemobileads.mediation.gma_mediation_ironsource

import androidx.test.ext.junit.runners.AndroidJUnit4
import com.ironsource.mediationsdk.IronSource
import io.flutter.plugins.googlemobileads.mediation.gma_mediation_ironsource.GmaMediationIronsourcePlugin.Companion.FALSE
import io.flutter.plugins.googlemobileads.mediation.gma_mediation_ironsource.GmaMediationIronsourcePlugin.Companion.IRONSOURCE_DONOTSELL_KEY
import io.flutter.plugins.googlemobileads.mediation.gma_mediation_ironsource.GmaMediationIronsourcePlugin.Companion.TRUE
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mockito.mockStatic
import org.mockito.kotlin.eq

@RunWith(AndroidJUnit4::class)
internal class GmaMediationIronsourcePluginTest {
  @Test
  fun setConsent_withTrueValue_invokesIronSourceSetConsent() {
    val plugin = GmaMediationIronsourcePlugin()
    mockStatic(IronSource::class.java).use { mockedIronSource ->

      plugin.setConsent(true)

      mockedIronSource.verify {
        IronSource.setConsent(eq(true))
      }
    }
  }

  @Test
  fun setConsent_withFalseValue_invokesIronSourceSetConsent() {
    val plugin = GmaMediationIronsourcePlugin()
    mockStatic(IronSource::class.java).use { mockedIronSource ->

      plugin.setConsent(false)

      mockedIronSource.verify {
        IronSource.setConsent(eq(false))
      }
    }
  }

  @Test
  fun setDoNotSell_withTrueValue_invokesIronSourceMetaDataWithCorrectKeyAndValue() {
    val plugin = GmaMediationIronsourcePlugin()
    mockStatic(IronSource::class.java).use { mockedIronSource ->

      plugin.setDoNotSell(true)

      mockedIronSource.verify {
        IronSource.setMetaData(eq(IRONSOURCE_DONOTSELL_KEY), eq(TRUE))
      }
    }
  }

  @Test
  fun setDoNotSell_withFalseValue_invokesIronSourceMetaDataWithCorrectKeyAndValue() {
    val plugin = GmaMediationIronsourcePlugin()
    mockStatic(IronSource::class.java).use { mockedIronSource ->

      plugin.setDoNotSell(false)

      mockedIronSource.verify {
        IronSource.setMetaData(eq(IRONSOURCE_DONOTSELL_KEY), eq(FALSE))
      }
    }
  }
}
