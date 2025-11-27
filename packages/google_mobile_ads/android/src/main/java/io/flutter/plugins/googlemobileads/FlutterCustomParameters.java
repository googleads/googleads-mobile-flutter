package io.flutter.plugins.googlemobileads;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.google.android.gms.ads.nativead.NativeCustomFormatAd.OnCustomFormatAdLoadedListener;
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin.CustomAdFactory;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

class FlutterCustomParameters {
  @NonNull final List<String> formatIds;
  @Nullable final Map<String, Object> viewOptions;

  FlutterCustomParameters(
      @NonNull List<String> formatIds, @Nullable Map<String, Object> viewOptions) {
    this.formatIds = formatIds;
    this.viewOptions = viewOptions;
  }

  FlutterAdLoaderAd.CustomParameters asCustomParameters(
      @NonNull OnCustomFormatAdLoadedListener listener,
      @NonNull Map<String, CustomAdFactory> registeredFactories) {
    Map<String, CustomAdFactory> factories = new HashMap<>();
    for (String formatId : formatIds) {
      factories.put(formatId, registeredFactories.get(formatId));
    }
    return new FlutterAdLoaderAd.CustomParameters(listener, factories, viewOptions);
  }
}
