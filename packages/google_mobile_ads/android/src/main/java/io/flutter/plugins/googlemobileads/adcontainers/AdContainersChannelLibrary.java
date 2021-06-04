// GENERATED CODE - DO NOT MODIFY BY HAND


package io.flutter.plugins.googlemobileads.adcontainers;


import androidx.annotation.NonNull;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

import github.penguin.reference.async.Completable;
import github.penguin.reference.reference.PairedInstance;
import github.penguin.reference.reference.TypeChannel;
import github.penguin.reference.reference.TypeChannelHandler;
import github.penguin.reference.reference.TypeChannelMessenger;

// **************************************************************************
// ReferenceGenerator
// **************************************************************************

public class AdContainersChannelLibrary {
  
  public interface $OnUserEarnedRewardListener {
    
    
    
  }
  
  public interface $AppEventListener {
    
    
    
  }
  
  public interface $AdWithViewListener {
    
    
    
    
    
    
    
    
    
    
    
    
    
  }
  
  public interface $BannerAdListener {
    
  }
  
  public interface $AdManagerBannerAdListener {
    
  }
  
  public interface $NativeAdListener {
    
    
    
  }
  
  public interface $FullScreenContentCallback {
    
    
    
    
    
    
    
    
    
    
    
  }
  
  public interface $RewardedAdLoadCallback {
    
    
    
    
    
  }
  
  public interface $InterstitialAdLoadCallback {
    
    
    
    
    
  }
  
  public interface $AdManagerInterstitialAdLoadCallback {
    
    
    
    
    
  }
  
  public interface $AdError {
    
  }
  
  public interface $ResponseInfo {
    
  }
  
  public interface $AdapterResponseInfo {
    
  }
  
  public interface $LoadAdError {
    
  }
  
  public interface $AdRequest {
    
    
    Object addKeyword(String keyword) throws Exception;
    
    
    
    Object setContentUrl(String url) throws Exception;
    
    
    
    Object setNonPersonalizedAds(Boolean nonPersonalizedAds) throws Exception;
    
    
  }
  
  public interface $AdManagerAdRequest {
    
    
    Object addCustomTargeting(String key,String value) throws Exception;
    
    
    
    Object addCustomTargetingList(String key,List<String> values) throws Exception;
    
    
  }
  
  public interface $AdSize {
    
  }
  
  public interface $BannerAd {
    
    
    Object load() throws Exception;
    
    
  }
  
  public interface $AdManagerBannerAd {
    
    
    Object load() throws Exception;
    
    
  }
  
  public interface $NativeAd {
    
    
    Object load() throws Exception;
    
    
  }
  
  public interface $InterstitialAd {
    
    
    Object show() throws Exception;
    
    
  }
  
  public interface $AdManagerInterstitialAd {
    
    
    Object show() throws Exception;
    
    
  }
  
  public interface $RewardedAd {
    
    
    Object show($OnUserEarnedRewardListener onUserEarnedReward) throws Exception;
    
    
  }
  
  public interface $RewardItem {
    
  }
  
  public interface $ServerSideVerificationOptions {
    
  }
  

  
  public static class $OnUserEarnedRewardListenerChannel extends TypeChannel<$OnUserEarnedRewardListener> {
    public $OnUserEarnedRewardListenerChannel(@NonNull TypeChannelMessenger messenger) {
      super(messenger, "google_mobile_ads.OnUserEarnedRewardListener");
    }

    public Completable<PairedInstance> $$create($OnUserEarnedRewardListener $instance, boolean $owner) {
      return createNewInstancePair($instance, Arrays.<Object>asList(), $owner);
    }

    

    
    
    public Completable<Object> $onUserEarnedRewardCallback($OnUserEarnedRewardListener $instance,$RewardItem reward) {
      return invokeMethod($instance, "onUserEarnedRewardCallback", Arrays.<Object>asList(reward));
    }
    
    
  }
  
  public static class $AppEventListenerChannel extends TypeChannel<$AppEventListener> {
    public $AppEventListenerChannel(@NonNull TypeChannelMessenger messenger) {
      super(messenger, "google_mobile_ads.AppEventListener");
    }

    public Completable<PairedInstance> $$create($AppEventListener $instance, boolean $owner) {
      return createNewInstancePair($instance, Arrays.<Object>asList(), $owner);
    }

    

    
    
    public Completable<Object> $onAppEvent($AppEventListener $instance,String name,String data) {
      return invokeMethod($instance, "onAppEvent", Arrays.<Object>asList(name,data));
    }
    
    
  }
  
  public static class $AdWithViewListenerChannel extends TypeChannel<$AdWithViewListener> {
    public $AdWithViewListenerChannel(@NonNull TypeChannelMessenger messenger) {
      super(messenger, "google_mobile_ads.AdWithViewListener");
    }

    public Completable<PairedInstance> $$create($AdWithViewListener $instance, boolean $owner) {
      return createNewInstancePair($instance, Arrays.<Object>asList(), $owner);
    }

    

    
    
    public Completable<Object> $onAdLoaded($AdWithViewListener $instance) {
      return invokeMethod($instance, "onAdLoaded", Arrays.<Object>asList());
    }
    
    
    
    public Completable<Object> $onAdFailedToLoad($AdWithViewListener $instance,$LoadAdError error) {
      return invokeMethod($instance, "onAdFailedToLoad", Arrays.<Object>asList(error));
    }
    
    
    
    public Completable<Object> $onAdOpened($AdWithViewListener $instance) {
      return invokeMethod($instance, "onAdOpened", Arrays.<Object>asList());
    }
    
    
    
    public Completable<Object> $onAdWillDismissScreen($AdWithViewListener $instance) {
      return invokeMethod($instance, "onAdWillDismissScreen", Arrays.<Object>asList());
    }
    
    
    
    public Completable<Object> $onAdClosed($AdWithViewListener $instance) {
      return invokeMethod($instance, "onAdClosed", Arrays.<Object>asList());
    }
    
    
    
    public Completable<Object> $onAdImpression($AdWithViewListener $instance) {
      return invokeMethod($instance, "onAdImpression", Arrays.<Object>asList());
    }
    
    
  }
  
  public static class $BannerAdListenerChannel extends TypeChannel<$BannerAdListener> {
    public $BannerAdListenerChannel(@NonNull TypeChannelMessenger messenger) {
      super(messenger, "google_mobile_ads.BannerAdListener");
    }

    public Completable<PairedInstance> $$create($BannerAdListener $instance, boolean $owner) {
      return createNewInstancePair($instance, Arrays.<Object>asList(), $owner);
    }

    

    
  }
  
  public static class $AdManagerBannerAdListenerChannel extends TypeChannel<$AdManagerBannerAdListener> {
    public $AdManagerBannerAdListenerChannel(@NonNull TypeChannelMessenger messenger) {
      super(messenger, "google_mobile_ads.AdManagerBannerAdListener");
    }

    public Completable<PairedInstance> $$create($AdManagerBannerAdListener $instance, boolean $owner) {
      return createNewInstancePair($instance, Arrays.<Object>asList(), $owner);
    }

    

    
  }
  
  public static class $NativeAdListenerChannel extends TypeChannel<$NativeAdListener> {
    public $NativeAdListenerChannel(@NonNull TypeChannelMessenger messenger) {
      super(messenger, "google_mobile_ads.NativeAdListener");
    }

    public Completable<PairedInstance> $$create($NativeAdListener $instance, boolean $owner) {
      return createNewInstancePair($instance, Arrays.<Object>asList(), $owner);
    }

    

    
    
    public Completable<Object> $onAdClicked($NativeAdListener $instance) {
      return invokeMethod($instance, "onAdClicked", Arrays.<Object>asList());
    }
    
    
  }
  
  public static class $FullScreenContentCallbackChannel extends TypeChannel<$FullScreenContentCallback> {
    public $FullScreenContentCallbackChannel(@NonNull TypeChannelMessenger messenger) {
      super(messenger, "google_mobile_ads.FullScreenContentCallback");
    }

    public Completable<PairedInstance> $$create($FullScreenContentCallback $instance, boolean $owner) {
      return createNewInstancePair($instance, Arrays.<Object>asList(), $owner);
    }

    

    
    
