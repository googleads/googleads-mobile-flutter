// Copyright 2026 Google LLC
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

package io.flutter.plugins.googlemobileads;

import android.app.Activity;
import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.util.Log;
import android.webkit.WebView;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.google.android.libraries.ads.mobile.sdk.MobileAds;
import com.google.android.libraries.ads.mobile.sdk.common.OnAdInspectorClosedListener;
import com.google.android.libraries.ads.mobile.sdk.common.RequestConfiguration;
import com.google.android.libraries.ads.mobile.sdk.initialization.InitializationConfig;
import com.google.android.libraries.ads.mobile.sdk.initialization.OnAdapterInitializationCompleteListener;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.webviewflutter.WebViewFlutterAndroidExternalApi;

/** A wrapper around static methods in {@link com.google.android.gms.ads.MobileAds}. */
public class FlutterMobileAdsWrapper {

  private static final String TAG = "FlutterMobileAdsWrapper";
  private static final String APPLICATION_ID_KEY = "com.google.android.gms.ads.APPLICATION_ID";
  private static boolean disableMediationAdapterInitialization = false;

  public FlutterMobileAdsWrapper() {}

  /** Initializes the sdk. */
  public void initialize(
      @NonNull Context context, @NonNull OnAdapterInitializationCompleteListener listener) {
    final String appId = getApplicationMetaData(context, APPLICATION_ID_KEY);

    if (appId == null) {
      Log.e(TAG, "Application ID is null. Cannot initialize the Google Mobile Ads SDK.");
      return;
    }

    InitializationConfig.Builder configBuilder = new InitializationConfig.Builder(appId);
    if(disableMediationAdapterInitialization) {
      configBuilder.disableMediationAdapterInitialization();
    }
    InitializationConfig config = configBuilder.build();
    new Thread(
            new Runnable() {
              @Override
              public void run() {
                MobileAds.initialize(context, config, listener);
              }
            })
        .start();
  }

  /** Wrapper for setAppMuted. */
  public void setAppMuted(boolean muted) {
    MobileAds.setUserMutedApp(muted);
  }

  /** Wrapper for setAppVolume. */
  public void setAppVolume(double volume) {
    MobileAds.setUserControlledAppVolume((float) volume);
  }

  /** Wrapper for disableMediationInitialization. */
  public void disableMediationInitialization(@NonNull Context context) {
    disableMediationAdapterInitialization = true;
  }

  /** Wrapper for getVersionString. */
  public String getVersionString() {
    return MobileAds.getVersion().toString();
  }

  /** Wrapper for getRequestConfiguration. */
  public RequestConfiguration getRequestConfiguration() {
    return MobileAds.getRequestConfiguration();
  }

  /** Wrapper for openDebugMenu. */
  public void openDebugMenu(Context context, String adUnitId) {
    if (!(context instanceof Activity)) {
      Log.w(TAG, "Cannot openDebugMenu before GMA SDK is attached to a Flutter Activity");
      return;
    }
    Activity activity = (Activity) context;
    MobileAds.openDebugMenu(activity, adUnitId);
  }

  /** Open the ad inspector. */
  public void openAdInspector(Context context, OnAdInspectorClosedListener listener) {
    MobileAds.openAdInspector(listener);
  }

  /** Register the webView for monetization. */
  public void registerWebView(int webViewId, FlutterEngine flutterEngine) {
    WebView webView = WebViewFlutterAndroidExternalApi.getWebView(flutterEngine, webViewId);
    if (webView == null) {
      Log.w(TAG, "MobileAds.registerWebView unable to find webView with id: " + webViewId);
    } else {
      MobileAds.registerWebView(webView);
    }
  }

  @Nullable
  private String getApplicationMetaData(Context context, String key) {
    try {
      ApplicationInfo appInfo =
          context
              .getPackageManager()
              .getApplicationInfo(context.getPackageName(), PackageManager.GET_META_DATA);
      Bundle bundle = appInfo.metaData;
      if (bundle != null && bundle.containsKey(key)) {
        return bundle.getString(key);
      } else {
        Log.e(TAG, "Application ID not found in manifest!");
      }
    } catch (Exception e) {
      Log.e(TAG, "Error reading application ID from manifest: " + e.getMessage());
    }
    return null;
  }
}
