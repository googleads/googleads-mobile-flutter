package io.flutter.plugins.googlemobileads.adcontainers;

import androidx.annotation.NonNull;

import com.google.android.gms.ads.admanager.AppEventListener;

public class AppEventListenerProxy implements AppEventListener, AdContainersChannelLibrary.$AppEventListener {
  public final AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations;

  public AppEventListenerProxy(AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations) {
    this.implementations = implementations;
  }

  @Override
  public void onAppEvent(@NonNull String name, @NonNull String data) {
    implementations.getChannelAppEventListener().$onAppEvent(this, name, data);
  }
}
