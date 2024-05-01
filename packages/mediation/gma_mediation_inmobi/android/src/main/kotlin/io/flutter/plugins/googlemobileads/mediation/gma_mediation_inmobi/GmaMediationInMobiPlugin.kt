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

import com.google.ads.mediation.inmobi.InMobiConsent
import com.inmobi.sdk.InMobiSdk
import io.flutter.embedding.engine.plugins.FlutterPlugin
import org.json.JSONException
import org.json.JSONObject

/** Manages InMobiPrivacyApi and implements the needed methods. */
class GmaMediationInMobiPlugin : FlutterPlugin, InMobiPrivacyApi {
  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    InMobiPrivacyApi.setUp(flutterPluginBinding.binaryMessenger, this)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    InMobiPrivacyApi.setUp(binding.binaryMessenger, null)
  }

  override fun updateGDPRConsent(isGDPRApplicable: Boolean, gdprConsent: Boolean) {
    val consentObject = JSONObject()
    consentObject.put(InMobiSdk.IM_GDPR_CONSENT_AVAILABLE, gdprConsent)
    consentObject.put("gdpr", if (isGDPRApplicable) "1" else "0")
    InMobiConsent.updateGDPRConsent(consentObject)
  }
}
