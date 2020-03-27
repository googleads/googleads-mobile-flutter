// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "FLTMobileAd.h"
#import "FLTFirebaseAdMobPlugin.h"
#import "FLTRequestFactory.h"

static NSMutableDictionary *allAds = nil;
static NSDictionary *statusToString = nil;

@implementation FLTFirebaseAdmobViewFactory
- (nonnull NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame
                                            viewIdentifier:(int64_t)viewId
                                                 arguments:(id _Nullable)args {
  NSNumber *adId = args;
  FLTMobileAdWithView *view = allAds[adId];

  if (!view) {
    NSString *reason = [NSString
        stringWithFormat:@"Could not find an ad with id: %@. Was this ad already disposed?", adId];
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:reason userInfo:nil];
  }

  [view setFrameForPlatformView:frame];
  return view;
}

- (NSObject<FlutterMessageCodec> *)createArgsCodec {
  return [FlutterStandardMessageCodec sharedInstance];
}
@end

@implementation FLTMobileAd
NSNumber *_mobileAdId;
FlutterMethodChannel *_channel;
FLTMobileAdStatus _status;
double _anchorOffset;
double _horizontalCenterOffset;
int _anchorType;

+ (void)initialize {
  if (allAds == nil) {
    allAds = [[NSMutableDictionary alloc] init];
  }
  _anchorType = 0;
  _anchorOffset = 0;
  _horizontalCenterOffset = 0;

  if (statusToString == nil) {
    statusToString = @{
      @(CREATED) : @"CREATED",
      @(LOADING) : @"LOADING",
      @(FAILED) : @"FAILED",
      @(PENDING) : @"PENDING",
      @(LOADED) : @"LOADED"
    };
  }
}

+ (void)configureWithAppId:(NSString *)appId {
  [GADMobileAds configureWithApplicationID:appId];
}

+ (FLTMobileAd *)getAdForId:(NSNumber *)mobileAdId {
  return allAds[mobileAdId];
}

+ (UIViewController *)rootViewController {
  return [UIApplication sharedApplication].delegate.window.rootViewController;
}

- (instancetype)initWithId:(NSNumber *)mobileAdId channel:(FlutterMethodChannel *)channel {
  self = [super init];
  if (self) {
    _mobileAdId = mobileAdId;
    _channel = channel;
    _status = CREATED;
    _anchorOffset = 0;
    _horizontalCenterOffset = 0;
    _anchorType = 0;
    allAds[mobileAdId] = self;
  }
  return self;
}

- (FLTMobileAdStatus)status {
  return _status;
}

- (void)loadWithAdUnitId:(NSString *)adUnitId targetingInfo:(NSDictionary *)targetingInfo {
  // Implemented by the Banner and Interstitial subclasses
}

- (void)showAtOffset:(double)anchorOffset
       hCenterOffset:(double)horizontalCenterOffset
          fromAnchor:(int)anchorType {
  _anchorType = anchorType;
  _anchorOffset = anchorOffset;
  if (_anchorType == 0) {
    _anchorOffset = -_anchorOffset;
  }
  _horizontalCenterOffset = horizontalCenterOffset;
  [self show];
}

- (void)show {
  // Implemented by the FLTMobileAdWithView and Interstitial subclasses
}

- (void)dispose {
  [allAds removeObjectForKey:_mobileAdId];
}

- (NSDictionary *)argumentsMap {
  return @{@"id" : _mobileAdId};
}

- (NSString *)description {
  NSString *statusString = (NSString *)statusToString[[NSNumber numberWithInt:_status]];
  return [NSString
      stringWithFormat:@"%@ %@ mobileAdId:%@", super.description, statusString, _mobileAdId];
}
@end

