// Copyright 2026 Google LLC
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

import androidx.annotation.NonNull;
import com.google.android.gms.ads.AdError;
import com.google.android.libraries.ads.mobile.sdk.common.AdEventCallback;
import com.google.android.libraries.ads.mobile.sdk.common.AdValue;
import com.google.android.libraries.ads.mobile.sdk.common.FullScreenContentError;

/**
 * Flutter implementation of {@link FullScreenContentCallback}. Forwards events to
 * AdInstanceManager.
 */
class FlutterFullScreenContentCallback implements AdEventCallback {

  @NonNull protected final AdInstanceManager manager;

  @NonNull protected final int adId;

  public FlutterFullScreenContentCallback(@NonNull AdInstanceManager manager, int adId) {
    this.manager = manager;
    this.adId = adId;
  }

  @Override
  public void onAdFailedToShowFullScreenContent(@NonNull FullScreenContentError adError) {
    manager.onFailedToShowFullScreenContent(
        adId,
        new AdError(
            adError.getCode().getValue(),
            adError.getMessage(),
            "com.google.android.libraries.ads.mobile.sdk"));
  }

  @Override
  public void onAdShowedFullScreenContent() {
    manager.onAdShowedFullScreenContent(adId);
  }

  @Override
  public void onAdDismissedFullScreenContent() {
    manager.onAdDismissedFullScreenContent(adId);
  }

  @Override
  public void onAdImpression() {
    manager.onAdImpression(adId);
  }

  @Override
  public void onAdClicked() {
    manager.onAdClicked(adId);
  }

  @Override
  public void onAdPaid(@NonNull AdValue adValue) {
    FlutterAd ad = manager.adForId(adId);
    if (ad != null) {
      manager.onPaidEvent(ad, AdInstanceManager.comAdValueToFlutterAdValue(adValue));
    }
  }
}
