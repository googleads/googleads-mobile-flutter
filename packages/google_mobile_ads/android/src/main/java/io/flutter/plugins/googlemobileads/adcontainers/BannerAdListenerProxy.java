package io.flutter.plugins.googlemobileads.adcontainers;

public class BannerAdListenerProxy extends AdViewWithListenerProxy implements AdContainersChannelLibrary.$BannerAdListener {
  public BannerAdListenerProxy(AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations) {
    super(implementations);
  }

  @Override
  public void onAdImpression() {
    implementations.getChannelAdWithViewListener().$onAdImpression(this);
  }

  @Override
  protected void finalize() throws Throwable {
    implementations.getChannelBannerAdListener().disposeInstancePair(this);
    super.finalize();
  }
}