@implementation FLTMobileAdWithView
- (void)show {
  if (_status == LOADING) {
    _status = PENDING;
    return;
  }

  if (_status != LOADED) return;

  UIView *screen = [FLTMobileAd rootViewController].view;
  [screen addSubview:self.view];

// UIView.safeAreaLayoutGuide is only available on iOS 11.0+
#if defined(__IPHONE_11_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0)
  if (@available(ios 11.0, *)) {
    self.view.translatesAutoresizingMaskIntoConstraints = NO;

    UILayoutGuide *guide = screen.safeAreaLayoutGuide;
    [NSLayoutConstraint activateConstraints:@[
      [self.view.centerXAnchor constraintEqualToAnchor:guide.centerXAnchor
                                              constant:_horizontalCenterOffset],

      [self.view.leftAnchor constraintGreaterThanOrEqualToAnchor:guide.leftAnchor],
      [self.view.rightAnchor constraintLessThanOrEqualToAnchor:guide.rightAnchor],
    ]];

    if (_anchorType == 0) {
      [NSLayoutConstraint activateConstraints:@[
        [self.view.bottomAnchor constraintEqualToAnchor:guide.bottomAnchor constant:_anchorOffset],
      ]];
    } else {
      [NSLayoutConstraint activateConstraints:@[
        [self.view.topAnchor constraintEqualToAnchor:guide.topAnchor constant:_anchorOffset],
      ]];
    }
  }
#endif

  // We find the left most point that aligns the view to the horizontal center.
  CGFloat x =
      screen.frame.size.width / 2 - self.view.frame.size.width / 2 + _horizontalCenterOffset;
  // We find the top point that anchors the view to the top/bottom depending on anchorType.
  CGFloat y;
  if (_anchorType == 0) {
    y = screen.frame.size.height - self.view.frame.size.height + _anchorOffset;
  } else {
    y = _anchorOffset;
  }
  self.view.frame = (CGRect){{x, self.view.frame.origin.y}, self.view.frame.size};
}

- (void)dispose {
  if (self.view.superview) [self.view removeFromSuperview];
  [super dispose];
}

- (NSString *)description {
  return [NSString stringWithFormat:@"%@ for: %@", super.description, self.view];
}

// To be overriden by subclasses.
- (void)setFrameForPlatformView:(CGRect)frame {
  // Do nothing
}

// To be overriden by subclasses.
- (UIView *)view {
  return nil;
}
@end

@implementation FLTBannerAd
GADBannerView *_banner;
GADAdSize _adSize;

+ (instancetype)withId:(NSNumber *)mobileAdId
                adSize:(GADAdSize)adSize
               channel:(FlutterMethodChannel *)channel {
  FLTMobileAd *ad = [FLTMobileAd getAdForId:mobileAdId];
  return ad != nil ? (FLTBannerAd *)ad
                   : [[FLTBannerAd alloc] initWithId:mobileAdId adSize:adSize channel:channel];
}

- (instancetype)initWithId:mobileAdId
                    adSize:(GADAdSize)adSize
                   channel:(FlutterMethodChannel *)channel {
  self = [super initWithId:mobileAdId channel:channel];
  if (self) {
    _adSize = adSize;
    return self;
  }

  return nil;
}

- (UIView *)view {
  return _banner;
}

- (void)loadWithAdUnitId:(NSString *)adUnitId targetingInfo:(NSDictionary *)targetingInfo {
  if (_status != CREATED) return;
  _status = LOADING;
  _banner = [[GADBannerView alloc] initWithAdSize:_adSize];
  _banner.delegate = self;
  _banner.adUnitID = adUnitId;
  _banner.rootViewController = [FLTMobileAd rootViewController];
  FLTRequestFactory *factory = [[FLTRequestFactory alloc] initWithTargetingInfo:targetingInfo];
  [_banner loadRequest:[factory createRequest]];
}

- (void)adView:(GADBannerView *)adView didFailToReceiveAdWithError:(GADRequestError *)error {
  FLTLogWarning(@"adView:didFailToReceiveAdWithError: %@ (MobileAd %@)",
                [error localizedDescription], self);
  [_channel invokeMethod:@"onAdFailedToLoad" arguments:[self argumentsMap]];
}

