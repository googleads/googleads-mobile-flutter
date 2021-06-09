package io.flutter.plugins.googlemobileads.adcontainers;

import androidx.annotation.NonNull;

import com.google.android.gms.ads.AdListener;
import com.google.android.gms.ads.LoadAdError;

public class BannerAdListenerProxy implements AdContainersChannelLibrary.$BannerAdListener {
  public final AdListener adListener;
  private final AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations;
  
  public BannerAdListenerProxy(final AdContainersChannelLibrary.$AdVoidCallback onAdLoaded,
                               final AdContainersChannelLibrary.$LoadFailCallback onAdFailedToLoad,
                               final AdContainersChannelLibrary.$AdVoidCallback onAdOpened,
                               AdContainersChannelLibrary.$AdVoidCallback onAdWillDismissScreen,
                               final AdContainersChannelLibrary.$AdVoidCallback onAdClosed,
                               final AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations) {
    this(new AdListener() {
      @Override
      public void onAdClosed() {
        if (onAdClosed != null) onAdClosed.invoke();
      }

      @Override
      public void onAdFailedToLoad(@NonNull LoadAdError loadAdError) {
        if (onAdFailedToLoad == null) return;
        final LoadAdErrorProxy loadAdErrorProxy = new LoadAdErrorProxy(loadAdError, implementations);
        onAdFailedToLoad.invoke(loadAdErrorProxy);
      }

      @Override
      public void onAdOpened() {
        if (onAdOpened != null) onAdOpened.invoke();
      }

      @Override
      public void onAdLoaded() {
        onAdLoaded.invoke();
      }
    }, implementations);
  }
  
  public BannerAdListenerProxy(AdListener adListener, AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations) {
    this.adListener = adListener;
    this.implementations = implementations;
  }

  @Override
  protected void finalize() throws Throwable {
    implementations.getChannelBannerAdListener().disposeInstancePair(this);
    super.finalize();
  }
}
