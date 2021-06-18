package io.flutter.plugins.googlemobileads.adcontainers;

import androidx.annotation.NonNull;

import com.google.android.gms.ads.OnUserEarnedRewardListener;
import com.google.android.gms.ads.rewarded.RewardItem;

public class OnUserEarnedRewardListenerProxy implements AdContainersChannelLibrary.$OnUserEarnedRewardListener {
  public final OnUserEarnedRewardListener onUserEarnedRewardListener;
  private final AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations;

  public OnUserEarnedRewardListenerProxy(final AdContainersChannelLibrary.$UserEarnedRewardCallback userEarnedRewardCallback, final AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations) {
    this(new OnUserEarnedRewardListener() {
      @Override
      public void onUserEarnedReward(@NonNull RewardItem rewardItem) {
        final RewardItemProxy rewardItemProxy = new RewardItemProxy(rewardItem, implementations);
        userEarnedRewardCallback.invoke(rewardItemProxy);
      }
    }, implementations);
  }

  public OnUserEarnedRewardListenerProxy(OnUserEarnedRewardListener onUserEarnedRewardListener, AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations) {
    this.onUserEarnedRewardListener = onUserEarnedRewardListener;
    this.implementations = implementations;
  }

  @Override
  protected void finalize() throws Throwable {
    implementations.getChannelOnUserEarnedRewardListener().disposeInstancePair(this);
    super.finalize();
  }
}
