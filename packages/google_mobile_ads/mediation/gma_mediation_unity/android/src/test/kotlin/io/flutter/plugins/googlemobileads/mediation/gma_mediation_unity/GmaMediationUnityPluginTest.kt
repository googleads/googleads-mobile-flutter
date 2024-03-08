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
