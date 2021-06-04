package io.flutter.plugins.googlemobileads.adcontainers;

import androidx.annotation.NonNull;

public class AdManagerBannerAdListenerProxy extends BannerAdListenerProxy implements AppEventListenerProxy, AdContainersChannelLibrary.$AdManagerBannerAdListener {
  public AdManagerBannerAdListenerProxy(AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations) {
    super(implementations);
  }

  @Override
  public void onAppEvent(@NonNull String name, @NonNull String data) {
    implementations.getChannelAppEventListener().$onAppEvent(this, name, data);
  }
}
