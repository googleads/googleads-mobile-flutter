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

import android.util.Log;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.google.android.gms.ads.AdError;
import com.google.android.libraries.ads.mobile.sdk.common.AdLoadCallback;
import com.google.android.libraries.ads.mobile.sdk.common.AdValue;
import com.google.android.libraries.ads.mobile.sdk.common.FullScreenContentError;
import com.google.android.libraries.ads.mobile.sdk.common.LoadAdError;
import com.google.android.libraries.ads.mobile.sdk.rewarded.OnUserEarnedRewardListener;
import com.google.android.libraries.ads.mobile.sdk.rewarded.RewardItem;
import com.google.android.libraries.ads.mobile.sdk.rewardedinterstitial.RewardedInterstitialAdEventCallback;
import com.google.android.libraries.ads.mobile.sdk.rewardedinterstitial.RewardedInterstitialAd;
import io.flutter.plugins.googlemobileads.FlutterRewardedAd.FlutterRewardItem;
import java.lang.ref.WeakReference;

/** A wrapper for {@link RewardedInterstitialAd}. */
class FlutterRewardedInterstitialAd extends FlutterAd.FlutterOverlayAd {
  private static final String TAG = "FlutterRIAd";

  @NonNull private final AdInstanceManager manager;
  @NonNull private final String adUnitId;
  @NonNull private final FlutterAdLoader flutterAdLoader;
  @Nullable private final FlutterAdRequest request;
  @Nullable private final FlutterAdManagerAdRequest adManagerRequest;
  @Nullable RewardedInterstitialAd rewardedInterstitialAd;

  /** Constructor for AdMob Ad Request. */
  public FlutterRewardedInterstitialAd(
      int adId,
      @NonNull AdInstanceManager manager,
      @NonNull String adUnitId,
      @NonNull FlutterAdRequest request,
      @NonNull FlutterAdLoader flutterAdLoader) {
    super(adId);
    this.manager = manager;
    this.adUnitId = adUnitId;
    this.request = request;
    this.adManagerRequest = null;
    this.flutterAdLoader = flutterAdLoader;
  }

  /** Constructor for Ad Manager Ad request. */
  public FlutterRewardedInterstitialAd(
      int adId,
      @NonNull AdInstanceManager manager,
      @NonNull String adUnitId,
      @NonNull FlutterAdManagerAdRequest adManagerRequest,
      @NonNull FlutterAdLoader flutterAdLoader) {
    super(adId);
    this.manager = manager;
    this.adUnitId = adUnitId;
    this.adManagerRequest = adManagerRequest;
    this.request = null;
    this.flutterAdLoader = flutterAdLoader;
  }

  @Override
  void load() {
    final AdLoadCallback adLoadCallback = new DelegatingRewardedCallback(this);
    if (request != null) {
      flutterAdLoader.loadRewardedInterstitial(request.asAdRequest(adUnitId), adLoadCallback);
    } else if (adManagerRequest != null) {
      flutterAdLoader.loadAdManagerRewardedInterstitial(
          adManagerRequest.asAdManagerAdRequest(adUnitId), adLoadCallback);
    } else {
      Log.e(TAG, "A null or invalid ad request was provided.");
    }
  }

  void onAdLoaded(@NonNull RewardedInterstitialAd rewardedInterstitialAd) {
    FlutterRewardedInterstitialAd.this.rewardedInterstitialAd = rewardedInterstitialAd;
    manager.onAdLoaded(adId, rewardedInterstitialAd.getResponseInfo());
  }

  void onAdFailedToLoad(@NonNull LoadAdError loadAdError) {
    manager.onAdFailedToLoad(adId, new FlutterLoadAdError(loadAdError));
  }

  @Override
  public void show() {
    if (rewardedInterstitialAd == null) {
      Log.e(
          TAG,
          "Error showing rewarded interstitial - the rewarded interstitial ad wasn't loaded yet.");
      return;
    }
    if (manager.getActivity() == null) {
      Log.e(TAG, "Tried to show rewarded interstitial ad before activity was bound to the plugin.");
      return;
    }
    rewardedInterstitialAd.setAdEventCallback(new DelegatingRewardedCallback(this));
    rewardedInterstitialAd.show(manager.getActivity(), new DelegatingRewardedCallback(this));
  }

