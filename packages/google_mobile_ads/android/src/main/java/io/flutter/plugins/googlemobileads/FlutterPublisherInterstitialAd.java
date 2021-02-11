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
import androidx.annotation.VisibleForTesting;
import com.google.android.gms.ads.doubleclick.PublisherInterstitialAd;

/**
 * Wrapper around {@link com.google.android.gms.ads.doubleclick.PublisherInterstitialAd} for the
 * Google Mobile Ads Plugin.
 */
class FlutterPublisherInterstitialAd extends FlutterAd.FlutterOverlayAd {
  private static final String TAG = "FLTPubInterstitialAd";

  @NonNull private final AdInstanceManager manager;
  @NonNull private final String adUnitId;
  @Nullable private final FlutterPublisherAdRequest request;
  @Nullable private PublisherInterstitialAd ad;

  /**
   * Constructs a `FlutterPublisherInterstitialAd`.
   *
   * <p>Call `load()` to instantiate the `AdView` and load the `AdRequest`. `getView()` will return
   * null only until `load` is called.
   */
  public FlutterPublisherInterstitialAd(
      @NonNull AdInstanceManager manager,
      @NonNull String adUnitId,
      @Nullable FlutterPublisherAdRequest request) {
    this.manager = manager;
    this.adUnitId = adUnitId;
    this.request = request;
  }

  @Override
  void load() {
    ad = createPublisherInterstitialAd();
    ad.setAdUnitId(adUnitId);
    ad.setAdListener(new FlutterAdListener(manager, this));

    if (request != null) {
      ad.loadAd(request.asPublisherAdRequest());
    } else {
      ad.loadAd(new FlutterPublisherAdRequest.Builder().build().asPublisherAdRequest());
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

  @VisibleForTesting
  PublisherInterstitialAd createPublisherInterstitialAd() {
    return new PublisherInterstitialAd(manager.activity);
  }
}
