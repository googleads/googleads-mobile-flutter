// Copyright 2021 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "FLTAd_Internal.h"
#import "FLTConstants.h"

@implementation FLTAdSize
- (instancetype _Nonnull)initWithWidth:(NSNumber *_Nonnull)width height:(NSNumber *_Nonnull)height {
  return
      [self initWithAdSize:GADAdSizeFromCGSize(CGSizeMake(width.doubleValue, height.doubleValue))];
}

- (instancetype _Nonnull)initWithAdSize:(GADAdSize)size {
  self = [super init];
  if (self) {
    _size = size;
    _width = @(size.size.width);
    _height = @(size.size.height);
  }
  return self;
}
@end

@implementation FLTAdSizeFactory
- (GADAdSize)portraitAnchoredAdaptiveBannerAdSizeWithWidth:(NSNumber *_Nonnull)width {
  return GADPortraitAnchoredAdaptiveBannerAdSizeWithWidth(width.doubleValue);
}

- (GADAdSize)landscapeAnchoredAdaptiveBannerAdSizeWithWidth:(NSNumber *_Nonnull)width {
  return GADLandscapeAnchoredAdaptiveBannerAdSizeWithWidth(width.doubleValue);
}
@end

@implementation FLTAnchoredAdaptiveBannerSize
- (instancetype _Nonnull)initWithFactory:(FLTAdSizeFactory *_Nonnull)factory
                             orientation:(NSString *_Nonnull)orientation
                                   width:(NSNumber *_Nonnull)width {
  GADAdSize size;
  if ([orientation isEqualToString:@"portrait"]) {
    size = [factory portraitAnchoredAdaptiveBannerAdSizeWithWidth:width];
  } else if ([orientation isEqualToString:@"landscape"]) {
    size = [factory landscapeAnchoredAdaptiveBannerAdSizeWithWidth:width];
  } else {
    NSLog(@"AdaptiveBanner orientation should be 'portrait' or 'landscape': %@", orientation);
    return nil;
  }

  self = [self initWithAdSize:size];
  if (self) {
    _orientation = orientation;
  }
  return self;
}
@end

@implementation FLTSmartBannerSize
- (instancetype _Nonnull)initWithOrientation:(NSString *_Nonnull)orientation {
  GADAdSize size;
  if ([orientation isEqualToString:@"portrait"]) {
    size = kGADAdSizeSmartBannerPortrait;
  } else if ([orientation isEqualToString:@"landscape"]) {
    size = kGADAdSizeSmartBannerLandscape;
  } else {
    NSLog(@"SmartBanner orientation should be 'portrait' or 'landscape': %@", orientation);
    return nil;
  }

  self = [self initWithAdSize:size];
  if (self) {
    _orientation = orientation;
  }
  return self;
}
@end

@implementation FLTAdRequest
- (GADRequest *_Nonnull)asGADRequest {
  GADRequest *request = [GADRequest request];
  request.keywords = _keywords;
  request.contentURL = _contentURL;
  if (_nonPersonalizedAds) {
    GADExtras *extras = [[GADExtras alloc] init];
    extras.additionalParameters = @{@"npa" : @"1"};
    [request registerAdNetworkExtras:extras];
  }

  request.requestAgent = FLT_REQUEST_AGENT_VERSIONED;
  return request;
}
@end

@implementation FLTGADResponseInfo

- (instancetype _Nonnull)initWithResponseInfo:(GADResponseInfo *_Nonnull)responseInfo {
  self = [super init];
  if (self) {
    _responseIdentifier = responseInfo.responseIdentifier;
    _adNetworkClassName = responseInfo.adNetworkClassName;
    NSMutableArray<FLTGADAdNetworkResponseInfo *> *infoArray = [[NSMutableArray alloc] init];
    for (GADAdNetworkResponseInfo *adNetworkInfo in responseInfo.adNetworkInfoArray) {
      [infoArray
          addObject:[[FLTGADAdNetworkResponseInfo alloc] initWithResponseInfo:adNetworkInfo]];
    }
    _adNetworkInfoArray = infoArray;
  }
  return self;
}
@end

@implementation FLTGADAdNetworkResponseInfo

