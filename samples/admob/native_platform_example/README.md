# native_template_example

An example project that demonstrates loading and showing native ads using platform-specific code.

## Always test with test ads

When building and testing your apps, make sure you use test ads rather than
live, production ads. Failure to do so can lead to suspension of your account.

## Implementation

The main steps to integrate rewarded ads are:

1. Register your platform-specific code
2. Load an ad
3. Handle ad events
4. Display a native ad


### Register your platform-specifc code
Native ads are presented to users through UI components that are native to the platform (for example, a View on Android or a UIView on iOS). In the native layer is you implement the NativeAdFactory protocol to create your native ad views. Each NativeAdFactory needs to be registered with a factoryId (which must match the factoryId in the load request. 

### Load an ad
The sample shows how to load a native ad.

```
bool _nativeAdIsLoaded = false;

  _nativeAd = NativeAd(
        adUnitId: _adUnitId,
        factoryId: "adFactoryExample",
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            // ignore: avoid_print
            print('$NativeAd loaded.');
            setState(() {
              _nativeAdIsLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            // ignore: avoid_print
            print('$NativeAd failedToLoad: $error');
            ad.dispose();
          },
        ),
        request: const AdRequest(),
    )..load();
 ```

### Handle ad events
The sample shows how to handle native ad events using the NativeAdListener.

```
bool _nativeAdIsLoaded = false;

  _nativeAd = NativeAd(
        adUnitId: _adUnitId,
        factoryId: "adFactoryExample",
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            // ignore: avoid_print
            print('$NativeAd loaded.');
            setState(() {
              _nativeAdIsLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            // ignore: avoid_print
            print('$NativeAd failedToLoad: $error');
            ad.dispose();
          },
          // Called when a click is recorded for a NativeAd.
          onAdClicked: (ad) {},
          // Called when an impression occurs on the ad.
          onAdImpression: (ad) {},
          // Called when an ad removes an overlay that covers the screen.
          onAdClosed: (ad) {},
          // Called when an ad opens an overlay that covers the screen.
          onAdOpened: (ad) {},
          // For iOS only. Called before dismissing a full screen view
          onAdWillDismissScreen: (ad) {},
          // Called when an ad receives revenue value.
          onPaidEvent: (ad, valueMicros, precision, currencyCode) {},
        ),
        request: const AdRequest(),
    )..load();
 ```

### Display a native ad
The sample shows how to display a native ad.

```
if (_nativeAdIsLoaded && _nativeAd != null)
                    SizedBox(
                        height: HEIGHT,
                        width: MediaQuery.of(context).size.width,
                        child: AdWidget(ad: _nativeAd!)),
```
