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
import io.flutter.plugin.platform.PlatformView;

class FlutterBannerAd extends FlutterAd implements PlatformView, FlutterDestroyableAd {
  @NonNull private final AdInstanceManager manager;
  @NonNull private final String adUnitId;
  @NonNull private final FlutterAdSize size;
  @Nullable private FlutterAdRequest request;
  @Nullable private AdView view;

  static class Builder {
    @Nullable private AdInstanceManager manager;
    @Nullable private String adUnitId;
    @Nullable private FlutterAdSize size;
    @Nullable private FlutterAdRequest request;

    public Builder setManager(@NonNull AdInstanceManager manager) {
      this.manager = manager;
      return this;
    }

    public Builder setAdUnitId(@NonNull String adUnitId) {
      this.adUnitId = adUnitId;
      return this;
    }

    public Builder setSize(@NonNull FlutterAdSize size) {
      this.size = size;
      return this;
    }

    public Builder setRequest(@Nullable FlutterAdRequest request) {
      this.request = request;
      return this;
    }

    FlutterBannerAd build() {
      if (manager == null) {
        throw new IllegalStateException("AdInstanceManager cannot not be null.");
      } else if (adUnitId == null) {
        throw new IllegalStateException("AdUnitId cannot not be null.");
      } else if (size == null) {
        throw new IllegalStateException("Size cannot not be null.");
      }

      final FlutterBannerAd bannerAd = new FlutterBannerAd(manager, adUnitId, size);
      bannerAd.request = request;
      return bannerAd;
    }
  }

  private FlutterBannerAd(
      @NonNull AdInstanceManager manager, @NonNull String adUnitId, @NonNull FlutterAdSize size) {
    this.manager = manager;
    this.adUnitId = adUnitId;
    this.size = size;
  }

  @Override
  void load() {
    view = new AdView(manager.activity);
    view.setAdUnitId(adUnitId);
    view.setAdSize(size.size);
    view.setAdListener(new FlutterAdListener(manager, this));
    view.setOnPaidEventListener(new FlutterPaidEventListener(manager, this));

    if (request != null) {
      view.loadAd(request.asAdRequest());
    } else {
      view.loadAd(new FlutterAdRequest.Builder().build().asAdRequest());
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
