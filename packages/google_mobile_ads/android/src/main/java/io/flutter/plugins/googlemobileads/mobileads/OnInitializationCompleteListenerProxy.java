package io.flutter.plugins.googlemobileads.mobileads;

import androidx.annotation.NonNull;

import com.google.android.gms.ads.initialization.InitializationStatus;
import com.google.android.gms.ads.initialization.OnInitializationCompleteListener;

public class OnInitializationCompleteListenerProxy implements MobileAdsChannelLibrary.$OnInitializationCompleteListener, OnInitializationCompleteListener {
  public final MobileAdsChannelRegistrar.MobileAdsLibraryImplementations implementations;

  public OnInitializationCompleteListenerProxy(MobileAdsChannelRegistrar.MobileAdsLibraryImplementations implementations) {
    this.implementations = implementations;
  }

  @Override
  public void onInitializationComplete(@NonNull InitializationStatus initializationStatus) {
    final InitializationStatusProxy initializationStatusProxy = new InitializationStatusProxy(initializationStatus, implementations);
    implementations.getChannelOnInitializationCompleteListener().$onInitializationComplete(this, initializationStatusProxy);
  }
}
