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
import com.google.android.gms.ads.AdError;
import com.google.android.gms.ads.ResponseInfo;
import com.google.android.gms.ads.interstitial.InterstitialAdPreloader;
import com.google.android.gms.ads.preload.PreloadCallbackV2;
import com.google.android.gms.ads.preload.PreloadConfiguration;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import java.util.HashMap;
import java.util.Map;

class FlutterAdPreloader {

  private final Context context;
  private final AdInstanceManager instanceManager;
  private final MethodChannel channel;

  FlutterAdPreloader(@NonNull Context context, @NonNull AdInstanceManager instanceManager, @NonNull MethodChannel channel) {
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

        PreloadConfiguration.Builder builder = new PreloadConfiguration.Builder(adUnitId);
        if (bufferSize != null) {
          builder.setBufferSize(bufferSize);
        }
        PreloadConfiguration config = builder.build();

        InterstitialAdPreloader.start(preloadId, config, new PreloadCallbackV2() {
          @Override
          public void onAdPreloaded(@NonNull String id, @NonNull ResponseInfo responseInfo) {
            Map<Object, Object> arguments = new HashMap<>();
            arguments.put("preloadId", id);
            arguments.put("eventName", "onAdPreloaded");
            arguments.put("responseInfo", new FlutterAd.FlutterResponseInfo(responseInfo));
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
          public void onAdFailedToPreload(@NonNull String id, @NonNull AdError adError) {
            Map<Object, Object> arguments = new HashMap<>();
            arguments.put("preloadId", id);
            arguments.put("eventName", "onAdFailedToPreload");
            arguments.put("error", new FlutterAd.FlutterAdError(adError));
            invokeOnPreloadEvent(arguments);
          }
        });
        result.success(null);
        break;
      }
      case "MobileAds#destroyPreloader": {
        String preloadId = call.argument("preloadId");
        InterstitialAdPreloader.destroy(preloadId);
        result.success(null);
        break;
      }
      case "MobileAds#destroyAllPreloaders": {
        InterstitialAdPreloader.destroyAll();
        result.success(null);
        break;
      }
      case "MobileAds#isPreloadedAdAvailable": {
        String preloadId = call.argument("preloadId");
        boolean available = InterstitialAdPreloader.isAdAvailable(preloadId);
        result.success(available);
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
}
