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
import com.applovin.sdk.AppLovinPrivacySettings
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

/** Links the Android dependency of the AppLovin Adapter and calls the AppLovin SDK APIs. */
class GmaMediationApplovinPlugin : FlutterPlugin, ActivityAware, AppLovinSDKApi {
  private lateinit var context: Context

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    context = flutterPluginBinding.applicationContext
    AppLovinSDKApi.setUp(flutterPluginBinding.binaryMessenger, this)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    AppLovinSDKApi.setUp(binding.binaryMessenger, null)
  }

  override fun setHasUserConsent(hasUserConsent: Boolean) {
    AppLovinPrivacySettings.setHasUserConsent(hasUserConsent, context)
  }

  override fun setDoNotSell(doNotSell: Boolean) {
    AppLovinPrivacySettings.setDoNotSell(doNotSell, context)
  }

  override fun onDetachedFromActivity() {}

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {}

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {}

  override fun onDetachedFromActivityForConfigChanges() {}
}
