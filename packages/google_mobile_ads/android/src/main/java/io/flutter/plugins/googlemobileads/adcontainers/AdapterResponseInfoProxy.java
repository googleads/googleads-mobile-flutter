package io.flutter.plugins.googlemobileads.adcontainers;

import com.google.android.gms.ads.AdapterResponseInfo;

import java.util.ArrayList;
import java.util.List;

public class AdapterResponseInfoProxy implements AdContainersChannelLibrary.$AdapterResponseInfo {
  public final AdapterResponseInfo adapterResponseInfo;
  
  static List<AdContainersChannelLibrary.$AdapterResponseInfo> fromList(List<AdapterResponseInfo> responses, AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations) {
    final List<AdContainersChannelLibrary.$AdapterResponseInfo> responseProxies = new ArrayList<>(responses.size());
    for (AdapterResponseInfo response : responses) {
      responseProxies.add(new AdapterResponseInfoProxy(response, implementations));
    }
    return responseProxies;
  }

  public AdapterResponseInfoProxy(AdapterResponseInfo adapterResponseInfo, AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations) {
    this.adapterResponseInfo = adapterResponseInfo;
    final AdErrorProxy adError;
    if (adapterResponseInfo.getAdError() != null) {
      adError = new AdErrorProxy(adapterResponseInfo.getAdError(), implementations);
    } else {
      adError = null;
    }
    implementations.getChannelAdapterResponseInfo().$$create(this, false,
        adapterResponseInfo.getAdapterClassName(),
        adapterResponseInfo.getLatencyMillis(),
        adapterResponseInfo.toString(),
        adapterResponseInfo.getCredentials().toString(), adError);
  }
}
