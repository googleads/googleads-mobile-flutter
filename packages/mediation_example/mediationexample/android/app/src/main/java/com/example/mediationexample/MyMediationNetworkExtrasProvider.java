package com.example.mediationexample;

import android.os.Bundle;
import androidx.annotation.Nullable;
import com.applovin.mediation.AppLovinExtras;
import com.applovin.mediation.ApplovinAdapter;
import com.google.ads.mediation.admob.AdMobAdapter;
import com.google.android.gms.ads.mediation.MediationExtrasReceiver;
import io.flutter.plugins.googlemobileads.MediationNetworkExtrasProvider;
import java.util.HashMap;
import java.util.Map;

/**
 * Your implementation of {@link MediationNetworkExtrasProvider}. Will be used when ad requests are
 * created to pass mediation extras to the ad request.
 */
final class MyMediationNetworkExtrasProvider implements MediationNetworkExtrasProvider {

  /**
   * Override this method to pass mediation network extras that will be used when ad requests are
   * created.
   */
  @Override
  public Map<Class<? extends MediationExtrasReceiver>, Bundle> getMediationExtras(
      String adUnitId, @Nullable String identifier) {
    Bundle appLovinBundle = new AppLovinExtras.Builder().setMuteAudio(true).build();
    Map<Class<? extends MediationExtrasReceiver>, Bundle> extras = new HashMap<>();
    extras.put(ApplovinAdapter.class, appLovinBundle);

    Bundle admobExtras = new Bundle();
    admobExtras.putString("someString", "2");
    extras.put(AdMobAdapter.class, admobExtras);
    return extras;
  }
}
