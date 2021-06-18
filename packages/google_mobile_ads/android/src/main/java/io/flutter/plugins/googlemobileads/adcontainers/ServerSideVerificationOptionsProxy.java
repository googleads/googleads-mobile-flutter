package io.flutter.plugins.googlemobileads.adcontainers;

import com.google.android.gms.ads.rewarded.ServerSideVerificationOptions;

public class ServerSideVerificationOptionsProxy implements AdContainersChannelLibrary.$ServerSideVerificationOptions {
  public final ServerSideVerificationOptions.Builder serverSideVerificationOptions;

  public ServerSideVerificationOptionsProxy(String userId, String customData) {
    this(new ServerSideVerificationOptions.Builder(), userId, customData);
  }

  public ServerSideVerificationOptionsProxy(ServerSideVerificationOptions.Builder serverSideVerificationOptions,
                                            String userId,
                                            String customData) {
    this.serverSideVerificationOptions = serverSideVerificationOptions;
    if (userId != null) serverSideVerificationOptions.setUserId(userId);
    if (customData != null) serverSideVerificationOptions.setCustomData(customData);
  }
}
