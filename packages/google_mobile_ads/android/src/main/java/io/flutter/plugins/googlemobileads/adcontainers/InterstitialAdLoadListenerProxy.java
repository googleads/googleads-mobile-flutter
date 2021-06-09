package io.flutter.plugins.googlemobileads.adcontainers;

import androidx.annotation.NonNull;

import com.google.android.gms.ads.LoadAdError;
import com.google.android.gms.ads.interstitial.InterstitialAd;
import com.google.android.gms.ads.interstitial.InterstitialAdLoadCallback;

public class InterstitialAdLoadListenerProxy implements AdContainersChannelLibrary.$InterstitialAdLoadListener {
  public final InterstitialAdLoadCallback callback;
  private final AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations;

  public InterstitialAdLoadListenerProxy(final AdContainersChannelLibrary.$InterstitialAdLoadCallback onAdLoaded, final AdContainersChannelLibrary.$LoadFailCallback onAdFailedToLoad, final AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations) {
    this(new InterstitialAdLoadCallback() {
      @Override
      public void onAdLoaded(@NonNull InterstitialAd interstitialAd) {
        final InterstitialAdProxy interstitialAdProxy = new InterstitialAdProxy(interstitialAd, implementations);
        onAdLoaded.invoke(interstitialAdProxy);
      }

      @Override
      public void onAdFailedToLoad(@NonNull LoadAdError loadAdError) {
        final LoadAdErrorProxy loadAdErrorProxy = new LoadAdErrorProxy(loadAdError, implementations);
        onAdFailedToLoad.invoke(loadAdErrorProxy);
      }
    }, implementations);
  }

  public InterstitialAdLoadListenerProxy(InterstitialAdLoadCallback callback, AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations) {
    this.callback = callback;
    this.implementations = implementations;
  }

  @Override
  protected void finalize() throws Throwable {
    implementations.getChannelInterstitialAdLoadListener().disposeInstancePair(this);
    super.finalize();
  }
}
