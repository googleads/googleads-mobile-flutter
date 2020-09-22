// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.firebaseadmob;

import android.view.View;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.google.android.gms.ads.AdLoader;
import com.google.android.gms.ads.formats.NativeAdOptions;
import com.google.android.gms.ads.formats.UnifiedNativeAd;
import com.google.android.gms.ads.formats.UnifiedNativeAdView;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugins.firebaseadmob.FirebaseAdMobPlugin.NativeAdFactory;
import java.util.Map;

class FlutterNativeAd extends FlutterAd implements PlatformView {
  @NonNull private final AdInstanceManager manager;
  @NonNull private final String adUnitId;
  @NonNull private final NativeAdFactory adFactory;
  @Nullable private FlutterAdRequest request;
  @Nullable private Map<String, Object> customOptions;
  @Nullable private UnifiedNativeAdView ad;

  static class Builder {
    @Nullable private AdInstanceManager manager;
    @Nullable private String adUnitId;
    @Nullable private NativeAdFactory adFactory;
    @Nullable private FlutterAdRequest request;
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

    FlutterNativeAd build() {
      if (manager == null) {
        throw new IllegalStateException("AdInstanceManager cannot not be null.");
      } else if (adUnitId == null) {
        throw new IllegalStateException("AdUnitId cannot not be null.");
      } else if (adFactory == null) {
        throw new IllegalStateException("NativeAdFactory cannot not be null.");
      }

      final FlutterNativeAd nativeAd = new FlutterNativeAd(manager, adUnitId, adFactory);
      nativeAd.request = request;
      nativeAd.customOptions = customOptions;
      return nativeAd;
    }
  }

  public FlutterNativeAd(
      @NonNull AdInstanceManager manager,
      @NonNull String adUnitId,
      @NonNull io.flutter.plugins.firebaseadmob.FirebaseAdMobPlugin.NativeAdFactory adFactory) {
    this.manager = manager;
    this.adUnitId = adUnitId;
    this.adFactory = adFactory;
  }

  @Override
  void load() {
    final AdLoader adLoader =
        new AdLoader.Builder(manager.activity, adUnitId)
            .forUnifiedNativeAd(
                new UnifiedNativeAd.OnUnifiedNativeAdLoadedListener() {
                  @Override
                  public void onUnifiedNativeAdLoaded(UnifiedNativeAd unifiedNativeAd) {
                    ad = adFactory.createNativeAd(unifiedNativeAd, customOptions);
                    manager.onAdLoaded(FlutterNativeAd.this);
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

    if (request != null) {
      adLoader.loadAd(request.asAdRequest());
    } else {
      adLoader.loadAd(new FlutterAdRequest.Builder().build().asAdRequest());
    }
  }

  @Override
  @Nullable
  public View getView() {
    return ad;
  }

  @Override
  public void dispose() {
    // Do nothing.
  }
}
