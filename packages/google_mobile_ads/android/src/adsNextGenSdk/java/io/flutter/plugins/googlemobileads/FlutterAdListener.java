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
import com.google.android.libraries.ads.mobile.sdk.banner.BannerAd;
import com.google.android.libraries.ads.mobile.sdk.banner.BannerAdEventCallback;
import com.google.android.libraries.ads.mobile.sdk.common.AdLoadCallback;
import com.google.android.libraries.ads.mobile.sdk.common.AdValue;
import com.google.android.libraries.ads.mobile.sdk.common.FullScreenContentError;
import com.google.android.libraries.ads.mobile.sdk.common.LoadAdError;
import com.google.android.libraries.ads.mobile.sdk.nativead.NativeAd;
import com.google.android.libraries.ads.mobile.sdk.nativead.NativeAdEventCallback;
import com.google.android.libraries.ads.mobile.sdk.nativead.NativeAdLoaderCallback;
import java.lang.ref.WeakReference;

/** Callback type to notify when an ad successfully loads. */
interface FlutterAdLoadedListener {
  void onAdLoaded();
}

abstract class FlutterAdListener<AdT> implements AdLoadCallback<AdT> {
  protected final int adId;
  @NonNull protected final AdInstanceManager manager;

  FlutterAdListener(int adId, @NonNull AdInstanceManager manager) {
    this.adId = adId;
    this.manager = manager;
  }

  @Override
  public void onAdFailedToLoad(LoadAdError loadAdError) {
    manager.onAdFailedToLoad(adId, new FlutterAd.FlutterLoadAdError(loadAdError));
  }
}

/**
 * Ad listener for banner ads. Does not override onAdClicked(), since that is only for native ads.
 */
class FlutterBannerAdListener extends FlutterAdListener<BannerAd> implements BannerAdEventCallback {

  @NonNull final WeakReference<FlutterAdLoadedListener> adLoadedListenerWeakReference;

  FlutterBannerAdListener(
      int adId, @NonNull AdInstanceManager manager, FlutterAdLoadedListener adLoadedListener) {
    super(adId, manager);
    adLoadedListenerWeakReference = new WeakReference<>(adLoadedListener);
  }

  @Override
  public void onAdLoaded(@NonNull BannerAd ad) {
    if (adLoadedListenerWeakReference.get() != null) {
      adLoadedListenerWeakReference.get().onAdLoaded();
    }
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

/** Listener for native ads. */
class FlutterNativeAdListener implements NativeAdEventCallback {
  private final int adId;
  @NonNull private final AdInstanceManager manager;

  FlutterNativeAdListener(int adId, AdInstanceManager manager) {
    this.adId = adId;
    this.manager = manager;
  }

  @Override
  public void onAdShowedFullScreenContent() {
    manager.onAdOpened(adId);
  }

  @Override
  public void onAdDismissedFullScreenContent() {
    manager.onAdClosed(adId);
  }

  @Override
  public void onAdFailedToShowFullScreenContent(FullScreenContentError fullScreenContentError) {}

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

/** {@link NativeAdLoaderCallback} for native ads. */
class FlutterNativeAdLoadedListener implements NativeAdLoaderCallback {

  private final WeakReference<FlutterNativeAd> nativeAdWeakReference;

  FlutterNativeAdLoadedListener(FlutterNativeAd flutterNativeAd) {
    nativeAdWeakReference = new WeakReference<>(flutterNativeAd);
  }

  @Override
  public void onNativeAdLoaded(@NonNull NativeAd nativeAd) {
    if (nativeAdWeakReference.get() != null) {
      nativeAdWeakReference.get().onNativeAdLoaded(nativeAd);
    }
  }

  @Override
  public void onAdFailedToLoad(LoadAdError loadAdError) {
    if (nativeAdWeakReference.get() != null) {
      nativeAdWeakReference.get().onNativeAdFailed(loadAdError);
    }
  }
}
