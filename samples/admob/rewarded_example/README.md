# rewarded_example

An example project that demonstrates loading and showing rewarded ads.

## Always test with test ads

When building and testing your apps, make sure you use test ads rather than
live, production ads. Failure to do so can lead to suspension of your account.

## Implementation

The main steps to integrate rewarded ads are:

1. Load an ad
2. Handle ad events
3. Display an ad and handle the reward


### Load an ad
The sample shows how to load a rewarded ad.

```
RewardedAd.load(
  adUnitId: _adUnitId,
  request: const AdRequest(),
  adLoadCallback: RewardedAdLoadCallback(
    onAdLoaded: (RewardedAd ad) {
      // Keep a reference to the ad so you can show it later.
      _rewardedAd = ad;
    },
    onAdFailedToLoad: (LoadAdError error) {
      print('RewardedAd failed to load: $error');
    },
  ));
 ```

### Handle ad events
The sample shows how to handle rewarded ad events.

```
_rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
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

### Display an ad and handle the reward
The sample shows how to display a rewarded ad and handle the reward.
```
_rewardedAd?.show(onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
  print('Reward amount: ${rewardItem.amount}');
});
```
