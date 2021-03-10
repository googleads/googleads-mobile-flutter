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
import android.view.View;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.VisibleForTesting;
import com.google.android.gms.ads.AdLoader;
import com.google.android.gms.ads.formats.NativeAdOptions;
import com.google.android.gms.ads.formats.UnifiedNativeAd;
import com.google.android.gms.ads.formats.UnifiedNativeAdView;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin.NativeAdFactory;
import java.util.Map;

class FlutterNativeAd extends FlutterAd implements PlatformView, FlutterDestroyableAd {
  private static final String TAG = "FlutterNativeAd";

  @NonNull private final AdInstanceManager manager;
  @NonNull private final String adUnitId;
  @NonNull private final NativeAdFactory adFactory;
  @Nullable private FlutterAdRequest request;
  @Nullable private FlutterPublisherAdRequest publisherRequest;
  @Nullable private Map<String, Object> customOptions;
  @Nullable private UnifiedNativeAdView ad;

  static class Builder {
    @Nullable private AdInstanceManager manager;
    @Nullable private String adUnitId;
    @Nullable private NativeAdFactory adFactory;
    @Nullable private FlutterAdRequest request;
    @Nullable private FlutterPublisherAdRequest publisherRequest;
    @Nullable private Map<String, Object> customOptions;

    public Builder setAdFactory(@NonNull NativeAdFactory adFactory) {
      this.adFactory = adFactory;
      return this;
    }

    public Builder setCustomOptions(@Nullable Map<String, Object> customOptions) {
      this.customOptions = customOptions;
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

    public Builder setRequest(@Nullable FlutterAdRequest request) {
      this.request = request;
      return this;
    }

    public Builder setPublisherRequest(@Nullable FlutterPublisherAdRequest request) {
      this.publisherRequest = request;
      return this;
    }

    FlutterNativeAd build() {
      if (manager == null) {
        throw new IllegalStateException("AdInstanceManager cannot not be null.");
      } else if (adUnitId == null) {
        throw new IllegalStateException("AdUnitId cannot not be null.");
      } else if (adFactory == null) {
        throw new IllegalStateException("NativeAdFactory cannot not be null.");
      } else if (request == null && publisherRequest == null) {
        throw new IllegalStateException("adRequest or publisherRequest must be non-null.");
      }

      final FlutterNativeAd nativeAd;
      if (request == null) {
        nativeAd = new FlutterNativeAd(manager, adUnitId, adFactory, publisherRequest);
      } else {
        nativeAd = new FlutterNativeAd(manager, adUnitId, adFactory, request);
      }
      nativeAd.customOptions = customOptions;
      return nativeAd;
    }
  }

  private FlutterNativeAd(
      @NonNull AdInstanceManager manager,
      @NonNull String adUnitId,
      @NonNull NativeAdFactory adFactory,
      @NonNull FlutterAdRequest request) {
    this.manager = manager;
    this.adUnitId = adUnitId;
    this.adFactory = adFactory;
    this.request = request;
  }

  private FlutterNativeAd(
      @NonNull AdInstanceManager manager,
      @NonNull String adUnitId,
      @NonNull NativeAdFactory adFactory,
      @NonNull FlutterPublisherAdRequest publisherRequest) {
    this.manager = manager;
    this.adUnitId = adUnitId;
    this.adFactory = adFactory;
    this.publisherRequest = publisherRequest;
  }

  @Override
  void load() {
    final AdLoader adLoader = buildAdLoader();

    if (request != null) {
      adLoader.loadAd(request.asAdRequest());
    } else if (publisherRequest != null) {
      adLoader.loadAd(publisherRequest.asPublisherAdRequest());
    } else {
      Log.e(TAG, "A null or invalid ad request was provided.");
    }
  }

  @Override
  @Nullable
  public View getView() {
    return ad;
  }

  @Override
  public void dispose() {
    // Do nothing. Cleanup is handled in destroy() below, which is triggered from dispose() being
    // called on the flutter ad object. This is allows for reuse of the ad view, for example
    // in a scrolling list view.
  }

  @Override
  public void destroy() {
    if (ad != null) {
      ad.destroy();
      ad = null;
    }
  }

  @NonNull
  @VisibleForTesting
  AdLoader buildAdLoader() {
    return new AdLoader.Builder(manager.activity, adUnitId)
        .forUnifiedNativeAd(
            new UnifiedNativeAd.OnUnifiedNativeAdLoadedListener() {
              @Override
              public void onUnifiedNativeAdLoaded(UnifiedNativeAd unifiedNativeAd) {
                ad = adFactory.createNativeAd(unifiedNativeAd, customOptions);
              }
            })
        .withNativeAdOptions(new NativeAdOptions.Builder().build())
        .withAdListener(
            new FlutterAdListener(manager, this) {
              @Override
              public void onAdClicked() {
                manager.onNativeAdClicked(FlutterNativeAd.this);
              }

              @Override
              public void onAdImpression() {
                manager.onNativeAdImpression(FlutterNativeAd.this);
              }
            })
        .build();
  }
}
