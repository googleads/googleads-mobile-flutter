package io.flutter.plugins.googlemobileads.adcontainers;

import com.google.android.gms.ads.rewarded.RewardedAd;

public class RewardedAdProxy implements AdContainersChannelLibrary.$RewardedAd {
  public final RewardedAd rewardedAd;
  private final AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations;

  public static void load(String adUnitId, AdRequestProxy request, RewardedAdLoadListenerProxy adLoadCallback, AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations) {
    RewardedAd.load(implementations.activity, adUnitId, request.adRequest.build(), adLoadCallback.rewardedAdLoadCallback);
  }

  public RewardedAdProxy(RewardedAd rewardedAd, AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations) {
    this.rewardedAd = rewardedAd;
    this.implementations = implementations;
    implementations.getChannelRewardedAd().$$create(this, false);
  }

  @Override
  public Void show(AdContainersChannelLibrary.$OnUserEarnedRewardListener onUserEarnedReward,
                   AdContainersChannelLibrary.$ServerSideVerificationOptions serverSideVerificationOptions,
                   AdContainersChannelLibrary.$FullScreenContentListener fullScreenContentListener) {
    if (fullScreenContentListener != null) {
      rewardedAd.setFullScreenContentCallback(((FullScreenContentListenerProxy) fullScreenContentListener).fullScreenContentCallback);
    }
    if (serverSideVerificationOptions != null) {
      rewardedAd.setServerSideVerificationOptions(((ServerSideVerificationOptionsProxy) serverSideVerificationOptions).serverSideVerificationOptions.build());
    }
    rewardedAd.show(implementations.activity,
        ((OnUserEarnedRewardListenerProxy) onUserEarnedReward).onUserEarnedRewardListener);
    return null;
  }
}
