package io.flutter.plugins.googlemobileads.adcontainers;

import android.view.View;

import com.google.android.gms.ads.AdView;

import io.flutter.plugin.platform.PlatformView;

public class BannerAdProxy implements AdContainersChannelLibrary.$BannerAd, PlatformView {
  public final AdView bannerAd;
  private final AdRequestProxy request;
  
  public BannerAdProxy(AdSizeProxy size, String adUnitId, BannerAdListenerProxy listener, AdRequestProxy request, AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations) {
    this(new AdView(implementations.activity), size, adUnitId, listener, request);
  }

  public BannerAdProxy(AdView bannerAd, AdSizeProxy size, String adUnitId, BannerAdListenerProxy listener, AdRequestProxy request) {
    this.bannerAd = bannerAd;
    this.request = request;
    bannerAd.setAdSize(size.adSize);
    bannerAd.setAdUnitId(adUnitId);
    bannerAd.setAdListener(listener.adListener);
  }

  @Override
  public Void load() {
    bannerAd.loadAd(request.adRequest.build());
    return null;
  }

  @Override
  public View getView() {
    return bannerAd;
  }

  @Override
  public void dispose() {
    // Do nothing.
  }
}
