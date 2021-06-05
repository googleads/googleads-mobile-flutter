package io.flutter.plugins.googlemobileads.adcontainers;

import androidx.annotation.NonNull;

import com.google.android.gms.ads.LoadAdError;
import com.google.android.gms.ads.admanager.AdManagerInterstitialAd;
import com.google.android.gms.ads.admanager.AdManagerInterstitialAdLoadCallback;

public class AdManagerInterstitialAdLoadCallbackProxy extends AdManagerInterstitialAdLoadCallback implements AdContainersChannelLibrary.$AdManagerInterstitialAdLoadCallback {
  public final AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations;

  public AdManagerInterstitialAdLoadCallbackProxy(AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations) {
    this.implementations = implementations;
  }

  @Override
  public void onAdLoaded(@NonNull AdManagerInterstitialAd interstitialAd) {
    final AdManagerInterstitialAdProxy interstitialAdProxy = new AdManagerInterstitialAdProxy(interstitialAd);
    implementations.getChannelAdManagerInterstitialAdLoadCallback().$onAdLoaded(this, interstitialAdProxy);
  }

  @Override
  public void onAdFailedToLoad(@NonNull LoadAdError loadAdError) {
    final LoadAdErrorProxy loadAdErrorProxy = new LoadAdErrorProxy(loadAdError, implementations);
    implementations.getChannelAdManagerInterstitialAdLoadCallback().$onAdFailedToLoad(this, loadAdErrorProxy);
  }
}
