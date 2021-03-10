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

package io.flutter.plugins.googlemobileads;

import android.app.Activity;
import androidx.annotation.NonNull;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.StandardMethodCodec;
import java.util.HashMap;
import java.util.Map;

/**
 * Maintains reference to ad instances for the {@link
 * io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin}.
 *
 * <p>When an Ad is loaded from Dart, an equivalent ad object is created and maintained here to
 * provide access until the ad is disposed.
 */
class AdInstanceManager {
  @NonNull Activity activity;

  @NonNull private final Map<Integer, FlutterAd> ads;
  @NonNull private final MethodChannel channel;

  AdInstanceManager(@NonNull Activity activity, @NonNull BinaryMessenger binaryMessenger) {
    this.activity = activity;
    this.ads = new HashMap<>();
    final StandardMethodCodec methodCodec = new StandardMethodCodec(new AdMessageCodec());
    this.channel =
        new MethodChannel(binaryMessenger, "plugins.flutter.io/google_mobile_ads", methodCodec);
  }

  void setActivity(@NonNull Activity activity) {
    this.activity = activity;
  }

  FlutterAd adForId(int id) {
    return ads.get(id);
  }

  Integer adIdFor(@NonNull FlutterAd ad) {
    for (Integer adId : ads.keySet()) {
      if (ads.get(adId) == ad) {
        return adId;
      }
    }
    return null;
  }

  void trackAd(@NonNull FlutterAd ad, int adId) {
    if (ads.get(adId) != null) {
      throw new IllegalArgumentException(
          String.format("Ad for following adId already exists: %d", adId));
    }
    ads.put(adId, ad);
  }

  void disposeAd(int adId) {
    if (!ads.containsKey(adId)) {
      return;
    }
    Object adObject = ads.get(adId);
    if (adObject instanceof FlutterDestroyableAd) {
      ((FlutterDestroyableAd) adObject).destroy();
    }
    ads.remove(adId);
  }

  void onAdLoaded(@NonNull FlutterAd ad) {
    Map<Object, Object> arguments = new HashMap<>();
    arguments.put("adId", adIdFor(ad));
    arguments.put("eventName", "onAdLoaded");
    channel.invokeMethod("onAdEvent", arguments);
  }

  void onAdFailedToLoad(@NonNull FlutterAd ad, @NonNull FlutterAd.FlutterLoadAdError error) {
    Map<Object, Object> arguments = new HashMap<>();
    arguments.put("adId", adIdFor(ad));
    arguments.put("eventName", "onAdFailedToLoad");
    arguments.put("loadAdError", error);
    channel.invokeMethod("onAdEvent", arguments);
  }

  void onAppEvent(@NonNull FlutterAd ad, @NonNull String name, @NonNull String data) {
    Map<Object, Object> arguments = new HashMap<>();
    arguments.put("adId", adIdFor(ad));
    arguments.put("eventName", "onAppEvent");
    arguments.put("name", name);
    arguments.put("data", data);
    channel.invokeMethod("onAdEvent", arguments);
  }

  void onNativeAdClicked(@NonNull FlutterNativeAd ad) {
    Map<Object, Object> arguments = new HashMap<>();
    arguments.put("adId", adIdFor(ad));
    arguments.put("eventName", "onNativeAdClicked");
    channel.invokeMethod("onAdEvent", arguments);
  }

  void onNativeAdImpression(@NonNull FlutterNativeAd ad) {
    Map<Object, Object> arguments = new HashMap<>();
    arguments.put("adId", adIdFor(ad));
    arguments.put("eventName", "onNativeAdImpression");
    channel.invokeMethod("onAdEvent", arguments);
  }

  void onAdOpened(@NonNull FlutterAd ad) {
    Map<Object, Object> arguments = new HashMap<>();
    arguments.put("adId", adIdFor(ad));
    arguments.put("eventName", "onAdOpened");
    channel.invokeMethod("onAdEvent", arguments);
  }

  void onApplicationExit(@NonNull FlutterAd ad) {
    Map<Object, Object> arguments = new HashMap<>();
    arguments.put("adId", adIdFor(ad));
    arguments.put("eventName", "onApplicationExit");
    channel.invokeMethod("onAdEvent", arguments);
  }

  void onAdClosed(@NonNull FlutterAd ad) {
    Map<Object, Object> arguments = new HashMap<>();
    arguments.put("adId", adIdFor(ad));
    arguments.put("eventName", "onAdClosed");
    channel.invokeMethod("onAdEvent", arguments);
  }

  void onRewardedAdUserEarnedReward(
      @NonNull FlutterRewardedAd ad, @NonNull FlutterRewardedAd.FlutterRewardItem reward) {
    final Map<Object, Object> arguments = new HashMap<>();
    arguments.put("adId", adIdFor(ad));
    arguments.put("eventName", "onRewardedAdUserEarnedReward");
    arguments.put("rewardItem", reward);
    channel.invokeMethod("onAdEvent", arguments);
  }

  boolean showAdWithId(int id) {
    final FlutterAd.FlutterOverlayAd ad = (FlutterAd.FlutterOverlayAd) adForId(id);

    if (ad == null) {
      return false;
    }

    ad.show();
    return true;
  }
}
