package io.flutter.plugins.googlemobileads.adcontainers;

import com.google.android.gms.ads.ResponseInfo;

public class ResponseInfoProxy implements AdContainersChannelLibrary.$ResponseInfo {
  public final ResponseInfo responseInfo;

  public ResponseInfoProxy(ResponseInfo responseInfo, AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations) {
    this.responseInfo = responseInfo;
    implementations.getChannelResponseInfo().$$create(this, false,
        responseInfo.getResponseId(),
        responseInfo.getMediationAdapterClassName(),
        AdapterResponseInfoProxy.fromList(responseInfo.getAdapterResponses(), implementations));
  }
}