  @Override
  public void setImmersiveMode(boolean immersiveModeEnabled) {
    if (rewardedInterstitialAd == null) {
      Log.e(
          TAG,
          "Error setting immersive mode in rewarded interstitial ad - the rewarded interstitial ad"
              + " wasn't loaded yet.");
      return;
    }
    rewardedInterstitialAd.setImmersiveMode(immersiveModeEnabled);
  }

  void onAdMetadataChanged() {
    manager.onAdMetadataChanged(adId);
  }

  void onUserEarnedReward(@NonNull RewardItem rewardItem) {
    manager.onRewardedAdUserEarnedReward(
        adId, new FlutterRewardItem(rewardItem.getAmount(), rewardItem.getType()));
  }

  @Override
  void dispose() {
    rewardedInterstitialAd = null;
  }

  public void setServerSideVerificationOptions(FlutterServerSideVerificationOptions options) {
    if (rewardedInterstitialAd != null) {
      rewardedInterstitialAd.setServerSideVerificationOptions(
          options.asServerSideVerificationOptions());
    } else {
      Log.e(TAG, "RewardedInterstitialAd is null in setServerSideVerificationOptions");
    }
  }

  /**
   * This class delegates various rewarded interstitial ad callbacks to
   * FlutterRewardedInterstitialAd. Maintains a weak reference to avoid memory leaks.
   */
  private static final class DelegatingRewardedCallback
      implements AdLoadCallback<RewardedInterstitialAd>,
          RewardedInterstitialAdEventCallback,
          OnUserEarnedRewardListener {

    private final WeakReference<FlutterRewardedInterstitialAd> delegate;

    DelegatingRewardedCallback(FlutterRewardedInterstitialAd delegate) {
      this.delegate = new WeakReference<>(delegate);
    }

    @Override
    public void onAdLoaded(@NonNull RewardedInterstitialAd rewardedInterstitialAd) {
      FlutterRewardedInterstitialAd ad = delegate.get();
      if (ad != null) {
        ad.onAdLoaded(rewardedInterstitialAd);
      }
    }

    @Override
    public void onAdFailedToLoad(@NonNull LoadAdError loadAdError) {
      FlutterRewardedInterstitialAd ad = delegate.get();
      if (ad != null) {
        ad.onAdFailedToLoad(loadAdError);
      }
    }

    @Override
    public void onUserEarnedReward(@NonNull RewardItem rewardItem) {
      FlutterRewardedInterstitialAd ad = delegate.get();
      if (ad != null) {
        ad.onUserEarnedReward(rewardItem);
      }
    }

    @Override
    public void onAdMetadataChanged() {
      FlutterRewardedInterstitialAd ad = delegate.get();
      if (ad != null) {
        ad.onAdMetadataChanged();
      }
    }

    @Override
    public void onAdFailedToShowFullScreenContent(@NonNull FullScreenContentError adError) {
      FlutterRewardedInterstitialAd ad = delegate.get();
      if (ad != null) {
        ad.manager.onFailedToShowFullScreenContent(
            ad.adId,
            new AdError(
                adError.getCode().getValue(),
                adError.getMessage(),
                AdInstanceManager.NEXT_GEN_DOMAIN));
      }
    }

    @Override
    public void onAdShowedFullScreenContent() {
      FlutterRewardedInterstitialAd ad = delegate.get();
      if (ad != null) {
        ad.manager.onAdShowedFullScreenContent(ad.adId);
      }
    }

    @Override
    public void onAdDismissedFullScreenContent() {
      FlutterRewardedInterstitialAd ad = delegate.get();
      if (ad != null) {
        ad.manager.onAdDismissedFullScreenContent(ad.adId);
      }
    }

    @Override
    public void onAdImpression() {
      FlutterRewardedInterstitialAd ad = delegate.get();
      if (ad != null) {
        ad.manager.onAdImpression(ad.adId);
      }
    }

    @Override
    public void onAdClicked() {
      FlutterRewardedInterstitialAd ad = delegate.get();
      if (ad != null) {
        ad.manager.onAdClicked(ad.adId);
      }
    }

    @Override
    public void onAdPaid(@NonNull AdValue adValue) {
      FlutterRewardedInterstitialAd ad = delegate.get();
      if (ad != null) {
        ad.manager.onPaidEvent(
            ad,
            AdInstanceManager.comAdValueToFlutterAdValue(adValue));
      }
    }
  }
}
