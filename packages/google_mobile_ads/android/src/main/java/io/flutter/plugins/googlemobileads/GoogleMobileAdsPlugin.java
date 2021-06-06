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

import android.util.Log;
import androidx.annotation.NonNull;
import com.google.android.gms.ads.nativead.NativeAd;
import com.google.android.gms.ads.nativead.NativeAdView;
import github.penguin.reference.ReferencePlugin;
import github.penguin.reference.reference.TypeChannelMessenger;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugins.googlemobileads.adcontainers.AdContainersChannelRegistrar;
import io.flutter.plugins.googlemobileads.mobileads.MobileAdsChannelRegistrar;
import java.util.Map;

/**
 * Flutter plugin accessing Google Mobile Ads API.
 *
 * <p>Instantiate this in an add to app scenario to gracefully handle activity and context changes.
 */
public class GoogleMobileAdsPlugin implements FlutterPlugin, ActivityAware {
  public FlutterPluginBinding flutterPluginBinding;

  /**
   * Public constructor for the plugin. Dependency initialization is handled in lifecycle methods
   * below.
   */
  public GoogleMobileAdsPlugin() {}

  /**
   * Interface used to display a {@link com.google.android.gms.ads.nativead.NativeAd}.
   *
   * <p>Added to a {@link io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin} and creates
   * {@link com.google.android.gms.ads.nativead.NativeAdView}s from Native Ads created in Dart.
   */
  public interface NativeAdFactory {
    /**
     * Creates a {@link com.google.android.gms.ads.nativead.NativeAdView} with a {@link
     * com.google.android.gms.ads.nativead.NativeAd}.
     *
     * @param nativeAd Ad information used to create a {@link
     *     com.google.android.gms.ads.nativead.NativeAd}
     * @param customOptions Used to pass additional custom options to create the {@link
     *     com.google.android.gms.ads.nativead.NativeAdView}. Nullable.
     * @return a {@link com.google.android.gms.ads.nativead.NativeAdView} that is overlaid on top of
     *     the FlutterView.
     */
    NativeAdView createNativeAd(NativeAd nativeAd, Map<String, Object> customOptions);
  }

  /**
   * Registers a {@link io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin.NativeAdFactory}
   * used to create {@link com.google.android.gms.ads.nativead.NativeAdView}s from a Native Ad
   * created in Dart.
   *
   * @param binaryMessenger key to retrieve a TypeChannelMessenger
   * @param factoryId a unique identifier for the ad factory. The Native Ad created in Dart includes
   *     a parameter that refers to this.
   * @param nativeAdFactory creates {@link com.google.android.gms.ads.nativead.NativeAdView}s when
   *     Flutter NativeAds are created.
   * @return whether the factoryId is unique and the nativeAdFactory was successfully added.
   */
  public static boolean registerNativeAdFactory(
      BinaryMessenger binaryMessenger, String factoryId, NativeAdFactory nativeAdFactory) {
    final TypeChannelMessenger messenger = ReferencePlugin.getMessengerInstance(binaryMessenger);
    if (messenger.getInstanceManager().containsInstance(factoryId)) {
      final String errorMessage =
          String.format(
              "A NativeAdFactory with the following factoryId already exists: %s", factoryId);
      Log.e(GoogleMobileAdsPlugin.class.getSimpleName(), errorMessage);
      return false;
    }
    messenger.getInstanceManager().addStrongReference(nativeAdFactory, factoryId);
    return true;
  }

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
    flutterPluginBinding = binding;
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    // Do nothing
  }

  @Override
  public void onAttachedToActivity(ActivityPluginBinding binding) {
    final TypeChannelMessenger messenger =
        ReferencePlugin.getMessengerInstance(flutterPluginBinding.getBinaryMessenger());
    final AdContainersChannelRegistrar adContainersRegistrar =
        new AdContainersChannelRegistrar(new AdContainersChannelRegistrar.AdContainersLibraryImplementations(messenger,
            binding.getActivity()));
    final MobileAdsChannelRegistrar mobileAdsRegistrar =
        new MobileAdsChannelRegistrar(new MobileAdsChannelRegistrar.MobileAdsLibraryImplementations(messenger, binding.getActivity()));

    adContainersRegistrar.registerHandlers();
    mobileAdsRegistrar.registerHandlers();
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    // Do nothing.
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {


  }

  @Override
  public void onDetachedFromActivity() {
    // Do nothing.
  }
}