- (instancetype _Nonnull)initWithResponseInfo:(GADAdNetworkResponseInfo *_Nonnull)responseInfo {
  self = [super init];
  if (self) {
    _adNetworkClassName = responseInfo.adNetworkClassName;
    NSNumber *timeInMillis = [[NSNumber alloc] initWithDouble:responseInfo.latency * 1000];
    _latency = @(timeInMillis.longValue);
    _dictionaryDescription = responseInfo.dictionaryRepresentation.description;
    _credentialsDescription = responseInfo.credentials.description;
    _error = responseInfo.error;
  }
  return self;
}
@end

@implementation FLTLoadAdError

- (instancetype _Nonnull)initWithError:(NSError *_Nonnull)error {
  self = [super init];
  if (self) {
    _code = error.code;
    _domain = error.domain;
    _message = error.localizedDescription;
    GADResponseInfo *responseInfo = error.userInfo[GADErrorUserInfoKeyResponseInfo];
    if (responseInfo) {
      _responseInfo = [[FLTGADResponseInfo alloc] initWithResponseInfo:responseInfo];
    }
  }
  return self;
}
@end

@implementation FLTGAMAdRequest
- (GADRequest *_Nonnull)asGAMRequest {
  GAMRequest *request = [GAMRequest request];
  request.keywords = self.keywords;
  request.contentURL = self.contentURL;

  NSMutableDictionary<NSString *, id> *targetingDictionary =
      [NSMutableDictionary dictionaryWithDictionary:self.customTargeting];
  [targetingDictionary addEntriesFromDictionary:self.customTargetingLists];
  request.customTargeting = targetingDictionary;

  if (self.nonPersonalizedAds) {
    GADExtras *extras = [[GADExtras alloc] init];
    extras.additionalParameters = @{@"npa" : @"1"};
    [request registerAdNetworkExtras:extras];
  }

  request.requestAgent = FLT_REQUEST_AGENT_VERSIONED;
  return request;
}
@end

@implementation FLTBannerAd {
  GADBannerView *_bannerView;
  FLTAdRequest *_adRequest;
}

- (instancetype)initWithAdUnitId:(NSString *_Nonnull)adUnitId
                            size:(FLTAdSize *_Nonnull)size
                         request:(FLTAdRequest *_Nonnull)request
              rootViewController:(UIViewController *_Nonnull)rootViewController {
  self = [super init];
  if (self) {
    _adRequest = request;
    _bannerView = [[GADBannerView alloc] initWithAdSize:size.size];
    _bannerView.adUnitID = adUnitId;
    self.bannerView.rootViewController = rootViewController;
  }
  return self;
}

- (GADBannerView *_Nonnull)bannerView {
  return _bannerView;
}

- (void)load {
  self.bannerView.delegate = self;
  [self.bannerView loadRequest:_adRequest.asGADRequest];
}

#pragma mark - GADBannerViewDelegate

- (void)bannerViewDidReceiveAd:(GADBannerView *)bannerView {
  [_manager onAdLoaded:self responseInfo:bannerView.responseInfo];
}

- (void)bannerView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(NSError *)error {
  [_manager onAdFailedToLoad:self error:error];
}

- (void)bannerViewDidRecordImpression:(GADBannerView *)bannerView {
  [_manager onBannerImpression:self];
}

- (void)bannerViewWillPresentScreen:(GADBannerView *)bannerView {
  [_manager onBannerWillPresentScreen:self];
}

- (void)bannerViewWillDismissScreen:(GADBannerView *)bannerView {
  [_manager onBannerWillDismissScreen:self];
}

- (void)bannerViewDidDismissScreen:(GADBannerView *)bannerView {
  [_manager onBannerDidDismissScreen:self];
}

#pragma mark - FlutterPlatformView
- (nonnull UIView *)view {
  return self.bannerView;
}
@end

@implementation FLTGAMBannerAd {
  GAMBannerView *_bannerView;
  FLTGAMAdRequest *_adRequest;
}

