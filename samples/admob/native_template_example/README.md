# native_template_example

An example project that demonstrates loading and showing native ads using native templates.

## Always test with test ads

When building and testing your apps, make sure you use test ads rather than
live, production ads. Failure to do so can lead to suspension of your account.

## Implementation

The main steps to integrate rewarded ads are:

1. Load an ad
2. Handle ad events
3. Display a native ad


### Load an ad
The sample shows how to load a native ad.

```
bool _nativeAdIsLoaded = false;

_nativeAd = NativeAd(
        adUnitId: _adUnitId,
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            print('$NativeAd loaded.');
            setState(() {
              _nativeAdIsLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            print('$NativeAd failedToLoad: $error');
          },
        ),
        request: const AdRequest(),
        nativeTemplateStyle: NativeTemplateStyle(
            templateType: TemplateType.medium,
            mainBackgroundColor: const Color(0xfffffbed),
            callToActionTextStyle: NativeTemplateTextStyle(
                textColor: Colors.white,
                style: NativeTemplateFontStyle.monospace,
                size: 16.0),
            primaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.black,
                style: NativeTemplateFontStyle.bold,
                size: 16.0),
            secondaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.black,
                style: NativeTemplateFontStyle.italic,
                size: 16.0),
            tertiaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.black,
                style: NativeTemplateFontStyle.normal,
                size: 16.0)))
      ..load();
 ```

### Handle ad events
The sample shows how to handle native ad events using the NativeAdListener.

```
_nativeAd = NativeAd(
        adUnitId: _adUnitId,
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            print('$NativeAd loaded.');
          },
          onAdFailedToLoad: (ad, error) {
            print('$NativeAd failedToLoad: $error');
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
          onPaidEvent: (ad, valueMicros, precision, currencyCode) {},**
        ),
 ...
```

### Display a native ad
The sample shows how to display a native ad.

```
if (_nativeAdIsLoaded && _nativeAd != null)
                        SizedBox(
                            height: MediaQuery.of(context).size.width *
                                _adAspectRatioMedium,
                            width: MediaQuery.of(context).size.width,
                            child: AdWidget(ad: _nativeAd!)),
```
