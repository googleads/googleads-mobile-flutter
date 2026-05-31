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
import com.google.android.gms.ads.admanager.AdManagerAdRequest;
import com.google.android.gms.ads.admanager.AdManagerInterstitialAd;
import com.google.android.gms.ads.admanager.AdManagerInterstitialAdLoadCallback;
import com.google.android.gms.ads.admanager.AppEventListener;
import com.google.android.gms.ads.interstitial.InterstitialAdPreloader;
import java.lang.ref.WeakReference;

/**
 * Wrapper around {@link com.google.android.gms.ads.admanager.AdManagerInterstitialAd} for the
 * Google Mobile Ads Plugin.
 */
class FlutterAdManagerInterstitialAd extends FlutterAd.FlutterOverlayAd {
  private static final String TAG = "FltGAMInterstitialAd";

  @NonNull private final AdInstanceManager manager;
  @NonNull private final String adUnitId;
  @NonNull private final FlutterAdManagerAdRequest request;
  @Nullable private AdManagerInterstitialAd ad;
  @NonNull private final FlutterAdLoader flutterAdLoader;
  @Nullable private final String preloadId;

  /**
   * Constructs a `FlutterAdManagerInterstitialAd`.
   *
   * <p>Call `load()` to instantiate the `AdView` and load the `AdRequest`. `getView()` will return
   * null only until `load` is called.
   */
  public FlutterAdManagerInterstitialAd(
      int adId,
      @NonNull AdInstanceManager manager,
      @NonNull String adUnitId,
      @NonNull FlutterAdManagerAdRequest request,
      @NonNull FlutterAdLoader flutterAdLoader,
      @Nullable String preloadId) {
    super(adId);
    this.manager = manager;
    this.adUnitId = adUnitId;
    this.request = request;
    this.flutterAdLoader = flutterAdLoader;
    this.preloadId = preloadId;
  }

  @Override
  void load() {
    if (preloadId != null) {
      AdManagerInterstitialAd preloadedAd = (AdManagerInterstitialAd) InterstitialAdPreloader.pollAd(preloadId);
      if (preloadedAd != null) {
        onAdLoaded(preloadedAd);
      } else {
        LoadAdError error = new LoadAdError(
            AdManagerAdRequest.ERROR_CODE_INTERNAL_ERROR,
            "Preloaded ad not found or already exhausted for preloadId: " + preloadId,
            "com.google.android.gms.ads",
            null,
            null);
        onAdFailedToLoad(error);
      }
      return;
    }
    flutterAdLoader.loadAdManagerInterstitial(
        adUnitId,
        request.asAdManagerAdRequest(adUnitId),
        new DelegatingAdManagerInterstitialAdCallbacks(this));
  }

  void onAdLoaded(AdManagerInterstitialAd ad) {
    this.ad = ad;
    ad.setAppEventListener(new DelegatingAdManagerInterstitialAdCallbacks(this));
    ad.setOnPaidEventListener(new FlutterPaidEventListener(manager, this));
    manager.onAdLoaded(adId, ad.getResponseInfo());
  }

  void onAdFailedToLoad(LoadAdError loadAdError) {
    manager.onAdFailedToLoad(adId, new FlutterLoadAdError(loadAdError));
  }

  void onAppEvent(@NonNull String name, @NonNull String data) {
    manager.onAppEvent(adId, name, data);
  }

  @Override
  public void show() {
    if (ad == null) {
      Log.e(TAG, "The interstitial wasn't loaded yet.");
      return;
    }
    if (manager.getActivity() == null) {
      Log.e(TAG, "Tried to show interstitial before activity was bound to the plugin.");
      return;
    }
    ad.setFullScreenContentCallback(new FlutterFullScreenContentCallback(manager, adId));
    ad.show(manager.getActivity());
  }

  @Override
  public void setImmersiveMode(boolean immersiveModeEnabled) {
    if (ad == null) {
      Log.e(TAG, "The interstitial wasn't loaded yet.");
      return;
    }
    ad.setImmersiveMode(immersiveModeEnabled);
  }

  @Override
  void dispose() {
    ad = null;
  }

  /**
   * This class delegates various rewarded ad callbacks to FlutterAdManagerInterstitialAd. Maintains
   * a weak reference to avoid memory leaks.
   */
  private static final class DelegatingAdManagerInterstitialAdCallbacks
      extends AdManagerInterstitialAdLoadCallback implements AppEventListener {

    private final WeakReference<FlutterAdManagerInterstitialAd> delegate;

    DelegatingAdManagerInterstitialAdCallbacks(FlutterAdManagerInterstitialAd delegate) {
      this.delegate = new WeakReference<>(delegate);
    }

    @Override
    public void onAdLoaded(@NonNull AdManagerInterstitialAd interstitialAd) {
      if (delegate.get() != null) {
        delegate.get().onAdLoaded(interstitialAd);
      }
    }

    @Override
    public void onAdFailedToLoad(@NonNull LoadAdError loadAdError) {
      if (delegate.get() != null) {
        delegate.get().onAdFailedToLoad(loadAdError);
      }
    }

    @Override
    public void onAppEvent(@NonNull String name, @NonNull String data) {
      if (delegate.get() != null) {
        delegate.get().onAppEvent(name, data);
      }
    }
  }
}