    public Completable<Object> $onAdShowedFullScreenContent($FullScreenContentCallback $instance) {
      return invokeMethod($instance, "onAdShowedFullScreenContent", Arrays.<Object>asList());
    }
    
    
    
    public Completable<Object> $onAdDismissedFullScreenContent($FullScreenContentCallback $instance) {
      return invokeMethod($instance, "onAdDismissedFullScreenContent", Arrays.<Object>asList());
    }
    
    
    
    public Completable<Object> $onAdWillDismissFullScreenContent($FullScreenContentCallback $instance) {
      return invokeMethod($instance, "onAdWillDismissFullScreenContent", Arrays.<Object>asList());
    }
    
    
    
    public Completable<Object> $onAdImpression($FullScreenContentCallback $instance) {
      return invokeMethod($instance, "onAdImpression", Arrays.<Object>asList());
    }
    
    
    
    public Completable<Object> $onAdFailedToShowFullScreenContent($FullScreenContentCallback $instance) {
      return invokeMethod($instance, "onAdFailedToShowFullScreenContent", Arrays.<Object>asList());
    }
    
    
  }
  
  public static class $RewardedAdLoadCallbackChannel extends TypeChannel<$RewardedAdLoadCallback> {
    public $RewardedAdLoadCallbackChannel(@NonNull TypeChannelMessenger messenger) {
      super(messenger, "google_mobile_ads.RewardedAdLoadCallback");
    }

    public Completable<PairedInstance> $$create($RewardedAdLoadCallback $instance, boolean $owner) {
      return createNewInstancePair($instance, Arrays.<Object>asList(), $owner);
    }

    

    
    
    public Completable<Object> $onAdLoaded($RewardedAdLoadCallback $instance,$RewardedAd ad) {
      return invokeMethod($instance, "onAdLoaded", Arrays.<Object>asList(ad));
    }
    
    
    
    public Completable<Object> $onAdFailedToLoad($RewardedAdLoadCallback $instance,$LoadAdError error) {
      return invokeMethod($instance, "onAdFailedToLoad", Arrays.<Object>asList(error));
    }
    
    
  }
  
  public static class $InterstitialAdLoadCallbackChannel extends TypeChannel<$InterstitialAdLoadCallback> {
    public $InterstitialAdLoadCallbackChannel(@NonNull TypeChannelMessenger messenger) {
      super(messenger, "google_mobile_ads.InterstitialAdLoadCallback");
    }

    public Completable<PairedInstance> $$create($InterstitialAdLoadCallback $instance, boolean $owner) {
      return createNewInstancePair($instance, Arrays.<Object>asList(), $owner);
    }

    

    
    
    public Completable<Object> $onAdLoaded($InterstitialAdLoadCallback $instance,$InterstitialAd ad) {
      return invokeMethod($instance, "onAdLoaded", Arrays.<Object>asList(ad));
    }
    
    
    
    public Completable<Object> $onAdFailedToLoad($InterstitialAdLoadCallback $instance,$LoadAdError error) {
      return invokeMethod($instance, "onAdFailedToLoad", Arrays.<Object>asList(error));
    }
    
    
  }
  
  public static class $AdManagerInterstitialAdLoadCallbackChannel extends TypeChannel<$AdManagerInterstitialAdLoadCallback> {
    public $AdManagerInterstitialAdLoadCallbackChannel(@NonNull TypeChannelMessenger messenger) {
      super(messenger, "google_mobile_ads.AdManagerInterstitialAdLoadCallback");
    }

    public Completable<PairedInstance> $$create($AdManagerInterstitialAdLoadCallback $instance, boolean $owner) {
      return createNewInstancePair($instance, Arrays.<Object>asList(), $owner);
    }

    

    
    
    public Completable<Object> $onAdLoaded($AdManagerInterstitialAdLoadCallback $instance,$AdManagerInterstitialAd ad) {
      return invokeMethod($instance, "onAdLoaded", Arrays.<Object>asList(ad));
    }
    
    
    
    public Completable<Object> $onAdFailedToLoad($AdManagerInterstitialAdLoadCallback $instance,$LoadAdError error) {
      return invokeMethod($instance, "onAdFailedToLoad", Arrays.<Object>asList(error));
    }
    
    
  }
  
  public static class $AdErrorChannel extends TypeChannel<$AdError> {
    public $AdErrorChannel(@NonNull TypeChannelMessenger messenger) {
      super(messenger, "google_mobile_ads.AdError");
    }

    public Completable<PairedInstance> $$create($AdError $instance, boolean $owner,Integer code,String domain,String message) {
      return createNewInstancePair($instance, Arrays.<Object>asList(code,domain,message), $owner);
    }

    

    
  }
  
  public static class $ResponseInfoChannel extends TypeChannel<$ResponseInfo> {
    public $ResponseInfoChannel(@NonNull TypeChannelMessenger messenger) {
      super(messenger, "google_mobile_ads.ResponseInfo");
    }

    public Completable<PairedInstance> $$create($ResponseInfo $instance, boolean $owner,String responseId,String mediationAdapterClassName,List<$AdapterResponseInfo> adapterResponses) {
      return createNewInstancePair($instance, Arrays.<Object>asList(responseId,mediationAdapterClassName,adapterResponses), $owner);
    }

    

    
  }
  
  public static class $AdapterResponseInfoChannel extends TypeChannel<$AdapterResponseInfo> {
    public $AdapterResponseInfoChannel(@NonNull TypeChannelMessenger messenger) {
      super(messenger, "google_mobile_ads.AdapterResponseInfo");
    }

    public Completable<PairedInstance> $$create($AdapterResponseInfo $instance, boolean $owner,String adapterClassName,Long latencyMillis,String description,String credentials,$AdError adError) {
      return createNewInstancePair($instance, Arrays.<Object>asList(adapterClassName,latencyMillis,description,credentials,adError), $owner);
    }

    

    
  }
  
  public static class $LoadAdErrorChannel extends TypeChannel<$LoadAdError> {
    public $LoadAdErrorChannel(@NonNull TypeChannelMessenger messenger) {
      super(messenger, "google_mobile_ads.LoadAdError");
    }

    public Completable<PairedInstance> $$create($LoadAdError $instance, boolean $owner,Integer code,String domain,String message,$ResponseInfo responseInfo) {
      return createNewInstancePair($instance, Arrays.<Object>asList(code,domain,message,responseInfo), $owner);
    }

    

    
  }
  
  public static class $AdRequestChannel extends TypeChannel<$AdRequest> {
    public $AdRequestChannel(@NonNull TypeChannelMessenger messenger) {
      super(messenger, "google_mobile_ads.AdRequest");
    }

    public Completable<PairedInstance> $$create($AdRequest $instance, boolean $owner) {
      return createNewInstancePair($instance, Arrays.<Object>asList(), $owner);
    }

    

    
    
    
    
    
    
    
  }
  
  public static class $AdManagerAdRequestChannel extends TypeChannel<$AdManagerAdRequest> {
    public $AdManagerAdRequestChannel(@NonNull TypeChannelMessenger messenger) {
      super(messenger, "google_mobile_ads.AdRequest");
    }

    public Completable<PairedInstance> $$create($AdManagerAdRequest $instance, boolean $owner) {
      return createNewInstancePair($instance, Arrays.<Object>asList(), $owner);
    }

    

    
    
    
    
    
  }
  
  public static class $AdSizeChannel extends TypeChannel<$AdSize> {
    public $AdSizeChannel(@NonNull TypeChannelMessenger messenger) {
      super(messenger, "google_mobile_ads.AdSize");
    }

    public Completable<PairedInstance> $$create($AdSize $instance, boolean $owner,Integer width,Integer height,String constant) {
      return createNewInstancePair($instance, Arrays.<Object>asList(width,height,constant), $owner);
    }

    
    
    
    
    

    
  }
  
  public static class $BannerAdChannel extends TypeChannel<$BannerAd> {
    public $BannerAdChannel(@NonNull TypeChannelMessenger messenger) {
      super(messenger, "google_mobile_ads.BannerAd");
    }

    public Completable<PairedInstance> $$create($BannerAd $instance, boolean $owner,$AdSize size,String adUnitId,$BannerAdListener listener,$AdRequest request) {
      return createNewInstancePair($instance, Arrays.<Object>asList(size,adUnitId,listener,request), $owner);
    }

    

    
    
    
  }
  
