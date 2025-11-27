// Copyright 20222 Google LLC
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
import androidx.annotation.Nullable;
import com.google.android.gms.ads.AdSize;
import com.google.android.gms.ads.formats.OnAdManagerAdViewLoadedListener;
import java.util.List;

class FlutterBannerParameters {
  @NonNull final List<FlutterAdSize> sizes;
  @Nullable final FlutterAdManagerAdViewOptions adManagerAdViewOptions;

  FlutterBannerParameters(
      @NonNull List<FlutterAdSize> sizes,
      @Nullable FlutterAdManagerAdViewOptions adManagerAdViewOptions) {
    this.sizes = sizes;
    this.adManagerAdViewOptions = adManagerAdViewOptions;
  }

  FlutterAdLoaderAd.BannerParameters asBannerParameters(
      @NonNull OnAdManagerAdViewLoadedListener listener) {
    AdSize[] adSizes = new AdSize[sizes.size()];
    int i = 0;
    for (FlutterAdSize size : sizes) {
      adSizes[i++] = size.getAdSize();
    }
    return new FlutterAdLoaderAd.BannerParameters(
        listener,
        adSizes,
        adManagerAdViewOptions != null ? adManagerAdViewOptions.asAdManagerAdViewOptions() : null);
  }
}
