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
import android.os.Handler;
import android.os.Looper;
import android.util.Log;
import android.webkit.WebView;
import androidx.annotation.MainThread;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.VisibleForTesting;
import com.google.android.libraries.ads.mobile.sdk.MobileAds;
import com.google.android.libraries.ads.mobile.sdk.common.OnAdInspectorClosedListener;
import com.google.android.libraries.ads.mobile.sdk.common.RequestConfiguration;
import com.google.android.libraries.ads.mobile.sdk.initialization.InitializationConfig;
import com.google.android.libraries.ads.mobile.sdk.initialization.OnAdapterInitializationCompleteListener;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.webviewflutter.WebViewFlutterAndroidExternalApi;
import java.lang.reflect.Method;
import java.util.ArrayDeque;
import java.util.Deque;
import java.util.concurrent.Executor;
import java.util.function.Consumer;

/** A wrapper around static methods in {@link com.google.android.gms.ads.MobileAds}. */
public class FlutterMobileAdsWrapper {

  private static final String TAG = "FlutterMobileAdsWrapper";
  private static final String APPLICATION_ID_KEY = "com.google.android.gms.ads.APPLICATION_ID";
  private static boolean disableMediationAdapterInitialization = false;
  private static boolean initInProgress = false;
  private static final Deque<Runnable> pendingCalls = new ArrayDeque<>();

  private final Executor sdkExecutor;
  private final Handler mainHandler;

  public FlutterMobileAdsWrapper() {
    this(command -> new Thread(command).start(), new Handler(Looper.getMainLooper()));
  }

  @VisibleForTesting
  FlutterMobileAdsWrapper(@NonNull Executor sdkExecutor, @NonNull Handler mainHandler) {
    this.sdkExecutor = sdkExecutor;
    this.mainHandler = mainHandler;
  }

  @VisibleForTesting
  static void resetForTesting() {
    initInProgress = false;
    pendingCalls.clear();
    disableMediationAdapterInitialization = false;
  }

  static void runWhenSdkReady(
      @NonNull Runnable task, @NonNull Consumer<RuntimeException> onDeferredFailure) {
    if (!initInProgress) {
      task.run();
      return;
    }
    pendingCalls.add(
        () -> {
          try {
            task.run();
          } catch (RuntimeException e) {
            onDeferredFailure.accept(e);
          }
        });
  }

  static void clearPendingCalls() {
    pendingCalls.clear();
  }

  @MainThread
  private static void onSdkReady() {
    initInProgress = false;
    while (!pendingCalls.isEmpty()) {
      pendingCalls.poll().run();
    }
  }

  /** Initializes the sdk. */
  public void initialize(
      @NonNull Context context, @NonNull OnAdapterInitializationCompleteListener listener) {
    final String appId = getApplicationMetaData(context, APPLICATION_ID_KEY);

    if (appId == null) {
      String message = "Application ID is null. Cannot initialize the Google Mobile Ads SDK.";
      Log.e(TAG, message);
      if (listener instanceof FlutterInitializationListener) {
        ((FlutterInitializationListener) listener)
            .onInitializationFailed("InitializationError", message);
      }
      return;
    }

    initInProgress = true;
    InitializationConfig.Builder configBuilder = new InitializationConfig.Builder(appId);
    if (disableMediationAdapterInitialization) {
      configBuilder.disableMediationAdapterInitialization();
    }
    configBuilder.setRequestConfiguration(
        FlutterRequestConfiguration.getCurrentRequestConfiguration());
    FlutterRequestConfiguration.clearPendingRequestConfiguration();
    setPlugin(configBuilder);
    InitializationConfig config = configBuilder.build();
    sdkExecutor.execute(
        () -> {
          try {
            MobileAds.initialize(context, config, listener);
          } catch (Throwable t) {
            Log.e(TAG, "Error initializing the Google Mobile Ads SDK.", t);
            if (listener instanceof FlutterInitializationListener) {
              ((FlutterInitializationListener) listener)
                  .onInitializationFailed(
                      "InitializationError",
                      t.getMessage() != null ? t.getMessage() : t.toString());
            }
          } finally {
            mainHandler.post(FlutterMobileAdsWrapper::onSdkReady);
          }
        });
  }

  @VisibleForTesting
  static void setPlugin(@NonNull InitializationConfig.Builder configBuilder) {
    try {
      Method setPluginMethod =
          InitializationConfig.Builder.class.getDeclaredMethod("setPlugin", String.class);
      setPluginMethod.setAccessible(true);
      setPluginMethod.invoke(configBuilder, Constants.REQUEST_AGENT_PREFIX_VERSIONED);
    } catch (Exception e) {
      Log.w(TAG, "Failed to set plugin on InitializationConfig.Builder.", e);
    }
  }

  /** Wrapper for setAppMuted. */
  public void setAppMuted(boolean muted) {
    runWhenSdkReady(
        () -> MobileAds.setUserMutedApp(muted),
        e -> Log.e(TAG, "Failed to set app muted.", e));
  }

  /** Wrapper for setAppVolume. */
  public void setAppVolume(double volume) {
    runWhenSdkReady(
        () -> MobileAds.setUserControlledAppVolume((float) volume),
        e -> Log.e(TAG, "Failed to set app volume.", e));
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
  public FlutterRequestConfiguration getRequestConfiguration() {
    RequestConfiguration rc = FlutterRequestConfiguration.getCurrentRequestConfiguration();
    return new FlutterRequestConfiguration.Builder()
        .setMaxAdContentRating(rc.getMaxAdContentRating() != null ? rc.getMaxAdContentRating().getValue() : null)
        .setTagForChildDirectedTreatment(rc.getTagForChildDirectedTreatment() != null ? rc.getTagForChildDirectedTreatment().getValue() : null)
        .setTagForUnderAgeOfConsent(rc.getTagForUnderAgeOfConsent() != null ? rc.getTagForUnderAgeOfConsent().getValue() : null)
        .setTestDeviceIds(rc.getTestDeviceIds())
        .setAgeRestrictedTreatment(rc.getAgeRestrictedTreatment() != null ? rc.getAgeRestrictedTreatment().ordinal() : null)
        .build();
  }

  /** Wrapper for openDebugMenu. */
  public void openDebugMenu(Context context, String adUnitId) {
    runWhenSdkReady(
        () -> {
          if (!(context instanceof Activity)) {
            Log.w(TAG, "Cannot openDebugMenu before GMA SDK is attached to a Flutter Activity");
            return;
          }
          Activity activity = (Activity) context;
          MobileAds.openDebugMenu(activity, adUnitId);
        },
        e -> Log.e(TAG, "Failed to open debug menu.", e));
  }

  /** Open the ad inspector. */
  public void openAdInspector(Context context, OnAdInspectorClosedListener listener) {
    MobileAds.openAdInspector(listener);
  }

  /** Register the webView for monetization. */
  public void registerWebView(int webViewId, FlutterEngine flutterEngine) {
    runWhenSdkReady(
        () -> {
          WebView webView = WebViewFlutterAndroidExternalApi.getWebView(flutterEngine, webViewId);
          if (webView == null) {
            Log.w(TAG, "MobileAds.registerWebView unable to find webView with id: " + webViewId);
          } else {
            MobileAds.registerWebView(webView);
          }
        },
        e -> Log.e(TAG, "Failed to register webView.", e));
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
