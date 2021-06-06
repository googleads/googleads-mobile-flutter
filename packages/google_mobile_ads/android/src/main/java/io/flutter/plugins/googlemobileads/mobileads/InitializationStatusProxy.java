package io.flutter.plugins.googlemobileads.mobileads;

import com.google.android.gms.ads.MobileAds;
import com.google.android.gms.ads.initialization.InitializationStatus;

public class InitializationStatusProxy implements MobileAdsChannelLibrary.$InitializationStatus {
  public final InitializationStatus initializationStatus;

  public InitializationStatusProxy(InitializationStatus initializationStatus, MobileAdsChannelRegistrar.MobileAdsLibraryImplementations implementations) {
    this.initializationStatus = initializationStatus;
    implementations.getChannelInitializationStatus().$$create(this, false, AdapterStatusProxy.fromMap(initializationStatus.getAdapterStatusMap(), implementations));
  }
}
