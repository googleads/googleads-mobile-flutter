package io.flutter.plugins.googlemobileads.adcontainers;

import androidx.annotation.NonNull;

import com.google.android.gms.ads.LoadAdError;
import com.google.android.gms.ads.rewarded.RewardedAd;
import com.google.android.gms.ads.rewarded.RewardedAdLoadCallback;

public class RewardedAdLoadCallbackProxy extends RewardedAdLoadCallback implements AdContainersChannelLibrary.$RewardedAdLoadCallback {
  public final AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations;

  public RewardedAdLoadCallbackProxy(AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations) {
    this.implementations = implementations;
  }

  @Override
  public void onAdLoaded(@NonNull RewardedAd rewardedAd) {
    final RewardedAdProxy rewardedAdProxy = new RewardedAdProxy(rewardedAd, implementations);
    implementations.getChannelRewardedAdLoadCallback().$onAdLoaded(this, rewardedAdProxy);
  }

  @Override
  public void onAdFailedToLoad(@NonNull LoadAdError loadAdError) {
    final LoadAdErrorProxy loadAdErrorProxy = new LoadAdErrorProxy(loadAdError, implementations);
    implementations.getChannelRewardedAdLoadCallback().$onAdFailedToLoad(this, loadAdErrorProxy);
  }

  @Override
  protected void finalize() throws Throwable {
    implementations.getChannelRewardedAdLoadCallback().disposeInstancePair(this);
    super.finalize();
  }
}
