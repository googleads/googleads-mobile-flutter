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

import android.util.Log;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.google.android.gms.ads.AdError;
import com.google.android.libraries.ads.mobile.sdk.common.AdValue;
import com.google.android.libraries.ads.mobile.sdk.common.FullScreenContentError;
import com.google.android.libraries.ads.mobile.sdk.common.LoadAdError;
import com.google.android.libraries.ads.mobile.sdk.common.AdLoadCallback;
import com.google.android.libraries.ads.mobile.sdk.interstitial.InterstitialAd;
import com.google.android.libraries.ads.mobile.sdk.interstitial.InterstitialAdEventCallback;
import java.lang.ref.WeakReference;

class FlutterInterstitialAd extends FlutterAd.FlutterOverlayAd {
  private static final String TAG = "FlutterInterstitialAd";

  @NonNull protected final AdInstanceManager manager;
  @NonNull private final String adUnitId;
  @NonNull private final FlutterAdRequest request;
  @Nullable private InterstitialAd ad;
  @NonNull private final FlutterAdLoader flutterAdLoader;

  public FlutterInterstitialAd(
      int adId,
      @NonNull AdInstanceManager manager,
      @NonNull String adUnitId,
      @NonNull FlutterAdRequest request,
      @NonNull FlutterAdLoader flutterAdLoader) {
    super(adId);
    this.manager = manager;
    this.adUnitId = adUnitId;
    this.request = request;
    this.flutterAdLoader = flutterAdLoader;
  }

  @Override
  void load() {
    if (manager != null && adUnitId != null && request != null) {
      flutterAdLoader.loadInterstitial(
          request.asAdRequest(adUnitId), new DelegatingInterstitialAdLoadCallback(this));
    }
  }

  void onAdLoaded(InterstitialAd ad) {
    this.ad = ad;
    manager.onAdLoaded(adId, ad.getResponseInfo());
  }

  void onAdFailedToLoad(LoadAdError loadAdError) {
    manager.onAdFailedToLoad(adId, new FlutterAd.FlutterLoadAdError(loadAdError));
  }

  @Override
  void dispose() {
    ad = null;
  }

  @Override
  public void show() {
    if (ad == null) {
      Log.e(TAG, "Error showing interstitial - the interstitial ad wasn't loaded yet.");
      return;
    }
    if (manager.getActivity() == null) {
      Log.e(TAG, "Tried to show interstitial before activity was bound to the plugin.");
      return;
    }
    ad.setAdEventCallback(new DelegatingInterstitialAdLoadCallback(this));
    ad.show(manager.getActivity());
  }

  @Override
  public void setImmersiveMode(boolean immersiveModeEnabled) {
    if (ad == null) {
      Log.e(
          TAG,
          "Error setting immersive mode in interstitial ad - the interstitial ad wasn't loaded"
              + " yet.");
      return;
    }
    ad.setImmersiveMode(immersiveModeEnabled);
  }

  /** An AdLoadCallback that just forwards events to a delegate. */
  private static final class DelegatingInterstitialAdLoadCallback
      implements AdLoadCallback<InterstitialAd>, InterstitialAdEventCallback {

    private final WeakReference<FlutterInterstitialAd> delegate;

    DelegatingInterstitialAdLoadCallback(FlutterInterstitialAd delegate) {
      this.delegate = new WeakReference<>(delegate);
    }

    @Override
    public void onAdLoaded(@NonNull InterstitialAd interstitialAd) {
      FlutterInterstitialAd ad = delegate.get();
      if (ad != null) {
        ad.onAdLoaded(interstitialAd);
      }
    }

    @Override
    public void onAdFailedToLoad(@NonNull LoadAdError loadAdError) {
      FlutterInterstitialAd ad = delegate.get();
      if (ad != null) {
        ad.onAdFailedToLoad(loadAdError);
      }
    }

    @Override
    public void onAdFailedToShowFullScreenContent(@NonNull FullScreenContentError adError) {
      FlutterInterstitialAd ad = delegate.get();
      if (ad != null) {
        ad.manager.onFailedToShowFullScreenContent(
            ad.adId,
            new AdError(
                adError.getCode().getValue(),
                adError.getMessage(),
                AdInstanceManager.NEXT_GEN_DOMAIN));
      }
    }

    @Override
    public void onAdShowedFullScreenContent() {
      FlutterInterstitialAd ad = delegate.get();
      if (ad != null) {
        ad.manager.onAdShowedFullScreenContent(ad.adId);
      }
    }

    @Override
    public void onAdDismissedFullScreenContent() {
      FlutterInterstitialAd ad = delegate.get();
      if (ad != null) {
        ad.manager.onAdDismissedFullScreenContent(ad.adId);
      }
    }

    @Override
    public void onAdImpression() {
      FlutterInterstitialAd ad = delegate.get();
      if (ad != null) {
        ad.manager.onAdImpression(ad.adId);
      }
    }

    @Override
    public void onAdClicked() {
      FlutterInterstitialAd ad = delegate.get();
      if (ad != null) {
        ad.manager.onAdClicked(ad.adId);
      }
    }

    @Override
    public void onAdPaid(@NonNull AdValue adValue) {
      FlutterInterstitialAd ad = delegate.get();
      if (ad != null) {
        ad.manager.onPaidEvent(
            ad,
            AdInstanceManager.comAdValueToFlutterAdValue(adValue));
      }
    }

    @Override
    public void onAppEvent(@NonNull String name, @NonNull String data) {
      FlutterInterstitialAd ad = delegate.get();
      if (ad != null) {
        ad.manager.onAppEvent(ad.adId, name, data);
      }
    }
  }
}