- (instancetype)initWithAdUnitId:(NSString *_Nonnull)adUnitId
                           sizes:(NSArray<FLTAdSize *> *_Nonnull)sizes
                         request:(FLTGAMAdRequest *_Nonnull)request
              rootViewController:(UIViewController *_Nonnull)rootViewController {
  self = [super init];
  if (self) {
    _adRequest = request;
    _bannerView = [[GAMBannerView alloc] initWithAdSize:sizes[0].size];
    _bannerView.adUnitID = adUnitId;
    _bannerView.rootViewController = rootViewController;
    _bannerView.appEventDelegate = self;
    _bannerView.delegate = self;

    NSMutableArray<NSValue *> *validAdSizes = [NSMutableArray arrayWithCapacity:sizes.count];
    for (FLTAdSize *size in sizes) {
      [validAdSizes addObject:NSValueFromGADAdSize(size.size)];
    }
    _bannerView.validAdSizes = validAdSizes;
  }
  return self;
}

- (GADBannerView *_Nonnull)bannerView {
  return _bannerView;
}

- (void)load {
  [self.bannerView loadRequest:_adRequest.asGAMRequest];
}

#pragma mark - FlutterPlatformView

- (nonnull UIView *)view {
  return self.bannerView;
}

#pragma mark - GADAppEventDelegate
- (void)adView:(nonnull GADBannerView *)banner
    didReceiveAppEvent:(nonnull NSString *)name
              withInfo:(nullable NSString *)info {
  [self.manager onAppEvent:self name:name data:info];
}

@end

@implementation FLTInterstitialAd {
  GADInterstitialAd *_interstitialView;
  FLTAdRequest *_adRequest;
  UIViewController *_rootViewController;
  NSString *_adUnitId;
}

- (instancetype)initWithAdUnitId:(NSString *_Nonnull)adUnitId
                         request:(FLTAdRequest *_Nonnull)request
              rootViewController:(UIViewController *_Nonnull)rootViewController {
  self = [super init];
  if (self) {
    _adRequest = request;
    _adUnitId = [adUnitId copy];
    _rootViewController = rootViewController;
  }
  return self;
}

- (GADInterstitialAd *_Nullable)interstitial {
  return _interstitialView;
}

- (NSString *_Nonnull)adUnitId {
  return _adUnitId;
}

- (void)load {
  [GADInterstitialAd loadWithAdUnitID:_adUnitId
                              request:[_adRequest asGADRequest]
                    completionHandler:^(GADInterstitialAd *ad, NSError *error) {
                      if (error) {
                        [self.manager onAdFailedToLoad:self error:error];
                        return;
                      }
                      ad.fullScreenContentDelegate = self;
                      self->_interstitialView = ad;
                      [self.manager onAdLoaded:self responseInfo:ad.responseInfo];
                    }];
}

- (void)show {
  if (self.interstitial) {
    [self.interstitial presentFromRootViewController:_rootViewController];
  } else {
    NSLog(@"InterstitialAd failed to show because the ad was not ready.");
  }
}

#pragma mark - GADFullScreenContentDelegate

- (void)ad:(nonnull id<GADFullScreenPresentingAd>)ad
    didFailToPresentFullScreenContentWithError:(nonnull NSError *)error {
  [self.manager didFailToPresentFullScreenContentWithError:self error:error];
}

- (void)adDidPresentFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
  [self.manager onAdDidPresentFullScreenContent:self];
}

- (void)adDidDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
  [self.manager adDidDismissFullScreenContent:self];
}

- (void)adWillDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
  [self.manager adWillDismissFullScreenContent:self];
}

- (void)adDidRecordImpression:(nonnull id<GADFullScreenPresentingAd>)ad {
  [self.manager adDidRecordImpression:self];
}

@synthesize manager;

@end

@implementation FLTGAMInterstitialAd {
  GAMInterstitialAd *_insterstitial;
  FLTGAMAdRequest *_adRequest;
  UIViewController *_rootViewController;
  NSString *_adUnitId;
}

- (instancetype)initWithAdUnitId:(NSString *_Nonnull)adUnitId
                         request:(FLTGAMAdRequest *_Nonnull)request
              rootViewController:(UIViewController *_Nonnull)rootViewController {
  self = [super init];
  if (self) {
    _adRequest = request;
    _adUnitId = [adUnitId copy];
    _rootViewController = rootViewController;
  }
  return self;
}

- (GADInterstitialAd *_Nullable)interstitial {
  return _insterstitial;
}

