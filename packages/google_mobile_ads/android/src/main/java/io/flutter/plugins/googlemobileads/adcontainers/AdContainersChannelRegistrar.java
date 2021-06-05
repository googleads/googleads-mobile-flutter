package io.flutter.plugins.googlemobileads.adcontainers;

import android.app.Activity;

import java.util.List;
import java.util.Map;

import github.penguin.reference.reference.TypeChannelMessenger;

public class AdContainersChannelRegistrar extends AdContainersChannelLibrary.$ChannelRegistrar {
  public AdContainersChannelRegistrar(AdContainersChannelLibrary.$LibraryImplementations implementations) {
    super(implementations);
  }

  public static class AdContainersLibraryImplementations extends AdContainersChannelLibrary.$LibraryImplementations {
    public final Activity activity;

    public AdContainersLibraryImplementations(TypeChannelMessenger messenger, Activity activity) {
      super(messenger);
      this.activity = activity;
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

    @Override
    public BannerAdListenerHandler getHandlerBannerAdListener() {
      return new BannerAdListenerHandler(this);
    }

    @Override
    public BannerAdHandler getHandlerBannerAd() {
      return new BannerAdHandler(this);
    }

    @Override
    public AdManagerBannerAdListenerHandler getHandlerAdManagerBannerAdListener() {
      return new AdManagerBannerAdListenerHandler(this);
    }

    @Override
    public AdManagerBannerAdHandler getHandlerAdManagerBannerAd() {
      return new AdManagerBannerAdHandler(this);
    }

    @Override
    public NativeAdListenerHandler getHandlerNativeAdListener() {
      return new NativeAdListenerHandler(this);
    }

    @Override
    public NativeAdHandler getHandlerNativeAd() {
      return new NativeAdHandler(this);
    }

    @Override
    public FullScreenContentCallbackHandler getHandlerFullScreenContentCallback() {
      return new FullScreenContentCallbackHandler(this);
    }

    @Override
    public InterstitialAdLoadCallbackHandler getHandlerInterstitialAdLoadCallback() {
      return new InterstitialAdLoadCallbackHandler(this);
    }

    @Override
    public InterstitialAdHandler getHandlerInterstitialAd() {
      return new InterstitialAdHandler(this);
    }

    @Override
    public AppEventListenerHandler getHandlerAppEventListener() {
      return new AppEventListenerHandler(this);
    }

    @Override
    public AdManagerInterstitialAdHandler getHandlerAdManagerInterstitialAd() {
      return new AdManagerInterstitialAdHandler(this);
    }

    @Override
    public ServerSideVerificationOptionsHandler getHandlerServerSideVerificationOptions() {
      return new ServerSideVerificationOptionsHandler();
    }

    @Override
    public OnUserEarnedRewardListenerHandler getHandlerOnUserEarnedRewardListener() {
      return new OnUserEarnedRewardListenerHandler(this);
    }

    @Override
    public RewardedAdLoadCallbackHandler getHandlerRewardedAdLoadCallback() {
      return new RewardedAdLoadCallbackHandler(this);
    }

    @Override
    public AdContainersChannelLibrary.$RewardedAdHandler getHandlerRewardedAd() {
      return new RewardedAdHandler(this);
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

  public static class BannerAdListenerHandler extends AdContainersChannelLibrary.$BannerAdListenerHandler {
    public final AdContainersLibraryImplementations implementations;

    public BannerAdListenerHandler(AdContainersLibraryImplementations implementations) {
      this.implementations = implementations;
    }

    @Override
    public BannerAdListenerProxy $$create(TypeChannelMessenger messenger) throws Exception {
      return new BannerAdListenerProxy(implementations);
    }
  }

  public static class BannerAdHandler extends AdContainersChannelLibrary.$BannerAdHandler {
    public final AdContainersLibraryImplementations implementations;

    public BannerAdHandler(AdContainersLibraryImplementations implementations) {
      this.implementations = implementations;
    }

    @Override
    public BannerAdProxy $$create(TypeChannelMessenger messenger, AdContainersChannelLibrary.$AdSize size, String adUnitId, AdContainersChannelLibrary.$BannerAdListener listener, AdContainersChannelLibrary.$AdRequest request) {
      return new BannerAdProxy((AdSizeProxy) size, adUnitId, (BannerAdListenerProxy) listener, (AdRequestProxy) request, implementations);
    }
  }
  
  public static class AdManagerBannerAdListenerHandler extends AdContainersChannelLibrary.$AdManagerBannerAdListenerHandler {
    public final AdContainersLibraryImplementations implementations;

    public AdManagerBannerAdListenerHandler(AdContainersLibraryImplementations implementations) {
      this.implementations = implementations;
    }
    
    @Override
    public AdManagerBannerAdListenerProxy $$create(TypeChannelMessenger messenger) {
      return new AdManagerBannerAdListenerProxy(implementations);
    }
  }

  public static class AdManagerBannerAdHandler extends AdContainersChannelLibrary.$AdManagerBannerAdHandler {
    public final AdContainersLibraryImplementations implementations;

    public AdManagerBannerAdHandler(AdContainersLibraryImplementations implementations) {
      this.implementations = implementations;
    }

    @Override
    public AdManagerBannerAdProxy $$create(TypeChannelMessenger messenger, List<AdContainersChannelLibrary.$AdSize> sizes, String adUnitId, AdContainersChannelLibrary.$AdManagerBannerAdListener listener, AdContainersChannelLibrary.$AdManagerAdRequest request, AdContainersChannelLibrary.$AppEventListener appEventListener) {
      return new AdManagerBannerAdProxy(sizes, adUnitId, (AdManagerBannerAdListenerProxy) listener, (AdManagerAdRequestProxy) request, (AppEventListenerProxy) appEventListener, implementations);
    }
  }
  
  public static class NativeAdListenerHandler extends AdContainersChannelLibrary.$NativeAdListenerHandler {
    public final AdContainersLibraryImplementations implementations;

    public NativeAdListenerHandler(AdContainersLibraryImplementations implementations) {
      this.implementations = implementations;
    }

    @Override
    public NativeAdListenerProxy $$create(TypeChannelMessenger messenger) {
      return new NativeAdListenerProxy(implementations);
    }
  }
  
  public static class NativeAdHandler extends AdContainersChannelLibrary.$NativeAdHandler {
    public final AdContainersLibraryImplementations implementations;

    public NativeAdHandler(AdContainersLibraryImplementations implementations) {
      this.implementations = implementations;
    }

    @Override
    public NativeAdProxy $$create(TypeChannelMessenger messenger, String adUnitId, String factoryId, AdContainersChannelLibrary.$NativeAdListener listener, AdContainersChannelLibrary.$AdRequest request, Map<String, Object> customOptions) {
      return new NativeAdProxy(adUnitId, factoryId, (NativeAdListenerProxy) listener, (AdRequestProxy) request, customOptions, implementations);
    }
  }
  
  public static class FullScreenContentCallbackHandler extends AdContainersChannelLibrary.$FullScreenContentCallbackHandler {
    public final AdContainersLibraryImplementations implementations;

    public FullScreenContentCallbackHandler(AdContainersLibraryImplementations implementations) {
      this.implementations = implementations;
    }

    @Override
    public FullScreenContentCallbackProxy $$create(TypeChannelMessenger messenger) {
      return new FullScreenContentCallbackProxy(implementations);
    }
  }

  public static class InterstitialAdLoadCallbackHandler extends AdContainersChannelLibrary.$InterstitialAdLoadCallbackHandler {
    public final AdContainersLibraryImplementations implementations;

    public InterstitialAdLoadCallbackHandler(AdContainersLibraryImplementations implementations) {
      this.implementations = implementations;
    }

    @Override
    public InterstitialAdLoadCallbackProxy $$create(TypeChannelMessenger messenger) {
      return new InterstitialAdLoadCallbackProxy(implementations);
    }
  }

  public static class InterstitialAdHandler extends AdContainersChannelLibrary.$InterstitialAdHandler {
    public final AdContainersLibraryImplementations implementations;

    public InterstitialAdHandler(AdContainersLibraryImplementations implementations) {
      this.implementations = implementations;
    }

    @Override
    public Void $load(TypeChannelMessenger messenger, String adUnitId, AdContainersChannelLibrary.$AdRequest request, AdContainersChannelLibrary.$InterstitialAdLoadCallback adLoadCallback) {
      InterstitialAdProxy.load(adUnitId, (AdRequestProxy) request, (InterstitialAdLoadCallbackProxy) adLoadCallback, implementations);
      return null;
    }
  }

  public static class AppEventListenerHandler extends AdContainersChannelLibrary.$AppEventListenerHandler {
    public final AdContainersLibraryImplementations implementations;

    public AppEventListenerHandler(AdContainersLibraryImplementations implementations) {
      this.implementations = implementations;
    }

    @Override
    public AppEventListenerProxy $$create(TypeChannelMessenger messenger) {
      return new AppEventListenerProxy(implementations);
    }
  }

  public static class AdManagerInterstitialAdHandler extends AdContainersChannelLibrary.$AdManagerInterstitialAdHandler {
    public final AdContainersLibraryImplementations implementations;

    public AdManagerInterstitialAdHandler(AdContainersLibraryImplementations implementations) {
      this.implementations = implementations;
    }

    @Override
    public Void $load(TypeChannelMessenger messenger, String adUnitId, AdContainersChannelLibrary.$AdManagerAdRequest request, AdContainersChannelLibrary.$AdManagerInterstitialAdLoadCallback adLoadCallback) {
      AdManagerInterstitialAdProxy.load(adUnitId, (AdManagerAdRequestProxy) request, (AdManagerInterstitialAdLoadCallbackProxy) adLoadCallback, implementations);
      return null;
    }
  }

  public static class ServerSideVerificationOptionsHandler extends AdContainersChannelLibrary.$ServerSideVerificationOptionsHandler {
    @Override
    public ServerSideVerificationOptionsProxy $$create(TypeChannelMessenger messenger, String userId, String customData) {
      return new ServerSideVerificationOptionsProxy(userId, customData);
    }
  }

  public static class OnUserEarnedRewardListenerHandler extends AdContainersChannelLibrary.$OnUserEarnedRewardListenerHandler {
    public final AdContainersLibraryImplementations implementations;

    public OnUserEarnedRewardListenerHandler(AdContainersLibraryImplementations implementations) {
      this.implementations = implementations;
    }

    @Override
    public OnUserEarnedRewardListenerProxy $$create(TypeChannelMessenger messenger) {
      return new OnUserEarnedRewardListenerProxy(implementations);
    }
  }

  public static class RewardedAdLoadCallbackHandler extends AdContainersChannelLibrary.$RewardedAdLoadCallbackHandler {
    public final AdContainersLibraryImplementations implementations;

    public RewardedAdLoadCallbackHandler(AdContainersLibraryImplementations implementations) {
      this.implementations = implementations;
    }

    @Override
    public RewardedAdLoadCallbackProxy $$create(TypeChannelMessenger messenger) {
      return new RewardedAdLoadCallbackProxy(implementations);
    }
  }

  public static class RewardedAdHandler extends AdContainersChannelLibrary.$RewardedAdHandler {
    public final AdContainersLibraryImplementations implementations;

    public RewardedAdHandler(AdContainersLibraryImplementations implementations) {
      this.implementations = implementations;
    }

    @Override
    public Void $load(TypeChannelMessenger messenger, String adUnitId, AdContainersChannelLibrary.$AdRequest request, AdContainersChannelLibrary.$RewardedAdLoadCallback adLoadCallback) {
      RewardedAdProxy.load(adUnitId, (AdRequestProxy) request, (RewardedAdLoadCallbackProxy) adLoadCallback, implementations);
      return null;
    }
  }
}
