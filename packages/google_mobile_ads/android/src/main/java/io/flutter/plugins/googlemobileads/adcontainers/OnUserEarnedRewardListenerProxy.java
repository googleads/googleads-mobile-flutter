package io.flutter.plugins.googlemobileads.adcontainers;

import androidx.annotation.NonNull;

import com.google.android.gms.ads.OnUserEarnedRewardListener;
import com.google.android.gms.ads.rewarded.RewardItem;

public class OnUserEarnedRewardListenerProxy implements OnUserEarnedRewardListener, AdContainersChannelLibrary.$OnUserEarnedRewardListener {
  public final AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations;

  public OnUserEarnedRewardListenerProxy(AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations) {
    this.implementations = implementations;
  }

  @Override
  public void onUserEarnedReward(@NonNull RewardItem rewardItem) {
    final RewardItemProxy rewardItemProxy = new RewardItemProxy(rewardItem, implementations);
    implementations.getChannelOnUserEarnedRewardListener().$onUserEarnedRewardCallback(this, rewardItemProxy);
  }
}
