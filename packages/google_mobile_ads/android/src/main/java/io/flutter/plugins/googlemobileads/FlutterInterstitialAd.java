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

package io.flutter.plugins.googlemobileads;

import android.util.Log;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.google.android.gms.ads.InterstitialAd;

class FlutterInterstitialAd extends FlutterAd.FlutterOverlayAd {
  private static final String TAG = "FlutterInterstitialAd";

  @NonNull private final AdInstanceManager manager;
  @NonNull private final String adUnitId;
  @Nullable private FlutterAdRequest request;
  @Nullable private InterstitialAd ad;

  static class Builder {
    @Nullable private AdInstanceManager manager;
    @Nullable private String adUnitId;
    @Nullable private FlutterAdRequest request;

    public Builder setManager(@NonNull AdInstanceManager manager) {
      this.manager = manager;
      return this;
    }

    public Builder setAdUnitId(@NonNull String adUnitId) {
      this.adUnitId = adUnitId;
      return this;
    }

    public Builder setRequest(@Nullable FlutterAdRequest request) {
      this.request = request;
      return this;
    }

    FlutterInterstitialAd build() {
      if (manager == null) {
        throw new IllegalStateException("AdInstanceManager cannot not be null.");
      } else if (adUnitId == null) {
        throw new IllegalStateException("AdUnitId cannot not be null.");
      }

      final FlutterInterstitialAd interstitialAd = new FlutterInterstitialAd(manager, adUnitId);
      interstitialAd.request = request;
      return interstitialAd;
    }
  }

  private FlutterInterstitialAd(@NonNull AdInstanceManager manager, @NonNull String adUnitId) {
    this.manager = manager;
    this.adUnitId = adUnitId;
  }

  @Override
  void load() {
    ad = new InterstitialAd(manager.activity);
    ad.setAdUnitId(adUnitId);
    ad.setAdListener(new FlutterAdListener(manager, this));

    if (request != null) {
      ad.loadAd(request.asAdRequest());
    } else {
      ad.loadAd(new FlutterAdRequest.Builder().build().asAdRequest());
    }
  }

  @Override
  public void show() {
    if (ad == null || !ad.isLoaded()) {
      Log.e(TAG, "The interstitial wasn't loaded yet.");
      return;
    }
    ad.show();
  }
}
