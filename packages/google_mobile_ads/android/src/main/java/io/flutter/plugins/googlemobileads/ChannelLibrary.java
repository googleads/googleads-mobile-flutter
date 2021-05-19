// GENERATED CODE - DO NOT MODIFY BY HAND

package io.flutter.plguins.googlemobileads;

import androidx.annotation.NonNull;

import java.lang.reflect.Method;
import java.util.Arrays;
import java.util.List;

import github.penguin.reference.async.Completable;
import github.penguin.reference.reference.TypeChannel;
import github.penguin.reference.reference.TypeChannelHandler;
import github.penguin.reference.reference.TypeChannelMessenger;

// **************************************************************************
// ReferenceGenerator
// **************************************************************************

public class ChannelLibrary {
  public interface $LoadAdError {
    Integer getCode();
String getDomain();
String getMessage();

    
  }
public interface $AdRequest {
    

    Object addKeyword(String keyword) throws Exception;
Object setContentUrl(String url) throws Exception;
Object setNonPersonalizedAds(Boolean nonPersonalizedAds) throws Exception;
  }
public interface $PublisherAdRequest {
    

    Object addCustomTargeting(String key,String value) throws Exception;
Object addCustomTargetingList(String key,List<String> values) throws Exception;
  }
public interface $AdSize {
    Integer getWidth();
Integer getHeight();
String getConstant();

    
  }
public interface $AdListener {
    

    Object onAdLoaded() throws Exception;
Object onAdFailedToLoad($LoadAdError error) throws Exception;
Object onAppEvent(String name,String data) throws Exception;
Object onNativeAdClicked() throws Exception;
Object onNativeAdImpression() throws Exception;
Object onAdOpened() throws Exception;
Object onApplicationExit() throws Exception;
Object onAdClosed() throws Exception;
Object onRewardedAdUserEarnedReward($RewardItem reward) throws Exception;
  }
public interface $BannerAd {
    $AdSize getSize();
String getAdUnitId();
$AdListener getListener();
$AdRequest getRequest();

    Object load() throws Exception;
  }
public interface $PublisherBannerAd {
    List<$AdSize> getSizes();
String getAdUnitId();
$AdListener getListener();
$PublisherAdRequest getRequest();

    Object load() throws Exception;
  }
public interface $NativeAd {
    String getAdUnitId();
String getFactoryId();
$AdListener getListener();
$AdRequest getRequest();
Map<String,Object> getCustomOptions();

    Object load() throws Exception;
  }
public interface $InterstitialAd {
    String getAdUnitId();
$AdListener getListener();
$AdRequest getRequest();

    Object load() throws Exception;
Object show() throws Exception;
  }
public interface $PublisherInterstitialAd {
    String getAdUnitId();
$AdListener getListener();
$PublisherAdRequest getRequest();

    Object load() throws Exception;
Object show() throws Exception;
  }
public interface $RewardedAd {
    String getAdUnitId();
$AdListener getListener();
$AdRequest getRequest();
$ServerSideVerificationOptions getServerSideVerificationOptions();

    Object load() throws Exception;
Object show() throws Exception;
  }
public interface $RewardItem {
    Number getAmount();
String getType();

    
  }
public interface $ServerSideVerificationOptions {
    

    Object setUserId(String userId) throws Exception;
Object setCustomData(String customData) throws Exception;
  }

  public static class $LoadAdErrorCreationArgs {
    public Integer code;
public String domain;
public String message;
  }

static class $AdRequestCreationArgs {
    
  }

static class $PublisherAdRequestCreationArgs {
    
  }

static class $AdSizeCreationArgs {
    public Integer width;
public Integer height;
public String constant;
  }

static class $AdListenerCreationArgs {
    
  }

static class $BannerAdCreationArgs {
    public $AdSize size;
public String adUnitId;
public $AdListener listener;
public $AdRequest request;
  }

static class $PublisherBannerAdCreationArgs {
    public List<$AdSize> sizes;
public String adUnitId;
public $AdListener listener;
public $PublisherAdRequest request;
  }

static class $NativeAdCreationArgs {
    public String adUnitId;
public String factoryId;
public $AdListener listener;
public $AdRequest request;
public Map<String,Object> customOptions;
  }

static class $InterstitialAdCreationArgs {
    public String adUnitId;
public $AdListener listener;
public $AdRequest request;
  }

static class $PublisherInterstitialAdCreationArgs {
    public String adUnitId;
public $AdListener listener;
public $PublisherAdRequest request;
  }

static class $RewardedAdCreationArgs {
    public String adUnitId;
public $AdListener listener;
public $AdRequest request;
public $ServerSideVerificationOptions serverSideVerificationOptions;
  }

static class $RewardItemCreationArgs {
    public Number amount;
public String type;
  }

static class $ServerSideVerificationOptionsCreationArgs {
    
  }

