package io.flutter.plugins.googlemobileads.adcontainers;

import androidx.annotation.NonNull;

import com.google.android.gms.ads.AdListener;
import com.google.android.gms.ads.LoadAdError;

public class NativeAdListenerProxy implements AdContainersChannelLibrary.$NativeAdListener {
  public final AdListener adListener;
  private final AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations;

  public NativeAdListenerProxy(final AdContainersChannelLibrary.$AdVoidCallback onAdLoaded,
                               final AdContainersChannelLibrary.$LoadFailCallback onAdFailedToLoad,
                               final AdContainersChannelLibrary.$AdVoidCallback onAdOpened,
                               final AdContainersChannelLibrary.$AdVoidCallback onAdWillDismissScreen,
                               final AdContainersChannelLibrary.$AdVoidCallback onAdImpression,
                               final AdContainersChannelLibrary.$AdVoidCallback onAdClosed,
                               final AdContainersChannelLibrary.$AdVoidCallback onAdClicked,
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

      @Override
      public void onAdClicked() {
        if (onAdClicked != null) onAdClicked.invoke();
      }

      @Override
      public void onAdImpression() {
        if (onAdImpression != null) onAdImpression.invoke();
      }
    }, implementations);
  }

  public NativeAdListenerProxy(AdListener adListener, AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations) {
    this.adListener = adListener;
    this.implementations = implementations;
  }

  @Override
  protected void finalize() throws Throwable {
    implementations.getChannelNativeAdListener().disposeInstancePair(this);
    super.finalize();
  }
}
