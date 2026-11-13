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
import android.util.Log;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.VisibleForTesting;
import com.google.android.gms.ads.nativead.NativeAdOptions;
import com.google.android.libraries.ads.mobile.sdk.appopen.AppOpenAd;
import com.google.android.libraries.ads.mobile.sdk.common.AdChoicesPlacement;
import com.google.android.libraries.ads.mobile.sdk.common.AdLoadCallback;
import com.google.android.libraries.ads.mobile.sdk.common.AdRequest;
import com.google.android.libraries.ads.mobile.sdk.common.VideoOptions;
import com.google.android.libraries.ads.mobile.sdk.interstitial.InterstitialAd;
import com.google.android.libraries.ads.mobile.sdk.nativead.NativeAd.NativeAdType;
import com.google.android.libraries.ads.mobile.sdk.nativead.NativeAd.NativeMediaAspectRatio;
import com.google.android.libraries.ads.mobile.sdk.nativead.NativeAdLoader;
import com.google.android.libraries.ads.mobile.sdk.nativead.NativeAdLoaderCallback;
import com.google.android.libraries.ads.mobile.sdk.nativead.NativeAdRequest;
import com.google.android.libraries.ads.mobile.sdk.rewarded.RewardedAd;
import com.google.android.libraries.ads.mobile.sdk.rewardedinterstitial.RewardedInterstitialAd;
import java.util.List;

/**
 * A wrapper around load methods in GMA. This exists mainly to make the Android code more testable.
 */
public class FlutterAdLoader {

  @NonNull private final Context context;

  public FlutterAdLoader(@NonNull Context context) {
    this.context = context;
  }

  /** Load an app open ad. */
  public void loadAppOpen(
      @NonNull AdRequest adRequest, @NonNull AdLoadCallback<AppOpenAd> loadCallback) {
    AppOpenAd.load(adRequest, loadCallback);
  }

  /** Load an ad manager app open ad. */
  public void loadAdManagerAppOpen(
      @NonNull AdRequest adRequest, @NonNull AdLoadCallback<AppOpenAd> loadCallback) {
    loadAppOpen(adRequest, loadCallback);
  }

  /** Load an interstitial ad. */
  public void loadInterstitial(
      @NonNull AdRequest adRequest, @NonNull AdLoadCallback<InterstitialAd> loadCallback) {
    InterstitialAd.load(adRequest, loadCallback);
  }

  /** Load an ad manager interstitial ad. */
  public void loadAdManagerInterstitial(
      @NonNull AdRequest adRequest, @NonNull AdLoadCallback<InterstitialAd> loadCallback) {
    loadInterstitial(adRequest, loadCallback);
  }

  /** Load a rewarded ad. */
  public void loadRewarded(
      @NonNull AdRequest adRequest, @NonNull AdLoadCallback<RewardedAd> loadCallback) {
    RewardedAd.load(adRequest, loadCallback);
  }

  /** Load a rewarded interstitial ad. */
  public void loadRewardedInterstitial(
      @NonNull AdRequest adRequest, @NonNull AdLoadCallback<RewardedInterstitialAd> loadCallback) {
    RewardedInterstitialAd.load(adRequest, loadCallback);
  }

  /** Load an ad manager rewarded ad. */
  public void loadAdManagerRewarded(
      @NonNull AdRequest adRequest, @NonNull AdLoadCallback<RewardedAd> loadCallback) {
    loadRewarded(adRequest, loadCallback);
  }

  /** Load an ad manager rewarded interstitial ad. */
  public void loadAdManagerRewardedInterstitial(
      @NonNull AdRequest adRequest, @NonNull AdLoadCallback<RewardedInterstitialAd> loadCallback) {
    loadRewardedInterstitial(adRequest, loadCallback);
  }

  /** Load a native ad. */
  public void loadNativeAd(
      @NonNull String adUnitId,
      @NonNull NativeAdLoaderCallback nativeAdLoaderCallback,
      @NonNull NativeAdOptions nativeAdOptions) {
    NativeAdLoader.load(buildNativeAdRequest(adUnitId, nativeAdOptions), nativeAdLoaderCallback);
  }

