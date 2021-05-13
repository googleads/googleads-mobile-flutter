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
import com.google.android.gms.ads.AdListener;
import com.google.android.gms.ads.ResponseInfo;
import com.google.android.gms.ads.nativead.NativeAd;
import com.google.android.gms.ads.nativead.NativeAd.OnNativeAdLoadedListener;
import com.google.android.gms.ads.nativead.NativeAdOptions;
import com.google.android.gms.ads.nativead.NativeAdView;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin.NativeAdFactory;
import java.util.Map;

/** A wrapper for {@link NativeAd}. */
class FlutterNativeAd extends FlutterAd implements PlatformView, FlutterDestroyableAd {
  private static final String TAG = "FlutterNativeAd";

  @NonNull private final AdInstanceManager manager;
  @NonNull private final String adUnitId;
  @NonNull private final NativeAdFactory adFactory;
  @NonNull private final FlutterAdLoader flutterAdLoader;
  @Nullable private FlutterAdRequest request;
  @Nullable private FlutterAdManagerAdRequest adManagerRequest;
  @Nullable private Map<String, Object> customOptions;
  @Nullable private NativeAdView ad;
  @Nullable private ResponseInfo responseInfo;

  static class Builder {
    @Nullable private AdInstanceManager manager;
    @Nullable private String adUnitId;
    @Nullable private NativeAdFactory adFactory;
    @Nullable private FlutterAdRequest request;
    @Nullable private FlutterAdManagerAdRequest adManagerRequest;
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

    public Builder setRequest(@NonNull FlutterAdRequest request) {
      this.request = request;
      return this;
    }

    public Builder setAdManagerRequest(@NonNull FlutterAdManagerAdRequest request) {
      this.adManagerRequest = request;
      return this;
    }

    FlutterNativeAd build() {
      if (manager == null) {
        throw new IllegalStateException("AdInstanceManager cannot not be null.");
      } else if (adUnitId == null) {
        throw new IllegalStateException("AdUnitId cannot not be null.");
      } else if (adFactory == null) {
        throw new IllegalStateException("NativeAdFactory cannot not be null.");
      } else if (request == null && adManagerRequest == null) {
        throw new IllegalStateException("adRequest or addManagerRequest must be non-null.");
      }

      final FlutterNativeAd nativeAd;
      if (request == null) {
        nativeAd = new FlutterNativeAd(
          manager, adUnitId, adFactory, adManagerRequest, new FlutterAdLoader(), customOptions);
      } else {
        nativeAd = new FlutterNativeAd(
          manager, adUnitId, adFactory, request, new FlutterAdLoader(), customOptions);
      }
      return nativeAd;
    }
  }

  protected FlutterNativeAd(
      @NonNull AdInstanceManager manager,
      @NonNull String adUnitId,
      @NonNull NativeAdFactory adFactory,
      @NonNull FlutterAdRequest request,
      @NonNull FlutterAdLoader flutterAdLoader,
      @Nullable Map<String, Object> customOptions) {
    this.manager = manager;
    this.adUnitId = adUnitId;
    this.adFactory = adFactory;
    this.request = request;
    this.flutterAdLoader = flutterAdLoader;
    this.customOptions = customOptions;
  }

  protected FlutterNativeAd(
      @NonNull AdInstanceManager manager,
      @NonNull String adUnitId,
      @NonNull NativeAdFactory adFactory,
      @NonNull FlutterAdManagerAdRequest adManagerRequest,
      @NonNull FlutterAdLoader flutterAdLoader,
      @Nullable Map<String, Object> customOptions) {
    this.manager = manager;
    this.adUnitId = adUnitId;
    this.adFactory = adFactory;
    this.adManagerRequest = adManagerRequest;
    this.flutterAdLoader = flutterAdLoader;
    this.customOptions = customOptions;
  }

  @Override
  void load() {
    // Note we delegate loading the ad to FlutterAdLoader mainly for testing purposes.
    // As of 20.0.0 of GMA, mockito is unable to mock AdLoader.
    OnNativeAdLoadedListener loadedListener = new OnNativeAdLoadedListener() {
      @Override
      public void onNativeAdLoaded(@NonNull NativeAd nativeAd) {
        ad = adFactory.createNativeAd(nativeAd, customOptions);
        responseInfo = nativeAd.getResponseInfo();
      }
    };

    final ResponseInfoProvider responseInfoProvider = new ResponseInfoProvider() {
      @Override
      public ResponseInfo getResponseInfo() {
        return responseInfo;
      }
    };
    final AdListener adListener = new FlutterAdListener(manager, this, responseInfoProvider) {
      @Override
      public void onAdClicked() {
        manager.onNativeAdClicked(FlutterNativeAd.this);
      }

      @Override
      public void onAdImpression() {
        manager.onAdImpression(FlutterNativeAd.this);
      }
    };
    NativeAdOptions options = new NativeAdOptions.Builder().build();
    if (request != null) {
      flutterAdLoader.loadNativeAd(
        manager.activity, adUnitId, loadedListener, options, adListener, request.asAdRequest());
    } else if (adManagerRequest != null) {
      flutterAdLoader.loadAdManagerNativeAd(
        manager.activity,
        adUnitId,
        loadedListener,
        options,
        adListener,
        adManagerRequest.asAdManagerAdRequest());
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
}
