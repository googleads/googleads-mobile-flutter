// Copyright 2021 Google LLC
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

package com.example.mediationexample;

import android.os.Bundle;
import androidx.annotation.Nullable;
import com.applovin.mediation.AppLovinExtras;
import com.applovin.mediation.ApplovinAdapter;
import com.google.android.gms.ads.mediation.MediationExtrasReceiver;
import io.flutter.plugins.googlemobileads.MediationNetworkExtrasProvider;
import java.util.HashMap;
import java.util.Map;

/**
 * Your implementation of {@link MediationNetworkExtrasProvider}. Will be used when ad requests are
 * created to pass mediation extras to the ad request.
 */
final class MyMediationNetworkExtrasProvider implements MediationNetworkExtrasProvider {

  /**
   * Override this method to pass mediation network extras that will be used when ad requests are
   * created.
   */
  @Override
  public Map<Class<? extends MediationExtrasReceiver>, Bundle> getMediationExtras(
      String adUnitId, @Nullable String identifier) {
    Bundle appLovinBundle = new AppLovinExtras.Builder().setMuteAudio(true).build();
    Map<Class<? extends MediationExtrasReceiver>, Bundle> extras = new HashMap<>();
    extras.put(ApplovinAdapter.class, appLovinBundle);

    return extras;
  }
}
