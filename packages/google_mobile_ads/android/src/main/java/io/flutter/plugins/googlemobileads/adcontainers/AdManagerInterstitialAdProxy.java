package io.flutter.plugins.googlemobileads.adcontainers;

import com.google.android.gms.ads.admanager.AdManagerAdRequest;
import com.google.android.gms.ads.admanager.AdManagerInterstitialAd;

public class AdManagerInterstitialAdProxy implements AdContainersChannelLibrary.$AdManagerInterstitialAd {
  public final AdManagerInterstitialAd adManagerInterstitialAd;
  private AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations;

  public static void load(String adUnitId,
                          AdManagerAdRequestProxy request,
                          AdManagerInterstitialAdLoadListenerProxy listener,
                          AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations) {
    AdManagerInterstitialAd.load(implementations.activity, adUnitId, ((AdManagerAdRequest.Builder)request.adRequest).build(), listener.adManagerInterstitialAdLoadCallback);
  }

  public AdManagerInterstitialAdProxy(AdManagerInterstitialAd adManagerInterstitialAd, AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations) {
    this.adManagerInterstitialAd = adManagerInterstitialAd;
    this.implementations = implementations;
    implementations.getChannelAdManagerInterstitialAd().$$create(this, false);
  }

  @Override
  public Void show(AdContainersChannelLibrary.$AppEventListener appEventListener, AdContainersChannelLibrary.$FullScreenContentListener fullScreenContentListener) {
    if (appEventListener != null) {
      adManagerInterstitialAd.setAppEventListener(((AppEventListenerProxy) appEventListener).appEventListener);
    }
    if (fullScreenContentListener != null) {
      adManagerInterstitialAd.setFullScreenContentCallback(((FullScreenContentListenerProxy) fullScreenContentListener).fullScreenContentCallback);
    }
    adManagerInterstitialAd.show(implementations.activity);
    return null;
  }
}
