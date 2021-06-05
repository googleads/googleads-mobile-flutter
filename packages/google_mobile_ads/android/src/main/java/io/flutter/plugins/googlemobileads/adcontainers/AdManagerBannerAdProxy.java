package io.flutter.plugins.googlemobileads.adcontainers;

import android.view.View;

import com.google.android.gms.ads.AdSize;
import com.google.android.gms.ads.admanager.AdManagerAdView;

import java.util.List;

import io.flutter.plugin.platform.PlatformView;

public class AdManagerBannerAdProxy implements AdContainersChannelLibrary.$AdManagerBannerAd, PlatformView {
  public final AdManagerAdView adManagerAdView;
  private final AdManagerAdRequestProxy request;

  public AdManagerBannerAdProxy(List<AdContainersChannelLibrary.$AdSize> sizes, String adUnitId, AdManagerBannerAdListenerProxy listener, AdManagerAdRequestProxy request, AppEventListenerProxy appEventListener, AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations) {
    this(new AdManagerAdView(implementations.activity), sizes, adUnitId, listener, request, appEventListener);
  }

  public AdManagerBannerAdProxy(AdManagerAdView adManagerAdView, List<AdContainersChannelLibrary.$AdSize> sizes, String adUnitId, AdManagerBannerAdListenerProxy listener, AdManagerAdRequestProxy request, AppEventListenerProxy appEventListener) {
    this.adManagerAdView = adManagerAdView;
    this.request = request;
    adManagerAdView.setAdSizes((AdSize[]) AdSizeProxy.fromList(sizes).toArray());
    adManagerAdView.setAdUnitId(adUnitId);
    adManagerAdView.setAdListener(listener);
    adManagerAdView.setAppEventListener(appEventListener);
  }
  
  @Override
  public Void load() {
    adManagerAdView.loadAd(request.adRequest.build());
    return null;
  }

  @Override
  public View getView() {
    return adManagerAdView;
  }

  @Override
  public void dispose() {
    // Do nothing.
  }
}