- (void)adViewWillPresentScreen:(GADBannerView *)adView {
  [_channel invokeMethod:@"onAdClicked" arguments:[self argumentsMap]];
}

- (void)adViewWillDismissScreen:(GADBannerView *)adView {
  [_channel invokeMethod:@"onAdImpression" arguments:[self argumentsMap]];
}

- (void)adViewDidDismissScreen:(GADBannerView *)adView {
  [_channel invokeMethod:@"onAdClosed" arguments:[self argumentsMap]];
}

- (void)adViewWillLeaveApplication:(GADBannerView *)adView {
  [_channel invokeMethod:@"onAdLeftApplication" arguments:[self argumentsMap]];
}

- (void)adViewDidReceiveAd:(GADBannerView *)adView {
  bool statusWasPending = _status == PENDING;
  _status = LOADED;
  [_channel invokeMethod:@"onAdLoaded" arguments:[self argumentsMap]];
  if (statusWasPending) [self show];
}
@end

@implementation FLTInterstitialAd
GADInterstitial *_interstitial;

+ (instancetype)withId:(NSNumber *)mobileAdId channel:(FlutterMethodChannel *)channel {
  FLTMobileAd *ad = [FLTMobileAd getAdForId:mobileAdId];
  return ad != nil ? (FLTInterstitialAd *)ad
                   : [[FLTInterstitialAd alloc] initWithId:mobileAdId channel:channel];
}

- (void)loadWithAdUnitId:(NSString *)adUnitId targetingInfo:(NSDictionary *)targetingInfo {
  if (_status != CREATED) return;
  _status = LOADING;

  _interstitial = [[GADInterstitial alloc] initWithAdUnitID:adUnitId];
  _interstitial.delegate = self;
  FLTRequestFactory *factory = [[FLTRequestFactory alloc] initWithTargetingInfo:targetingInfo];
  [_interstitial loadRequest:[factory createRequest]];
}

- (void)show {
  if (_status == LOADING) {
    _status = PENDING;
    return;
  }
  if (_status != LOADED) return;

  [_interstitial presentFromRootViewController:[FLTMobileAd rootViewController]];
}

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
  bool statusWasPending = _status == PENDING;
  _status = LOADED;
  [_channel invokeMethod:@"onAdLoaded" arguments:[self argumentsMap]];
  if (statusWasPending) [self show];
}

- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error {
  FLTLogWarning(@"interstitial:didFailToReceiveAdWithError: %@ (MobileAd %@)",
                [error localizedDescription], self);
  [_channel invokeMethod:@"onAdFailedToLoad" arguments:[self argumentsMap]];
}

- (void)interstitialWillPresentScreen:(GADInterstitial *)ad {
  [_channel invokeMethod:@"onAdClicked" arguments:[self argumentsMap]];
}

- (void)interstitialWillDismissScreen:(GADInterstitial *)ad {
  [_channel invokeMethod:@"onAdImpression" arguments:[self argumentsMap]];
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
  [_channel invokeMethod:@"onAdClosed" arguments:[self argumentsMap]];
}

- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad {
  [_channel invokeMethod:@"onAdLeftApplication" arguments:[self argumentsMap]];
}

- (void)dispose {
  // It is not possible to hide/remove/destroy an AdMob interstitial Ad.
  _interstitial = nil;
  [super dispose];
}

- (NSString *)description {
  return [NSString stringWithFormat:@"%@ for: %@", super.description, _interstitial];
}
@end

@implementation FLTNativeAd {
  GADAdLoader *_adLoader;
  GADUnifiedNativeAdView *_nativeAd;
  id<FLTNativeAdFactory> _nativeAdFactory;
  NSDictionary *_customOptions;
  UIView *_containerView;
  BOOL _showAsPlatformView;
}