  public static class $LoadAdErrorChannel extends TypeChannel<$LoadAdError> {
    public $LoadAdErrorChannel(@NonNull TypeChannelMessenger messenger) {
      super(messenger, "google_mobile_ads.LoadAdError");
    }

    

    
  }

public static class $AdRequestChannel extends TypeChannel<$AdRequest> {
    public $AdRequestChannel(@NonNull TypeChannelMessenger messenger) {
      super(messenger, "google_mobile_ads.AdRequest");
    }

    

    public Completable<Object> $invokeAddKeyword($AdRequest instance, String keyword) {
      return invokeMethod(instance, "addKeyword", Arrays.<Object>asList(keyword));
    }

public Completable<Object> $invokeSetContentUrl($AdRequest instance, String url) {
      return invokeMethod(instance, "setContentUrl", Arrays.<Object>asList(url));
    }

public Completable<Object> $invokeSetNonPersonalizedAds($AdRequest instance, Boolean nonPersonalizedAds) {
      return invokeMethod(instance, "setNonPersonalizedAds", Arrays.<Object>asList(nonPersonalizedAds));
    }
  }

public static class $PublisherAdRequestChannel extends TypeChannel<$PublisherAdRequest> {
    public $PublisherAdRequestChannel(@NonNull TypeChannelMessenger messenger) {
      super(messenger, "google_mobile_ads.PublisherAdRequest");
    }

    

    public Completable<Object> $invokeAddCustomTargeting($PublisherAdRequest instance, String key , String value) {
      return invokeMethod(instance, "addCustomTargeting", Arrays.<Object>asList(key, value));
    }

public Completable<Object> $invokeAddCustomTargetingList($PublisherAdRequest instance, String key , List<String> values) {
      return invokeMethod(instance, "addCustomTargetingList", Arrays.<Object>asList(key, values));
    }
  }

public static class $AdSizeChannel extends TypeChannel<$AdSize> {
    public $AdSizeChannel(@NonNull TypeChannelMessenger messenger) {
      super(messenger, "google_mobile_ads.AdSize");
    }

    public Completable<Object> $invokeGetPortraitAnchoredAdaptiveBannerAdSize(Integer width) {
      return invokeStaticMethod("getPortraitAnchoredAdaptiveBannerAdSize", Arrays.<Object>asList(width));
    }

public Completable<Object> $invokeGetLandscapeAnchoredAdaptiveBannerAdSize(Integer width) {
      return invokeStaticMethod("getLandscapeAnchoredAdaptiveBannerAdSize", Arrays.<Object>asList(width));
    }

    
  }

public static class $AdListenerChannel extends TypeChannel<$AdListener> {
    public $AdListenerChannel(@NonNull TypeChannelMessenger messenger) {
      super(messenger, "google_mobile_ads.AdListener");
    }

    

    public Completable<Object> $invokeOnAdLoaded($AdListener instance) {
      return invokeMethod(instance, "onAdLoaded", Arrays.<Object>asList());
    }

public Completable<Object> $invokeOnAdFailedToLoad($AdListener instance, $LoadAdError error) {
      return invokeMethod(instance, "onAdFailedToLoad", Arrays.<Object>asList(error));
    }

public Completable<Object> $invokeOnAppEvent($AdListener instance, String name , String data) {
      return invokeMethod(instance, "onAppEvent", Arrays.<Object>asList(name, data));
    }

public Completable<Object> $invokeOnNativeAdClicked($AdListener instance) {
      return invokeMethod(instance, "onNativeAdClicked", Arrays.<Object>asList());
    }

public Completable<Object> $invokeOnNativeAdImpression($AdListener instance) {
      return invokeMethod(instance, "onNativeAdImpression", Arrays.<Object>asList());
    }

public Completable<Object> $invokeOnAdOpened($AdListener instance) {
      return invokeMethod(instance, "onAdOpened", Arrays.<Object>asList());
    }

public Completable<Object> $invokeOnApplicationExit($AdListener instance) {
      return invokeMethod(instance, "onApplicationExit", Arrays.<Object>asList());
    }

public Completable<Object> $invokeOnAdClosed($AdListener instance) {
      return invokeMethod(instance, "onAdClosed", Arrays.<Object>asList());
    }

public Completable<Object> $invokeOnRewardedAdUserEarnedReward($AdListener instance, $RewardItem reward) {
      return invokeMethod(instance, "onRewardedAdUserEarnedReward", Arrays.<Object>asList(reward));
    }
  }

public static class $BannerAdChannel extends TypeChannel<$BannerAd> {
    public $BannerAdChannel(@NonNull TypeChannelMessenger messenger) {
      super(messenger, "google_mobile_ads.BannerAd");
    }

    