  public static class $AdManagerBannerAdChannel extends TypeChannel<$AdManagerBannerAd> {
    public $AdManagerBannerAdChannel(@NonNull TypeChannelMessenger messenger) {
      super(messenger, "google_mobile_ads.AdManagerBannerAd");
    }

    public Completable<PairedInstance> $$create($AdManagerBannerAd $instance, boolean $owner,List<$AdSize> sizes,String adUnitId,$AdManagerBannerAdListener listener,$AdManagerAdRequest request) {
      return createNewInstancePair($instance, Arrays.<Object>asList(sizes,adUnitId,listener,request), $owner);
    }

    

    
    
    
  }
  
  public static class $NativeAdChannel extends TypeChannel<$NativeAd> {
    public $NativeAdChannel(@NonNull TypeChannelMessenger messenger) {
      super(messenger, "google_mobile_ads.NativeAd");
    }

    public Completable<PairedInstance> $$create($NativeAd $instance, boolean $owner,String adUnitId,String factoryId,$NativeAdListener listener,$AdRequest request,Map<String,Object> customOptions) {
      return createNewInstancePair($instance, Arrays.<Object>asList(adUnitId,factoryId,listener,request,customOptions), $owner);
    }

    

    
    
    
  }
  
  public static class $InterstitialAdChannel extends TypeChannel<$InterstitialAd> {
    public $InterstitialAdChannel(@NonNull TypeChannelMessenger messenger) {
      super(messenger, "google_mobile_ads.InterstitialAd");
    }

    public Completable<PairedInstance> $$create($InterstitialAd $instance, boolean $owner) {
      return createNewInstancePair($instance, Arrays.<Object>asList(), $owner);
    }

    
    
    

    
    
    
  }
  
  public static class $AdManagerInterstitialAdChannel extends TypeChannel<$AdManagerInterstitialAd> {
    public $AdManagerInterstitialAdChannel(@NonNull TypeChannelMessenger messenger) {
      super(messenger, "google_mobile_ads.AdManagerInterstitialAd");
    }

    public Completable<PairedInstance> $$create($AdManagerInterstitialAd $instance, boolean $owner) {
      return createNewInstancePair($instance, Arrays.<Object>asList(), $owner);
    }

    
    
    

    
    
    
  }
  
  public static class $RewardedAdChannel extends TypeChannel<$RewardedAd> {
    public $RewardedAdChannel(@NonNull TypeChannelMessenger messenger) {
      super(messenger, "google_mobile_ads.RewardedAd");
    }

    public Completable<PairedInstance> $$create($RewardedAd $instance, boolean $owner) {
      return createNewInstancePair($instance, Arrays.<Object>asList(), $owner);
    }

    
    
    

    
    
    
  }
  
  public static class $RewardItemChannel extends TypeChannel<$RewardItem> {
    public $RewardItemChannel(@NonNull TypeChannelMessenger messenger) {
      super(messenger, "google_mobile_ads.RewardItem");
    }

    public Completable<PairedInstance> $$create($RewardItem $instance, boolean $owner,Number amount,String type) {
      return createNewInstancePair($instance, Arrays.<Object>asList(amount,type), $owner);
    }

    

    
  }
  
  public static class $ServerSideVerificationOptionsChannel extends TypeChannel<$ServerSideVerificationOptions> {
    public $ServerSideVerificationOptionsChannel(@NonNull TypeChannelMessenger messenger) {
      super(messenger, "google_mobile_ads.ServerSideVerificationOptions");
    }

    public Completable<PairedInstance> $$create($ServerSideVerificationOptions $instance, boolean $owner,String userId,String customData) {
      return createNewInstancePair($instance, Arrays.<Object>asList(userId,customData), $owner);
    }

    

    
  }
  

  
  public static class $OnUserEarnedRewardListenerHandler implements TypeChannelHandler<$OnUserEarnedRewardListener> {
    public $OnUserEarnedRewardListener $$create(TypeChannelMessenger messenger)
        throws Exception {
      throw new UnsupportedOperationException();
    }

    

    
    
    

    @Override
    public Object invokeStaticMethod(
        TypeChannelMessenger messenger, String methodName, List<Object> arguments)
        throws Exception {
      switch (methodName) {
        
      }

      throw new UnsupportedOperationException(
          String.format("Unable to invoke static method %s", methodName));
    }

    @Override
    public $OnUserEarnedRewardListener createInstance(TypeChannelMessenger messenger, List<Object> arguments)
        throws Exception {
      return $$create(messenger);
    }

    @Override
    public Object invokeMethod(
        TypeChannelMessenger messenger,
        $OnUserEarnedRewardListener instance,
        String methodName,
        List<Object> arguments)
        throws Exception {
      switch(methodName) {
        
        
        
      }

      throw new UnsupportedOperationException(
          String.format("%s.%s not supported.", instance, methodName));
    }
  }
  
  public static class $AppEventListenerHandler implements TypeChannelHandler<$AppEventListener> {
    public $AppEventListener $$create(TypeChannelMessenger messenger)
        throws Exception {
      throw new UnsupportedOperationException();
    }

    

    
    
    

    @Override
    public Object invokeStaticMethod(
        TypeChannelMessenger messenger, String methodName, List<Object> arguments)
        throws Exception {
      switch (methodName) {
        
      }

      throw new UnsupportedOperationException(
          String.format("Unable to invoke static method %s", methodName));
    }

    @Override
    public $AppEventListener createInstance(TypeChannelMessenger messenger, List<Object> arguments)
        throws Exception {
      return $$create(messenger);
    }

    @Override
    public Object invokeMethod(
        TypeChannelMessenger messenger,
        $AppEventListener instance,
        String methodName,
        List<Object> arguments)
        throws Exception {
      switch(methodName) {
        
        
        
      }

      throw new UnsupportedOperationException(
          String.format("%s.%s not supported.", instance, methodName));
    }
  }
  
  public static class $AdWithViewListenerHandler implements TypeChannelHandler<$AdWithViewListener> {
    public $AdWithViewListener $$create(TypeChannelMessenger messenger)
        throws Exception {
      throw new UnsupportedOperationException();
    }

    

    
    
    
    
    
    
    
    
    
    
    
    
    

    @Override
    public Object invokeStaticMethod(
        TypeChannelMessenger messenger, String methodName, List<Object> arguments)
        throws Exception {
      switch (methodName) {
        
      }

      throw new UnsupportedOperationException(
          String.format("Unable to invoke static method %s", methodName));
    }

    @Override
    public $AdWithViewListener createInstance(TypeChannelMessenger messenger, List<Object> arguments)
        throws Exception {
      return $$create(messenger);
    }

    @Override
    public Object invokeMethod(
        TypeChannelMessenger messenger,
        $AdWithViewListener instance,
        String methodName,
        List<Object> arguments)
        throws Exception {
      switch(methodName) {
        
        
        
        
        
        
        
        
        
        
        
        
        
      }

      throw new UnsupportedOperationException(
          String.format("%s.%s not supported.", instance, methodName));
    }
  }
  
  public static class $BannerAdListenerHandler implements TypeChannelHandler<$BannerAdListener> {
    public $BannerAdListener $$create(TypeChannelMessenger messenger)
        throws Exception {
      throw new UnsupportedOperationException();
    }

    

    

    @Override
    public Object invokeStaticMethod(
        TypeChannelMessenger messenger, String methodName, List<Object> arguments)
        throws Exception {
      switch (methodName) {
        
      }

      throw new UnsupportedOperationException(
          String.format("Unable to invoke static method %s", methodName));
    }

    @Override
    public $BannerAdListener createInstance(TypeChannelMessenger messenger, List<Object> arguments)
        throws Exception {
      return $$create(messenger);
    }

    @Override
    public Object invokeMethod(
        TypeChannelMessenger messenger,
        $BannerAdListener instance,
        String methodName,
        List<Object> arguments)
        throws Exception {
      switch(methodName) {
        
      }

      throw new UnsupportedOperationException(
          String.format("%s.%s not supported.", instance, methodName));
    }
  }
  
