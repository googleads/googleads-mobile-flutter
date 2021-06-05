package io.flutter.plugins.googlemobileads.adcontainers;

import com.google.android.gms.ads.rewarded.RewardItem;

public class RewardItemProxy implements AdContainersChannelLibrary.$RewardItem {
  public final RewardItem rewardItem;

  public RewardItemProxy(RewardItem rewardItem, AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations) {
    this.rewardItem = rewardItem;
    implementations.getChannelRewardItem().$$create(this, false, rewardItem.getAmount(), rewardItem.getType());
  }
}
