package io.flutter.plugins.googlemobileads.mobileads;

import android.app.Activity;

import java.util.List;

import github.penguin.reference.reference.TypeChannelMessenger;

public class MobileAdsChannelRegistrar extends MobileAdsChannelLibrary.$ChannelRegistrar {
  public MobileAdsChannelRegistrar(MobileAdsLibraryImplementations implementations) {
    super(implementations);
  }

  public static class MobileAdsLibraryImplementations extends MobileAdsChannelLibrary.$LibraryImplementations {
    public final Activity activity;

    public MobileAdsLibraryImplementations(TypeChannelMessenger messenger, Activity activity) {
      super(messenger);
      this.activity = activity;
    }

    @Override
    public OnInitializationCompleteListenerHandler getHandlerOnInitializationCompleteListener() {
      return new OnInitializationCompleteListenerHandler(this);
    }

    @Override
    public RequestConfigurationHandler getHandlerRequestConfiguration() {
      return new RequestConfigurationHandler();
    }

    @Override
    public MobileAdsHandler getHandlerMobileAds() {
      return new MobileAdsHandler(this);
    }
  }

  public static class OnInitializationCompleteListenerHandler extends MobileAdsChannelLibrary.$OnInitializationCompleteListenerHandler {
    public final MobileAdsLibraryImplementations implementations;

    public OnInitializationCompleteListenerHandler(MobileAdsLibraryImplementations implementations) {
      this.implementations = implementations;
    }

    @Override
    public OnInitializationCompleteListenerProxy $$create(TypeChannelMessenger messenger) {
      return new OnInitializationCompleteListenerProxy(implementations);
    }
  }

  public static class RequestConfigurationHandler extends MobileAdsChannelLibrary.$RequestConfigurationHandler {
    @Override
    public RequestConfigurationProxy $$create(TypeChannelMessenger messenger, String maxAdContentRating, Integer tagForChildDirectedTreatment, Integer tagForUnderAgeOfConsent, List<String> testDeviceIds) {
      return new RequestConfigurationProxy(maxAdContentRating, tagForChildDirectedTreatment, tagForUnderAgeOfConsent, testDeviceIds);
    }
  }

  public static class MobileAdsHandler extends MobileAdsChannelLibrary.$MobileAdsHandler {
    public final MobileAdsLibraryImplementations implementations;

    public MobileAdsHandler(MobileAdsLibraryImplementations implementations) {
      this.implementations = implementations;
    }

    @Override
    public MobileAdsProxy $$create(TypeChannelMessenger messenger) {
      return new MobileAdsProxy(implementations);
    }
  }
}