  public static class $AdManagerBannerAdListenerHandler implements TypeChannelHandler<$AdManagerBannerAdListener> {
    public $AdManagerBannerAdListener $$create(TypeChannelMessenger messenger)
        throws Exception {
      throw new UnsupportedOperationException();
    }

    

    

    @Override
    public Object invokeStaticMethod(
        TypeChannelMessenger messenger, String methodName, List<Object> arguments)
        throws Exception {
      switch (methodName) {
        
      }

      throw new UnsupportedOperationException(
          String.format("Unable to invoke static method %s", methodName));
    }

    @Override
    public $AdManagerBannerAdListener createInstance(TypeChannelMessenger messenger, List<Object> arguments)
        throws Exception {
      return $$create(messenger);
    }

    @Override
    public Object invokeMethod(
        TypeChannelMessenger messenger,
        $AdManagerBannerAdListener instance,
        String methodName,
        List<Object> arguments)
        throws Exception {
      switch(methodName) {
        
      }

      throw new UnsupportedOperationException(
          String.format("%s.%s not supported.", instance, methodName));
    }
  }
  
  public static class $NativeAdListenerHandler implements TypeChannelHandler<$NativeAdListener> {
    public $NativeAdListener $$create(TypeChannelMessenger messenger)
        throws Exception {
      throw new UnsupportedOperationException();
    }

    

    
    
    

    @Override
    public Object invokeStaticMethod(
        TypeChannelMessenger messenger, String methodName, List<Object> arguments)
        throws Exception {
      switch (methodName) {
        
      }

      throw new UnsupportedOperationException(
          String.format("Unable to invoke static method %s", methodName));
    }

    @Override
    public $NativeAdListener createInstance(TypeChannelMessenger messenger, List<Object> arguments)
        throws Exception {
      return $$create(messenger);
    }

    @Override
    public Object invokeMethod(
        TypeChannelMessenger messenger,
        $NativeAdListener instance,
        String methodName,
        List<Object> arguments)
        throws Exception {
      switch(methodName) {
        
        
        
      }

      throw new UnsupportedOperationException(
          String.format("%s.%s not supported.", instance, methodName));
    }
  }
  
  public static class $FullScreenContentCallbackHandler implements TypeChannelHandler<$FullScreenContentCallback> {
    public $FullScreenContentCallback $$create(TypeChannelMessenger messenger)
        throws Exception {
      throw new UnsupportedOperationException();
    }

    

    
    
    
    
    
    
    
    
    
    
    

    @Override
    public Object invokeStaticMethod(
        TypeChannelMessenger messenger, String methodName, List<Object> arguments)
        throws Exception {
      switch (methodName) {
        
      }

      throw new UnsupportedOperationException(
          String.format("Unable to invoke static method %s", methodName));
    }

    @Override
    public $FullScreenContentCallback createInstance(TypeChannelMessenger messenger, List<Object> arguments)
        throws Exception {
      return $$create(messenger);
    }

    @Override
    public Object invokeMethod(
        TypeChannelMessenger messenger,
        $FullScreenContentCallback instance,
        String methodName,
        List<Object> arguments)
        throws Exception {
      switch(methodName) {
        
        
        
        
        
        
        
        
        
        
        
      }

      throw new UnsupportedOperationException(
          String.format("%s.%s not supported.", instance, methodName));
    }
  }
  
  public static class $RewardedAdLoadCallbackHandler implements TypeChannelHandler<$RewardedAdLoadCallback> {
    public $RewardedAdLoadCallback $$create(TypeChannelMessenger messenger)
        throws Exception {
      throw new UnsupportedOperationException();
    }

    

    
    
    
    
    

    @Override
    public Object invokeStaticMethod(
        TypeChannelMessenger messenger, String methodName, List<Object> arguments)
        throws Exception {
      switch (methodName) {
        
      }

      throw new UnsupportedOperationException(
          String.format("Unable to invoke static method %s", methodName));
    }

    @Override
    public $RewardedAdLoadCallback createInstance(TypeChannelMessenger messenger, List<Object> arguments)
        throws Exception {
      return $$create(messenger);
    }

    @Override
    public Object invokeMethod(
        TypeChannelMessenger messenger,
        $RewardedAdLoadCallback instance,
        String methodName,
        List<Object> arguments)
        throws Exception {
      switch(methodName) {
        
        
        
        
        
      }

      throw new UnsupportedOperationException(
          String.format("%s.%s not supported.", instance, methodName));
    }
  }
  
  public static class $InterstitialAdLoadCallbackHandler implements TypeChannelHandler<$InterstitialAdLoadCallback> {
    public $InterstitialAdLoadCallback $$create(TypeChannelMessenger messenger)
        throws Exception {
      throw new UnsupportedOperationException();
    }

    

    
    
    
    
    

    @Override
    public Object invokeStaticMethod(
        TypeChannelMessenger messenger, String methodName, List<Object> arguments)
        throws Exception {
      switch (methodName) {
        
      }

      throw new UnsupportedOperationException(
          String.format("Unable to invoke static method %s", methodName));
    }

    @Override
    public $InterstitialAdLoadCallback createInstance(TypeChannelMessenger messenger, List<Object> arguments)
        throws Exception {
      return $$create(messenger);
    }

    @Override
    public Object invokeMethod(
        TypeChannelMessenger messenger,
        $InterstitialAdLoadCallback instance,
        String methodName,
        List<Object> arguments)
        throws Exception {
      switch(methodName) {
        
        
        
        
        
      }

      throw new UnsupportedOperationException(
          String.format("%s.%s not supported.", instance, methodName));
    }
  }
  
  public static class $AdManagerInterstitialAdLoadCallbackHandler implements TypeChannelHandler<$AdManagerInterstitialAdLoadCallback> {
    public $AdManagerInterstitialAdLoadCallback $$create(TypeChannelMessenger messenger)
        throws Exception {
      throw new UnsupportedOperationException();
    }

    

    
    
    
    
    

    @Override
    public Object invokeStaticMethod(
        TypeChannelMessenger messenger, String methodName, List<Object> arguments)
        throws Exception {
      switch (methodName) {
        
      }

      throw new UnsupportedOperationException(
          String.format("Unable to invoke static method %s", methodName));
    }

    @Override
    public $AdManagerInterstitialAdLoadCallback createInstance(TypeChannelMessenger messenger, List<Object> arguments)
        throws Exception {
      return $$create(messenger);
    }

    @Override
    public Object invokeMethod(
        TypeChannelMessenger messenger,
        $AdManagerInterstitialAdLoadCallback instance,
        String methodName,
        List<Object> arguments)
        throws Exception {
      switch(methodName) {
        
        
        
        
        
      }

      throw new UnsupportedOperationException(
          String.format("%s.%s not supported.", instance, methodName));
    }
  }
  
  public static class $AdErrorHandler implements TypeChannelHandler<$AdError> {
    public $AdError $$create(TypeChannelMessenger messenger,Integer code,String domain,String message)
        throws Exception {
      throw new UnsupportedOperationException();
    }

    

    

    @Override
    public Object invokeStaticMethod(
        TypeChannelMessenger messenger, String methodName, List<Object> arguments)
        throws Exception {
      switch (methodName) {
        
      }

      throw new UnsupportedOperationException(
          String.format("Unable to invoke static method %s", methodName));
    }

    @Override
    public $AdError createInstance(TypeChannelMessenger messenger, List<Object> arguments)
        throws Exception {
      return $$create(messenger,(Integer) arguments.get(0),(String) arguments.get(1),(String) arguments.get(2));
    }

    @Override
    public Object invokeMethod(
        TypeChannelMessenger messenger,
        $AdError instance,
        String methodName,
        List<Object> arguments)
        throws Exception {
      switch(methodName) {
        
      }

      throw new UnsupportedOperationException(
          String.format("%s.%s not supported.", instance, methodName));
    }
  }
  
  public static class $ResponseInfoHandler implements TypeChannelHandler<$ResponseInfo> {
    public $ResponseInfo $$create(TypeChannelMessenger messenger,String responseId,String mediationAdapterClassName,List<$AdapterResponseInfo> adapterResponses)
        throws Exception {
      throw new UnsupportedOperationException();
    }

    

    

