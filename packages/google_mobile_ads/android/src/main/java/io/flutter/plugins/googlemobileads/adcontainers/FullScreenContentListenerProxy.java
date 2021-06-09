package io.flutter.plugins.googlemobileads.adcontainers;

import androidx.annotation.NonNull;

import com.google.android.gms.ads.AdError;
import com.google.android.gms.ads.FullScreenContentCallback;

public class FullScreenContentListenerProxy implements AdContainersChannelLibrary.$FullScreenContentListener {
  public final FullScreenContentCallback fullScreenContentCallback;
  private final AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations;

  public FullScreenContentListenerProxy(final AdContainersChannelLibrary.$AdVoidCallback onAdShowedFullScreenContent,
                                        final AdContainersChannelLibrary.$AdVoidCallback onAdImpression,
                                        final AdContainersChannelLibrary.$AdVoidCallback onAdFailedToShowFullScreenContent,
                                        AdContainersChannelLibrary.$AdVoidCallback onAdWillDismissFullScreenContent,
                                        final AdContainersChannelLibrary.$AdVoidCallback onAdDismissedFullScreenContent,
                                        AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations) {
    this(new FullScreenContentCallback() {
      @Override
      public void onAdFailedToShowFullScreenContent(@NonNull AdError adError) {
        if (onAdFailedToShowFullScreenContent != null) onAdFailedToShowFullScreenContent.invoke();
      }

      @Override
      public void onAdShowedFullScreenContent() {
        if (onAdShowedFullScreenContent != null) onAdShowedFullScreenContent.invoke();
      }

      @Override
      public void onAdDismissedFullScreenContent() {
        if (onAdDismissedFullScreenContent != null) onAdDismissedFullScreenContent.invoke();
      }

      @Override
      public void onAdImpression() {
        if (onAdImpression != null) onAdImpression.invoke();
      }
    }, implementations);
  }

  public FullScreenContentListenerProxy(FullScreenContentCallback fullScreenContentCallback,
                                        AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations) {
    this.fullScreenContentCallback = fullScreenContentCallback;
    this.implementations = implementations;
  }

  @Override
  protected void finalize() throws Throwable {
    implementations.getChannelFullScreenContentListener().disposeInstancePair(this);
    super.finalize();
  }
}