+ (instancetype)withId:(NSNumber *)mobileAdId
               channel:(FlutterMethodChannel *)channel
       nativeAdFactory:(id<FLTNativeAdFactory>)nativeAdFactory
         customOptions:(NSDictionary *)customOptions {
  FLTMobileAd *ad = [FLTMobileAd getAdForId:mobileAdId];
  return ad != nil ? (FLTNativeAd *)ad
                   : [[FLTNativeAd alloc] initWithId:mobileAdId
                                             channel:channel
                                     nativeAdFactory:nativeAdFactory
                                       customOptions:customOptions];
}

- (instancetype)initWithId:mobileAdId
                   channel:(FlutterMethodChannel *)channel
           nativeAdFactory:(id<FLTNativeAdFactory>)nativeAdFactory
             customOptions:(NSDictionary *)customOptions {
  self = [super initWithId:mobileAdId channel:channel];
  if (self) {
    _nativeAdFactory = nativeAdFactory;
    _customOptions = customOptions;
    _containerView = [[UIView alloc] init];
    _showAsPlatformView = NO;
  }
  return self;
}

- (UIView *)view {
  _showAsPlatformView = YES;
  return _containerView;
}

- (void)setFrameForPlatformView:(CGRect)frame {
  _containerView.frame = frame;
  for (UIView *view in _containerView.subviews) {
    view.frame = _containerView.frame;
  }
}

- (void)loadWithAdUnitId:(NSString *)adUnitId targetingInfo:(NSDictionary *)targetingInfo {
  if (_status != CREATED) return;
  _status = LOADING;

  _adLoader = [[GADAdLoader alloc] initWithAdUnitID:adUnitId
                                 rootViewController:[FLTMobileAd rootViewController]
                                            adTypes:@[ kGADAdLoaderAdTypeUnifiedNative ]
                                            options:@[]];
  _adLoader.delegate = self;

  FLTRequestFactory *factory = [[FLTRequestFactory alloc] initWithTargetingInfo:targetingInfo];
  [_adLoader loadRequest:[factory createRequest]];
}

- (void)adLoader:(nonnull GADAdLoader *)adLoader
    didFailToReceiveAdWithError:(nonnull GADRequestError *)error {
  FLTLogWarning(@"adLoader:didFailToReceiveAdWithError: %@ (MobileAd %@)",
                [error localizedDescription], self);
  [_channel invokeMethod:@"onAdFailedToLoad" arguments:[self argumentsMap]];
}

- (void)adLoader:(nonnull GADAdLoader *)adLoader
    didReceiveUnifiedNativeAd:(nonnull GADUnifiedNativeAd *)nativeAd {
  nativeAd.delegate = self;
  _nativeAd = [_nativeAdFactory createNativeAd:nativeAd customOptions:_customOptions];

  if (!_showAsPlatformView) {
    _containerView.frame = _nativeAd.frame;
  }

  _nativeAd.frame = _containerView.frame;
  [_containerView addSubview:_nativeAd];

  bool statusWasPending = _status == PENDING;
  _status = LOADED;
  [_channel invokeMethod:@"onAdLoaded" arguments:[self argumentsMap]];
  if (statusWasPending) [self show];
}

- (void)nativeAdWillPresentScreen:(GADUnifiedNativeAd *)nativeAd {
  [_channel invokeMethod:@"onAdClicked" arguments:[self argumentsMap]];
}

- (void)nativeAdWillDismissScreen:(GADUnifiedNativeAd *)nativeAd {
  [_channel invokeMethod:@"onAdImpression" arguments:[self argumentsMap]];
}

- (void)nativeAdDidDismissScreen:(GADUnifiedNativeAd *)nativeAd {
  [_channel invokeMethod:@"onAdClosed" arguments:[self argumentsMap]];
}

- (void)nativeAdWillLeaveApplication:(GADUnifiedNativeAd *)nativeAd {
  [_channel invokeMethod:@"onAdLeftApplication" arguments:[self argumentsMap]];
}
@end