    @Override
    public Object invokeStaticMethod(
        TypeChannelMessenger messenger, String methodName, List<Object> arguments)
        throws Exception {
      switch (methodName) {
        
      }

      throw new UnsupportedOperationException(
          String.format("Unable to invoke static method %s", methodName));
    }

    @Override
    public $ResponseInfo createInstance(TypeChannelMessenger messenger, List<Object> arguments)
        throws Exception {
      return $$create(messenger,(String) arguments.get(0),(String) arguments.get(1),(List<$AdapterResponseInfo>) arguments.get(2));
    }

    @Override
    public Object invokeMethod(
        TypeChannelMessenger messenger,
        $ResponseInfo instance,
        String methodName,
        List<Object> arguments)
        throws Exception {
      switch(methodName) {
        
      }

      throw new UnsupportedOperationException(
          String.format("%s.%s not supported.", instance, methodName));
    }
  }
  
  public static class $AdapterResponseInfoHandler implements TypeChannelHandler<$AdapterResponseInfo> {
    public $AdapterResponseInfo $$create(TypeChannelMessenger messenger,String adapterClassName,Integer latencyMillis,String description,String credentials,$AdError adError)
        throws Exception {
      throw new UnsupportedOperationException();
    }

    

    

    @Override
    public Object invokeStaticMethod(
        TypeChannelMessenger messenger, String methodName, List<Object> arguments)
        throws Exception {
      switch (methodName) {
        
      }

      throw new UnsupportedOperationException(
          String.format("Unable to invoke static method %s", methodName));
    }

    @Override
    public $AdapterResponseInfo createInstance(TypeChannelMessenger messenger, List<Object> arguments)
        throws Exception {
      return $$create(messenger,(String) arguments.get(0),(Integer) arguments.get(1),(String) arguments.get(2),(String) arguments.get(3),($AdError) arguments.get(4));
    }

    @Override
    public Object invokeMethod(
        TypeChannelMessenger messenger,
        $AdapterResponseInfo instance,
        String methodName,
        List<Object> arguments)
        throws Exception {
      switch(methodName) {
        
      }

      throw new UnsupportedOperationException(
          String.format("%s.%s not supported.", instance, methodName));
    }
  }
  
  public static class $LoadAdErrorHandler implements TypeChannelHandler<$LoadAdError> {
    public $LoadAdError $$create(TypeChannelMessenger messenger,Integer code,String domain,String message,$ResponseInfo responseInfo)
        throws Exception {
      throw new UnsupportedOperationException();
    }

    

    

    @Override
    public Object invokeStaticMethod(
        TypeChannelMessenger messenger, String methodName, List<Object> arguments)
        throws Exception {
      switch (methodName) {
        
      }

      throw new UnsupportedOperationException(
          String.format("Unable to invoke static method %s", methodName));
    }

    @Override
    public $LoadAdError createInstance(TypeChannelMessenger messenger, List<Object> arguments)
        throws Exception {
      return $$create(messenger,(Integer) arguments.get(0),(String) arguments.get(1),(String) arguments.get(2),($ResponseInfo) arguments.get(3));
    }

    @Override
    public Object invokeMethod(
        TypeChannelMessenger messenger,
        $LoadAdError instance,
        String methodName,
        List<Object> arguments)
        throws Exception {
      switch(methodName) {
        
      }

      throw new UnsupportedOperationException(
          String.format("%s.%s not supported.", instance, methodName));
    }
  }
  
  public static class $AdRequestHandler implements TypeChannelHandler<$AdRequest> {
    public $AdRequest $$create(TypeChannelMessenger messenger)
        throws Exception {
      throw new UnsupportedOperationException();
    }

    

    
    
    public Object $addKeyword($AdRequest $instance,String keyword) throws Exception {
      return $instance.addKeyword( keyword );
    }
    
    
    
    public Object $setContentUrl($AdRequest $instance,String url) throws Exception {
      return $instance.setContentUrl( url );
    }
    
    
    
    public Object $setNonPersonalizedAds($AdRequest $instance,Boolean nonPersonalizedAds) throws Exception {
      return $instance.setNonPersonalizedAds( nonPersonalizedAds );
    }
    
    

    @Override
    public Object invokeStaticMethod(
        TypeChannelMessenger messenger, String methodName, List<Object> arguments)
        throws Exception {
      switch (methodName) {
        
      }

      throw new UnsupportedOperationException(
          String.format("Unable to invoke static method %s", methodName));
    }

    @Override
    public $AdRequest createInstance(TypeChannelMessenger messenger, List<Object> arguments)
        throws Exception {
      return $$create(messenger);
    }

    @Override
    public Object invokeMethod(
        TypeChannelMessenger messenger,
        $AdRequest instance,
        String methodName,
        List<Object> arguments)
        throws Exception {
      switch(methodName) {
        
        
        case "addKeyword":
          return $addKeyword(instance,(String) arguments.get(0));
        
        
        
        case "setContentUrl":
          return $setContentUrl(instance,(String) arguments.get(0));
        
        
        
        case "setNonPersonalizedAds":
          return $setNonPersonalizedAds(instance,(Boolean) arguments.get(0));
        
        
      }

      throw new UnsupportedOperationException(
          String.format("%s.%s not supported.", instance, methodName));
    }
  }
  
  public static class $AdManagerAdRequestHandler implements TypeChannelHandler<$AdManagerAdRequest> {
    public $AdManagerAdRequest $$create(TypeChannelMessenger messenger)
        throws Exception {
      throw new UnsupportedOperationException();
    }

    

    
    
    public Object $addCustomTargeting($AdManagerAdRequest $instance,String key,String value) throws Exception {
      return $instance.addCustomTargeting( key , value );
    }
    
    
    
    public Object $addCustomTargetingList($AdManagerAdRequest $instance,String key,List<String> values) throws Exception {
      return $instance.addCustomTargetingList( key , values );
    }
    
    

    @Override
    public Object invokeStaticMethod(
        TypeChannelMessenger messenger, String methodName, List<Object> arguments)
        throws Exception {
      switch (methodName) {
        
      }

      throw new UnsupportedOperationException(
          String.format("Unable to invoke static method %s", methodName));
    }

    @Override
    public $AdManagerAdRequest createInstance(TypeChannelMessenger messenger, List<Object> arguments)
        throws Exception {
      return $$create(messenger);
    }

    @Override
    public Object invokeMethod(
        TypeChannelMessenger messenger,
        $AdManagerAdRequest instance,
        String methodName,
        List<Object> arguments)
        throws Exception {
      switch(methodName) {
        
        
        case "addCustomTargeting":
          return $addCustomTargeting(instance,(String) arguments.get(0),(String) arguments.get(1));
        
        
        
        case "addCustomTargetingList":
          return $addCustomTargetingList(instance,(String) arguments.get(0),(List<String>) arguments.get(1));
        
        
      }

      throw new UnsupportedOperationException(
          String.format("%s.%s not supported.", instance, methodName));
    }
  }
  
  public static class $AdSizeHandler implements TypeChannelHandler<$AdSize> {
    public $AdSize $$create(TypeChannelMessenger messenger,Integer width,Integer height,String constant)
        throws Exception {
      throw new UnsupportedOperationException();
    }

    
    
    public Object $getPortraitAnchoredAdaptiveBannerAdSize(TypeChannelMessenger messenger,Integer width)
        throws Exception {
      throw new UnsupportedOperationException();
    }
    
    
    
    public Object $getLandscapeAnchoredAdaptiveBannerAdSize(TypeChannelMessenger messenger,Integer width)
        throws Exception {
      throw new UnsupportedOperationException();
    }
    
    

    

    @Override
    public Object invokeStaticMethod(
        TypeChannelMessenger messenger, String methodName, List<Object> arguments)
        throws Exception {
      switch (methodName) {
        
        
        case "getPortraitAnchoredAdaptiveBannerAdSize":
          return $getPortraitAnchoredAdaptiveBannerAdSize(messenger,(Integer) arguments.get(0));
        
        
        
        case "getLandscapeAnchoredAdaptiveBannerAdSize":
          return $getLandscapeAnchoredAdaptiveBannerAdSize(messenger,(Integer) arguments.get(0));
        
        
      }

      throw new UnsupportedOperationException(
          String.format("Unable to invoke static method %s", methodName));
    }

