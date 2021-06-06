package io.flutter.plugins.googlemobileads.mobileads;

import androidx.annotation.NonNull;

import com.google.android.gms.ads.MobileAds;
import com.google.android.gms.ads.initialization.InitializationStatus;
import com.google.android.gms.ads.initialization.OnInitializationCompleteListener;

import github.penguin.reference.reference.TypeChannelMessenger;

public class MobileAdsChannelRegistrar extends MobileAdsChannelLibrary.$ChannelRegistrar {
  public MobileAdsChannelRegistrar(MobileAdsLibraryImplementations implementations) {
    super(implementations);
  }

  public static class MobileAdsLibraryImplementations extends MobileAdsChannelLibrary.$LibraryImplementations {
    public MobileAdsLibraryImplementations(TypeChannelMessenger messenger) {
      MobileAds.initialize(im, new OnInitializationCompleteListener() {
        @Override
        public void onInitializationComplete(@NonNull InitializationStatus initializationStatus) {

        }
      });
      MobileAds.getInitializationStatus();
      super(messenger);
    }
  }
}
