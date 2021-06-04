// GENERATED CODE - DO NOT MODIFY BY HAND


package io.flutter.plugins.googlemobileads.mobileads;


import androidx.annotation.NonNull;

import java.util.Arrays;
import java.util.List;

import github.penguin.reference.async.Completable;
import github.penguin.reference.reference.PairedInstance;
import github.penguin.reference.reference.TypeChannel;
import github.penguin.reference.reference.TypeChannelHandler;
import github.penguin.reference.reference.TypeChannelMessenger;

// **************************************************************************
// ReferenceGenerator
// **************************************************************************

public class MobileAdsChannelLibrary {
  
  public interface $AdapterInitializationState {
    
  }
  
  public interface $MobileAds {
    
    
    Object initialize() throws Exception;
    
    
    
    Object updateRequestConfiguration($RequestConfiguration requestConfiguration) throws Exception;
    
    
    
    Object setSameAppKeyEnabled(Boolean isEnabled) throws Exception;
    
    
  }
  
  public interface $InitializationStatus {
    
  }
  
  public interface $AdapterStatus {
    
  }
  
  public interface $RequestConfiguration {
    
  }
  

  
  public static class $AdapterInitializationStateChannel extends TypeChannel<$AdapterInitializationState> {
    public $AdapterInitializationStateChannel(@NonNull TypeChannelMessenger messenger) {
      super(messenger, "google_mobile_ads.AdapterInitializationState");
    }

    public Completable<PairedInstance> $$create($AdapterInitializationState $instance, boolean $owner,String value) {
      return createNewInstancePair($instance, Arrays.<Object>asList(value), $owner);
    }

    

    
  }
  
  public static class $MobileAdsChannel extends TypeChannel<$MobileAds> {
    public $MobileAdsChannel(@NonNull TypeChannelMessenger messenger) {
      super(messenger, "google_mobile_ads.MobileAds");
    }

    public Completable<PairedInstance> $$create($MobileAds $instance, boolean $owner) {
      return createNewInstancePair($instance, Arrays.<Object>asList(), $owner);
    }

    

    
    
    
    
    
    
    
  }
  
  public static class $InitializationStatusChannel extends TypeChannel<$InitializationStatus> {
    public $InitializationStatusChannel(@NonNull TypeChannelMessenger messenger) {
      super(messenger, "google_mobile_ads.InitializationStatus");
    }

    public Completable<PairedInstance> $$create($InitializationStatus $instance, boolean $owner,Map<String,$AdapterStatus> adapterStatuses) {
      return createNewInstancePair($instance, Arrays.<Object>asList(adapterStatuses), $owner);
    }

    

    
  }
  
  public static class $AdapterStatusChannel extends TypeChannel<$AdapterStatus> {
    public $AdapterStatusChannel(@NonNull TypeChannelMessenger messenger) {
      super(messenger, "google_mobile_ads.AdapterStatus");
    }

    public Completable<PairedInstance> $$create($AdapterStatus $instance, boolean $owner,$AdapterInitializationState state,String description,Double latency) {
      return createNewInstancePair($instance, Arrays.<Object>asList(state,description,latency), $owner);
    }

    

    
  }
  
  public static class $RequestConfigurationChannel extends TypeChannel<$RequestConfiguration> {
    public $RequestConfigurationChannel(@NonNull TypeChannelMessenger messenger) {
      super(messenger, "google_mobile_ads.RequestConfiguration");
    }

    public Completable<PairedInstance> $$create($RequestConfiguration $instance, boolean $owner,String maxAdContentRating,Integer tagForChildDirectedTreatment,Integer tagForUnderAgeOfConsent,List<String> testDeviceIds) {
      return createNewInstancePair($instance, Arrays.<Object>asList(maxAdContentRating,tagForChildDirectedTreatment,tagForUnderAgeOfConsent,testDeviceIds), $owner);
    }

    

    
  }
  

  
  public static class $AdapterInitializationStateHandler implements TypeChannelHandler<$AdapterInitializationState> {
    public $AdapterInitializationState $$create(TypeChannelMessenger messenger,String value)
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
    public $AdapterInitializationState createInstance(TypeChannelMessenger messenger, List<Object> arguments)
        throws Exception {
      return $$create(messenger,(String) arguments.get(0));
    }

    @Override
    public Object invokeMethod(
        TypeChannelMessenger messenger,
        $AdapterInitializationState instance,
        String methodName,
        List<Object> arguments)
        throws Exception {
      switch(methodName) {
        
      }

      throw new UnsupportedOperationException(
          String.format("%s.%s not supported.", instance, methodName));
    }
  }
  
  public static class $MobileAdsHandler implements TypeChannelHandler<$MobileAds> {
    public $MobileAds $$create(TypeChannelMessenger messenger)
        throws Exception {
      throw new UnsupportedOperationException();
    }

    

    
    
    public Object $initialize($MobileAds $instance) throws Exception {
      return $instance.initialize();
    }
    
    
    
    public Object $updateRequestConfiguration($MobileAds $instance,$RequestConfiguration requestConfiguration) throws Exception {
      return $instance.updateRequestConfiguration( requestConfiguration );
    }
    
    
    
