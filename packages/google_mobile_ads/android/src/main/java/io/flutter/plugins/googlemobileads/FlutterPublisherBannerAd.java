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
class FlutterPublisherBannerAd extends FlutterAd implements PlatformView, FlutterDestroyableAd {
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
    // Do nothing. Cleanup is handled in destroy() below, which is triggered from dispose() being
    // called on the flutter ad object. This is allows for reuse of the ad view, for example
    // in a scrolling list view.
  }

  @Override
  public void destroy() {
    if (view != null) {
      view.destroy();
      view = null;
    }
  }
}
