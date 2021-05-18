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
import com.google.android.gms.ads.LoadAdError;
import com.google.android.gms.ads.admanager.AdManagerInterstitialAd;
import com.google.android.gms.ads.admanager.AdManagerInterstitialAdLoadCallback;
import com.google.android.gms.ads.admanager.AppEventListener;

/**
 * Wrapper around {@link com.google.android.gms.ads.admanager.AdManagerInterstitialAd} for the
 * Google Mobile Ads Plugin.
 */
class FlutterAdManagerInterstitialAd extends FlutterAd.FlutterOverlayAd {
  private static final String TAG = "FlutterAdManagerInterstitialAd";

  @NonNull private final AdInstanceManager manager;
  @NonNull private final String adUnitId;
  @NonNull private final FlutterAdManagerAdRequest request;
  @Nullable private AdManagerInterstitialAd ad;
  @NonNull private final FlutterAdLoader flutterAdLoader;

  /**
   * Constructs a `FlutterAdManagerInterstitialAd`.
   *
   * <p>Call `load()` to instantiate the `AdView` and load the `AdRequest`. `getView()` will return
   * null only until `load` is called.
   */
  public FlutterAdManagerInterstitialAd(
      @NonNull AdInstanceManager manager,
      @NonNull String adUnitId,
      @NonNull FlutterAdManagerAdRequest request,
      @NonNull FlutterAdLoader flutterAdLoader) {
    this.manager = manager;
    this.adUnitId = adUnitId;
    this.request = request;
    this.flutterAdLoader = flutterAdLoader;
  }

  @Override
  void load() {
    flutterAdLoader.loadAdManagerInterstitial(
        manager.activity,
        adUnitId,
        request.asAdManagerAdRequest(),
        new AdManagerInterstitialAdLoadCallback() {
          @Override
          public void onAdLoaded(@NonNull AdManagerInterstitialAd adManagerInterstitialAd) {
            FlutterAdManagerInterstitialAd.this.ad = adManagerInterstitialAd;
            ad.setAppEventListener(
                new AppEventListener() {
                  @Override
                  public void onAppEvent(@NonNull String name, @NonNull String data) {
                    manager.onAppEvent(FlutterAdManagerInterstitialAd.this, name, data);
                  }
                });
            manager.onAdLoaded(
                FlutterAdManagerInterstitialAd.this, adManagerInterstitialAd.getResponseInfo());
          }

          @Override
          public void onAdFailedToLoad(@NonNull LoadAdError loadAdError) {
            manager.onAdFailedToLoad(
                FlutterAdManagerInterstitialAd.this, new FlutterLoadAdError(loadAdError));
            super.onAdFailedToLoad(loadAdError);
          }
        });
  }

  @Override
  public void show() {
    if (ad == null) {
      Log.e(TAG, "The interstitial wasn't loaded yet.");
      return;
    }
    ad.setFullScreenContentCallback(new FlutterFullScreenContentCallback(manager, this));
    ad.show(manager.activity);
  }
}
