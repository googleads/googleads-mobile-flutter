package io.flutter.plugins.googlemobileads;

import android.content.Context;
import io.flutter.plugin.common.MethodChannel.Result;

public final class FlutterAdInspector {
  public static void openAdInspector(
      Context context, FlutterMobileAdsWrapper flutterMobileAds, Result result) {
    flutterMobileAds.openAdInspector(
        context,
        adInspectorError -> {
          if (adInspectorError != null) {
            String errorCode = Integer.toString(adInspectorError.getCode().getValue());
            result.error(
                errorCode,
                adInspectorError.getMessage(),
                "com.google.android.libraries.ads.mobile.sdk");
          } else {
            result.success(null);
          }
        });
  }
}
