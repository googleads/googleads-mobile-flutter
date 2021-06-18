package io.flutter.plugins.googlemobileads.adcontainers;

import com.google.android.gms.ads.AdError;

public class AdErrorProxy implements AdContainersChannelLibrary.$AdError {
  public final AdError adError;

  public AdErrorProxy(AdError adError, AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations) {
    this.adError = adError;
    implementations.getChannelAdError().$$create(this, false, adError.getCode(), adError.getDomain(), adError.getMessage());
  }
}
