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
import com.chartboost.sdk.Chartboost
import com.chartboost.sdk.privacy.model.CCPA
import com.chartboost.sdk.privacy.model.GDPR
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

/** Required to link the Android dependency of the Chartboost Adapter. */
class GmaMediationChartboostPlugin : FlutterPlugin, ActivityAware, ChartboostSDKApi {
  private lateinit var context: Context

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    context = flutterPluginBinding.applicationContext
    ChartboostSDKApi.setUp(flutterPluginBinding.binaryMessenger, this)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    ChartboostSDKApi.setUp(binding.binaryMessenger, null)
  }

  override fun setGDPRConsent(userConsent: Boolean) {
    val dataUserConsent =
      if (userConsent) GDPR(GDPR.GDPR_CONSENT.BEHAVIORAL)
      else GDPR(GDPR.GDPR_CONSENT.NON_BEHAVIORAL)
    Chartboost.addDataUseConsent(context, dataUserConsent)
  }

  override fun setCCPAConsent(userOptIn: Boolean) {
    val dataUseConsent =
      if (userOptIn) CCPA(CCPA.CCPA_CONSENT.OPT_IN_SALE) else CCPA(CCPA.CCPA_CONSENT.OPT_OUT_SALE)
    Chartboost.addDataUseConsent(context, dataUseConsent)
  }

  override fun onDetachedFromActivity() {}

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {}

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {}

  override fun onDetachedFromActivityForConfigChanges() {}
}
