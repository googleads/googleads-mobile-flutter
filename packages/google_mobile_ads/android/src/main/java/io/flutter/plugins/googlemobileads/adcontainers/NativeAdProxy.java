package io.flutter.plugins.googlemobileads.adcontainers;

import android.view.View;

import androidx.annotation.NonNull;

import com.google.android.gms.ads.AdLoader;
import com.google.android.gms.ads.nativead.NativeAd;
import com.google.android.gms.ads.nativead.NativeAdOptions;
import com.google.android.gms.ads.nativead.NativeAdView;

import java.util.Map;

import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin;

public class NativeAdProxy implements AdContainersChannelLibrary.$NativeAd, PlatformView {
  public final AdLoader nativeAd;
  private NativeAdView adView;
  private final AdRequestProxy request;
  
  public NativeAdProxy(String adUnitId,
                       String factoryId,
                       NativeAdListenerProxy listener,
                       AdRequestProxy request, Map<String, Object> customOptions, AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations) {
    this(new AdLoader.Builder(implementations.activity, adUnitId), factoryId, listener, request, customOptions, implementations);
  }

  public NativeAdProxy(AdLoader.Builder nativeAd,
                       final String factoryId,
                       NativeAdListenerProxy listener,
                       AdRequestProxy request, final Map<String, Object> customOptions,
                       final AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations) {
    this.nativeAd = nativeAd
        .forNativeAd(new NativeAd.OnNativeAdLoadedListener() {
          @Override
          public void onNativeAdLoaded(@NonNull NativeAd nativeAd) {
            final GoogleMobileAdsPlugin.NativeAdFactory adFactory = (GoogleMobileAdsPlugin.NativeAdFactory)
                implementations.getChannelNativeAd().messenger.getInstanceManager().getInstance(factoryId);

            if (adFactory == null) {
              throw new IllegalArgumentException("No NativeAdFactory was found with factoryId: " + factoryId);
            }
            adView = adFactory.createNativeAd(nativeAd, customOptions);
          }
        })
        .withNativeAdOptions(new NativeAdOptions.Builder().build())
        .withAdListener(listener)
        .build();
    this.request = request;
  }

  @Override
  public Void load() {
    nativeAd.loadAd(request.adRequest.build());
    return null;
  }

  @Override
  public View getView() {
    return adView;
  }

  @Override
  public void dispose() {
    // Do nothing.
  }
}
