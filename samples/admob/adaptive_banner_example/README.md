# adaptive_banner_example

An example project that demonstrates loading and showing adaptive banner ads.

## Always test with test ads

When building and testing your apps, make sure you use test ads rather than
live, production ads. Failure to do so can lead to suspension of your account.

## Implementation

The main steps to integrate banner ads are:

1. Determine the ad width
2. Load an ad
3. Display an ad

### Determine the ad width
If you use a hardcoded width, you're done. To use our preferred [Adaptive Banner](https://developers.google.com/admob/flutter/banner/anchored-adaptive) format, the sample shows how to get the size of the window containing your app to determine the ad width.

```
final size = await AdSize.
    getCurrentOrientationAnchoredAdaptiveBannerAdSize(
        MediaQuery.of(context).size.width.truncate());
```


### Load an ad
The sample shows how to load an adaptive banner ad.

```
BannerAd(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      size: size,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
            _isLoaded = true;
          });
        },
        ...
      ),
    ).load();
 ```

 ### Display an ad
 The sample shows how to display a banner ad.

 ```
Widget build(BuildContext context) {
  return MaterialApp(
    ...
      body: Stack(
        children: [
          if (_bannerAd != null && _isLoaded)
            Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                child: SizedBox(
                width: _bannerAd!.size.width.toDouble(),
                height: _bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!),
                ),
              ),
            )
        ],
      )
    ),
  );
}
 ```
