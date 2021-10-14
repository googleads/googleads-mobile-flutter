package io.flutter.plugins.googlemobileads;

import android.os.Bundle;
import androidx.annotation.Nullable;
import com.google.android.gms.ads.mediation.MediationExtrasReceiver;
import io.flutter.embedding.engine.FlutterEngine;
import java.util.Map;

/**
 * Provides mediation extras for ad requests.
 * TODO - reword this
 * If you wish to provide mediation extras, implement
 * this interface and provide an instance to
 * {@link GoogleMobileAdsPlugin#registerMediationNetworkExtrasProvider(FlutterEngine,
 * MediationNetworkExtrasProvider)}.
 */
public interface MediationNetworkExtrasProvider {

  /**
   * Gets mediation extras that should be included for an ad request for the {@code adUnitId}
   * and {@code identifier}.
   *
   * @param adUnitId The ad unit for the associated ad request.
   * @param identifier An optional identifier that comes from the associated ad request. This value
   *                   can be provided when creating the dart ad request object, if you want to
   *                   additional customization of mediation extras. TODO - reword this.
   *
   */
  Map<Class<? extends MediationExtrasReceiver>, Bundle> getMediationExtras(
      String adUnitId,
      @Nullable String identifier);
}
