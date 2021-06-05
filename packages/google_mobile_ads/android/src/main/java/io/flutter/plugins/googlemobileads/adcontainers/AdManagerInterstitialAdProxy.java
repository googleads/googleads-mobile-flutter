package io.flutter.plugins.googlemobileads.adcontainers;

import com.google.android.gms.ads.admanager.AdManagerAdRequest;
import com.google.android.gms.ads.admanager.AdManagerInterstitialAd;

public class AdManagerInterstitialAdProxy implements AdContainersChannelLibrary.$AdManagerInterstitialAd {
  public final AdManagerInterstitialAd adManagerInterstitialAd;

  public static void load(String adUnitId,
                          AdManagerAdRequestProxy request,
                          AdManagerInterstitialAdLoadCallbackProxy adLoadCallback,
                          AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations) {
    AdManagerInterstitialAd.load(implementations.context, adUnitId, ((AdManagerAdRequest.Builder)request.adRequest).build(), adLoadCallback);
  }

  public AdManagerInterstitialAdProxy(AdManagerInterstitialAd adManagerInterstitialAd) {
    this.adManagerInterstitialAd = adManagerInterstitialAd;
  }

  @Override
  public Void show(AdContainersChannelLibrary.$AppEventListener appEventListener, AdContainersChannelLibrary.$FullScreenContentCallback fullScreenContentCallback) {
    if (appEventListener != null) {
      adManagerInterstitialAd.setAppEventListener((AppEventListenerProxy) appEventListener);
    }
    if (fullScreenContentCallback != null) {
      adManagerInterstitialAd.setFullScreenContentCallback((FullScreenContentCallbackProxy) fullScreenContentCallback);
    }
    return null;
  }
}
