// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.googlemobileads;

import android.view.View;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.google.android.gms.ads.AdSize;
import com.google.android.gms.ads.doubleclick.AppEventListener;
import com.google.android.gms.ads.doubleclick.PublisherAdView;
import io.flutter.plugin.platform.PlatformView;
import java.util.List;

/**
 * Wrapper around {@link com.google.android.gms.ads.doubleclick.PublisherAdView} for the Google
 * Mobile Ads Plugin.
 */
class FlutterPublisherBannerAd extends FlutterAd implements PlatformView {
  @NonNull private final AdInstanceManager manager;
  @NonNull private final String adUnitId;
  @NonNull private final List<FlutterAdSize> sizes;
  @Nullable FlutterPublisherAdRequest request;
  @Nullable private PublisherAdView view;

  static class Builder {
    @Nullable private AdInstanceManager manager;
    @Nullable private String adUnitId;
    @Nullable private List<FlutterAdSize> sizes;
    @Nullable private FlutterPublisherAdRequest request;

    public Builder setManager(@NonNull AdInstanceManager manager) {
      this.manager = manager;
      return this;
    }

    public Builder setAdUnitId(@NonNull String adUnitId) {
      this.adUnitId = adUnitId;
      return this;
    }

    public Builder setSizes(@NonNull List<FlutterAdSize> sizes) {
      this.sizes = sizes;
      return this;
    }

    public Builder setRequest(@Nullable FlutterPublisherAdRequest request) {
      this.request = request;
      return this;
    }

    FlutterPublisherBannerAd build() {
      if (manager == null) {
        throw new IllegalStateException("AdInstanceManager cannot not be null.");
      } else if (adUnitId == null) {
        throw new IllegalStateException("AdUnitId cannot not be null.");
      } else if (sizes == null || sizes.isEmpty()) {
        throw new IllegalStateException("Sizes cannot not be null or empty.");
      }

      final FlutterPublisherBannerAd bannerAd =
          new FlutterPublisherBannerAd(manager, adUnitId, sizes);
      bannerAd.request = request;
      return bannerAd;
    }
  }

  /**
   * Constructs a `FlutterPublisherBannerAd`.
   *
   * <p>Call `load()` to instantiate the `AdView` and load the `AdRequest`. `getView()` will return
   * null only until `load` is called.
   */
  private FlutterPublisherBannerAd(
      @NonNull AdInstanceManager manager,
      @NonNull String adUnitId,
      @NonNull List<FlutterAdSize> sizes) {
    this.manager = manager;
    this.adUnitId = adUnitId;
    this.sizes = sizes;
  }

  @Override
  void load() {
    view = new PublisherAdView(manager.activity);
    view.setAdUnitId(adUnitId);
    view.setAppEventListener(
        new AppEventListener() {
          @Override
          public void onAppEvent(String name, String data) {
            manager.onAppEvent(FlutterPublisherBannerAd.this, name, data);
          }
        });

    final AdSize[] allSizes = new AdSize[sizes.size()];
    for (int i = 0; i < sizes.size(); i++) {
      allSizes[i] = sizes.get(i).size;
    }
    view.setAdSizes(allSizes);

    view.setAdListener(new FlutterAdListener(manager, this));

    if (request != null) {
      view.loadAd(request.asPublisherAdRequest());
    } else {
      view.loadAd(new FlutterPublisherAdRequest.Builder().build().asPublisherAdRequest());
    }
  }

  @Override
  @Nullable
  public View getView() {
    return view;
  }

  @Override
  public void dispose() {
    // Do nothing.
  }
}
