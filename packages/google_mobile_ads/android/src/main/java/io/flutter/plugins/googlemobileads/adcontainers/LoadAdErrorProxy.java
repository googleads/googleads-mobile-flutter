package io.flutter.plugins.googlemobileads.adcontainers;

import com.google.android.gms.ads.LoadAdError;

public class LoadAdErrorProxy implements AdContainersChannelLibrary.$LoadAdError {
  public final LoadAdError loadAdError;

  public LoadAdErrorProxy(LoadAdError loadAdError, AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations) {
    this.loadAdError = loadAdError;
    final ResponseInfoProxy responseInfo;
    if (loadAdError.getResponseInfo() != null) {
      responseInfo = new ResponseInfoProxy(loadAdError.getResponseInfo(), implementations);
    } else {
      responseInfo = null;
    }
    implementations.getChannelLoadAdError().$$create(this, false, loadAdError.getCode(), loadAdError.getDomain(), loadAdError.getMessage(), responseInfo);
  }
}
