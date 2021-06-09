package io.flutter.plugins.googlemobileads.adcontainers;

import com.google.android.gms.ads.interstitial.InterstitialAd;

public class InterstitialAdProxy implements AdContainersChannelLibrary.$InterstitialAd {
  public final InterstitialAd interstitialAd;
  private AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations;
  
  public static void load(String adUnitId,
                          AdRequestProxy request,
                          InterstitialAdLoadListenerProxy listener,
                          AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations) {
    InterstitialAd.load(implementations.activity, adUnitId, request.adRequest.build(), listener.callback);
  }

  public InterstitialAdProxy(InterstitialAd interstitialAd, AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations) {
    this.interstitialAd = interstitialAd;
    this.implementations = implementations;
    implementations.getChannelInterstitialAd().$$create(this, false);
  }

  @Override
  public Void show(AdContainersChannelLibrary.$FullScreenContentListener fullScreenContentListener) {
    if (fullScreenContentListener != null) {
      interstitialAd.setFullScreenContentCallback(((FullScreenContentListenerProxy) fullScreenContentListener).fullScreenContentCallback);
    }
    interstitialAd.show(implementations.activity);
    return null;
  }
}