    public Completable<Object> $invokeLoad($BannerAd instance) {
      return invokeMethod(instance, "load", Arrays.<Object>asList());
    }
  }

public static class $PublisherBannerAdChannel extends TypeChannel<$PublisherBannerAd> {
    public $PublisherBannerAdChannel(@NonNull TypeChannelMessenger messenger) {
      super(messenger, "google_mobile_ads.PublisherBannerAd");
    }

    

    public Completable<Object> $invokeLoad($PublisherBannerAd instance) {
      return invokeMethod(instance, "load", Arrays.<Object>asList());
    }
  }

public static class $NativeAdChannel extends TypeChannel<$NativeAd> {
    public $NativeAdChannel(@NonNull TypeChannelMessenger messenger) {
      super(messenger, "google_mobile_ads.NativeAd");
    }

    

    public Completable<Object> $invokeLoad($NativeAd instance) {
      return invokeMethod(instance, "load", Arrays.<Object>asList());
    }
  }

public static class $InterstitialAdChannel extends TypeChannel<$InterstitialAd> {
    public $InterstitialAdChannel(@NonNull TypeChannelMessenger messenger) {
      super(messenger, "google_mobile_ads.InterstitialAd");
    }

    

    public Completable<Object> $invokeLoad($InterstitialAd instance) {
      return invokeMethod(instance, "load", Arrays.<Object>asList());
    }

public Completable<Object> $invokeShow($InterstitialAd instance) {
      return invokeMethod(instance, "show", Arrays.<Object>asList());
    }
  }

public static class $PublisherInterstitialAdChannel extends TypeChannel<$PublisherInterstitialAd> {
    public $PublisherInterstitialAdChannel(@NonNull TypeChannelMessenger messenger) {
      super(messenger, "google_mobile_ads.PublisherInterstitialAd");
    }

    

    public Completable<Object> $invokeLoad($PublisherInterstitialAd instance) {
      return invokeMethod(instance, "load", Arrays.<Object>asList());
    }

public Completable<Object> $invokeShow($PublisherInterstitialAd instance) {
      return invokeMethod(instance, "show", Arrays.<Object>asList());
    }
  }

public static class $RewardedAdChannel extends TypeChannel<$RewardedAd> {
    public $RewardedAdChannel(@NonNull TypeChannelMessenger messenger) {
      super(messenger, "google_mobile_ads.RewardedAd");
    }

    

    public Completable<Object> $invokeLoad($RewardedAd instance) {
      return invokeMethod(instance, "load", Arrays.<Object>asList());
    }

public Completable<Object> $invokeShow($RewardedAd instance) {
      return invokeMethod(instance, "show", Arrays.<Object>asList());
    }
  }

public static class $RewardItemChannel extends TypeChannel<$RewardItem> {
    public $RewardItemChannel(@NonNull TypeChannelMessenger messenger) {
      super(messenger, "google_mobile_ads.RewardItem");
    }

    

    
  }

public static class $ServerSideVerificationOptionsChannel extends TypeChannel<$ServerSideVerificationOptions> {
    public $ServerSideVerificationOptionsChannel(@NonNull TypeChannelMessenger messenger) {
      super(messenger, "google_mobile_ads.ServerSideVerificationOptions");
    }

    

    public Completable<Object> $invokeSetUserId($ServerSideVerificationOptions instance, String userId) {
      return invokeMethod(instance, "setUserId", Arrays.<Object>asList(userId));
    }

public Completable<Object> $invokeSetCustomData($ServerSideVerificationOptions instance, String customData) {
      return invokeMethod(instance, "setCustomData", Arrays.<Object>asList(customData));
    }
  }