- (void)load {
  [GAMInterstitialAd loadWithAdManagerAdUnitID:_adUnitId
                                       request:[_adRequest asGAMRequest]
                             completionHandler:^(GAMInterstitialAd *ad, NSError *error) {
                               if (error) {
                                 [self.manager onAdFailedToLoad:self error:error];
                                 return;
                               }
                               [self.manager onAdLoaded:self responseInfo:ad.responseInfo];
                               ad.fullScreenContentDelegate = self;
                               ad.appEventDelegate = self;
                               self->_insterstitial = ad;
                             }];
}

- (void)show {
  if (self.interstitial) {
    [self.interstitial presentFromRootViewController:_rootViewController];
  } else {
    NSLog(@"InterstitialAd failed to show because the ad was not ready.");
  }
}

#pragma mark - GADAppEventDelegate

- (void)interstitialAd:(nonnull GADInterstitialAd *)interstitialAd
    didReceiveAppEvent:(nonnull NSString *)name
              withInfo:(nullable NSString *)info {
  [self.manager onAppEvent:self name:name data:info];
}

@end

@implementation FLTRewardedAd {
  GADRewardedAd *_rewardedView;
  FLTAdRequest *_adRequest;
  UIViewController *_rootViewController;
  FLTServerSideVerificationOptions *_serverSideVerificationOptions;
  NSString *_adUnitId;
}

- (instancetype)initWithAdUnitId:(NSString *_Nonnull)adUnitId
                          request:(FLTAdRequest *_Nonnull)request
               rootViewController:(UIViewController *_Nonnull)rootViewController
    serverSideVerificationOptions:
        (FLTServerSideVerificationOptions *_Nullable)serverSideVerificationOptions {
  self = [super init];
  if (self) {
    _adRequest = request;
    _rootViewController = rootViewController;
    _serverSideVerificationOptions = serverSideVerificationOptions;
    _adUnitId = [adUnitId copy];
  }
  return self;
}

- (GADRewardedAd *_Nullable)rewardedAd {
  return _rewardedView;
}

- (void)load {
  GADRequest *request;
  if ([_adRequest isKindOfClass:[FLTGAMAdRequest class]]) {
    FLTGAMAdRequest *gamRequest = (FLTGAMAdRequest *)_adRequest;
    request = gamRequest.asGAMRequest;
  } else if ([_adRequest isKindOfClass:[FLTAdRequest class]]) {
    request = _adRequest.asGADRequest;
  } else {
    NSLog(@"A null or invalid ad request was provided.");
    return;
  }

  [GADRewardedAd loadWithAdUnitID:_adUnitId
                          request:request
                completionHandler:^(GADRewardedAd *_Nullable rewardedAd, NSError *_Nullable error) {
                  if (error) {
                    [self.manager onAdFailedToLoad:self error:error];
                    return;
                  }
                  if (self->_serverSideVerificationOptions != NULL &&
                      ![self->_serverSideVerificationOptions isEqual:[NSNull null]]) {
                    rewardedAd.serverSideVerificationOptions =
                        [self->_serverSideVerificationOptions asGADServerSideVerificationOptions];
                  }

                  rewardedAd.fullScreenContentDelegate = self;
                  self->_rewardedView = rewardedAd;
                  [self.manager onAdLoaded:self responseInfo:rewardedAd.responseInfo];
                }];
}

- (void)show {
  if (self.rewardedAd) {
    [self.rewardedAd presentFromRootViewController:_rootViewController
                          userDidEarnRewardHandler:^{
                            GADAdReward *reward = self.rewardedAd.adReward;
                            FLTRewardItem *fltReward =
                                [[FLTRewardItem alloc] initWithAmount:reward.amount
                                                                 type:reward.type];
                            [self.manager onRewardedAdUserEarnedReward:self reward:fltReward];
                          }];
  } else {
    NSLog(@"RewardedAd failed to show because the ad was not ready.");
  }
}

#pragma mark - GADFullScreenContentDelegate

- (void)ad:(nonnull id<GADFullScreenPresentingAd>)ad
    didFailToPresentFullScreenContentWithError:(nonnull NSError *)error {
  [manager didFailToPresentFullScreenContentWithError:self error:error];
}

/// Tells the delegate that the ad presented full screen content.
- (void)adDidPresentFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
  [manager onAdDidPresentFullScreenContent:self];
}

/// Tells the delegate that the ad dismissed full screen content.
- (void)adDidDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
  [manager adDidDismissFullScreenContent:self];
}

