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
import android.util.Log;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.VisibleForTesting;
import com.google.android.gms.ads.MobileAds;
import com.google.android.gms.ads.RequestConfiguration;
import com.google.android.gms.ads.formats.UnifiedNativeAd;
import com.google.android.gms.ads.formats.UnifiedNativeAdView;
import com.google.android.gms.ads.initialization.InitializationStatus;
import com.google.android.gms.ads.initialization.OnInitializationCompleteListener;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.StandardMethodCodec;
import io.flutter.plugin.platform.PlatformViewRegistry;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Flutter plugin accessing Google Mobile Ads API.
 *
 * <p>Instantiate this in an add to app scenario to gracefully handle activity and context changes.
 */
public class GoogleMobileAdsPlugin implements FlutterPlugin, ActivityAware, MethodCallHandler {

  private static <T> T requireNonNull(T obj) {
    if (obj == null) {
      throw new IllegalArgumentException();
    }
    return obj;
  }

  // This is always null when not using v2 embedding.
  @Nullable private FlutterPluginBinding pluginBinding;
  @Nullable private AdInstanceManager instanceManager;
  private final Map<String, NativeAdFactory> nativeAdFactories = new HashMap<>();

  /**
   * Public constructor for the plugin. Dependency initialization is handled in lifecycle methods
   * below.
   */
  public GoogleMobileAdsPlugin() {}

  /** Constructor for testing. */
  @VisibleForTesting
  protected GoogleMobileAdsPlugin(
      @Nullable FlutterPluginBinding pluginBinding, @Nullable AdInstanceManager instanceManager) {
    this.pluginBinding = pluginBinding;
    this.instanceManager = instanceManager;
  }

  /**
   * Interface used to display a {@link com.google.android.gms.ads.formats.UnifiedNativeAd}.
   *
   * <p>Added to a {@link io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin} and creates
   * {@link com.google.android.gms.ads.formats.UnifiedNativeAdView}s from Native Ads created in
   * Dart.
   */
  public interface NativeAdFactory {
    /**
     * Creates a {@link com.google.android.gms.ads.formats.UnifiedNativeAdView} with a {@link
     * com.google.android.gms.ads.formats.UnifiedNativeAd}.
     *
     * @param nativeAd Ad information used to create a {@link
     *     com.google.android.gms.ads.formats.UnifiedNativeAdView}
     * @param customOptions Used to pass additional custom options to create the {@link
     *     com.google.android.gms.ads.formats.UnifiedNativeAdView}. Nullable.
     * @return a {@link com.google.android.gms.ads.formats.UnifiedNativeAdView} that is overlaid on
     *     top of the FlutterView.
     */
    UnifiedNativeAdView createNativeAd(UnifiedNativeAd nativeAd, Map<String, Object> customOptions);
  }

  /**
   * Registers a {@link io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin.NativeAdFactory}
   * used to create {@link com.google.android.gms.ads.formats.UnifiedNativeAdView}s from a Native Ad
   * created in Dart.
   *
   * @param engine maintains access to a GoogleMobileAdsPlugin instance.
   * @param factoryId a unique identifier for the ad factory. The Native Ad created in Dart includes
   *     a parameter that refers to this.
   * @param nativeAdFactory creates {@link com.google.android.gms.ads.formats.UnifiedNativeAdView}s
   *     when Flutter NativeAds are created.
   * @return whether the factoryId is unique and the nativeAdFactory was successfully added.
   */
  public static boolean registerNativeAdFactory(
      FlutterEngine engine, String factoryId, NativeAdFactory nativeAdFactory) {
    final GoogleMobileAdsPlugin gmaPlugin =
        (GoogleMobileAdsPlugin) engine.getPlugins().get(GoogleMobileAdsPlugin.class);
    return registerNativeAdFactory(gmaPlugin, factoryId, nativeAdFactory);
  }

  private static boolean registerNativeAdFactory(
      GoogleMobileAdsPlugin plugin, String factoryId, NativeAdFactory nativeAdFactory) {
    if (plugin == null) {
      final String message =
          String.format(
              "Could not find a %s instance. The plugin may have not been registered.",
              GoogleMobileAdsPlugin.class.getSimpleName());
      throw new IllegalStateException(message);
    }

    return plugin.addNativeAdFactory(factoryId, nativeAdFactory);
  }