    @Override
    public $AdSize createInstance(TypeChannelMessenger messenger, List<Object> arguments)
        throws Exception {
      return $$create(messenger,(Integer) arguments.get(0),(Integer) arguments.get(1),(String) arguments.get(2));
    }

    @Override
    public Object invokeMethod(
        TypeChannelMessenger messenger,
        $AdSize instance,
        String methodName,
        List<Object> arguments)
        throws Exception {
      switch(methodName) {
        
      }

      throw new UnsupportedOperationException(
          String.format("%s.%s not supported.", instance, methodName));
    }
  }
  
  public static class $BannerAdHandler implements TypeChannelHandler<$BannerAd> {
    public $BannerAd $$create(TypeChannelMessenger messenger,$AdSize size,String adUnitId,$BannerAdListener listener,$AdRequest request)
        throws Exception {
      throw new UnsupportedOperationException();
    }

    

    
    
    public Object $load($BannerAd $instance) throws Exception {
      return $instance.load();
    }
    
    

    @Override
    public Object invokeStaticMethod(
        TypeChannelMessenger messenger, String methodName, List<Object> arguments)
        throws Exception {
      switch (methodName) {
        
      }

      throw new UnsupportedOperationException(
          String.format("Unable to invoke static method %s", methodName));
    }

    @Override
    public $BannerAd createInstance(TypeChannelMessenger messenger, List<Object> arguments)
        throws Exception {
      return $$create(messenger,($AdSize) arguments.get(0),(String) arguments.get(1),($BannerAdListener) arguments.get(2),($AdRequest) arguments.get(3));
    }

    @Override
    public Object invokeMethod(
        TypeChannelMessenger messenger,
        $BannerAd instance,
        String methodName,
        List<Object> arguments)
        throws Exception {
      switch(methodName) {
        
        
        case "load":
          return $load(instance);
        
        
      }

      throw new UnsupportedOperationException(
          String.format("%s.%s not supported.", instance, methodName));
    }
  }
  
  public static class $AdManagerBannerAdHandler implements TypeChannelHandler<$AdManagerBannerAd> {
    public $AdManagerBannerAd $$create(TypeChannelMessenger messenger,List<$AdSize> sizes,String adUnitId,$AdManagerBannerAdListener listener,$AdManagerAdRequest request)
        throws Exception {
      throw new UnsupportedOperationException();
    }

    

    
    
    public Object $load($AdManagerBannerAd $instance) throws Exception {
      return $instance.load();
    }
    
    

    @Override
    public Object invokeStaticMethod(
        TypeChannelMessenger messenger, String methodName, List<Object> arguments)
        throws Exception {
      switch (methodName) {
        
      }

      throw new UnsupportedOperationException(
          String.format("Unable to invoke static method %s", methodName));
    }

    @Override
    public $AdManagerBannerAd createInstance(TypeChannelMessenger messenger, List<Object> arguments)
        throws Exception {
      return $$create(messenger,(List<$AdSize>) arguments.get(0),(String) arguments.get(1),($AdManagerBannerAdListener) arguments.get(2),($AdManagerAdRequest) arguments.get(3));
    }

    @Override
    public Object invokeMethod(
        TypeChannelMessenger messenger,
        $AdManagerBannerAd instance,
        String methodName,
        List<Object> arguments)
        throws Exception {
      switch(methodName) {
        
        
        case "load":
          return $load(instance);
        
        
      }

      throw new UnsupportedOperationException(
          String.format("%s.%s not supported.", instance, methodName));
    }
  }
  
  public static class $NativeAdHandler implements TypeChannelHandler<$NativeAd> {
    public $NativeAd $$create(TypeChannelMessenger messenger,String adUnitId,String factoryId,$NativeAdListener listener,$AdRequest request, Map<String,Object> customOptions)
        throws Exception {
      throw new UnsupportedOperationException();
    }

    

    
    
    public Object $load($NativeAd $instance) throws Exception {
      return $instance.load();
    }
    
    

    @Override
    public Object invokeStaticMethod(
        TypeChannelMessenger messenger, String methodName, List<Object> arguments)
        throws Exception {
      switch (methodName) {
        
      }

      throw new UnsupportedOperationException(
          String.format("Unable to invoke static method %s", methodName));
    }

    @Override
    public $NativeAd createInstance(TypeChannelMessenger messenger, List<Object> arguments)
        throws Exception {
      return $$create(messenger,(String) arguments.get(0),(String) arguments.get(1),($NativeAdListener) arguments.get(2),($AdRequest) arguments.get(3),(Map<String,Object>) arguments.get(4));
    }

    @Override
    public Object invokeMethod(
        TypeChannelMessenger messenger,
        $NativeAd instance,
        String methodName,
        List<Object> arguments)
        throws Exception {
      switch(methodName) {
        
        
        case "load":
          return $load(instance);
        
        
      }

      throw new UnsupportedOperationException(
          String.format("%s.%s not supported.", instance, methodName));
    }
  }
  
  public static class $InterstitialAdHandler implements TypeChannelHandler<$InterstitialAd> {
    public $InterstitialAd $$create(TypeChannelMessenger messenger)
        throws Exception {
      throw new UnsupportedOperationException();
    }

    
    
    public Object $load(TypeChannelMessenger messenger,String adUnitId,$AdRequest request,$InterstitialAdLoadCallback adLoadCallback,$FullScreenContentCallback fullScreenContentCallback)
        throws Exception {
      throw new UnsupportedOperationException();
    }
    
    

    
    
    public Object $show($InterstitialAd $instance) throws Exception {
      return $instance.show();
    }
    
    

    @Override
    public Object invokeStaticMethod(
        TypeChannelMessenger messenger, String methodName, List<Object> arguments)
        throws Exception {
      switch (methodName) {
        
        
        case "load":
          return $load(messenger,(String) arguments.get(0),($AdRequest) arguments.get(1),($InterstitialAdLoadCallback) arguments.get(2),($FullScreenContentCallback) arguments.get(3));
        
        
      }

      throw new UnsupportedOperationException(
          String.format("Unable to invoke static method %s", methodName));
    }

    @Override
    public $InterstitialAd createInstance(TypeChannelMessenger messenger, List<Object> arguments)
        throws Exception {
      return $$create(messenger);
    }

    @Override
    public Object invokeMethod(
        TypeChannelMessenger messenger,
        $InterstitialAd instance,
        String methodName,
        List<Object> arguments)
        throws Exception {
      switch(methodName) {
        
        
        case "show":
          return $show(instance);
        
        
      }

      throw new UnsupportedOperationException(
          String.format("%s.%s not supported.", instance, methodName));
    }
  }
  
  public static class $AdManagerInterstitialAdHandler implements TypeChannelHandler<$AdManagerInterstitialAd> {
    public $AdManagerInterstitialAd $$create(TypeChannelMessenger messenger)
        throws Exception {
      throw new UnsupportedOperationException();
    }

    
    
    public Object $load(TypeChannelMessenger messenger,String adUnitId,$AdManagerAdRequest request,$AdManagerInterstitialAdLoadCallback adLoadCallback,$AppEventListener appEventListener,$FullScreenContentCallback fullScreenContentCallback)
        throws Exception {
      throw new UnsupportedOperationException();
    }
    
    

    
    
    public Object $show($AdManagerInterstitialAd $instance) throws Exception {
      return $instance.show();
    }
    
    

    @Override
    public Object invokeStaticMethod(
        TypeChannelMessenger messenger, String methodName, List<Object> arguments)
        throws Exception {
      switch (methodName) {
        
        
        case "load":
          return $load(messenger,(String) arguments.get(0),($AdManagerAdRequest) arguments.get(1),($AdManagerInterstitialAdLoadCallback) arguments.get(2),($AppEventListener) arguments.get(3),($FullScreenContentCallback) arguments.get(4));
        
        
      }

      throw new UnsupportedOperationException(
          String.format("Unable to invoke static method %s", methodName));
    }

    @Override
    public $AdManagerInterstitialAd createInstance(TypeChannelMessenger messenger, List<Object> arguments)
        throws Exception {
      return $$create(messenger);
    }

