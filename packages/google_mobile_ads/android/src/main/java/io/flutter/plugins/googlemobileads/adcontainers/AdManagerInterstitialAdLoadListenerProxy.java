package io.flutter.plugins.googlemobileads.adcontainers;

import androidx.annotation.NonNull;

import com.google.android.gms.ads.LoadAdError;
import com.google.android.gms.ads.admanager.AdManagerInterstitialAd;
import com.google.android.gms.ads.admanager.AdManagerInterstitialAdLoadCallback;

public class AdManagerInterstitialAdLoadListenerProxy implements AdContainersChannelLibrary.$AdManagerInterstitialAdLoadListener {
  public final AdManagerInterstitialAdLoadCallback adManagerInterstitialAdLoadCallback;
  private final AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations;

  public AdManagerInterstitialAdLoadListenerProxy(final AdContainersChannelLibrary.$AdManagerInterstitialAdLoadCallback onAdLoaded,
                                                  final AdContainersChannelLibrary.$LoadFailCallback onAdFailedToLoad,
                                                  final AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations) {
    this(new AdManagerInterstitialAdLoadCallback() {
      @Override
      public void onAdLoaded(@NonNull AdManagerInterstitialAd interstitialAd) {
        final AdManagerInterstitialAdProxy interstitialAdProxy = new AdManagerInterstitialAdProxy(interstitialAd, implementations);
        onAdLoaded.invoke(interstitialAdProxy);
      }

      @Override
      public void onAdFailedToLoad(@NonNull LoadAdError loadAdError) {
        final LoadAdErrorProxy loadAdErrorProxy = new LoadAdErrorProxy(loadAdError, implementations);
        onAdFailedToLoad.invoke(loadAdErrorProxy);
      }
    }, implementations);
  }

  public AdManagerInterstitialAdLoadListenerProxy(AdManagerInterstitialAdLoadCallback adManagerInterstitialAdLoadCallback, AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations) {
    this.adManagerInterstitialAdLoadCallback = adManagerInterstitialAdLoadCallback;
    this.implementations = implementations;
  }

  @Override
  protected void finalize() throws Throwable {
    implementations.getChannelAdManagerInterstitialAdLoadListener().disposeInstancePair(this);
    super.finalize();
  }
}