  /**
   * Unregisters a {@link io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin.NativeAdFactory}
   * used to create {@link com.google.android.gms.ads.formats.UnifiedNativeAdView}s from a Native Ad
   * created in Dart.
   *
   * @param engine maintains access to a GoogleMobileAdsPlugin instance.
   * @param factoryId a unique identifier for the ad factory. The Native ad created in Dart includes
   *     a parameter that refers to this.
   * @return the previous {@link
   *     io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin.NativeAdFactory} associated with
   *     this factoryId, or null if there was none for this factoryId.
   */
  public static NativeAdFactory unregisterNativeAdFactory(FlutterEngine engine, String factoryId) {
    final FlutterPlugin gmaPlugin = engine.getPlugins().get(GoogleMobileAdsPlugin.class);
    if (gmaPlugin != null) {
      return ((GoogleMobileAdsPlugin) gmaPlugin).removeNativeAdFactory(factoryId);
    }

    return null;
  }

  private boolean addNativeAdFactory(String factoryId, NativeAdFactory nativeAdFactory) {
    if (nativeAdFactories.containsKey(factoryId)) {
      final String errorMessage =
          String.format(
              "A NativeAdFactory with the following factoryId already exists: %s", factoryId);
      Log.e(GoogleMobileAdsPlugin.class.getSimpleName(), errorMessage);
      return false;
    }

    nativeAdFactories.put(factoryId, nativeAdFactory);
    return true;
  }

  private NativeAdFactory removeNativeAdFactory(String factoryId) {
    return nativeAdFactories.remove(factoryId);
  }

  private void initializePlugin(
      Activity activity, BinaryMessenger messenger, PlatformViewRegistry viewRegistry) {
    final MethodChannel channel =
        new MethodChannel(
            messenger,
            "plugins.flutter.io/google_mobile_ads",
            new StandardMethodCodec(new AdMessageCodec()));
    channel.setMethodCallHandler(this);
    instanceManager = new AdInstanceManager(activity, messenger);
    viewRegistry.registerViewFactory(
        "plugins.flutter.io/google_mobile_ads/ad_widget",
        new GoogleMobileAdsViewFactory(instanceManager));
  }

  @Override
  public void onAttachedToEngine(FlutterPluginBinding binding) {
    pluginBinding = binding;
  }

  @Override
  public void onDetachedFromEngine(FlutterPluginBinding binding) {
    // Do nothing
  }

  @Override
  public void onAttachedToActivity(ActivityPluginBinding binding) {
    initializePlugin(
        binding.getActivity(),
        pluginBinding.getBinaryMessenger(),
        pluginBinding.getPlatformViewRegistry());
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    // Do nothing.
  }

  @Override
  public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {
    if (instanceManager != null) {
      instanceManager.setActivity(binding.getActivity());
    }
  }

