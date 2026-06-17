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

import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.google.android.libraries.ads.mobile.sdk.appopen.AppOpenAd;
import com.google.android.libraries.ads.mobile.sdk.appopen.AppOpenAdPreloader;
import com.google.android.libraries.ads.mobile.sdk.common.AdRequest;
import com.google.android.libraries.ads.mobile.sdk.common.LoadAdError;
import com.google.android.libraries.ads.mobile.sdk.common.PreloadCallback;
import com.google.android.libraries.ads.mobile.sdk.common.PreloadConfiguration;
import com.google.android.libraries.ads.mobile.sdk.common.ResponseInfo;
import com.google.android.libraries.ads.mobile.sdk.interstitial.InterstitialAd;
import com.google.android.libraries.ads.mobile.sdk.interstitial.InterstitialAdPreloader;
import com.google.android.libraries.ads.mobile.sdk.rewarded.RewardedAd;
import com.google.android.libraries.ads.mobile.sdk.rewarded.RewardedAdPreloader;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import java.util.HashMap;
import java.util.Map;

class FlutterAdPreloader {

  private final Context context;
  private final AdInstanceManager instanceManager;
  private final MethodChannel channel;
  private final Map<String, String> preloadIdToAdUnitId = new HashMap<>();

  FlutterAdPreloader(
      @NonNull Context context,
      @NonNull AdInstanceManager instanceManager,
      @NonNull MethodChannel channel) {
    this.context = context;
    this.instanceManager = instanceManager;
    this.channel = channel;
  }

