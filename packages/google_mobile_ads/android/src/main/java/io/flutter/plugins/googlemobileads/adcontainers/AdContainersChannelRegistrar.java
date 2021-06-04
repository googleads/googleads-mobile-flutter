package io.flutter.plugins.googlemobileads.adcontainers;

import github.penguin.reference.reference.TypeChannelMessenger;

public class AdContainersChannelRegistrar extends AdContainersChannelLibrary.$ChannelRegistrar {
  public AdContainersChannelRegistrar(AdContainersChannelLibrary.$LibraryImplementations implementations) {
    super(implementations);
  }

  public static class AdContainersLibraryImplementations extends AdContainersChannelLibrary.$LibraryImplementations {
    public AdContainersLibraryImplementations(TypeChannelMessenger messenger) {
      super(messenger);
    }

    @Override
    public AdRequestHandler getHandlerAdRequest() {
      return new AdRequestHandler();
    }
  }

  public static class AdRequestHandler extends AdContainersChannelLibrary.$AdRequestHandler {
    @Override
    public AdRequestProxy $$create(TypeChannelMessenger messenger) {
      return new AdRequestProxy();
    }
  }
}
