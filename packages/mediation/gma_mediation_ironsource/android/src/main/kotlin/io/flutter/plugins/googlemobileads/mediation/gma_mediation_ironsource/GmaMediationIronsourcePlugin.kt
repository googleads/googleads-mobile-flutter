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

import com.ironsource.mediationsdk.IronSource;
import io.flutter.embedding.engine.plugins.FlutterPlugin

/** GmaMediationIronsourcePlugin manages IronSourcePrivacyApi and implements the needed methods. */
class GmaMediationIronsourcePlugin: FlutterPlugin, IronSourcePrivacyApi {

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    IronSourcePrivacyApi.setUp(flutterPluginBinding.binaryMessenger, this)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    IronSourcePrivacyApi.setUp(binding.binaryMessenger, null)
  }

  override fun setConsent(gdprConsent: Boolean) {
    IronSource.setConsent(gdprConsent)
  }

  override fun setDoNotSell(doNotSell: Boolean) {
    IronSource.setMetaData(IRONSOURCE_DONOTSELL_KEY, if (doNotSell) TRUE else FALSE)
  }

  companion object {
    const val IRONSOURCE_DONOTSELL_KEY = "do_not_sell"
    const val TRUE = "true"
    const val FALSE = "false"
  }
}
