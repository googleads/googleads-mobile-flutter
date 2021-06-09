package io.flutter.plugins.googlemobileads.adcontainers;

import com.google.android.gms.ads.AdListener;

public class AdManagerBannerAdListenerProxy extends BannerAdListenerProxy implements AdContainersChannelLibrary.$AdManagerBannerAdListener {
  public AdManagerBannerAdListenerProxy(AdContainersChannelLibrary.$AdVoidCallback onAdLoaded, AdContainersChannelLibrary.$LoadFailCallback onAdFailedToLoad, AdContainersChannelLibrary.$AdVoidCallback onAdOpened, AdContainersChannelLibrary.$AdVoidCallback onAdWillDismissScreen, AdContainersChannelLibrary.$AdVoidCallback onAdClosed, AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations) {
    super(onAdLoaded, onAdFailedToLoad, onAdOpened, onAdWillDismissScreen, onAdClosed, implementations);
  }

  public AdManagerBannerAdListenerProxy(AdListener adListener, AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations) {
    super(adListener, implementations);
  }
}
