package io.flutter.plugins.googlemobileads.mobileads;

import com.google.android.gms.ads.initialization.AdapterStatus;

public class AdapterInitializationStateProxy implements MobileAdsChannelLibrary.$AdapterInitializationState {
  public final AdapterStatus.State adapterInitializationState;

  private static String serialize(AdapterStatus.State state) {
    switch (state) {
      case NOT_READY:
        return "notReady";
      case READY:
        return "ready";
    }

    throw new IllegalArgumentException("Unable to serialize AdapterInitializationState with state: " + state);
  }

  public AdapterInitializationStateProxy(AdapterStatus.State adapterInitializationState, MobileAdsChannelRegistrar.MobileAdsLibraryImplementations implementations) {
    this.adapterInitializationState = adapterInitializationState;
    implementations.getChannelAdapterInitializationState().$$create(this, false, serialize(adapterInitializationState));
  }
}
