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

package io.flutter.plugins.googlemobileads.mediation.gma_mediation_dtexchange

import android.os.Bundle
import android.util.Pair
import androidx.core.os.bundleOf
import com.fyber.inneractive.sdk.external.InneractiveMediationDefs
import com.google.ads.mediation.fyber.FyberMediationAdapter
// import com.google.ads.mediation.fyber.FyberMediationAdapter.KEY_MUTE_VIDEO
import com.google.android.gms.ads.mediation.MediationExtrasReceiver
import io.flutter.plugins.googlemobileads.FlutterMediationExtras

class DTExchangeFlutterMediationExtras : FlutterMediationExtras() {
  private var flutterExtras: Map<String, Any>? = null

  override fun setMediationExtras(extras: MutableMap<String, Any>?) {
    flutterExtras = extras
  }
  override fun getMediationExtras(): Pair<Class<out MediationExtrasReceiver>, Bundle> {
    val extrasMap = flutterExtras
    if (extrasMap == null) {
      return Pair<Class<out MediationExtrasReceiver>, Bundle>(FyberMediationAdapter::class.java, bundleOf())
    }
    val extrasBundle = bundleOf()
    val muteVideo = extrasMap[MUTE_VIDEO]
    if (muteVideo is Boolean) {
      // extrasBundle.putBoolean(KEY_MUTE_VIDEO, muteVideo)
      extrasBundle.putBoolean(MUTE_VIDEO, muteVideo)
    }
    val age = extrasMap[AGE]
    if (age is Int) {
      extrasBundle.putInt(InneractiveMediationDefs.KEY_AGE, age)
    }
    return Pair<Class<out MediationExtrasReceiver>, Bundle>(FyberMediationAdapter::class.java, extrasBundle)
  }

  companion object {
    private const val MUTE_VIDEO = "muteVideo"
    private const val AGE = "age"
  }
}