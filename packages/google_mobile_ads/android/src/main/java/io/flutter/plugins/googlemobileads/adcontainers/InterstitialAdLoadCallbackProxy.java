package io.flutter.plugins.googlemobileads.adcontainers;

import androidx.annotation.NonNull;

import com.google.android.gms.ads.LoadAdError;
import com.google.android.gms.ads.interstitial.InterstitialAd;
import com.google.android.gms.ads.interstitial.InterstitialAdLoadCallback;

public class InterstitialAdLoadCallbackProxy extends InterstitialAdLoadCallback implements AdContainersChannelLibrary.$InterstitialAdLoadCallback {
  public final AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations;

  public InterstitialAdLoadCallbackProxy(AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations) {
    this.implementations = implementations;
  }

  @Override
  public void onAdLoaded(@NonNull InterstitialAd interstitialAd) {
    final InterstitialAdProxy interstitialAdProxy = new InterstitialAdProxy(interstitialAd);
    implementations.getChannelInterstitialAdLoadCallback().$onAdLoaded(this, interstitialAdProxy);
  }

  @Override
  public void onAdFailedToLoad(@NonNull LoadAdError loadAdError) {
    final LoadAdErrorProxy loadAdErrorProxy = new LoadAdErrorProxy(loadAdError, implementations);
    implementations.getChannelInterstitialAdLoadCallback().$onAdFailedToLoad(this, loadAdErrorProxy);
  }

  @Override
  protected void finalize() throws Throwable {
    implementations.getChannelInterstitialAdLoadCallback().disposeInstancePair(this);
    super.finalize();
  }
}
