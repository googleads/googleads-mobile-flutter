package io.flutter.plugins.googlemobileads.adcontainers;

public class NativeAdListenerProxy extends AdViewWithListenerProxy implements AdContainersChannelLibrary.$NativeAdListener {
  public NativeAdListenerProxy(AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations) {
    super(implementations);
  }

  @Override
  public void onAdImpression() {
    implementations.getChannelAdWithViewListener().$onAdImpression(this);
  }

  @Override
  public void onAdClicked() {
    implementations.getChannelNativeAdListener().$onAdClicked(this);
  }
}
