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
