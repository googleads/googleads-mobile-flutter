package io.flutter.plugins.googlemobileads.adcontainers;

import com.google.android.gms.ads.rewarded.RewardedAd;

public class RewardedAdProxy implements AdContainersChannelLibrary.$RewardedAd {
  public final RewardedAd rewardedAd;
  public final AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations;

  public static void load(String adUnitId, AdRequestProxy request, RewardedAdLoadCallbackProxy adLoadCallback, AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations) {
    RewardedAd.load(implementations.activity, adUnitId, request.adRequest.build(), adLoadCallback);
  }

  public RewardedAdProxy(RewardedAd rewardedAd, AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations) {
    this.rewardedAd = rewardedAd;
    this.implementations = implementations;
  }

  @Override
  public Void show(AdContainersChannelLibrary.$OnUserEarnedRewardListener onUserEarnedReward, AdContainersChannelLibrary.$ServerSideVerificationOptions serverSideVerificationOptions, AdContainersChannelLibrary.$FullScreenContentCallback fullScreenContentCallback) {
    if (fullScreenContentCallback != null) {
      rewardedAd.setFullScreenContentCallback((FullScreenContentCallbackProxy) fullScreenContentCallback);
    }
    if (serverSideVerificationOptions != null) {
      rewardedAd.setServerSideVerificationOptions(((ServerSideVerificationOptionsProxy) serverSideVerificationOptions).serverSideVerificationOptions.build());
    }
    rewardedAd.show(implementations.activity, (OnUserEarnedRewardListenerProxy) onUserEarnedReward);
    return null;
  }
}
