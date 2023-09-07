# rewarded_interstitial_example

An example project that demonstrates loading and showing rewarded interstitial ads.

## Always test with test ads

When building and testing your apps, make sure you use test ads rather than
live, production ads. Failure to do so can lead to suspension of your account.

## Implementation

The main steps to integrate rewarded ads are:

1. Load an ad
2. Handle ad events
3. Present an into screen
4. Display an ad and handle the reward


### Load an ad
The sample shows how to load a rewarded ad.

```
RewardedInterstitialAd.load(
  adUnitId: _adUnitId,
  request: const AdRequest(),
  adLoadCallback: RewardedInterstitialAdLoadCallback(
    onAdLoaded: (RewardedInterstitialAd ad) {
      // Keep a reference to the ad so you can show it later.
      _rewardedInterstitialAd = ad;
    },
    onAdFailedToLoad: (LoadAdError error) {
      print('RewardedInterstitialAd failed to load: $error');
    },
  ));
 ```

### Handle ad events
The sample shows how to handle rewarded ad events.

```
_rewardedInterstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
    // Called when the ad showed the full screen content.
    onAdShowedFullScreenContent: (ad) {},
    // Called when an impression occurs on the ad.
    onAdImpression: (ad) {},
    // Called when the ad failed to show full screen content.
    onAdFailedToShowFullScreenContent: (ad, err) {},
    // Called when the ad dismissed full screen content.
    onAdDismissedFullScreenContent: (ad) {
      ad.dispose();
    },
    // Called when a click is recorded for an ad.
    onAdClicked: (ad) {});
```

### Present an intro screen
Before displaying a rewarded interstitial ad to users, you must present the user with an intro screen that provides clear reward messaging and an option to skip the ad before it starts.

### Display an ad and handle the reward
The sample shows how to display a rewarded ad and handle the reward.
```
_rewardedInterstitialAd?.show(onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
  print('Reward amount: ${rewardItem.amount}');
});
```
