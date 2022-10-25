package io.flutter.plugins.googlemobileads;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.google.android.libraries.ads.mobile.sdk.banner.AdSize;
import java.util.ArrayList;
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

  FlutterAdLoaderAd.BannerParameters asBannerParameters() {
    List<AdSize> adSizes = new ArrayList<>(sizes.size());
    for (FlutterAdSize size : sizes) {
      adSizes.add(size.getAdSize());
    }
    return new FlutterAdLoaderAd.BannerParameters(
        adSizes,
        adManagerAdViewOptions);
  }
}