    @Override
    public Object invokeMethod(
        TypeChannelMessenger messenger,
        $AdManagerInterstitialAd instance,
        String methodName,
        List<Object> arguments)
        throws Exception {
      switch(methodName) {
        
        
        case "show":
          return $show(instance);
        
        
      }

      throw new UnsupportedOperationException(
          String.format("%s.%s not supported.", instance, methodName));
    }
  }
  
  public static class $RewardedAdHandler implements TypeChannelHandler<$RewardedAd> {
    public $RewardedAd $$create(TypeChannelMessenger messenger)
        throws Exception {
      throw new UnsupportedOperationException();
    }

    
    
    public Object $load(TypeChannelMessenger messenger,String adUnitId,$AdRequest request,$RewardedAdLoadCallback adLoadCallback,$ServerSideVerificationOptions serverSideVerificationOptions,$FullScreenContentCallback fullScreenContentCallback)
        throws Exception {
      throw new UnsupportedOperationException();
    }
    
    

    
    
    public Object $show($RewardedAd $instance,$OnUserEarnedRewardListener onUserEarnedReward) throws Exception {
      return $instance.show( onUserEarnedReward );
    }
    
    

    @Override
    public Object invokeStaticMethod(
        TypeChannelMessenger messenger, String methodName, List<Object> arguments)
        throws Exception {
      switch (methodName) {
        
        
        case "load":
          return $load(messenger,(String) arguments.get(0),($AdRequest) arguments.get(1),($RewardedAdLoadCallback) arguments.get(2),($ServerSideVerificationOptions) arguments.get(3),($FullScreenContentCallback) arguments.get(4));
        
        
      }

      throw new UnsupportedOperationException(
          String.format("Unable to invoke static method %s", methodName));
    }

    @Override
    public $RewardedAd createInstance(TypeChannelMessenger messenger, List<Object> arguments)
        throws Exception {
      return $$create(messenger);
    }

    @Override
    public Object invokeMethod(
        TypeChannelMessenger messenger,
        $RewardedAd instance,
        String methodName,
        List<Object> arguments)
        throws Exception {
      switch(methodName) {
        
        
        case "show":
          return $show(instance,($OnUserEarnedRewardListener) arguments.get(0));
        
        
      }

      throw new UnsupportedOperationException(
          String.format("%s.%s not supported.", instance, methodName));
    }
  }
  
  public static class $RewardItemHandler implements TypeChannelHandler<$RewardItem> {
    public $RewardItem $$create(TypeChannelMessenger messenger,Number amount,String type)
        throws Exception {
      throw new UnsupportedOperationException();
    }

    

    

    @Override
    public Object invokeStaticMethod(
        TypeChannelMessenger messenger, String methodName, List<Object> arguments)
        throws Exception {
      switch (methodName) {
        
      }

      throw new UnsupportedOperationException(
          String.format("Unable to invoke static method %s", methodName));
    }

    @Override
    public $RewardItem createInstance(TypeChannelMessenger messenger, List<Object> arguments)
        throws Exception {
      return $$create(messenger,(Number) arguments.get(0),(String) arguments.get(1));
    }

    @Override
    public Object invokeMethod(
        TypeChannelMessenger messenger,
        $RewardItem instance,
        String methodName,
        List<Object> arguments)
        throws Exception {
      switch(methodName) {
        
      }

      throw new UnsupportedOperationException(
          String.format("%s.%s not supported.", instance, methodName));
    }
  }
  
  public static class $ServerSideVerificationOptionsHandler implements TypeChannelHandler<$ServerSideVerificationOptions> {
    public $ServerSideVerificationOptions $$create(TypeChannelMessenger messenger,String userId,String customData)
        throws Exception {
      throw new UnsupportedOperationException();
    }

    

    

    @Override
    public Object invokeStaticMethod(
        TypeChannelMessenger messenger, String methodName, List<Object> arguments)
        throws Exception {
      switch (methodName) {
        
      }

      throw new UnsupportedOperationException(
          String.format("Unable to invoke static method %s", methodName));
    }

    @Override
    public $ServerSideVerificationOptions createInstance(TypeChannelMessenger messenger, List<Object> arguments)
        throws Exception {
      return $$create(messenger,(String) arguments.get(0),(String) arguments.get(1));
    }

    @Override
    public Object invokeMethod(
        TypeChannelMessenger messenger,
        $ServerSideVerificationOptions instance,
        String methodName,
        List<Object> arguments)
        throws Exception {
      switch(methodName) {
        
      }

      throw new UnsupportedOperationException(
          String.format("%s.%s not supported.", instance, methodName));
    }
  }
  

  public static class $LibraryImplementations {
    public final TypeChannelMessenger messenger;

    public $LibraryImplementations(TypeChannelMessenger messenger) {
      this.messenger = messenger;
    }

    
    public $OnUserEarnedRewardListenerChannel getChannelOnUserEarnedRewardListener() {
      return new $OnUserEarnedRewardListenerChannel(messenger);
    }

    public $OnUserEarnedRewardListenerHandler getHandlerOnUserEarnedRewardListener() {
      return new $OnUserEarnedRewardListenerHandler();
    }
    
    public $AppEventListenerChannel getChannelAppEventListener() {
      return new $AppEventListenerChannel(messenger);
    }

    public $AppEventListenerHandler getHandlerAppEventListener() {
      return new $AppEventListenerHandler();
    }
    
    public $AdWithViewListenerChannel getChannelAdWithViewListener() {
      return new $AdWithViewListenerChannel(messenger);
    }

    public $AdWithViewListenerHandler getHandlerAdWithViewListener() {
      return new $AdWithViewListenerHandler();
    }
    
    public $BannerAdListenerChannel getChannelBannerAdListener() {
      return new $BannerAdListenerChannel(messenger);
    }

    public $BannerAdListenerHandler getHandlerBannerAdListener() {
      return new $BannerAdListenerHandler();
    }
    
    public $AdManagerBannerAdListenerChannel getChannelAdManagerBannerAdListener() {
      return new $AdManagerBannerAdListenerChannel(messenger);
    }

    public $AdManagerBannerAdListenerHandler getHandlerAdManagerBannerAdListener() {
      return new $AdManagerBannerAdListenerHandler();
    }
    
    public $NativeAdListenerChannel getChannelNativeAdListener() {
      return new $NativeAdListenerChannel(messenger);
    }

    public $NativeAdListenerHandler getHandlerNativeAdListener() {
      return new $NativeAdListenerHandler();
    }
    
    public $FullScreenContentCallbackChannel getChannelFullScreenContentCallback() {
      return new $FullScreenContentCallbackChannel(messenger);
    }

    public $FullScreenContentCallbackHandler getHandlerFullScreenContentCallback() {
      return new $FullScreenContentCallbackHandler();
    }
    
    public $RewardedAdLoadCallbackChannel getChannelRewardedAdLoadCallback() {
      return new $RewardedAdLoadCallbackChannel(messenger);
    }

    public $RewardedAdLoadCallbackHandler getHandlerRewardedAdLoadCallback() {
      return new $RewardedAdLoadCallbackHandler();
    }
    
    public $InterstitialAdLoadCallbackChannel getChannelInterstitialAdLoadCallback() {
      return new $InterstitialAdLoadCallbackChannel(messenger);
    }

    public $InterstitialAdLoadCallbackHandler getHandlerInterstitialAdLoadCallback() {
      return new $InterstitialAdLoadCallbackHandler();
    }
    
    public $AdManagerInterstitialAdLoadCallbackChannel getChannelAdManagerInterstitialAdLoadCallback() {
      return new $AdManagerInterstitialAdLoadCallbackChannel(messenger);
    }

    public $AdManagerInterstitialAdLoadCallbackHandler getHandlerAdManagerInterstitialAdLoadCallback() {
      return new $AdManagerInterstitialAdLoadCallbackHandler();
    }
    
    public $AdErrorChannel getChannelAdError() {
      return new $AdErrorChannel(messenger);
    }

    public $AdErrorHandler getHandlerAdError() {
      return new $AdErrorHandler();
    }
    
    public $ResponseInfoChannel getChannelResponseInfo() {
      return new $ResponseInfoChannel(messenger);
    }

