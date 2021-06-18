package io.flutter.plugins.googlemobileads.mobileads;

import com.google.android.gms.ads.initialization.AdapterStatus;

import java.util.HashMap;
import java.util.Map;

public class AdapterStatusProxy implements MobileAdsChannelLibrary.$AdapterStatus {
  public final AdapterStatus adapterStatus;

  public static Map<String, MobileAdsChannelLibrary.$AdapterStatus> fromMap(Map<String, AdapterStatus> statusMap, MobileAdsChannelRegistrar.MobileAdsLibraryImplementations implementations) {
    final Map<String, MobileAdsChannelLibrary.$AdapterStatus> newMap = new HashMap<>();
    for (Map.Entry<String, AdapterStatus> status : statusMap.entrySet()) {
      newMap.put(status.getKey(), new AdapterStatusProxy(status.getValue(), implementations));
    }
    return newMap;
  }

  public AdapterStatusProxy(AdapterStatus adapterStatus, MobileAdsChannelRegistrar.MobileAdsLibraryImplementations implementations) {
    this.adapterStatus = adapterStatus;
    final AdapterInitializationStateProxy adapterInitializationState =
        new AdapterInitializationStateProxy(adapterStatus.getInitializationState(), implementations);
    implementations.getChannelAdapterStatus().$$create(this, false, adapterInitializationState, adapterStatus.getDescription(), (double) adapterStatus.getLatency());
  }
}
