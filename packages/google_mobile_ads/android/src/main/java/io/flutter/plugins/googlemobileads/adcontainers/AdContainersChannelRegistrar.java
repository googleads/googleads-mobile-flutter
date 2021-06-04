package io.flutter.plugins.googlemobileads.adcontainers;

import android.content.Context;

import github.penguin.reference.reference.TypeChannelMessenger;

public class AdContainersChannelRegistrar extends AdContainersChannelLibrary.$ChannelRegistrar {
  public AdContainersChannelRegistrar(AdContainersChannelLibrary.$LibraryImplementations implementations) {
    super(implementations);
  }

  public static class AdContainersLibraryImplementations extends AdContainersChannelLibrary.$LibraryImplementations {
    public final Context context;

    public AdContainersLibraryImplementations(TypeChannelMessenger messenger, Context context) {
      super(messenger);
      this.context = context;
    }

    @Override
    public AdRequestHandler getHandlerAdRequest() {
      return new AdRequestHandler();
    }

    @Override
    public AdManagerAdRequestHandler getHandlerAdManagerAdRequest() {
      return new AdManagerAdRequestHandler();
    }

    @Override
    public AdSizeHandler getHandlerAdSize() {
      return new AdSizeHandler(this);
    }
  }

  public static class AdRequestHandler extends AdContainersChannelLibrary.$AdRequestHandler {
    @Override
    public AdRequestProxy $$create(TypeChannelMessenger messenger) {
      return new AdRequestProxy();
    }
  }

  public static class AdManagerAdRequestHandler extends AdContainersChannelLibrary.$AdManagerAdRequestHandler {
    @Override
    public AdManagerAdRequestProxy $$create(TypeChannelMessenger messenger) {
      return new AdManagerAdRequestProxy();
    }
  }

  public static class AdSizeHandler extends AdContainersChannelLibrary.$AdSizeHandler {
    public final AdContainersLibraryImplementations implementations;

    public AdSizeHandler(AdContainersLibraryImplementations implementations) {
      this.implementations = implementations;
    }

    @Override
    public AdSizeProxy $$create(TypeChannelMessenger messenger, Integer width, Integer height, String constant) {
      return new AdSizeProxy(width, height, constant);
    }

    @Override
    public AdSizeProxy $getLandscapeAnchoredAdaptiveBannerAdSize(TypeChannelMessenger messenger, Integer width) {
      return AdSizeProxy.getLandscapeAnchoredAdaptiveBannerAdSize(width, implementations);
    }

    @Override
    public AdSizeProxy $getPortraitAnchoredAdaptiveBannerAdSize(TypeChannelMessenger messenger, Integer width) {
      return AdSizeProxy.getPortraitAnchoredAdaptiveBannerAdSize(width, implementations);
    }
  }
}
