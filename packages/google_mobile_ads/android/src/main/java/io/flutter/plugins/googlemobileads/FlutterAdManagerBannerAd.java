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
import com.google.android.gms.ads.ResponseInfo;
import com.google.android.gms.ads.admanager.AdManagerAdView;
import com.google.android.gms.ads.admanager.AppEventListener;
import com.google.android.gms.common.internal.Preconditions;
import io.flutter.plugin.platform.PlatformView;
import java.util.List;

/**
 * Wrapper around {@link com.google.android.gms.ads.admanager.AdManagerAdView} for the Google Mobile
 * Ads Plugin.
 */
class FlutterAdManagerBannerAd extends FlutterAd implements PlatformView, FlutterDestroyableAd {
  @NonNull private final AdInstanceManager manager;
  @NonNull private final String adUnitId;
  @NonNull private final List<FlutterAdSize> sizes;
  @NonNull private final FlutterAdManagerAdRequest request;
  @NonNull private final BannerAdCreator bannerAdCreator;
  @Nullable private AdManagerAdView view;

  /**
   * Constructs a `FlutterAdManagerBannerAd`.
   *
   * <p>Call `load()` to instantiate the `AdView` and load the `AdRequest`. `getView()` will return
   * null only until `load` is called.
   */
  public FlutterAdManagerBannerAd(
      @NonNull AdInstanceManager manager,
      @NonNull String adUnitId,
      @NonNull List<FlutterAdSize> sizes,
      @NonNull FlutterAdManagerAdRequest request,
      @NonNull BannerAdCreator bannerAdCreator) {
    Preconditions.checkNotNull(manager);
    Preconditions.checkNotNull(adUnitId);
    Preconditions.checkNotNull(sizes);
    Preconditions.checkNotNull(request);
    this.manager = manager;
    this.adUnitId = adUnitId;
    this.sizes = sizes;
    this.request = request;
    this.bannerAdCreator = bannerAdCreator;
  }

  @Override
  void load() {
    view = bannerAdCreator.createAdManagerAdView();
    view.setAdUnitId(adUnitId);
    view.setAppEventListener(
        new AppEventListener() {
          @Override
          public void onAppEvent(String name, String data) {
            manager.onAppEvent(FlutterAdManagerBannerAd.this, name, data);
          }
        });

    final AdSize[] allSizes = new AdSize[sizes.size()];
    for (int i = 0; i < sizes.size(); i++) {
      allSizes[i] = sizes.get(i).getAdSize();
    }
    view.setAdSizes(allSizes);
    view.setAdListener(
        new FlutterBannerAdListener(
            manager,
            this,
            new ResponseInfoProvider() {
              @Override
              public ResponseInfo getResponseInfo() {
                return view.getResponseInfo();
              }
            }));
    view.loadAd(request.asAdManagerAdRequest());
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
