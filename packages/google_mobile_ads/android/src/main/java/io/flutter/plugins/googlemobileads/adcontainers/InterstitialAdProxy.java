package io.flutter.plugins.googlemobileads.adcontainers;

import com.google.android.gms.ads.interstitial.InterstitialAd;

public class InterstitialAdProxy implements AdContainersChannelLibrary.$InterstitialAd {
  public final InterstitialAd interstitialAd;
  
  public static void load(String adUnitId,
                          AdRequestProxy request,
                          InterstitialAdLoadCallbackProxy adLoadCallback,
                          AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations) {
    InterstitialAd.load(implementations.context, adUnitId, request.adRequest.build(), adLoadCallback);
  }

  public InterstitialAdProxy(InterstitialAd interstitialAd) {
    this.interstitialAd = interstitialAd;
  }

  @Override
  public Void show(AdContainersChannelLibrary.$FullScreenContentCallback fullScreenContentCallback) {
    if (fullScreenContentCallback != null) {
      interstitialAd.setFullScreenContentCallback((FullScreenContentCallbackProxy) fullScreenContentCallback);
    }
    return null;
  }
}
