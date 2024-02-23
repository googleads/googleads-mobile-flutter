// Copyright 2022 Google LLC
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
import com.google.android.gms.ads.nativead.NativeAd.OnNativeAdLoadedListener;
import com.google.android.gms.ads.nativead.NativeAdOptions;
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin.NativeAdFactory;
import java.util.Map;

class FlutterNativeParameters {
  @NonNull final String factoryId;
  @Nullable final FlutterNativeAdOptions nativeAdOptions;
  @Nullable final Map<String, Object> viewOptions;

  FlutterNativeParameters(
      @NonNull String factoryId,
      @Nullable FlutterNativeAdOptions nativeAdOptions,
      @Nullable Map<String, Object> viewOptions) {
    this.factoryId = factoryId;
    this.nativeAdOptions = nativeAdOptions;
    this.viewOptions = viewOptions;
  }

  FlutterAdLoaderAd.NativeParameters asNativeParameters(
      @NonNull OnNativeAdLoadedListener listener,
      @NonNull Map<String, NativeAdFactory> registeredFactories) {
    NativeAdOptions nativeAdOptions = null;
    if (this.nativeAdOptions != null) {
      nativeAdOptions = this.nativeAdOptions.asNativeAdOptions();
    }
    return new FlutterAdLoaderAd.NativeParameters(
        listener, registeredFactories.get(factoryId), nativeAdOptions, viewOptions);
  }
}
