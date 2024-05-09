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
import com.unity3d.ads.metadata.MetaData
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

/** GmaMediationUnityPlugin manages UnityPrivacyApi and implements the needed methods. */
class GmaMediationUnityPlugin: FlutterPlugin, ActivityAware, UnityPrivacyApi {
  private lateinit var context: Context

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    context = flutterPluginBinding.applicationContext
    UnityPrivacyApi.setUp(flutterPluginBinding.binaryMessenger, this)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    UnityPrivacyApi.setUp(binding.binaryMessenger, null)
  }

  override fun onDetachedFromActivity() {}

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {}

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {}

  override fun onDetachedFromActivityForConfigChanges() {}

  override fun setGDPRConsent(gdprConsent: Boolean) {
    val gdprMetaData = UnityApiWrapper.createMetaData(context)
    gdprMetaData.set("gdpr.consent", gdprConsent)
    gdprMetaData.commit()
  }

  override fun setCCPAConsent(ccpaConsent: Boolean) {
    val ccpaMetaData = UnityApiWrapper.createMetaData(context)
    ccpaMetaData.set("privacy.consent", ccpaConsent)
    ccpaMetaData.commit()
  }
}

/** Wrapper singleton to enable mocking of [MetaData] class for unit testing. */
object UnityApiWrapper {
  @JvmStatic
  fun createMetaData(context: Context) = MetaData(context)
}
