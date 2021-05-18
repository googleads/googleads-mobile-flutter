package io.flutter.plugins.googlemobileads;

import androidx.annotation.NonNull;

/** A wrapper for {@link com.google.android.gms.ads.AdValue}. */
public class FlutterAdValue {
  final int precisionType;
  @NonNull final String currencyCode;
  final long valueMicros;

  public FlutterAdValue(int precisionType, @NonNull String currencyCode, long valueMicros) {
    this.precisionType = precisionType;
    this.currencyCode = currencyCode;
    this.valueMicros = valueMicros;
  }
}
