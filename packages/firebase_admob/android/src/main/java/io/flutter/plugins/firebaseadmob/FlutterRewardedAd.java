package io.flutter.plugins.firebaseadmob;

import android.util.Log;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.google.android.gms.ads.rewarded.RewardItem;
import com.google.android.gms.ads.rewarded.RewardedAd;
import com.google.android.gms.ads.rewarded.RewardedAdCallback;
import com.google.android.gms.ads.rewarded.RewardedAdLoadCallback;

class FlutterRewardedAd extends FlutterAd implements FlutterAd.FlutterAdWithoutView {
  private static final String TAG = "FlutterRewardedAd";

  static class FlutterRewardItem {
    @NonNull final Integer amount;
    @NonNull final String type;

    FlutterRewardItem(@NonNull Integer amount, @NonNull String type) {
      this.amount = amount;
      this.type = type;
    }

    @Override
    public boolean equals(Object other) {
      if (this == other) return true;
      if (!(other instanceof FlutterRewardItem)) return false;

      final FlutterRewardItem that = (FlutterRewardItem) other;

      if (!amount.equals(that.amount)) return false;
      return type.equals(that.type);
    }

    @Override
    public int hashCode() {
      int result = amount.hashCode();
      result = 31 * result + type.hashCode();
      return result;
    }
  }

  @Nullable RewardedAd rewardedAd;

  public FlutterRewardedAd(AdInstanceManager manager, String adUnitId, FlutterAdRequest request) {
    super(manager, adUnitId, request);
  }

  @Override
  void load() {
    rewardedAd = new RewardedAd(manager.activity, adUnitId);
    final RewardedAdLoadCallback adLoadCallback =
        new RewardedAdLoadCallback() {
          @Override
          public void onRewardedAdLoaded() {
            manager.onAdLoaded(FlutterRewardedAd.this);
          }

          @Override
          public void onRewardedAdFailedToLoad(int errorCode) {
            manager.onAdFailedToLoad(FlutterRewardedAd.this);
          }
        };
    rewardedAd.loadAd(request.asAdRequest(), adLoadCallback);
  }

  @Override
  public void show() {
    if (!rewardedAd.isLoaded()) {
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
}
