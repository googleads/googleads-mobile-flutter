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

import com.google.android.libraries.ads.mobile.sdk.nativead.NativeAd;
import com.google.android.libraries.ads.mobile.sdk.nativead.NativeAdView;
import java.util.Map;

/**
 * Interface used to display a {@link NativeAd}.
 *
 * <p>Added to a {@link GoogleMobileAdsPlugin} and creates
 * {@link NativeAdView}s from Native Ads created in Dart.
 */
public interface NativeAdFactory {
  /**
   * Creates a {@link NativeAdView} with a {@link
   * NativeAd}.
   *
   * @param nativeAd Ad information used to create a {@link
   *     NativeAd}
   * @param customOptions Used to pass additional custom options to create the {@link
   *     NativeAdView}. Nullable.
   * @return a {@link NativeAdView} that is overlaid on top of
   *     the FlutterView
   */
  NativeAdView createNativeAd(NativeAd nativeAd, Map<String, Object> customOptions);
}