  /**
   * Builds the request for a native ad from the options set in Dart.
   *
   * <p>Multiple images and custom Mute This Ad have no equivalent on {@link
   * NativeAdRequest.Builder}, so those options are not carried over.
   */
  @VisibleForTesting
  @NonNull
  static NativeAdRequest buildNativeAdRequest(
      @NonNull String adUnitId, @NonNull NativeAdOptions nativeAdOptions) {
    VideoOptions videoOptions =
        nativeAdOptions.getVideoOptions() == null
            ? new VideoOptions.Builder().build()
            : new VideoOptions.Builder()
                .setClickToExpandRequested(
                    nativeAdOptions.getVideoOptions().getClickToExpandRequested())
                .setCustomControlsRequested(
                    nativeAdOptions.getVideoOptions().getCustomControlsRequested())
                .setStartMuted(nativeAdOptions.getVideoOptions().getStartMuted())
                .build();
    NativeAdRequest.Builder builder =
        new NativeAdRequest.Builder(adUnitId, List.of(NativeAdType.NATIVE))
            .setVideoOptions(videoOptions);
    NativeMediaAspectRatio mediaAspectRatio =
        toMediaAspectRatio(nativeAdOptions.getMediaAspectRatio());
    if (mediaAspectRatio != null) {
      builder.setMediaAspectRatio(mediaAspectRatio);
    }
    AdChoicesPlacement adChoicesPlacement =
        toAdChoicesPlacement(nativeAdOptions.getAdChoicesPlacement());
    if (adChoicesPlacement != null) {
      builder.setAdChoicesPlacement(adChoicesPlacement);
    }
    if (nativeAdOptions.shouldReturnUrlsForImageAssets()) {
      builder.disableImageDownloading();
    }
    return builder.build();
  }

  /** Returns null for {@code NATIVE_MEDIA_ASPECT_RATIO_UNKNOWN}, leaving the SDK default. */
  @Nullable
  private static NativeMediaAspectRatio toMediaAspectRatio(int mediaAspectRatio) {
    switch (mediaAspectRatio) {
      case NativeAdOptions.NATIVE_MEDIA_ASPECT_RATIO_ANY:
        return NativeMediaAspectRatio.ANY;
      case NativeAdOptions.NATIVE_MEDIA_ASPECT_RATIO_LANDSCAPE:
        return NativeMediaAspectRatio.LANDSCAPE;
      case NativeAdOptions.NATIVE_MEDIA_ASPECT_RATIO_PORTRAIT:
        return NativeMediaAspectRatio.PORTRAIT;
      case NativeAdOptions.NATIVE_MEDIA_ASPECT_RATIO_SQUARE:
        return NativeMediaAspectRatio.SQUARE;
      default:
        return null;
    }
  }

  @Nullable
  private static AdChoicesPlacement toAdChoicesPlacement(int adChoicesPlacement) {
    switch (adChoicesPlacement) {
      case NativeAdOptions.ADCHOICES_TOP_LEFT:
        return AdChoicesPlacement.TOP_LEFT;
      case NativeAdOptions.ADCHOICES_TOP_RIGHT:
        return AdChoicesPlacement.TOP_RIGHT;
      case NativeAdOptions.ADCHOICES_BOTTOM_RIGHT:
        return AdChoicesPlacement.BOTTOM_RIGHT;
      case NativeAdOptions.ADCHOICES_BOTTOM_LEFT:
        return AdChoicesPlacement.BOTTOM_LEFT;
      default:
        return null;
    }
  }

  /** Load an ad manager native ad. */
  public void loadAdManagerNativeAd(
      @NonNull String adUnitId,
      @NonNull NativeAdLoaderCallback nativeAdLoaderCallback,
      @NonNull NativeAdOptions nativeAdOptions) {
    loadNativeAd(adUnitId, nativeAdLoaderCallback, nativeAdOptions);
  }
}
