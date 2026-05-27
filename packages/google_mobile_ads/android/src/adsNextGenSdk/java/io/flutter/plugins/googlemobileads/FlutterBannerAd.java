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

import android.app.Activity;
import android.util.Log;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.google.android.libraries.ads.mobile.sdk.banner.AdSize;
import com.google.android.libraries.ads.mobile.sdk.banner.AdView;
import com.google.android.libraries.ads.mobile.sdk.banner.BannerAd;
import com.google.android.libraries.ads.mobile.sdk.banner.BannerAdRequest;
import com.google.android.libraries.ads.mobile.sdk.common.AdLoadCallback;
import com.google.android.libraries.ads.mobile.sdk.common.LoadAdError;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.util.Preconditions;
import java.util.ArrayList;
import java.util.List;

/**
 * A wrapper for {@link AdView}.
 */
class FlutterBannerAd extends FlutterAd implements FlutterAdLoadedListener {

  private static final String TAG = "FlutterBannerAd";

  @NonNull
  protected final AdInstanceManager manager;
  @NonNull
  protected final String adUnitId;
  @NonNull
  private final List<FlutterAdSize> sizes;
  @NonNull private final FlutterAdRequest request;
  @NonNull
  protected final BannerAdCreator bannerAdCreator;
  @Nullable
  protected BannerAd bannerAd;
  @Nullable
  protected AdView adView;

  /**
   * Constructs the FlutterBannerAd.
   */
  public FlutterBannerAd(
      int adId,
      @NonNull AdInstanceManager manager,
      @NonNull String adUnitId,
      FlutterAdRequest flutterAdRequest,  // Kept for compatibility
      @NonNull FlutterAdSize size,
      @NonNull BannerAdCreator bannerAdCreator) {
    this(adId, manager, adUnitId, flutterAdRequest, List.of(size), bannerAdCreator);
  }

  public FlutterBannerAd(
      int adId,
      @NonNull AdInstanceManager manager,
      @NonNull String adUnitId,
      @NonNull FlutterAdRequest request,
      @NonNull List<FlutterAdSize> sizes,
      @NonNull BannerAdCreator bannerAdCreator) {
    super(adId);
    Preconditions.checkNotNull(manager);
    Preconditions.checkNotNull(adUnitId);
    Preconditions.checkNotNull(sizes);
    this.manager = manager;
    this.adUnitId = adUnitId;
    this.request = Preconditions.checkNotNull(request);
    this.sizes = sizes;
    this.bannerAdCreator = bannerAdCreator;
  }

  @Override
  public void onAdLoaded() {
    if (bannerAd != null) {
      manager.onAdLoaded(adId, bannerAd.getResponseInfo());
    }
  }

  @Override
  void load() {
    adView = bannerAdCreator.createAdView();
    final List<AdSize> allSizes = new ArrayList<AdSize>();
    for (int i = 0; i < sizes.size(); i++) {
      FlutterAdSize flutterAdSize = sizes.get(i);
      if (flutterAdSize.getAdSize().isFluid()) {
        allSizes.add(AdSize.FLUID);
        continue;
      }
      AdSize adSize =
          new AdSize(flutterAdSize.getAdSize().getWidth(), flutterAdSize.getAdSize().getHeight());
      allSizes.add(adSize);
    }
    BannerAdRequest adRequest = request.toBannerAdRequestBuilder(adUnitId, allSizes).build();
    adView.loadAd(
        adRequest,
        new AdLoadCallback<BannerAd>() {
          @Override
          public void onAdLoaded(@NonNull BannerAd ad) {
            Activity activity = manager.getActivity();
            if (activity == null) {
              Log.e(TAG, "Tried to load banner ad before plugin is attached to an activity.");
              return;
            }
            bannerAd = ad;
            bannerAd.setAdEventCallback(
                new FlutterBannerAdListener(adId, manager, FlutterBannerAd.this));
            adView.registerBannerAd(bannerAd, activity);
            FlutterBannerAd.this.onAdLoaded();
          }

          @Override
          public void onAdFailedToLoad(@NonNull LoadAdError adError) {
            bannerAd = null;
          }
        });
  }

  @Nullable
  @Override
  public PlatformView getPlatformView() {
    if (adView == null) {
      return null;
    }
    return new FlutterPlatformView(adView);
  }

  @Override
  void dispose() {
    if (bannerAd != null) {
      bannerAd = null;
    }
    if (adView != null) {
      adView.destroy();
    }
  }

  @Nullable
  FlutterAdSize getAdSize() {
    if (adView == null || adView.getBannerAd().getAdSize() == null) {
      return null;
    }
    return new FlutterAdSize(
        adView.getBannerAd().getAdSize().getWidth(), adView.getBannerAd().getAdSize().getHeight());
  }

  boolean isCollapsible() {
    if (bannerAd == null) {
      Log.e(TAG, "Banner ad is not loaded or has been disposed.");
      return false;
    }
    return bannerAd.isCollapsible();
  }
}
