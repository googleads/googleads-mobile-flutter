package io.flutter.plugins.googlemobileads.adcontainers;

import androidx.annotation.NonNull;

import com.google.android.gms.ads.admanager.AppEventListener;

public class AppEventListenerProxy implements AdContainersChannelLibrary.$AppEventListener {
  public final AppEventListener appEventListener;
  private final AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations;

  public AppEventListenerProxy(final AdContainersChannelLibrary.$AppEventCallback onAppEvent, AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations) {
    this(new AppEventListener() {
      @Override
      public void onAppEvent(@NonNull String s, @NonNull String s1) {
        onAppEvent.invoke(s, s1);
      }
    }, implementations);
  }

  public AppEventListenerProxy(AppEventListener appEventListener, AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations) {
    this.appEventListener = appEventListener;
    this.implementations = implementations;
  }

  @Override
  protected void finalize() throws Throwable {
    implementations.getChannelAppEventListener().disposeInstancePair(this);
    super.finalize();
  }
}