  public static class $LoadAdErrorHandler implements TypeChannelHandler<$LoadAdError> {
    public $LoadAdError onCreate(TypeChannelMessenger messenger, $LoadAdErrorCreationArgs args)
        throws Exception {
      return null;
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
    public List<Object> getCreationArguments(
        TypeChannelMessenger messenger, $LoadAdError instance) {
      return Arrays.<Object>asList(instance.getCode(),instance.getDomain(),instance.getMessage());
    }

    @Override
    public $LoadAdError createInstance(TypeChannelMessenger messenger, List<Object> arguments)
        throws Exception {
      final $LoadAdErrorCreationArgs args = new $LoadAdErrorCreationArgs();
      args.code = (Integer) arguments.get(0);
args.domain = (String) arguments.get(1);
args.message = (String) arguments.get(2);
      return onCreate(messenger, args);
    }

    @Override
    public Object invokeMethod(
        TypeChannelMessenger messenger,
        $LoadAdError instance,
        String methodName,
        List<Object> arguments)
        throws Exception {
      for (Method method : $LoadAdError.class.getMethods()) {
        if (method.getName().equals(methodName)) {
          return method.invoke(instance, arguments.toArray());
        }
      }

      throw new UnsupportedOperationException(
          String.format("%s.%s not supported.", instance, methodName));
    }
  }
public static class $AdRequestHandler implements TypeChannelHandler<$AdRequest> {
    public $AdRequest onCreate(TypeChannelMessenger messenger, $AdRequestCreationArgs args)
        throws Exception {
      return null;
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
    public List<Object> getCreationArguments(
        TypeChannelMessenger messenger, $AdRequest instance) {
      return Arrays.<Object>asList();
    }

    @Override
    public $AdRequest createInstance(TypeChannelMessenger messenger, List<Object> arguments)
        throws Exception {
      final $AdRequestCreationArgs args = new $AdRequestCreationArgs();
      
      return onCreate(messenger, args);
    }

    @Override
    public Object invokeMethod(
        TypeChannelMessenger messenger,
        $AdRequest instance,
        String methodName,
        List<Object> arguments)
        throws Exception {
      for (Method method : $AdRequest.class.getMethods()) {
        if (method.getName().equals(methodName)) {
          return method.invoke(instance, arguments.toArray());
        }
      }

      throw new UnsupportedOperationException(
          String.format("%s.%s not supported.", instance, methodName));
    }
  }
public static class $PublisherAdRequestHandler implements TypeChannelHandler<$PublisherAdRequest> {
    public $PublisherAdRequest onCreate(TypeChannelMessenger messenger, $PublisherAdRequestCreationArgs args)
        throws Exception {
      return null;
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
    public List<Object> getCreationArguments(
        TypeChannelMessenger messenger, $PublisherAdRequest instance) {
      return Arrays.<Object>asList();
    }

    @Override
    public $PublisherAdRequest createInstance(TypeChannelMessenger messenger, List<Object> arguments)
        throws Exception {
      final $PublisherAdRequestCreationArgs args = new $PublisherAdRequestCreationArgs();
      
      return onCreate(messenger, args);
    }

    @Override
    public Object invokeMethod(
        TypeChannelMessenger messenger,
        $PublisherAdRequest instance,
        String methodName,
        List<Object> arguments)
        throws Exception {
      for (Method method : $PublisherAdRequest.class.getMethods()) {
        if (method.getName().equals(methodName)) {
          return method.invoke(instance, arguments.toArray());
        }
      }

      throw new UnsupportedOperationException(
          String.format("%s.%s not supported.", instance, methodName));
    }
  }
public static class $AdSizeHandler implements TypeChannelHandler<$AdSize> {
    public $AdSize onCreate(TypeChannelMessenger messenger, $AdSizeCreationArgs args)
        throws Exception {
      return null;
    }

    public Object $onGetPortraitAnchoredAdaptiveBannerAdSize(TypeChannelMessenger messenger, Integer width)
        throws Exception {
      return null;
    }
public Object $onGetLandscapeAnchoredAdaptiveBannerAdSize(TypeChannelMessenger messenger, Integer width)
        throws Exception {
      return null;
    }

    @Override
    public Object invokeStaticMethod(
        TypeChannelMessenger messenger, String methodName, List<Object> arguments)
        throws Exception {
      switch (methodName) {
        case "getPortraitAnchoredAdaptiveBannerAdSize":
          return $onGetPortraitAnchoredAdaptiveBannerAdSize(messenger, (Integer) arguments.get(0));
case "getLandscapeAnchoredAdaptiveBannerAdSize":
          return $onGetLandscapeAnchoredAdaptiveBannerAdSize(messenger, (Integer) arguments.get(0));
      }

      throw new UnsupportedOperationException(
          String.format("Unable to invoke static method %s", methodName));
    }

    @Override
    public List<Object> getCreationArguments(
        TypeChannelMessenger messenger, $AdSize instance) {
      return Arrays.<Object>asList(instance.getWidth(),instance.getHeight(),instance.getConstant());
    }

