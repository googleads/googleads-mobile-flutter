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

import android.os.Bundle
import android.util.Pair
import androidx.core.os.bundleOf
import com.applovin.mediation.ApplovinAdapter
import com.applovin.mediation.AppLovinExtras
import com.google.android.gms.ads.mediation.MediationExtrasReceiver
import io.flutter.plugins.googlemobileads.FlutterMediationExtras

class AppLovinFlutterMediationExtras : FlutterMediationExtras() {
  private var flutterExtras: Map<String, Any>? = null

  override fun setMediationExtras(extras: MutableMap<String, Any>) {
    flutterExtras = extras
  }

  override fun getMediationExtras(): Pair<Class<out MediationExtrasReceiver>, Bundle> {
    val extrasMap = flutterExtras
    if (extrasMap == null) {
      return Pair<Class<out MediationExtrasReceiver>, Bundle>(ApplovinAdapter::class.java, bundleOf())
    }
    var extrasBundle = bundleOf()
    val isMutedValue = extrasMap[IS_MUTED]
    if (isMutedValue is Boolean) {
      extrasBundle = AppLovinExtras.Builder().setMuteAudio(isMutedValue).build()
    }
    return Pair<Class<out MediationExtrasReceiver>, Bundle>(ApplovinAdapter::class.java, extrasBundle)
  }

  companion object {
    private const val IS_MUTED = "isMuted"
  }
}