    public $ResponseInfoHandler getHandlerResponseInfo() {
      return new $ResponseInfoHandler();
    }
    
    public $AdapterResponseInfoChannel getChannelAdapterResponseInfo() {
      return new $AdapterResponseInfoChannel(messenger);
    }

    public $AdapterResponseInfoHandler getHandlerAdapterResponseInfo() {
      return new $AdapterResponseInfoHandler();
    }
    
    public $LoadAdErrorChannel getChannelLoadAdError() {
      return new $LoadAdErrorChannel(messenger);
    }

    public $LoadAdErrorHandler getHandlerLoadAdError() {
      return new $LoadAdErrorHandler();
    }
    
    public $AdRequestChannel getChannelAdRequest() {
      return new $AdRequestChannel(messenger);
    }

    public $AdRequestHandler getHandlerAdRequest() {
      return new $AdRequestHandler();
    }
    
    public $AdManagerAdRequestChannel getChannelAdManagerAdRequest() {
      return new $AdManagerAdRequestChannel(messenger);
    }

    public $AdManagerAdRequestHandler getHandlerAdManagerAdRequest() {
      return new $AdManagerAdRequestHandler();
    }
    
    public $AdSizeChannel getChannelAdSize() {
      return new $AdSizeChannel(messenger);
    }

    public $AdSizeHandler getHandlerAdSize() {
      return new $AdSizeHandler();
    }
    
    public $BannerAdChannel getChannelBannerAd() {
      return new $BannerAdChannel(messenger);
    }

    public $BannerAdHandler getHandlerBannerAd() {
      return new $BannerAdHandler();
    }
    
    public $AdManagerBannerAdChannel getChannelAdManagerBannerAd() {
      return new $AdManagerBannerAdChannel(messenger);
    }

    public $AdManagerBannerAdHandler getHandlerAdManagerBannerAd() {
      return new $AdManagerBannerAdHandler();
    }
    
    public $NativeAdChannel getChannelNativeAd() {
      return new $NativeAdChannel(messenger);
    }

    public $NativeAdHandler getHandlerNativeAd() {
      return new $NativeAdHandler();
    }
    
    public $InterstitialAdChannel getChannelInterstitialAd() {
      return new $InterstitialAdChannel(messenger);
    }

    public $InterstitialAdHandler getHandlerInterstitialAd() {
      return new $InterstitialAdHandler();
    }
    
    public $AdManagerInterstitialAdChannel getChannelAdManagerInterstitialAd() {
      return new $AdManagerInterstitialAdChannel(messenger);
    }

    public $AdManagerInterstitialAdHandler getHandlerAdManagerInterstitialAd() {
      return new $AdManagerInterstitialAdHandler();
    }
    
    public $RewardedAdChannel getChannelRewardedAd() {
      return new $RewardedAdChannel(messenger);
    }

    public $RewardedAdHandler getHandlerRewardedAd() {
      return new $RewardedAdHandler();
    }
    
    public $RewardItemChannel getChannelRewardItem() {
      return new $RewardItemChannel(messenger);
    }

    public $RewardItemHandler getHandlerRewardItem() {
      return new $RewardItemHandler();
    }
    
    public $ServerSideVerificationOptionsChannel getChannelServerSideVerificationOptions() {
      return new $ServerSideVerificationOptionsChannel(messenger);
    }

    public $ServerSideVerificationOptionsHandler getHandlerServerSideVerificationOptions() {
      return new $ServerSideVerificationOptionsHandler();
    }
    
  }

  public static class $ChannelRegistrar {
    public final $LibraryImplementations implementations;

    public $ChannelRegistrar($LibraryImplementations implementations) {
      this.implementations = implementations;
    }


    public void registerHandlers() {
      
      implementations.getChannelOnUserEarnedRewardListener().setHandler(implementations.getHandlerOnUserEarnedRewardListener());
      
      implementations.getChannelAppEventListener().setHandler(implementations.getHandlerAppEventListener());
      
      implementations.getChannelAdWithViewListener().setHandler(implementations.getHandlerAdWithViewListener());
      
      implementations.getChannelBannerAdListener().setHandler(implementations.getHandlerBannerAdListener());
      
      implementations.getChannelAdManagerBannerAdListener().setHandler(implementations.getHandlerAdManagerBannerAdListener());
      
      implementations.getChannelNativeAdListener().setHandler(implementations.getHandlerNativeAdListener());
      
      implementations.getChannelFullScreenContentCallback().setHandler(implementations.getHandlerFullScreenContentCallback());
      
      implementations.getChannelRewardedAdLoadCallback().setHandler(implementations.getHandlerRewardedAdLoadCallback());
      
      implementations.getChannelInterstitialAdLoadCallback().setHandler(implementations.getHandlerInterstitialAdLoadCallback());
      
      implementations.getChannelAdManagerInterstitialAdLoadCallback().setHandler(implementations.getHandlerAdManagerInterstitialAdLoadCallback());
      
      implementations.getChannelAdError().setHandler(implementations.getHandlerAdError());
      
      implementations.getChannelResponseInfo().setHandler(implementations.getHandlerResponseInfo());
      
      implementations.getChannelAdapterResponseInfo().setHandler(implementations.getHandlerAdapterResponseInfo());
      
      implementations.getChannelLoadAdError().setHandler(implementations.getHandlerLoadAdError());
      
      implementations.getChannelAdRequest().setHandler(implementations.getHandlerAdRequest());
      
      implementations.getChannelAdManagerAdRequest().setHandler(implementations.getHandlerAdManagerAdRequest());
      
      implementations.getChannelAdSize().setHandler(implementations.getHandlerAdSize());
      
      implementations.getChannelBannerAd().setHandler(implementations.getHandlerBannerAd());
      
      implementations.getChannelAdManagerBannerAd().setHandler(implementations.getHandlerAdManagerBannerAd());
      
      implementations.getChannelNativeAd().setHandler(implementations.getHandlerNativeAd());
      
      implementations.getChannelInterstitialAd().setHandler(implementations.getHandlerInterstitialAd());
      
      implementations.getChannelAdManagerInterstitialAd().setHandler(implementations.getHandlerAdManagerInterstitialAd());
      
      implementations.getChannelRewardedAd().setHandler(implementations.getHandlerRewardedAd());
      
      implementations.getChannelRewardItem().setHandler(implementations.getHandlerRewardItem());
      
      implementations.getChannelServerSideVerificationOptions().setHandler(implementations.getHandlerServerSideVerificationOptions());
      
    }

    public void unregisterHandlers() {
      
      implementations.getChannelOnUserEarnedRewardListener().removeHandler();
      
      implementations.getChannelAppEventListener().removeHandler();
      
      implementations.getChannelAdWithViewListener().removeHandler();
      
      implementations.getChannelBannerAdListener().removeHandler();
      
      implementations.getChannelAdManagerBannerAdListener().removeHandler();
      
      implementations.getChannelNativeAdListener().removeHandler();
      
      implementations.getChannelFullScreenContentCallback().removeHandler();
      
      implementations.getChannelRewardedAdLoadCallback().removeHandler();
      
      implementations.getChannelInterstitialAdLoadCallback().removeHandler();
      
      implementations.getChannelAdManagerInterstitialAdLoadCallback().removeHandler();
      
      implementations.getChannelAdError().removeHandler();
      
      implementations.getChannelResponseInfo().removeHandler();
      
      implementations.getChannelAdapterResponseInfo().removeHandler();
      
      implementations.getChannelLoadAdError().removeHandler();
      
      implementations.getChannelAdRequest().removeHandler();
      
      implementations.getChannelAdManagerAdRequest().removeHandler();
      
      implementations.getChannelAdSize().removeHandler();
      
      implementations.getChannelBannerAd().removeHandler();
      
      implementations.getChannelAdManagerBannerAd().removeHandler();
      
      implementations.getChannelNativeAd().removeHandler();
      
      implementations.getChannelInterstitialAd().removeHandler();
      
      implementations.getChannelAdManagerInterstitialAd().removeHandler();
      
      implementations.getChannelRewardedAd().removeHandler();
      
      implementations.getChannelRewardItem().removeHandler();
      
      implementations.getChannelServerSideVerificationOptions().removeHandler();
      
    }
  }
}
