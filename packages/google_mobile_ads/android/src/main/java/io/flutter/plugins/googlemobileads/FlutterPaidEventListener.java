package io.flutter.plugins.googlemobileads;

import androidx.annotation.NonNull;
import com.google.android.gms.ads.AdValue;
import com.google.android.gms.ads.OnPaidEventListener;

/** Implementation of {@link OnPaidEventListener} that sends events to {@link AdInstanceManager}. */
public class FlutterPaidEventListener implements OnPaidEventListener {
  @NonNull private final AdInstanceManager manager;
  @NonNull private final FlutterAd ad;

  FlutterPaidEventListener(@NonNull AdInstanceManager manager, @NonNull FlutterAd ad) {
    this.manager = manager;
    this.ad = ad;
  }

  @Override
  public void onPaidEvent(AdValue adValue) {
    FlutterAdValue value =
        new FlutterAdValue(
            adValue.getPrecisionType(), adValue.getCurrencyCode(), adValue.getValueMicros());
    manager.onPaidEvent(ad, value);
  }
}