  void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
    switch (call.method) {
      case "MobileAds#startPreloading": {
        String preloadId = call.argument("preloadId");
        String adUnitId = call.argument("adUnitId");
        Integer bufferSize = call.argument("bufferSize");
        String className = call.argument("className");
        FlutterAdRequest request = call.argument("request");

        if (className == null || preloadId == null || adUnitId == null) {
          result.error("PreloadError", "Missing required arguments.", null);
          break;
        }

        AdRequest adRequest;
        if (request != null) {
          adRequest = request.asAdRequest(adUnitId);
        } else {
          adRequest = new FlutterAdRequest.Builder().build().asAdRequest(adUnitId);
        }

        PreloadConfiguration config = bufferSize != null
            ? new PreloadConfiguration(adRequest, bufferSize)
            : new PreloadConfiguration(adRequest);

        PreloadCallback callback = new PreloadCallback() {
          @Override
          public void onAdPreloaded(
              @NonNull String id, @NonNull ResponseInfo responseInfo) {
            Map<Object, Object> arguments = new HashMap<>();
            arguments.put("preloadId", id);
            arguments.put("eventName", "onAdPreloaded");
            arguments.put(
                "responseInfo", new FlutterAd.FlutterResponseInfo(responseInfo));
            invokeOnPreloadEvent(arguments);
          }

          @Override
          public void onAdsExhausted(@NonNull String id) {
            Map<Object, Object> arguments = new HashMap<>();
            arguments.put("preloadId", id);
            arguments.put("eventName", "onAdsExhausted");
            invokeOnPreloadEvent(arguments);
          }

          @Override
          public void onAdFailedToPreload(
              @NonNull String id, @NonNull LoadAdError loadAdError) {
            Map<Object, Object> arguments = new HashMap<>();
            arguments.put("preloadId", id);
            arguments.put("eventName", "onAdFailedToPreload");
            arguments.put(
                "error", new FlutterAd.FlutterLoadAdError(loadAdError));
            invokeOnPreloadEvent(arguments);
          }
        };

        if (className.equals("InterstitialAd")) {
          InterstitialAdPreloader.start(preloadId, config, callback);
        } else if (className.equals("RewardedAd")) {
          RewardedAdPreloader.start(preloadId, config, callback);
        } else if (className.equals("AppOpenAd")) {
          AppOpenAdPreloader.start(preloadId, config, callback);
        } else {
          result.error("PreloadError", "Unsupported className: " + className, null);
          break;
        }
        preloadIdToAdUnitId.put(preloadId, adUnitId);
        result.success(null);
        break;
      }
      case "MobileAds#destroyPreloader": {
        String preloadId = call.argument("preloadId");
        String className = call.argument("className");

        if (className == null || preloadId == null) {
          result.error("PreloadError", "Missing required argument.", null);
          break;
        }

        if (className.equals("InterstitialAd")) {
          InterstitialAdPreloader.destroy(preloadId);
        } else if (className.equals("RewardedAd")) {
          RewardedAdPreloader.destroy(preloadId);
        } else if (className.equals("AppOpenAd")) {
          AppOpenAdPreloader.destroy(preloadId);
        } else {
          result.error("PreloadError", "Unsupported className: " + className, null);
          break;
        }
        preloadIdToAdUnitId.remove(preloadId);
        result.success(null);
        break;
      }
      case "MobileAds#destroyAllPreloaders": {
        String className = call.argument("className");

        if (className == null) {
          result.error("PreloadError", "Missing className argument.", null);
          break;
        }

        if (className.equals("InterstitialAd")) {
          InterstitialAdPreloader.destroyAll();
        } else if (className.equals("RewardedAd")) {
          RewardedAdPreloader.destroyAll();
        } else if (className.equals("AppOpenAd")) {
          AppOpenAdPreloader.destroyAll();
        } else {
          result.error("PreloadError", "Unsupported className: " + className, null);
          break;
        }
        preloadIdToAdUnitId.clear();
        result.success(null);
        break;
      }
      case "MobileAds#isPreloadedAdAvailable": {
        String preloadId = call.argument("preloadId");
        String className = call.argument("className");

        if (className == null || preloadId == null) {
          result.error("PreloadError", "Missing required argument.", null);
          break;
        }

        boolean available = false;
        if (className.equals("InterstitialAd")) {
          available = InterstitialAdPreloader.isAdAvailable(preloadId);
        } else if (className.equals("RewardedAd")) {
          available = RewardedAdPreloader.isAdAvailable(preloadId);
        } else if (className.equals("AppOpenAd")) {
          available = AppOpenAdPreloader.isAdAvailable(preloadId);
        } else {
          result.error("PreloadError", "Unsupported className: " + className, null);
          break;
        }
        result.success(available);
        break;
      }
      case "MobileAds#getNumAdsAvailable": {
        String preloadId = call.argument("preloadId");
        String className = call.argument("className");

        if (className == null || preloadId == null) {
          result.error("PreloadError", "Missing required argument.", null);
          break;
        }

        int count = 0;
        if (className.equals("InterstitialAd")) {
          count = InterstitialAdPreloader.getNumAdsAvailable(preloadId);
        } else if (className.equals("RewardedAd")) {
          count = RewardedAdPreloader.getNumAdsAvailable(preloadId);
        } else if (className.equals("AppOpenAd")) {
          count = AppOpenAdPreloader.getNumAdsAvailable(preloadId);
        } else {
          result.error("PreloadError", "Unsupported className: " + className, null);
          break;
        }
        result.success(count);
        break;
      }
      case "MobileAds#getPreloadConfiguration": {
        String preloadId = call.argument("preloadId");
        String className = call.argument("className");

        if (className == null || preloadId == null) {
          result.error("PreloadError", "Missing required argument.", null);
          break;
        }

        PreloadConfiguration config = null;
        if (className.equals("InterstitialAd")) {
          config = InterstitialAdPreloader.getConfiguration(preloadId);
        } else if (className.equals("RewardedAd")) {
          config = RewardedAdPreloader.getConfiguration(preloadId);
        } else if (className.equals("AppOpenAd")) {
          config = AppOpenAdPreloader.getConfiguration(preloadId);
        } else {
          result.error("PreloadError", "Unsupported className: " + className, null);
          break;
        }
        result.success(serializeConfig(preloadId, config));
        break;
      }
      case "MobileAds#getPreloadConfigurations": {
        String className = call.argument("className");

        if (className == null) {
          result.error("PreloadError", "Missing required argument.", null);
          break;
        }

        Map<String, PreloadConfiguration> configs = null;
        if (className.equals("InterstitialAd")) {
          configs = InterstitialAdPreloader.getConfigurations();
        } else if (className.equals("RewardedAd")) {
          configs = RewardedAdPreloader.getConfigurations();
        } else if (className.equals("AppOpenAd")) {
          configs = AppOpenAdPreloader.getConfigurations();
        } else {
          result.error("PreloadError", "Unsupported className: " + className, null);
          break;
        }

        Map<String, Map<String, Object>> response = new HashMap<>();
        if (configs != null) {
          for (Map.Entry<String, PreloadConfiguration> entry : configs.entrySet()) {
            response.put(entry.getKey(), serializeConfig(entry.getKey(), entry.getValue()));
          }
        }
        result.success(response);
        break;
      }
      case "MobileAds#pollAd": {
        String preloadId = call.argument("preloadId");
        String className = call.argument("className");
        Integer adId = call.argument("adId");

        if (preloadId == null || className == null || adId == null) {
          result.error("PreloadError", "Missing arguments.", null);
          break;
        }

        Map<String, Object> response = null;
        if (className.equals("InterstitialAd")) {
          InterstitialAd preloadedAd = InterstitialAdPreloader.pollAd(preloadId);
          if (preloadedAd != null) {
            PreloadConfiguration config = InterstitialAdPreloader.getConfiguration(preloadId);
            String adUnitId = config != null && config.getRequest() != null ? config.getRequest().getAdUnitId() : "";
            FlutterInterstitialAd adWrapper = new FlutterInterstitialAd(
                adId,
                instanceManager,
                adUnitId != null ? adUnitId : "",
                new FlutterAdRequest.Builder().build(),
                new FlutterAdLoader(context));
            adWrapper.onAdLoaded(preloadedAd);
            instanceManager.trackAd(adWrapper, adId);
            response = new HashMap<>();
            response.put("adUnitId", adUnitId != null ? adUnitId : "");
          }
        } else if (className.equals("RewardedAd")) {
          RewardedAd preloadedAd = RewardedAdPreloader.pollAd(preloadId);
          if (preloadedAd != null) {
            PreloadConfiguration config = RewardedAdPreloader.getConfiguration(preloadId);
            String adUnitId = config != null && config.getRequest() != null ? config.getRequest().getAdUnitId() : "";
            FlutterRewardedAd adWrapper = new FlutterRewardedAd(
                adId,
                instanceManager,
                adUnitId != null ? adUnitId : "",
                new FlutterAdRequest.Builder().build(),
                new FlutterAdLoader(context));
            adWrapper.onAdLoaded(preloadedAd);
            instanceManager.trackAd(adWrapper, adId);
            response = new HashMap<>();
            response.put("adUnitId", adUnitId != null ? adUnitId : "");
          }
        } else if (className.equals("AppOpenAd")) {
          AppOpenAd preloadedAd = AppOpenAdPreloader.pollAd(preloadId);
          if (preloadedAd != null) {
            PreloadConfiguration config = AppOpenAdPreloader.getConfiguration(preloadId);
            String adUnitId = config != null && config.getRequest() != null ? config.getRequest().getAdUnitId() : "";
            FlutterAppOpenAd adWrapper = new FlutterAppOpenAd(
                adId,
                instanceManager,
                adUnitId != null ? adUnitId : "",
                new FlutterAdRequest.Builder().build(),
                null,
                new FlutterAdLoader(context));
            adWrapper.onAdLoaded(preloadedAd);
            instanceManager.trackAd(adWrapper, adId);
            response = new HashMap<>();
            response.put("adUnitId", adUnitId != null ? adUnitId : "");
          }
        }
        result.success(response);
        break;
      }
      default:
        result.notImplemented();
    }
  }

  private void invokeOnPreloadEvent(final Map<Object, Object> arguments) {
    new Handler(Looper.getMainLooper())
        .post(
            new Runnable() {
              @Override
              public void run() {
                channel.invokeMethod("onPreloadEvent", arguments);
              }
            });
  }

  private Map<String, Object> serializeConfig(String preloadId, PreloadConfiguration config) {
    if (config == null) {
      return null;
    }
    Map<String, Object> map = new HashMap<>();
    String adUnitId = preloadIdToAdUnitId.get(preloadId);
    map.put("adUnitId", adUnitId != null ? adUnitId : "");
    map.put("bufferSize", config.getBufferSize());
    return map;
  }
}
