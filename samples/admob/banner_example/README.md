# banner_example

An example project that demonstrates loading and showing banner ads.

## Always test with test ads

When building and testing your apps, make sure you use test ads rather than
live, production ads. Failure to do so can lead to suspension of your account.

## Implementation

The main steps to integrate banner ads are:

1. Load an ad
2. Display an ad

### Load an ad
The sample shows how to load a banner ad.

```
BannerAd(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      size: AdSize.Banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
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
          if (_bannerAd != null)
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
