package com.example.mediationexample;

import android.os.Bundle;
import android.util.Log;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.applovin.sdk.AppLovinSdk;
import com.google.android.gms.ads.identifier.AdvertisingIdClient;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin;
import java.util.Arrays;

public class MainActivity extends FlutterActivity {

  private static final String CHANNEL_NAME = "com.example.mediationexample/mediation-channel";
  private static final String TAG = "MainActivity";

  @Override
  protected void onCreate(@Nullable Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    AppLovinSdk.initializeSdk(this);
    AppLovinSdk.getInstance(this).getSettings().setVerboseLogging(true);
    new Thread(
            () -> {
              String adId = "";
              try {
                adId = AdvertisingIdClient.getAdvertisingIdInfo(getApplicationContext()).getId();
              } catch (Exception e) {
                Log.e(TAG, "Exception retrieving advertising ID.", e);
              }
              AppLovinSdk.getInstance(getApplicationContext())
                  .getSettings()
                  .setTestDeviceAdvertisingIds(Arrays.asList(adId));
            })
        .start();
  }

  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    super.configureFlutterEngine(flutterEngine);

    new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL_NAME)
        .setMethodCallHandler(new MyMediationMethodCallHandler(this));
    GoogleMobileAdsPlugin.registerMediationNetworkExtrasProvider(
        flutterEngine, new MyMediationNetworkExtrasProvider());
  }

  @Override
  public void cleanUpFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    super.cleanUpFlutterEngine(flutterEngine);
    GoogleMobileAdsPlugin.unregisterMediationNetworkExtrasProvider(flutterEngine);
  }
}
