// Copyright 2022 Google LLC
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
import android.view.View;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.google.android.gms.ads.AdListener;
import com.google.android.gms.ads.AdSize;
import com.google.android.gms.ads.BaseAdView;
import com.google.android.gms.ads.admanager.AdManagerAdView;
import com.google.android.gms.ads.formats.AdManagerAdViewOptions;
import com.google.android.gms.ads.formats.OnAdManagerAdViewLoadedListener;
import com.google.android.gms.ads.nativead.NativeAd;
import com.google.android.gms.ads.nativead.NativeAd.OnNativeAdLoadedListener;
import com.google.android.gms.ads.nativead.NativeAdOptions;
import com.google.android.gms.ads.nativead.NativeCustomFormatAd;
import com.google.android.gms.ads.nativead.NativeCustomFormatAd.OnCustomFormatAdLoadedListener;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin.CustomAdFactory;
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin.NativeAdFactory;
import java.util.Map;

/**
 * A central wrapper for {@link AdManagerAdView}, {@link NativeCustomFormatAd} and {@link NativeAd}
 * instances served for a single {@link AdRequest} or {@link AdManagerAdRequest}
 */
class FlutterAdLoaderAd extends FlutterAd
    implements OnAdManagerAdViewLoadedListener,
        OnCustomFormatAdLoadedListener,
        OnNativeAdLoadedListener {
  private static final String TAG = "FlutterAdLoaderAd";

  @NonNull private final AdInstanceManager manager;
  @NonNull private final String adUnitId;
  @NonNull private final FlutterAdLoader adLoader;
  @Nullable private FlutterAdRequest request;
  @Nullable private FlutterAdManagerAdRequest adManagerRequest;
  @Nullable private AdLoaderAdType type;
  @Nullable private String formatId;
  @Nullable private View view;
  @Nullable protected BannerParameters bannerParameters;
  @Nullable protected CustomParameters customParameters;
  @Nullable protected NativeParameters nativeParameters;

  static class Builder {
    @Nullable private AdInstanceManager manager;
    @Nullable private String adUnitId;
    @Nullable private FlutterAdRequest request;
    @Nullable private FlutterAdManagerAdRequest adManagerRequest;
    @Nullable private Integer id;
    @Nullable private FlutterAdLoader adLoader;
    @Nullable private FlutterBannerParameters bannerParameters;
    @Nullable private FlutterCustomParameters customParameters;
    @Nullable private Map<String, CustomAdFactory> customFactories;
    @Nullable private FlutterNativeParameters nativeParameters;
    @Nullable private Map<String, NativeAdFactory> nativeFactories;

    public Builder setId(int id) {
      this.id = id;
      return this;
    }

    public Builder setManager(@NonNull AdInstanceManager manager) {
      this.manager = manager;
      return this;
    }

    public Builder setAdUnitId(@NonNull String adUnitId) {
      this.adUnitId = adUnitId;
      return this;
    }

    public Builder setRequest(@NonNull FlutterAdRequest request) {
      this.request = request;
      return this;
    }

    public Builder setAdManagerRequest(@NonNull FlutterAdManagerAdRequest adManagerRequest) {
      this.adManagerRequest = adManagerRequest;
      return this;
    }

    public Builder setFlutterAdLoader(@NonNull FlutterAdLoader adLoader) {
      this.adLoader = adLoader;
      return this;
    }

    public Builder setBanner(@Nullable FlutterBannerParameters bannerParameters) {
      this.bannerParameters = bannerParameters;
      return this;
    }

    public Builder setCustom(@Nullable FlutterCustomParameters customParameters) {
      this.customParameters = customParameters;
      return this;
    }

    public Builder withAvailableCustomFactories(
        @NonNull Map<String, CustomAdFactory> customFactories) {
      this.customFactories = customFactories;
      return this;
    }

    public Builder setNative(@Nullable FlutterNativeParameters nativeParameters) {
      this.nativeParameters = nativeParameters;
      return this;
    }

    public Builder withAvailableNativeFactories(
        @NonNull Map<String, NativeAdFactory> nativeFactories) {
      this.nativeFactories = nativeFactories;
      return this;
    }

    FlutterAdLoaderAd build() {
      if (manager == null) {
        throw new IllegalStateException("manager must be provided");
      }

      if (adUnitId == null) {
        throw new IllegalStateException("adUnitId must be provided");
      }

      if (request == null && adManagerRequest == null) {
        throw new IllegalStateException("Either request or adManagerRequest must be provided");
      }

      final FlutterAdLoaderAd adLoaderAd;

      if (request == null) {
        adLoaderAd = new FlutterAdLoaderAd(id, manager, adUnitId, adManagerRequest, adLoader);
      } else {
        adLoaderAd = new FlutterAdLoaderAd(id, manager, adUnitId, request, adLoader);
      }

      if (bannerParameters != null) {
        adLoaderAd.bannerParameters =
            bannerParameters.asBannerParameters(
                new FlutterAdManagerAdViewLoadedListener(adLoaderAd));
      }

      if (customParameters != null) {
        adLoaderAd.customParameters =
            customParameters.asCustomParameters(
                new FlutterCustomFormatAdLoadedListener(adLoaderAd), customFactories);
      }

      if (nativeParameters != null) {
        adLoaderAd.nativeParameters =
            nativeParameters.asNativeParameters(
                new FlutterNativeAdLoadedListener(adLoaderAd), nativeFactories);
      }

      return adLoaderAd;
    }
  }

  enum AdLoaderAdType {
    UNKNOWN,
    BANNER,
    CUSTOM,
    NATIVE,
  }

  static class BannerParameters {
    @NonNull final OnAdManagerAdViewLoadedListener listener;
    @NonNull final AdSize[] adSizes;
    @Nullable final AdManagerAdViewOptions adManagerAdViewOptions;

    BannerParameters(
        @NonNull OnAdManagerAdViewLoadedListener listener,
        @NonNull AdSize[] adSizes,
        @Nullable AdManagerAdViewOptions adManagerAdViewOptions) {
      this.listener = listener;
      this.adSizes = adSizes;
      this.adManagerAdViewOptions = adManagerAdViewOptions;
    }
  }

  static class CustomParameters {
    @NonNull final OnCustomFormatAdLoadedListener listener;
    @NonNull final Map<String, CustomAdFactory> factories;
    @Nullable final Map<String, Object> viewOptions;

    CustomParameters(
        @NonNull OnCustomFormatAdLoadedListener listener,
        @NonNull Map<String, CustomAdFactory> factories,
        @Nullable Map<String, Object> viewOptions) {
      this.listener = listener;
      this.factories = factories;
      this.viewOptions = viewOptions;
    }
  }

  static class NativeParameters {
    @NonNull final OnNativeAdLoadedListener listener;
    @NonNull final NativeAdFactory factory;
    @Nullable final NativeAdOptions nativeAdOptions;
    @Nullable final Map<String, Object> viewOptions;

    NativeParameters(
        @NonNull OnNativeAdLoadedListener listener,
        @NonNull NativeAdFactory factory,
        @Nullable NativeAdOptions nativeAdOptions,
        @Nullable Map<String, Object> viewOptions) {
      this.listener = listener;
      this.factory = factory;
      this.nativeAdOptions = nativeAdOptions;
      this.viewOptions = viewOptions;
    }
  }

  protected FlutterAdLoaderAd(
      int adId,
      @NonNull AdInstanceManager manager,
      @NonNull String adUnitId,
      @NonNull FlutterAdRequest request,
      @NonNull FlutterAdLoader adLoader) {
    super(adId);

    this.type = AdLoaderAdType.UNKNOWN;
    this.formatId = null;

    this.manager = manager;
    this.adUnitId = adUnitId;
    this.request = request;
    this.adLoader = adLoader;
  }

  protected FlutterAdLoaderAd(
      int adId,
      @NonNull AdInstanceManager manager,
      @NonNull String adUnitId,
      @NonNull FlutterAdManagerAdRequest adManagerRequest,
      @NonNull FlutterAdLoader adLoader) {
    super(adId);

    this.type = AdLoaderAdType.UNKNOWN;
    this.formatId = null;

    this.manager = manager;
    this.adUnitId = adUnitId;
    this.adManagerRequest = adManagerRequest;
    this.adLoader = adLoader;
  }

  @Override
  void load() {
    final AdListener adListener = new FlutterAdLoaderAdListener(adId, manager);
    // Note we delegate loading the ad to FlutterAdLoader mainly for testing purposes.
    // As of 20.0.0 of GMA, mockito is unable to mock AdLoader.
    if (request != null) {
      adLoader.loadAdLoaderAd(
          adUnitId,
          adListener,
          request.asAdRequest(adUnitId),
          bannerParameters,
          customParameters,
          nativeParameters);
      return;
    }

    if (adManagerRequest != null) {
      adLoader.loadAdManagerAdLoaderAd(
          adUnitId,
          adListener,
          adManagerRequest.asAdManagerAdRequest(adUnitId),
          bannerParameters,
          customParameters,
          nativeParameters);
      return;
    }

    Log.e(TAG, "A null or invalid ad request was provided.");
  }

  @Nullable
  AdLoaderAdType getAdLoaderAdType() {
    return type;
  }

  @Nullable
  FlutterAdSize getAdSize() {
    if (view == null || !(view instanceof AdManagerAdView)) {
      return null;
    }
    return new FlutterAdSize(((AdManagerAdView) view).getAdSize());
  }

  @Nullable
  String getFormatId() {
    return formatId;
  }

  @Override
  @Nullable
  public PlatformView getPlatformView() {
    if (view == null) {
      return null;
    }

    return new FlutterPlatformView(view);
  }

  @Override
  public void onAdManagerAdViewLoaded(@NonNull AdManagerAdView adView) {
    view = adView;
    type = AdLoaderAdType.BANNER;
    manager.onAdLoaded(adId, adView.getResponseInfo());
  }

  @Override
  public void onCustomFormatAdLoaded(@NonNull NativeCustomFormatAd ad) {
    formatId = ad.getCustomFormatId();
    view =
        customParameters.factories.get(formatId).createCustomAd(ad, customParameters.viewOptions);
    type = AdLoaderAdType.CUSTOM;
    manager.onAdLoaded(adId, null);
  }

  @Override
  public void onNativeAdLoaded(@NonNull NativeAd ad) {
    view = nativeParameters.factory.createNativeAd(ad, nativeParameters.viewOptions);
    type = AdLoaderAdType.NATIVE;
    ad.setOnPaidEventListener(new FlutterPaidEventListener(manager, this));
    manager.onAdLoaded(adId, ad.getResponseInfo());
  }

  @Override
  void dispose() {
    if (view == null) {
      return;
    }

    if (view instanceof BaseAdView) {
      ((BaseAdView) view).destroy();
    }

    view = null;
  }
}
