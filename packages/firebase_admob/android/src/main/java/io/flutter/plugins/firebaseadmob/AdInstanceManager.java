package io.flutter.plugins.firebaseadmob;

import android.app.Activity;
import androidx.annotation.NonNull;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.StandardMethodCodec;
import java.util.HashMap;
import java.util.Map;

/**
 * Maintains reference to ad instances for the {@link
 * io.flutter.plugins.firebaseadmob.FirebaseAdMobPlugin}.
 *
 * <p>When an Ad is loaded from Dart, an equivalent ad object is created and maintained here to
 * provide access until the ad is disposed.
 */
class AdInstanceManager {
  @NonNull Activity activity;

  private final Map<Integer, FlutterAd> ads;
  private final MethodChannel channel;

  AdInstanceManager(@NonNull Activity activity, @NonNull BinaryMessenger binaryMessenger) {
    this.activity = activity;
    this.ads = new HashMap<>();
    final StandardMethodCodec methodCodec = new StandardMethodCodec(new AdMessageCodec());
    this.channel =
        new MethodChannel(binaryMessenger, "plugins.flutter.io/firebase_admob", methodCodec);
  }

  void setActivity(@NonNull Activity activity) {
    this.activity = activity;
  }

  FlutterAd adForId(int id) {
    return ads.get(id);
  }

  Integer adIdFor(@NonNull FlutterAd ad) {
    for (Integer adId : ads.keySet()) {
      if (ads.get(adId) == ad) return adId;
    }

    return null;
  }

  void loadAd(@NonNull FlutterAd ad, int adId) {
    if (ads.get(adId) != null) {
      throw new IllegalArgumentException(
          String.format("Ad for following adId already exists: %d", adId));
    }
    ads.put(adId, ad);
  }

  void disposeAd(int adId) {
    ads.remove(adId);
  }

  void onAdLoaded(@NonNull FlutterAd ad) {
    Map<Object, Object> arguments = new HashMap<>();
    arguments.put("adId", adIdFor(ad));
    arguments.put("eventName", "onAdLoaded");
    channel.invokeMethod("onAdEvent", arguments);
  }

  void onAdFailedToLoad(@NonNull FlutterAd ad) {
    Map<Object, Object> arguments = new HashMap<>();
    arguments.put("adId", adIdFor(ad));
    arguments.put("eventName", "onAdFailedToLoad");
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
    final FlutterAd.FlutterAdWithoutView ad = (FlutterAd.FlutterAdWithoutView) adForId(id);

    if (ad == null) {
      return false;
    }

    ad.show();
    return true;
  }
}