- (void)adWillDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
  [manager adWillDismissFullScreenContent:self];
}

- (void)adDidRecordImpression:(nonnull id<GADFullScreenPresentingAd>)ad {
  [manager adDidRecordImpression:self];
}

@synthesize manager;

@end

@implementation FLTNativeAd {
  NSString *_adUnitId;
  FLTAdRequest *_adRequest;
  NSObject<FLTNativeAdFactory> *_nativeAdFactory;
  NSDictionary<NSString *, id> *_customOptions;
  GADNativeAdView *_view;
  GADAdLoader *_adLoader;
}

- (instancetype _Nonnull)initWithAdUnitId:(NSString *_Nonnull)adUnitId
                                  request:(FLTAdRequest *_Nonnull)request
                          nativeAdFactory:(NSObject<FLTNativeAdFactory> *_Nonnull)nativeAdFactory
                            customOptions:(NSDictionary<NSString *, id> *_Nullable)customOptions
                       rootViewController:(UIViewController *_Nonnull)rootViewController {
  self = [super init];
  if (self) {
    _adUnitId = adUnitId;
    _adRequest = request;
    _nativeAdFactory = nativeAdFactory;
    _customOptions = customOptions;
    _adLoader = [[GADAdLoader alloc] initWithAdUnitID:_adUnitId
                                   rootViewController:rootViewController
                                              adTypes:@[ kGADAdLoaderAdTypeNative ]
                                              options:@[]];
    self.adLoader.delegate = self;
  }
  return self;
}

- (GADAdLoader *_Nonnull)adLoader {
  return _adLoader;
}

- (void)load {
  GADRequest *request;
  if ([_adRequest isKindOfClass:[FLTGAMAdRequest class]]) {
    FLTGAMAdRequest *gamRequest = (FLTGAMAdRequest *)_adRequest;
    request = gamRequest.asGAMRequest;
  } else {
    request = _adRequest.asGADRequest;
  }

  [self.adLoader loadRequest:request];
}

#pragma mark - GADNativeAdLoaderDelegate

- (void)adLoader:(GADAdLoader *)adLoader didReceiveNativeAd:(GADNativeAd *)nativeAd {
  // Use Nil instead of Null to fix crash with Swift integrations.
  NSDictionary<NSString *, id> *customOptions =
      [[NSNull null] isEqual:_customOptions] ? nil : _customOptions;
  _view = [_nativeAdFactory createNativeAd:nativeAd customOptions:customOptions];
  nativeAd.delegate = self;
  [_manager onAdLoaded:self responseInfo:nativeAd.responseInfo];
}

- (void)adLoader:(GADAdLoader *)adLoader didFailToReceiveAdWithError:(NSError *)error {
  [_manager onAdFailedToLoad:self error:error];
}

#pragma mark - GADNativeAdDelegate

- (void)nativeAdDidRecordClick:(GADNativeAd *)nativeAd {
  [_manager onNativeAdClicked:self];
}

- (void)nativeAdDidRecordImpression:(GADNativeAd *)nativeAd {
  [_manager onNativeAdImpression:self];
}

- (void)nativeAdWillPresentScreen:(GADNativeAd *)nativeAd {
  [_manager onNativeAdWillPresentScreen:self];
}

- (void)nativeAdWillDismissScreen:(nonnull GADNativeAd *)nativeAd {
  [_manager onNativeAdWillDismissScreen:self];
}

- (void)nativeAdDidDismissScreen:(GADNativeAd *)nativeAd {
  [_manager onNativeAdDidDismissScreen:self];
}

#pragma mark - FlutterPlatformView
- (UIView *)view {
  return _view;
}

@end

@implementation FLTRewardItem
- (instancetype _Nonnull)initWithAmount:(NSNumber *_Nonnull)amount type:(NSString *_Nonnull)type {
  self = [super init];
  if (self) {
    _amount = amount;
    _type = type;
  }
  return self;
}

- (BOOL)isEqual:(id)other {
  if (other == self) {
    return YES;
  } else if (![super isEqual:other]) {
    return NO;
  } else {
    FLTRewardItem *item = other;
    return [_amount isEqual:item.amount] && [_type isEqual:item.type];
  }
}

- (NSUInteger)hash {
  return _amount.hash | _type.hash;
}
@end
