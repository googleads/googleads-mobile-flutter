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
import com.google.android.gms.ads.AdView;
import com.google.android.gms.ads.ResponseInfo;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.util.Preconditions;

/** A wrapper for {@link AdView}. */
class FlutterBannerAd extends FlutterAd implements PlatformView, FlutterDestroyableAd {
  @NonNull private final AdInstanceManager manager;
  @NonNull private final String adUnitId;
  @NonNull private final FlutterAdSize size;
  @NonNull private final FlutterAdRequest request;
  @NonNull private final BannerAdCreator bannerAdCreator;
  @Nullable private AdView view;

  /** Constructs the FlutterBannerAd. */
  public FlutterBannerAd(
      @NonNull AdInstanceManager manager,
      @NonNull String adUnitId,
      @NonNull FlutterAdRequest request,
      @NonNull FlutterAdSize size,
      @NonNull BannerAdCreator bannerAdCreator) {
    Preconditions.checkNotNull(manager);
    Preconditions.checkNotNull(adUnitId);
    Preconditions.checkNotNull(request);
    Preconditions.checkNotNull(size);
    this.manager = manager;
    this.adUnitId = adUnitId;
    this.request = request;
    this.size = size;
    this.bannerAdCreator = bannerAdCreator;
  }

  @Override
  void load() {
    view = bannerAdCreator.createAdView();
    view.setAdUnitId(adUnitId);
    view.setAdSize(size.getAdSize());
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
    view.loadAd(request.asAdRequest());
  }

  @Override
  @Nullable
  public View getView() {
    return view;
  }

  @Override
  public void dispose() {
    // Do nothing. Cleanup is handled in destroy() below, which is triggered from dispose() being
    // called on the flutter ad object. This is allows for reuse of the  ad view, for example
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
