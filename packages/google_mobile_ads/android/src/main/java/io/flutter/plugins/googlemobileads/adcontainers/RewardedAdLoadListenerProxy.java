package io.flutter.plugins.googlemobileads.adcontainers;

import androidx.annotation.NonNull;

import com.google.android.gms.ads.LoadAdError;
import com.google.android.gms.ads.rewarded.RewardedAd;
import com.google.android.gms.ads.rewarded.RewardedAdLoadCallback;

public class RewardedAdLoadListenerProxy implements AdContainersChannelLibrary.$RewardedAdLoadListener {
  public final RewardedAdLoadCallback rewardedAdLoadCallback;
  private final AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations;

  public RewardedAdLoadListenerProxy(final AdContainersChannelLibrary.$RewardedAdLoadCallback onAdLoaded,
                                     final AdContainersChannelLibrary.$LoadFailCallback onAdFailedToLoad,
                                     final AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations) {
    this(new RewardedAdLoadCallback() {
      @Override
      public void onAdLoaded(@NonNull RewardedAd rewardedAd) {
        final RewardedAdProxy rewardedAdProxy = new RewardedAdProxy(rewardedAd, implementations);
        onAdLoaded.invoke(rewardedAdProxy);
      }

      @Override
      public void onAdFailedToLoad(@NonNull LoadAdError loadAdError) {
        if (onAdFailedToLoad == null) return;
        final LoadAdErrorProxy loadAdErrorProxy = new LoadAdErrorProxy(loadAdError, implementations);
        onAdFailedToLoad.invoke(loadAdErrorProxy);
      }
    }, implementations);
  }

  public RewardedAdLoadListenerProxy(RewardedAdLoadCallback rewardedAdLoadCallback, AdContainersChannelRegistrar.AdContainersLibraryImplementations implementations) {
    this.rewardedAdLoadCallback = rewardedAdLoadCallback;
    this.implementations = implementations;
  }

  @Override
  protected void finalize() throws Throwable {
    implementations.getChannelRewardedAdLoadListener().disposeInstancePair(this);
    super.finalize();
  }
}
