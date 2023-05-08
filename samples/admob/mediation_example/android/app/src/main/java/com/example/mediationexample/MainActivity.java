// Copyright 2021 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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
    // Necessary to get test ad units in applovin
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

    // Setup a method channel for calling APIs in the AppLovin SDK.
    new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL_NAME)
        .setMethodCallHandler(new MyMediationMethodCallHandler(this));

    // Register your MediationNetworkExtrasProvider to provide network extras to ad requests.
    GoogleMobileAdsPlugin.registerMediationNetworkExtrasProvider(
        flutterEngine, new MyMediationNetworkExtrasProvider());
  }

  @Override
  public void cleanUpFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    super.cleanUpFlutterEngine(flutterEngine);
    GoogleMobileAdsPlugin.unregisterMediationNetworkExtrasProvider(flutterEngine);
  }
}
