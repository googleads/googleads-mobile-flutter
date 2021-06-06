package io.flutter.plugins.googlemobileads.mobileads;

import github.penguin.reference.reference.TypeChannelMessenger;

public class MobileAdsChannelRegistrar extends MobileAdsChannelLibrary.$ChannelRegistrar {
  public MobileAdsChannelRegistrar(MobileAdsLibraryImplementations implementations) {
    super(implementations);
  }

  public static class MobileAdsLibraryImplementations extends MobileAdsChannelLibrary.$LibraryImplementations {
    public MobileAdsLibraryImplementations(TypeChannelMessenger messenger) {
      super(messenger);
    }
  }
}
