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
import com.google.android.libraries.ads.mobile.sdk.appopen.AppOpenAd;
import com.google.android.libraries.ads.mobile.sdk.appopen.AppOpenAdEventCallback;
import com.google.android.gms.ads.AdError;
import com.google.android.libraries.ads.mobile.sdk.common.AdLoadCallback;
import com.google.android.libraries.ads.mobile.sdk.common.AdValue;
import com.google.android.libraries.ads.mobile.sdk.common.FullScreenContentError;
import com.google.android.libraries.ads.mobile.sdk.common.LoadAdError;
import io.flutter.util.Preconditions;
import java.lang.ref.WeakReference;

/** A wrapper for {@link com.google.android.gms.ads.appopen.AppOpenAd}. */
class FlutterAppOpenAd extends FlutterAd.FlutterOverlayAd {

  private static final String TAG = "FlutterAppOpenAd";

  @NonNull private final AdInstanceManager manager;
  @NonNull private final String adUnitId;
  @Nullable private final FlutterAdRequest request;
  @Nullable private final FlutterAdManagerAdRequest adManagerAdRequest;
  @Nullable private AppOpenAd ad;
  @NonNull private final FlutterAdLoader flutterAdLoader;

  FlutterAppOpenAd(
      int adId,
      @NonNull AdInstanceManager manager,
      @NonNull String adUnitId,
      @Nullable FlutterAdRequest request,
      @Nullable FlutterAdManagerAdRequest adManagerAdRequest,
      @NonNull FlutterAdLoader flutterAdLoader) {
    super(adId);
    Preconditions.checkState(
        request != null || adManagerAdRequest != null,
        "One of request and adManagerAdRequest must be non-null.");
    this.manager = manager;
    this.adUnitId = adUnitId;
    this.request = request;
    this.adManagerAdRequest = adManagerAdRequest;
    this.flutterAdLoader = flutterAdLoader;
  }

  @Override
  void load() {
    if (request != null) {
      flutterAdLoader.loadAppOpen(
          request.asAdRequest(adUnitId), new DelegatingAppOpenAdLoadCallback(this));
    } else if (adManagerAdRequest != null) {
      flutterAdLoader.loadAdManagerAppOpen(
          adManagerAdRequest.asAdManagerAdRequest(adUnitId),
          new DelegatingAppOpenAdLoadCallback(this));
    }
  }

  void onAdLoaded(@NonNull AppOpenAd ad) {
    this.ad = ad;
    manager.onAdLoaded(adId, ad.getResponseInfo());
  }

  void onAdFailedToLoad(@NonNull LoadAdError loadAdError) {
    manager.onAdFailedToLoad(adId, new FlutterLoadAdError(loadAdError));
  }

  @Override
  void show() {
    if (ad == null) {
      Log.w(TAG, "Tried to show app open ad before it was loaded");
      return;
    }
    if (manager.getActivity() == null) {
      Log.e(TAG, "Tried to show app open ad before activity was bound to the plugin.");
      return;
    }
    ad.setAdEventCallback(new DelegatingAppOpenAdLoadCallback(this));
    ad.show(manager.getActivity());
  }

  @Override
  void setImmersiveMode(boolean immersiveModeEnabled) {
    if (ad == null) {
      Log.w(TAG, "Tried to set immersive mode on app open ad before it was loaded");
      return;
    }
    ad.setImmersiveMode(immersiveModeEnabled);
  }

  @Override
  void dispose() {
    ad = null;
  }

  /** An AppOpenAdLoadCallback that just forwards events to a delegate. */
  private static final class DelegatingAppOpenAdLoadCallback
      implements AdLoadCallback<AppOpenAd>, AppOpenAdEventCallback {

    private final WeakReference<FlutterAppOpenAd> delegate;

    DelegatingAppOpenAdLoadCallback(FlutterAppOpenAd delegate) {
      this.delegate = new WeakReference<>(delegate);
    }

    @Override
    public void onAdLoaded(@NonNull AppOpenAd appOpenAd) {
      FlutterAppOpenAd ad = delegate.get();
      if (ad != null) {
        ad.onAdLoaded(appOpenAd);
      }
    }

    @Override
    public void onAdFailedToLoad(@NonNull LoadAdError loadAdError) {
      FlutterAppOpenAd ad = delegate.get();
      if (ad != null) {
        ad.onAdFailedToLoad(loadAdError);
      }
    }

    @Override
    public void onAdFailedToShowFullScreenContent(@NonNull FullScreenContentError adError) {
      FlutterAppOpenAd ad = delegate.get();
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
      FlutterAppOpenAd ad = delegate.get();
      if (ad != null) {
        ad.manager.onAdShowedFullScreenContent(ad.adId);
      }
    }

    @Override
    public void onAdDismissedFullScreenContent() {
      FlutterAppOpenAd ad = delegate.get();
      if (ad != null) {
        ad.manager.onAdDismissedFullScreenContent(ad.adId);
      }
    }

    @Override
    public void onAdImpression() {
      FlutterAppOpenAd ad = delegate.get();
      if (ad != null) {
        ad.manager.onAdImpression(ad.adId);
      }
    }

    @Override
    public void onAdClicked() {
      FlutterAppOpenAd ad = delegate.get();
      if (ad != null) {
        ad.manager.onAdClicked(ad.adId);
      }
    }

    @Override
    public void onAdPaid(@NonNull AdValue adValue) {
      FlutterAppOpenAd ad = delegate.get();
      if (ad != null) {
        ad.manager.onPaidEvent(
            ad,
            AdInstanceManager.comAdValueToFlutterAdValue(adValue));
      }
    }
  }
}