    public Object $setSameAppKeyEnabled($MobileAds $instance,Boolean isEnabled) throws Exception {
      return $instance.setSameAppKeyEnabled( isEnabled );
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
    public $MobileAds createInstance(TypeChannelMessenger messenger, List<Object> arguments)
        throws Exception {
      return $$create(messenger);
    }

    @Override
    public Object invokeMethod(
        TypeChannelMessenger messenger,
        $MobileAds instance,
        String methodName,
        List<Object> arguments)
        throws Exception {
      switch(methodName) {
        
        
        case "initialize":
          return $initialize(instance);
        
        
        
        case "updateRequestConfiguration":
          return $updateRequestConfiguration(instance,($RequestConfiguration) arguments.get(0));
        
        
        
        case "setSameAppKeyEnabled":
          return $setSameAppKeyEnabled(instance,(Boolean) arguments.get(0));
        
        
      }

      throw new UnsupportedOperationException(
          String.format("%s.%s not supported.", instance, methodName));
    }
  }
  
  public static class $InitializationStatusHandler implements TypeChannelHandler<$InitializationStatus> {
    public $InitializationStatus $$create(TypeChannelMessenger messenger,Map<String,$AdapterStatus> adapterStatuses)
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
    public $InitializationStatus createInstance(TypeChannelMessenger messenger, List<Object> arguments)
        throws Exception {
      return $$create(messenger,(Map<String,$AdapterStatus>) arguments.get(0));
    }

    @Override
    public Object invokeMethod(
        TypeChannelMessenger messenger,
        $InitializationStatus instance,
        String methodName,
        List<Object> arguments)
        throws Exception {
      switch(methodName) {
        
      }

      throw new UnsupportedOperationException(
          String.format("%s.%s not supported.", instance, methodName));
    }
  }
  
  public static class $AdapterStatusHandler implements TypeChannelHandler<$AdapterStatus> {
    public $AdapterStatus $$create(TypeChannelMessenger messenger,$AdapterInitializationState state,String description,Double latency)
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
    public $AdapterStatus createInstance(TypeChannelMessenger messenger, List<Object> arguments)
        throws Exception {
      return $$create(messenger,($AdapterInitializationState) arguments.get(0),(String) arguments.get(1),(Double) arguments.get(2));
    }

    @Override
    public Object invokeMethod(
        TypeChannelMessenger messenger,
        $AdapterStatus instance,
        String methodName,
        List<Object> arguments)
        throws Exception {
      switch(methodName) {
        
      }

      throw new UnsupportedOperationException(
          String.format("%s.%s not supported.", instance, methodName));
    }
  }
  
  public static class $RequestConfigurationHandler implements TypeChannelHandler<$RequestConfiguration> {
    public $RequestConfiguration $$create(TypeChannelMessenger messenger,String maxAdContentRating,Integer tagForChildDirectedTreatment,Integer tagForUnderAgeOfConsent,List<String> testDeviceIds)
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
    public $RequestConfiguration createInstance(TypeChannelMessenger messenger, List<Object> arguments)
        throws Exception {
      return $$create(messenger,(String) arguments.get(0),(Integer) arguments.get(1),(Integer) arguments.get(2),(List<String>) arguments.get(3));
    }

    @Override
    public Object invokeMethod(
        TypeChannelMessenger messenger,
        $RequestConfiguration instance,
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

    
    public $AdapterInitializationStateChannel getChannelAdapterInitializationState() {
      return new $AdapterInitializationStateChannel(messenger);
    }

    public $AdapterInitializationStateHandler getHandlerAdapterInitializationState() {
      return new $AdapterInitializationStateHandler();
    }
    
    public $MobileAdsChannel getChannelMobileAds() {
      return new $MobileAdsChannel(messenger);
    }

    public $MobileAdsHandler getHandlerMobileAds() {
      return new $MobileAdsHandler();
    }
    
    public $InitializationStatusChannel getChannelInitializationStatus() {
      return new $InitializationStatusChannel(messenger);
    }

    public $InitializationStatusHandler getHandlerInitializationStatus() {
      return new $InitializationStatusHandler();
    }
    
    public $AdapterStatusChannel getChannelAdapterStatus() {
      return new $AdapterStatusChannel(messenger);
    }

    public $AdapterStatusHandler getHandlerAdapterStatus() {
      return new $AdapterStatusHandler();
    }
    
    public $RequestConfigurationChannel getChannelRequestConfiguration() {
      return new $RequestConfigurationChannel(messenger);
    }

    public $RequestConfigurationHandler getHandlerRequestConfiguration() {
      return new $RequestConfigurationHandler();
    }
    
  }

  public static class $ChannelRegistrar {
    public final $LibraryImplementations implementations;

    public $ChannelRegistrar($LibraryImplementations implementations) {
      this.implementations = implementations;
    }


    public void registerHandlers() {
      
      implementations.getChannelAdapterInitializationState().setHandler(implementations.getHandlerAdapterInitializationState());
      
      implementations.getChannelMobileAds().setHandler(implementations.getHandlerMobileAds());
      
      implementations.getChannelInitializationStatus().setHandler(implementations.getHandlerInitializationStatus());
      
      implementations.getChannelAdapterStatus().setHandler(implementations.getHandlerAdapterStatus());
      
      implementations.getChannelRequestConfiguration().setHandler(implementations.getHandlerRequestConfiguration());
      
    }

    public void unregisterHandlers() {
      
      implementations.getChannelAdapterInitializationState().removeHandler();
      
      implementations.getChannelMobileAds().removeHandler();
      
      implementations.getChannelInitializationStatus().removeHandler();
      
      implementations.getChannelAdapterStatus().removeHandler();
      
      implementations.getChannelRequestConfiguration().removeHandler();
      
    }
  }
}