    @Override
    public $AdSize createInstance(TypeChannelMessenger messenger, List<Object> arguments)
        throws Exception {
      final $AdSizeCreationArgs args = new $AdSizeCreationArgs();
      args.width = (Integer) arguments.get(0);
args.height = (Integer) arguments.get(1);
args.constant = (String) arguments.get(2);
      return onCreate(messenger, args);
    }

    @Override
    public Object invokeMethod(
        TypeChannelMessenger messenger,
        $AdSize instance,
        String methodName,
        List<Object> arguments)
        throws Exception {
      for (Method method : $AdSize.class.getMethods()) {
        if (method.getName().equals(methodName)) {
          return method.invoke(instance, arguments.toArray());
        }
      }

      throw new UnsupportedOperationException(
          String.format("%s.%s not supported.", instance, methodName));
    }
  }
public static class $AdListenerHandler implements TypeChannelHandler<$AdListener> {
    public $AdListener onCreate(TypeChannelMessenger messenger, $AdListenerCreationArgs args)
        throws Exception {
      return null;
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
    public List<Object> getCreationArguments(
        TypeChannelMessenger messenger, $AdListener instance) {
      return Arrays.<Object>asList();
    }

    @Override
    public $AdListener createInstance(TypeChannelMessenger messenger, List<Object> arguments)
        throws Exception {
      final $AdListenerCreationArgs args = new $AdListenerCreationArgs();
      
      return onCreate(messenger, args);
    }

    @Override
    public Object invokeMethod(
        TypeChannelMessenger messenger,
        $AdListener instance,
        String methodName,
        List<Object> arguments)
        throws Exception {
      for (Method method : $AdListener.class.getMethods()) {
        if (method.getName().equals(methodName)) {
          return method.invoke(instance, arguments.toArray());
        }
      }

      throw new UnsupportedOperationException(
          String.format("%s.%s not supported.", instance, methodName));
    }
  }
public static class $BannerAdHandler implements TypeChannelHandler<$BannerAd> {
    public $BannerAd onCreate(TypeChannelMessenger messenger, $BannerAdCreationArgs args)
        throws Exception {
      return null;
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
    public List<Object> getCreationArguments(
        TypeChannelMessenger messenger, $BannerAd instance) {
      return Arrays.<Object>asList(instance.getSize(),instance.getAdUnitId(),instance.getListener(),instance.getRequest());
    }

    @Override
    public $BannerAd createInstance(TypeChannelMessenger messenger, List<Object> arguments)
        throws Exception {
      final $BannerAdCreationArgs args = new $BannerAdCreationArgs();
      args.size = ($AdSize) arguments.get(0);
args.adUnitId = (String) arguments.get(1);
args.listener = ($AdListener) arguments.get(2);
args.request = ($AdRequest) arguments.get(3);
      return onCreate(messenger, args);
    }

    @Override
    public Object invokeMethod(
        TypeChannelMessenger messenger,
        $BannerAd instance,
        String methodName,
        List<Object> arguments)
        throws Exception {
      for (Method method : $BannerAd.class.getMethods()) {
        if (method.getName().equals(methodName)) {
          return method.invoke(instance, arguments.toArray());
        }
      }

      throw new UnsupportedOperationException(
          String.format("%s.%s not supported.", instance, methodName));
    }
  }
public static class $PublisherBannerAdHandler implements TypeChannelHandler<$PublisherBannerAd> {
    public $PublisherBannerAd onCreate(TypeChannelMessenger messenger, $PublisherBannerAdCreationArgs args)
        throws Exception {
      return null;
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
    public List<Object> getCreationArguments(
        TypeChannelMessenger messenger, $PublisherBannerAd instance) {
      return Arrays.<Object>asList(instance.getSizes(),instance.getAdUnitId(),instance.getListener(),instance.getRequest());
    }

    @Override
    public $PublisherBannerAd createInstance(TypeChannelMessenger messenger, List<Object> arguments)
        throws Exception {
      final $PublisherBannerAdCreationArgs args = new $PublisherBannerAdCreationArgs();
      args.sizes = (List<$AdSize>) arguments.get(0);
args.adUnitId = (String) arguments.get(1);
args.listener = ($AdListener) arguments.get(2);
args.request = ($PublisherAdRequest) arguments.get(3);
      return onCreate(messenger, args);
    }

    @Override
    public Object invokeMethod(
        TypeChannelMessenger messenger,
        $PublisherBannerAd instance,
        String methodName,
        List<Object> arguments)
        throws Exception {
      for (Method method : $PublisherBannerAd.class.getMethods()) {
        if (method.getName().equals(methodName)) {
          return method.invoke(instance, arguments.toArray());
        }
      }

      throw new UnsupportedOperationException(
          String.format("%s.%s not supported.", instance, methodName));
    }
  }
public static class $NativeAdHandler implements TypeChannelHandler<$NativeAd> {
    public $NativeAd onCreate(TypeChannelMessenger messenger, $NativeAdCreationArgs args)
        throws Exception {
      return null;
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
    public List<Object> getCreationArguments(
        TypeChannelMessenger messenger, $NativeAd instance) {
      return Arrays.<Object>asList(instance.getAdUnitId(),instance.getFactoryId(),instance.getListener(),instance.getRequest(),instance.getCustomOptions());
    }

    @Override
    public $NativeAd createInstance(TypeChannelMessenger messenger, List<Object> arguments)
        throws Exception {
      final $NativeAdCreationArgs args = new $NativeAdCreationArgs();
      args.adUnitId = (String) arguments.get(0);
args.factoryId = (String) arguments.get(1);
args.listener = ($AdListener) arguments.get(2);
args.request = ($AdRequest) arguments.get(3);
args.customOptions = (Map<String,Object>) arguments.get(4);
      return onCreate(messenger, args);
    }

    @Override
    public Object invokeMethod(
        TypeChannelMessenger messenger,
        $NativeAd instance,
        String methodName,
        List<Object> arguments)
        throws Exception {
      for (Method method : $NativeAd.class.getMethods()) {
        if (method.getName().equals(methodName)) {
          return method.invoke(instance, arguments.toArray());
        }
      }

      throw new UnsupportedOperationException(
          String.format("%s.%s not supported.", instance, methodName));
    }
  }
public static class $InterstitialAdHandler implements TypeChannelHandler<$InterstitialAd> {
    public $InterstitialAd onCreate(TypeChannelMessenger messenger, $InterstitialAdCreationArgs args)
        throws Exception {
      return null;
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
    public List<Object> getCreationArguments(
        TypeChannelMessenger messenger, $InterstitialAd instance) {
      return Arrays.<Object>asList(instance.getAdUnitId(),instance.getListener(),instance.getRequest());
    }

    @Override
    public $InterstitialAd createInstance(TypeChannelMessenger messenger, List<Object> arguments)
        throws Exception {
      final $InterstitialAdCreationArgs args = new $InterstitialAdCreationArgs();
      args.adUnitId = (String) arguments.get(0);
args.listener = ($AdListener) arguments.get(1);
args.request = ($AdRequest) arguments.get(2);
      return onCreate(messenger, args);
    }

    @Override
    public Object invokeMethod(
        TypeChannelMessenger messenger,
        $InterstitialAd instance,
        String methodName,
        List<Object> arguments)
        throws Exception {
      for (Method method : $InterstitialAd.class.getMethods()) {
        if (method.getName().equals(methodName)) {
          return method.invoke(instance, arguments.toArray());
        }
      }

      throw new UnsupportedOperationException(
          String.format("%s.%s not supported.", instance, methodName));
    }
  }
public static class $PublisherInterstitialAdHandler implements TypeChannelHandler<$PublisherInterstitialAd> {
    public $PublisherInterstitialAd onCreate(TypeChannelMessenger messenger, $PublisherInterstitialAdCreationArgs args)
        throws Exception {
      return null;
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
    public List<Object> getCreationArguments(
        TypeChannelMessenger messenger, $PublisherInterstitialAd instance) {
      return Arrays.<Object>asList(instance.getAdUnitId(),instance.getListener(),instance.getRequest());
    }

    @Override
    public $PublisherInterstitialAd createInstance(TypeChannelMessenger messenger, List<Object> arguments)
        throws Exception {
      final $PublisherInterstitialAdCreationArgs args = new $PublisherInterstitialAdCreationArgs();
      args.adUnitId = (String) arguments.get(0);
args.listener = ($AdListener) arguments.get(1);
args.request = ($PublisherAdRequest) arguments.get(2);
      return onCreate(messenger, args);
    }

    @Override
    public Object invokeMethod(
        TypeChannelMessenger messenger,
        $PublisherInterstitialAd instance,
        String methodName,
        List<Object> arguments)
        throws Exception {
      for (Method method : $PublisherInterstitialAd.class.getMethods()) {
        if (method.getName().equals(methodName)) {
          return method.invoke(instance, arguments.toArray());
        }
      }

      throw new UnsupportedOperationException(
          String.format("%s.%s not supported.", instance, methodName));
    }
  }
public static class $RewardedAdHandler implements TypeChannelHandler<$RewardedAd> {
    public $RewardedAd onCreate(TypeChannelMessenger messenger, $RewardedAdCreationArgs args)
        throws Exception {
      return null;
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
    public List<Object> getCreationArguments(
        TypeChannelMessenger messenger, $RewardedAd instance) {
      return Arrays.<Object>asList(instance.getAdUnitId(),instance.getListener(),instance.getRequest(),instance.getServerSideVerificationOptions());
    }

    @Override
    public $RewardedAd createInstance(TypeChannelMessenger messenger, List<Object> arguments)
        throws Exception {
      final $RewardedAdCreationArgs args = new $RewardedAdCreationArgs();
      args.adUnitId = (String) arguments.get(0);
args.listener = ($AdListener) arguments.get(1);
args.request = ($AdRequest) arguments.get(2);
args.serverSideVerificationOptions = ($ServerSideVerificationOptions) arguments.get(3);
      return onCreate(messenger, args);
    }

    @Override
    public Object invokeMethod(
        TypeChannelMessenger messenger,
        $RewardedAd instance,
        String methodName,
        List<Object> arguments)
        throws Exception {
      for (Method method : $RewardedAd.class.getMethods()) {
        if (method.getName().equals(methodName)) {
          return method.invoke(instance, arguments.toArray());
        }
      }

      throw new UnsupportedOperationException(
          String.format("%s.%s not supported.", instance, methodName));
    }
  }
public static class $RewardItemHandler implements TypeChannelHandler<$RewardItem> {
    public $RewardItem onCreate(TypeChannelMessenger messenger, $RewardItemCreationArgs args)
        throws Exception {
      return null;
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
    public List<Object> getCreationArguments(
        TypeChannelMessenger messenger, $RewardItem instance) {
      return Arrays.<Object>asList(instance.getAmount(),instance.getType());
    }

    @Override
    public $RewardItem createInstance(TypeChannelMessenger messenger, List<Object> arguments)
        throws Exception {
      final $RewardItemCreationArgs args = new $RewardItemCreationArgs();
      args.amount = (Number) arguments.get(0);
args.type = (String) arguments.get(1);
      return onCreate(messenger, args);
    }

    @Override
    public Object invokeMethod(
        TypeChannelMessenger messenger,
        $RewardItem instance,
        String methodName,
        List<Object> arguments)
        throws Exception {
      for (Method method : $RewardItem.class.getMethods()) {
        if (method.getName().equals(methodName)) {
          return method.invoke(instance, arguments.toArray());
        }
      }

      throw new UnsupportedOperationException(
          String.format("%s.%s not supported.", instance, methodName));
    }
  }
public static class $ServerSideVerificationOptionsHandler implements TypeChannelHandler<$ServerSideVerificationOptions> {
    public $ServerSideVerificationOptions onCreate(TypeChannelMessenger messenger, $ServerSideVerificationOptionsCreationArgs args)
        throws Exception {
      return null;
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
    public List<Object> getCreationArguments(
        TypeChannelMessenger messenger, $ServerSideVerificationOptions instance) {
      return Arrays.<Object>asList();
    }

    @Override
    public $ServerSideVerificationOptions createInstance(TypeChannelMessenger messenger, List<Object> arguments)
        throws Exception {
      final $ServerSideVerificationOptionsCreationArgs args = new $ServerSideVerificationOptionsCreationArgs();
      
      return onCreate(messenger, args);
    }

    @Override
    public Object invokeMethod(
        TypeChannelMessenger messenger,
        $ServerSideVerificationOptions instance,
        String methodName,
        List<Object> arguments)
        throws Exception {
      for (Method method : $ServerSideVerificationOptions.class.getMethods()) {
        if (method.getName().equals(methodName)) {
          return method.invoke(instance, arguments.toArray());
        }
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

    public $LoadAdErrorChannel getLoadAdErrorChannel() {
      return new $LoadAdErrorChannel(messenger);
    }
public $AdRequestChannel getAdRequestChannel() {
      return new $AdRequestChannel(messenger);
    }
public $PublisherAdRequestChannel getPublisherAdRequestChannel() {
      return new $PublisherAdRequestChannel(messenger);
    }
public $AdSizeChannel getAdSizeChannel() {
      return new $AdSizeChannel(messenger);
    }
public $AdListenerChannel getAdListenerChannel() {
      return new $AdListenerChannel(messenger);
    }
public $BannerAdChannel getBannerAdChannel() {
      return new $BannerAdChannel(messenger);
    }
public $PublisherBannerAdChannel getPublisherBannerAdChannel() {
      return new $PublisherBannerAdChannel(messenger);
    }
public $NativeAdChannel getNativeAdChannel() {
      return new $NativeAdChannel(messenger);
    }
public $InterstitialAdChannel getInterstitialAdChannel() {
      return new $InterstitialAdChannel(messenger);
    }
public $PublisherInterstitialAdChannel getPublisherInterstitialAdChannel() {
      return new $PublisherInterstitialAdChannel(messenger);
    }
public $RewardedAdChannel getRewardedAdChannel() {
      return new $RewardedAdChannel(messenger);
    }
public $RewardItemChannel getRewardItemChannel() {
      return new $RewardItemChannel(messenger);
    }
public $ServerSideVerificationOptionsChannel getServerSideVerificationOptionsChannel() {
      return new $ServerSideVerificationOptionsChannel(messenger);
    }

    public $LoadAdErrorHandler getLoadAdErrorHandler() {
      return new $LoadAdErrorHandler();
    }
public $AdRequestHandler getAdRequestHandler() {
      return new $AdRequestHandler();
    }
public $PublisherAdRequestHandler getPublisherAdRequestHandler() {
      return new $PublisherAdRequestHandler();
    }
public $AdSizeHandler getAdSizeHandler() {
      return new $AdSizeHandler();
    }
public $AdListenerHandler getAdListenerHandler() {
      return new $AdListenerHandler();
    }
public $BannerAdHandler getBannerAdHandler() {
      return new $BannerAdHandler();
    }
public $PublisherBannerAdHandler getPublisherBannerAdHandler() {
      return new $PublisherBannerAdHandler();
    }
public $NativeAdHandler getNativeAdHandler() {
      return new $NativeAdHandler();
    }
public $InterstitialAdHandler getInterstitialAdHandler() {
      return new $InterstitialAdHandler();
    }
public $PublisherInterstitialAdHandler getPublisherInterstitialAdHandler() {
      return new $PublisherInterstitialAdHandler();
    }
public $RewardedAdHandler getRewardedAdHandler() {
      return new $RewardedAdHandler();
    }
public $RewardItemHandler getRewardItemHandler() {
      return new $RewardItemHandler();
    }
public $ServerSideVerificationOptionsHandler getServerSideVerificationOptionsHandler() {
      return new $ServerSideVerificationOptionsHandler();
    }
  }

  public static class $ChannelRegistrar {
    public final $LibraryImplementations implementations;

    public $ChannelRegistrar($LibraryImplementations implementations) {
      this.implementations = implementations;
    }

    public void registerHandlers() {
      implementations.getLoadAdErrorChannel().setHandler(implementations.getLoadAdErrorHandler());
implementations.getAdRequestChannel().setHandler(implementations.getAdRequestHandler());
implementations.getPublisherAdRequestChannel().setHandler(implementations.getPublisherAdRequestHandler());
implementations.getAdSizeChannel().setHandler(implementations.getAdSizeHandler());
implementations.getAdListenerChannel().setHandler(implementations.getAdListenerHandler());
implementations.getBannerAdChannel().setHandler(implementations.getBannerAdHandler());
implementations.getPublisherBannerAdChannel().setHandler(implementations.getPublisherBannerAdHandler());
implementations.getNativeAdChannel().setHandler(implementations.getNativeAdHandler());
implementations.getInterstitialAdChannel().setHandler(implementations.getInterstitialAdHandler());
implementations.getPublisherInterstitialAdChannel().setHandler(implementations.getPublisherInterstitialAdHandler());
implementations.getRewardedAdChannel().setHandler(implementations.getRewardedAdHandler());
implementations.getRewardItemChannel().setHandler(implementations.getRewardItemHandler());
implementations.getServerSideVerificationOptionsChannel().setHandler(implementations.getServerSideVerificationOptionsHandler());
    }

    public void unregisterHandlers() {
      implementations.getLoadAdErrorChannel().removeHandler();
implementations.getAdRequestChannel().removeHandler();
implementations.getPublisherAdRequestChannel().removeHandler();
implementations.getAdSizeChannel().removeHandler();
implementations.getAdListenerChannel().removeHandler();
implementations.getBannerAdChannel().removeHandler();
implementations.getPublisherBannerAdChannel().removeHandler();
implementations.getNativeAdChannel().removeHandler();
implementations.getInterstitialAdChannel().removeHandler();
implementations.getPublisherInterstitialAdChannel().removeHandler();
implementations.getRewardedAdChannel().removeHandler();
implementations.getRewardItemChannel().removeHandler();
implementations.getServerSideVerificationOptionsChannel().removeHandler();
    }
  }
}