  @Override
  public void onDetachedFromActivity() {
    // Do nothing.
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull final Result result) {
    switch (call.method) {
      case "_init":
        // Internal init. This is necessary to cleanup state on hot restart.
        instanceManager.disposeAllAds();
        result.success(null);
        break;

      case "MobileAds#initialize":
        MobileAds.initialize(
            instanceManager.activity,
            new OnInitializationCompleteListener() {
              @Override
              public void onInitializationComplete(InitializationStatus initializationStatus) {
                result.success(new FlutterInitializationStatus(initializationStatus));
              }
            });
        break;
      case "MobileAds#updateRequestConfiguration":
        RequestConfiguration.Builder builder = MobileAds.getRequestConfiguration().toBuilder();
        String maxAdContentRating = call.argument("maxAdContentRating");
        Integer tagForChildDirectedTreatment = call.argument("tagForChildDirectedTreatment");
        Integer tagForUnderAgeOfConsent = call.argument("tagForUnderAgeOfConsent");
        List<String> testDeviceIds = call.argument("testDeviceIds");
        if (maxAdContentRating != null) {
          builder.setMaxAdContentRating(maxAdContentRating);
        }
        if (tagForChildDirectedTreatment != null) {
          builder.setTagForChildDirectedTreatment(tagForChildDirectedTreatment);
        }
        if (tagForUnderAgeOfConsent != null) {
          builder.setTagForUnderAgeOfConsent(tagForUnderAgeOfConsent);
        }
        if (testDeviceIds != null) {
          builder.setTestDeviceIds(testDeviceIds);
        }
        MobileAds.setRequestConfiguration(builder.build());
        result.success(null);
        break;
      case "loadBannerAd":
        final FlutterBannerAd bannerAd =
            new FlutterBannerAd.Builder()
                .setManager(instanceManager)
                .setAdUnitId(call.<String>argument("adUnitId"))
                .setRequest(call.<FlutterAdRequest>argument("request"))
                .setSize(call.<FlutterAdSize>argument("size"))
                .build();
        instanceManager.trackAd(bannerAd, call.<Integer>argument("adId"));
        bannerAd.load();
        result.success(null);
        break;
      case "loadNativeAd":
        final String factoryId = call.argument("factoryId");
        final NativeAdFactory factory = nativeAdFactories.get(factoryId);
        if (factory == null) {
          final String message = String.format("Can't find NativeAdFactory with id: %s", factoryId);
          result.error("NativeAdError", message, null);
          break;
        }

        final FlutterNativeAd nativeAd =
            new FlutterNativeAd.Builder()
                .setManager(instanceManager)
                .setAdUnitId(call.<String>argument("adUnitId"))
                .setAdFactory(factory)
                .setRequest(call.<FlutterAdRequest>argument("request"))
                .setPublisherRequest(call.<FlutterPublisherAdRequest>argument("publisherRequest"))
                .setCustomOptions(call.<Map<String, Object>>argument("customOptions"))
                .build();
        instanceManager.trackAd(nativeAd, call.<Integer>argument("adId"));
        nativeAd.load();
        result.success(null);
        break;
      case "loadInterstitialAd":
        final FlutterInterstitialAd interstitial =
            new FlutterInterstitialAd.Builder()
                .setManager(instanceManager)
                .setAdUnitId(call.<String>argument("adUnitId"))
                .setRequest(call.<FlutterAdRequest>argument("request"))
                .build();
        instanceManager.trackAd(interstitial, call.<Integer>argument("adId"));
        interstitial.load();
        result.success(null);
        break;
      case "loadRewardedAd":
        final String adUnitId = requireNonNull(call.<String>argument("adUnitId"));
        final FlutterAdRequest request = call.argument("request");
        final FlutterPublisherAdRequest publisherRequest = call.argument("publisherRequest");
        final FlutterServerSideVerificationOptions serverSideVerificationOptions =
            call.argument("serverSideVerificationOptions");

        final FlutterRewardedAd rewardedAd;
        if (request != null) {
          rewardedAd =
              new FlutterRewardedAd(
                  requireNonNull(instanceManager),
                  adUnitId,
                  request,
                  serverSideVerificationOptions);
        } else if (publisherRequest != null) {
          rewardedAd =
              new FlutterRewardedAd(
                  requireNonNull(instanceManager),
                  adUnitId,
                  publisherRequest,
                  serverSideVerificationOptions);
        } else {
          result.error("InvalidRequest", "A null or invalid ad request was provided.", null);
          break;
        }

        instanceManager.trackAd(rewardedAd, requireNonNull(call.<Integer>argument("adId")));
        rewardedAd.load();
        result.success(null);
        break;
      case "loadPublisherBannerAd":
        final FlutterPublisherBannerAd publisherBannerAd =
            new FlutterPublisherBannerAd.Builder()
                .setManager(instanceManager)
                .setAdUnitId(call.<String>argument("adUnitId"))
                .setSizes(call.<List<FlutterAdSize>>argument("sizes"))
                .setRequest(call.<FlutterPublisherAdRequest>argument("request"))
                .build();
        instanceManager.trackAd(publisherBannerAd, call.<Integer>argument("adId"));
        publisherBannerAd.load();
        result.success(null);
        break;
      case "loadPublisherInterstitialAd":
        final FlutterPublisherInterstitialAd publisherInterstitialAd =
            new FlutterPublisherInterstitialAd(
                requireNonNull(instanceManager),
                requireNonNull(call.<String>argument("adUnitId")),
                call.<FlutterPublisherAdRequest>argument("request"));
        instanceManager.trackAd(
            publisherInterstitialAd, requireNonNull(call.<Integer>argument("adId")));
        publisherInterstitialAd.load();
        result.success(null);
        break;
      case "disposeAd":
        instanceManager.disposeAd(call.<Integer>argument("adId"));
        result.success(null);
        break;
      case "":
        final boolean adShown = instanceManager.showAdWithId(call.<Integer>argument("adId"));
        if (!adShown) {
          result.error("AdShowError", "Ad failed to show.", null);
          break;
        }
        result.success(null);
        break;
      default:
        result.notImplemented();
    }
  }
}
