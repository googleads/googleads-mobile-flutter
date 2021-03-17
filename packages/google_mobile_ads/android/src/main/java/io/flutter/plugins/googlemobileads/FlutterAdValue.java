package io.flutter.plugins.googlemobileads;

import androidx.annotation.NonNull;

public class FlutterAdValue {
    @NonNull final int precisionType;
    @NonNull final String currencyCode;
    @NonNull final double valueMicros;

    public FlutterAdValue(int precisionType, @NonNull String currencyCode, long valueMicros) {
        this.precisionType = precisionType;
        this.currencyCode = currencyCode;
        this.valueMicros = valueMicros;
    }
}
