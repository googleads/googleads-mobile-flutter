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

package io.flutter.plugins.googlemobileads.mediation.gma_mediation_applovin

import android.content.Context
import androidx.test.core.app.ApplicationProvider
import androidx.test.ext.junit.runners.AndroidJUnit4
import com.applovin.sdk.AppLovinPrivacySettings
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mockito.mockStatic
import org.mockito.kotlin.doReturn
import org.mockito.kotlin.eq
import org.mockito.kotlin.mock
import org.mockito.kotlin.verify

@RunWith(AndroidJUnit4::class)
internal class GmaMediationApplovinPluginTest {
  private val context = ApplicationProvider.getApplicationContext<Context>()
  private val mockBinaryMessenger = mock<BinaryMessenger>()
  private val mockFlutterPluginBinding =
    mock<FlutterPlugin.FlutterPluginBinding> {
      on { applicationContext } doReturn context
      on { binaryMessenger } doReturn mockBinaryMessenger
    }

  @Test
  fun setHasUserConsent_withTrueValue_invokesSetHasUserConsent() {
    val plugin = GmaMediationApplovinPlugin()
    mockStatic(AppLovinPrivacySettings::class.java).use { mockedAppLovinPrivacySettings ->
      plugin.onAttachedToEngine(mockFlutterPluginBinding)

      plugin.setHasUserConsent(true)

      mockedAppLovinPrivacySettings.verify {
        AppLovinPrivacySettings.setHasUserConsent(eq(true), eq(context))
      }
    }
  }

  @Test
  fun setDoNotSell_withTrueValue_invokesSetDoNotSell() {
    val plugin = GmaMediationApplovinPlugin()
    mockStatic(AppLovinPrivacySettings::class.java).use { mockedAppLovinPrivacySettings ->
      plugin.onAttachedToEngine(mockFlutterPluginBinding)

      plugin.setDoNotSell(true)

      mockedAppLovinPrivacySettings.verify {
        AppLovinPrivacySettings.setDoNotSell(eq(true), eq(context))
      }
    }
  }
}
