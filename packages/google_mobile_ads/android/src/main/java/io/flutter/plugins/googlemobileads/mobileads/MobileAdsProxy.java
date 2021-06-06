package io.flutter.plugins.googlemobileads.mobileads;

import com.google.android.gms.ads.MobileAds;

public class MobileAdsProxy implements MobileAdsChannelLibrary.$MobileAds {
  public final MobileAdsChannelRegistrar.MobileAdsLibraryImplementations implementations;

  public MobileAdsProxy(MobileAdsChannelRegistrar.MobileAdsLibraryImplementations implementations) {
    this.implementations = implementations;
  }

  @Override
  public Void initialize(MobileAdsChannelLibrary.$OnInitializationCompleteListener listener) {
    if (listener == null) {
      MobileAds.initialize(implementations.activity);
    } else {
      MobileAds.initialize(implementations.activity, (OnInitializationCompleteListenerProxy) listener);
    }
    return null;
  }

  @Override
  public Void updateRequestConfiguration(MobileAdsChannelLibrary.$RequestConfiguration requestConfiguration) {
    MobileAds.setRequestConfiguration(((RequestConfigurationProxy)requestConfiguration).requestConfiguration.build());
    return null;
  }

  @Override
  public Void setSameAppKeyEnabled(Boolean isEnabled) {
    throw new UnsupportedOperationException();
  }
}
