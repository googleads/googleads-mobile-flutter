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

import androidx.annotation.NonNull;
import java.util.List;

/**
 * Wrapper around {@link com.google.android.libraries.ads.mobile.sdk.banner.AdView} for the Google Mobile
 * Ads Plugin.
 */
class FlutterAdManagerBannerAd extends FlutterBannerAd {
  /**
   * Constructs a `FlutterAdManagerBannerAd`.
   *
   * <p>Call `load()` to instantiate the `AdView` and load the `AdRequest`. `getView()` will return
   * null only until `load` is called.
   */
  public FlutterAdManagerBannerAd(
      int adId,
      @NonNull AdInstanceManager manager,
      @NonNull String adUnitId,
      @NonNull List<FlutterAdSize> sizes,
      FlutterAdManagerAdRequest flutterAdRequest,
      @NonNull BannerAdCreator bannerAdCreator) {
    super(adId, manager, adUnitId, flutterAdRequest, sizes, bannerAdCreator);
  }
}
