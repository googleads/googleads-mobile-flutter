package io.flutter.plugins.googlemobileads;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.google.android.gms.ads.nativead.NativeAdOptions;
import io.flutter.plugins.googlemobileads.NativeAdFactory;
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
      @NonNull Map<String, NativeAdFactory> registeredFactories) {
    NativeAdOptions nativeAdOptions = null;
    if (this.nativeAdOptions != null) {
      nativeAdOptions = this.nativeAdOptions.asNativeAdOptions();
    }
    return new FlutterAdLoaderAd.NativeParameters(
        registeredFactories.get(factoryId), nativeAdOptions, viewOptions);
  }
}
