# interstitial_example

An example project that demonstrates loading and showing interstitial ads.

## Always test with test ads

When building and testing your apps, make sure you use test ads rather than
live, production ads. Failure to do so can lead to suspension of your account.

## Implementation

The main steps to integrate interstitial ads are:

1. Load an ad
2. Handle ad events
3. Display an ad


### Load an ad
The sample shows how to load an interstitial ad.

```
InterstitialAd.load(
  adUnitId: _adUnitId,
  request: AdRequest(),
  adLoadCallback: InterstitialAdLoadCallback(
    onAdLoaded: (InterstitialAd ad) {
      // Keep a reference to the ad so you can show it later.
      _interstitialAd = ad;
    },
    onAdFailedToLoad: (LoadAdError error) {
      print('InterstitialAd failed to load: $error');
    },
  ));
 ```

### Handle ad events
The sample shows how to handle interstitial ad events.

```
_interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
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

### Display an ad
The sample shows how to display an interstitial ad.
```
_interstitialAd?.show();
```
