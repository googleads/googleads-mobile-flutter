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
import androidx.annotation.Nullable;
import androidx.annotation.VisibleForTesting;
import com.google.android.gms.ads.LoadAdError;
import com.google.android.gms.ads.rewarded.RewardItem;
import com.google.android.gms.ads.rewarded.RewardedAd;
import com.google.android.gms.ads.rewarded.RewardedAdCallback;
import com.google.android.gms.ads.rewarded.RewardedAdLoadCallback;

class FlutterRewardedAd extends FlutterAd.FlutterOverlayAd {
  private static final String TAG = "FlutterRewardedAd";

  @NonNull private final AdInstanceManager manager;
  @NonNull private final String adUnitId;
  @Nullable private final FlutterAdRequest request;
  @Nullable private final FlutterPublisherAdRequest publisherRequest;
  @Nullable private final FlutterServerSideVerificationOptions serverSideVerificationOptions;
  @Nullable RewardedAd rewardedAd;

  static class FlutterRewardItem {
    @NonNull final Integer amount;
    @NonNull final String type;

    FlutterRewardItem(@NonNull Integer amount, @NonNull String type) {
      this.amount = amount;
      this.type = type;
    }

    @Override
    public boolean equals(Object other) {
      if (this == other) {
        return true;
      } else if (!(other instanceof FlutterRewardItem)) {
        return false;
      }

      final FlutterRewardItem that = (FlutterRewardItem) other;
      if (!amount.equals(that.amount)) {
        return false;
      }
      return type.equals(that.type);
    }

    @Override
    public int hashCode() {
      int result = amount.hashCode();
      result = 31 * result + type.hashCode();
      return result;
    }
  }

  public FlutterRewardedAd(
      @NonNull AdInstanceManager manager,
      @NonNull String adUnitId,
      @NonNull FlutterAdRequest request,
      @Nullable FlutterServerSideVerificationOptions serverSideVerificationOptions) {
    this.manager = manager;
    this.adUnitId = adUnitId;
    this.request = request;
    this.publisherRequest = null;
    this.serverSideVerificationOptions = serverSideVerificationOptions;
  }

  public FlutterRewardedAd(
      @NonNull AdInstanceManager manager,
      @NonNull String adUnitId,
      @NonNull FlutterPublisherAdRequest publisherRequest,
    @Nullable FlutterServerSideVerificationOptions serverSideVerificationOptions) {
    this.manager = manager;
    this.adUnitId = adUnitId;
    this.publisherRequest = publisherRequest;
    this.request = null;
    this.serverSideVerificationOptions = serverSideVerificationOptions;
  }

  @Override
  void load() {
    rewardedAd = createRewardedAd();
    final RewardedAdLoadCallback adLoadCallback =
        new RewardedAdLoadCallback() {
          @Override
          public void onRewardedAdLoaded() {
            manager.onAdLoaded(FlutterRewardedAd.this);
          }

          @Override
          public void onRewardedAdFailedToLoad(LoadAdError loadAdError) {
            manager.onAdFailedToLoad(FlutterRewardedAd.this, new FlutterLoadAdError(loadAdError));
          }
        };

    if (request != null) {
      rewardedAd.loadAd(request.asAdRequest(), adLoadCallback);
    } else if (publisherRequest != null) {
      rewardedAd.loadAd(publisherRequest.asPublisherAdRequest(), adLoadCallback);
    } else {
      Log.e(TAG, "A null or invalid ad request was provided.");
    }
  }

  @Override
  public void show() {
    if (rewardedAd == null || !rewardedAd.isLoaded()) {
      Log.e(TAG, "The rewarded ad wasn't loaded yet.");
      return;
    }

    final RewardedAdCallback adCallback =
        new RewardedAdCallback() {
          @Override
          public void onRewardedAdOpened() {
            manager.onAdOpened(FlutterRewardedAd.this);
          }

          @Override
          public void onRewardedAdClosed() {
            manager.onAdClosed(FlutterRewardedAd.this);
          }

          @Override
          public void onUserEarnedReward(@NonNull RewardItem reward) {
            manager.onRewardedAdUserEarnedReward(
                FlutterRewardedAd.this,
                new FlutterRewardItem(reward.getAmount(), reward.getType()));
          }
        };
    rewardedAd.show(manager.activity, adCallback);
  }

  @NonNull
  @VisibleForTesting
  RewardedAd createRewardedAd() {
    RewardedAd rewardedAd = new RewardedAd(manager.activity, adUnitId);
    if (serverSideVerificationOptions != null) {
      rewardedAd.setServerSideVerificationOptions
        (serverSideVerificationOptions.asServerSideVerificationOptions());
    }
    return rewardedAd;
  }
}
