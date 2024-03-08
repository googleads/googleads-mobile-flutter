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

package io.flutter.plugins.googlemobileads;

import android.os.Bundle;
import android.util.Pair;
import com.google.android.gms.ads.mediation.MediationExtrasReceiver;
import java.util.Map;

/**
 * Mediation Adapters that require extra parameters provide implementations of this interface to
 * further be sent to the {@link com.google.android.gms.ads.AdRequest}
 *
 * <p>Implementation will receive the Map of Extras via the {@link
 * FlutterMediationExtras#setMediationExtras} which the implementation must store and later parse to
 * the proper pair of Class and Bundle values returned by {@link
 * FlutterMediationExtras#getMediationExtras()}
 */
public abstract class FlutterMediationExtras {
  Map<String, Object> extras;
  /**
   * Called when the {@link FlutterAdRequest} is parsed into an {@link
   * com.google.android.gms.ads.AdRequest}.
   *
   * @return The parsed values to be sent to the {@link
   *     com.google.android.gms.ads.AdRequest.Builder#addNetworkExtrasBundle}
   */
  public abstract Pair<Class<? extends MediationExtrasReceiver>, Bundle> getMediationExtras();

  /**
   * Pair of key-values to be stored and later be parsed into a {@link Bundle}.
   *
   * @param extras Received from the dart layer through the MediationExtras class.
   */
  public void setMediationExtras(Map<String, Object> extras) {
    this.extras = extras;
  }
}
