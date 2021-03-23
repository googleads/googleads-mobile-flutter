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
  self = [super init];
  if (self) {
    _width = width;
    _height = height;

    // These values must remain consistent with `AdSize.smartBannerPortrait` and
    // `adSize.smartBannerLandscape` in Dart.
    if ([_width isEqual:@(-1)] && [_height isEqual:@(-2)]) {
      _size = kGADAdSizeSmartBannerPortrait;
    } else if ([_width isEqual:@(-1)] && [_height isEqual:@(-3)]) {
      _size = kGADAdSizeSmartBannerLandscape;
    } else {
      _size = GADAdSizeFromCGSize(CGSizeMake(width.doubleValue, height.doubleValue));
    }
  }
  return self;
}
@end

@implementation FLTAdRequest
- (GADRequest *_Nonnull)asGADRequest {
  GADRequest *request = [GADRequest request];
  request.keywords = _keywords;
  request.contentURL = _contentURL;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
  request.testDevices = _testDevices;
#pragma clang diagnostic pop
  if (_nonPersonalizedAds) {
    GADExtras *extras = [[GADExtras alloc] init];
    extras.additionalParameters = @{@"npa" : @"1"};
    [request registerAdNetworkExtras:extras];
  }

  request.requestAgent = FLT_REQUEST_AGENT_VERSIONED;
  return request;
}
@end

@implementation FLTLoadAdError
- (instancetype _Nonnull)initWithCode:(NSNumber *_Nonnull)code
                               domain:(NSString *_Nonnull)domain
                              message:(NSString *_Nonnull)message {
  self = [super init];
  if (self) {
    _code = code;
    _domain = domain;
    _message = message;
  }
  return self;
}

- (instancetype _Nonnull)initWithError:(GADRequestError *_Nonnull)error {
  self = [super init];
  if (self) {
    _code = @(error.code);
    _domain = error.domain;
    _message = error.localizedDescription;
  }
  return self;
}
@end

@implementation FLTPublisherAdRequest
- (GADRequest *_Nonnull)asDFPRequest {
  DFPRequest *request = [DFPRequest request];
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

- (void)adView:(GADBannerView *)adView didFailToReceiveAdWithError:(GADRequestError *)error {
  [_manager onAdFailedToLoad:self error:[[FLTLoadAdError alloc] initWithError:error]];
}

- (void)adViewWillPresentScreen:(GADBannerView *)adView {
  [_manager onAdOpened:self];
}

- (void)adViewDidDismissScreen:(GADBannerView *)adView {
  [_manager onAdClosed:self];
}

- (void)adViewWillLeaveApplication:(GADBannerView *)adView {
  [_manager onApplicationExit:self];
}

- (void)adViewDidReceiveAd:(GADBannerView *)adView {
  [_manager onAdLoaded:self];
}
- (void)adView:(nonnull GADBannerView *)banner
    didReceiveAppEvent:(nonnull NSString *)name
              withInfo:(nullable NSString *)info {
  [_manager onAppEvent:self name:name data:info];
}
- (nonnull UIView *)view {
  return self.bannerView;
}
@end

@implementation FLTPublisherBannerAd {
  DFPBannerView *_bannerView;
  FLTPublisherAdRequest *_adRequest;
}

- (instancetype)initWithAdUnitId:(NSString *_Nonnull)adUnitId
                           sizes:(NSArray<FLTAdSize *> *_Nonnull)sizes
                         request:(FLTPublisherAdRequest *_Nonnull)request
              rootViewController:(UIViewController *_Nonnull)rootViewController {
  self = [super init];
  if (self) {
    _adRequest = request;
    _bannerView = [[DFPBannerView alloc] initWithAdSize:sizes[0].size];
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
  [self.bannerView loadRequest:_adRequest.asDFPRequest];
}

- (nonnull UIView *)view {
  return self.bannerView;
}

- (void)adLoader:(nonnull GADAdLoader *)adLoader
    didFailToReceiveAdWithError:(nonnull GADRequestError *)error {
  [self.manager onAdFailedToLoad:self error:[[FLTLoadAdError alloc] initWithError:error]];
}

- (void)adLoader:(nonnull GADAdLoader *)adLoader
    didReceiveDFPBannerView:(nonnull DFPBannerView *)bannerView {
  [self.manager onAdLoaded:self];
}

- (nonnull NSArray<NSValue *> *)validBannerSizesForAdLoader:(nonnull GADAdLoader *)adLoader {
  return _bannerView.validAdSizes;
}
@end

@implementation FLTInterstitialAd {
  GADInterstitial *_interstitialView;
  FLTAdRequest *_adRequest;
  UIViewController *_rootViewController;
}

- (instancetype)initWithAdUnitId:(NSString *_Nonnull)adUnitId
                         request:(FLTAdRequest *_Nonnull)request
              rootViewController:(UIViewController *_Nonnull)rootViewController {
  self = [super init];
  if (self) {
    _adRequest = request;
    _interstitialView = [[GADInterstitial alloc] initWithAdUnitID:adUnitId];
    self.interstitial.delegate = self;
    _rootViewController = rootViewController;
  }
  return self;
}

- (GADInterstitial *_Nonnull)interstitial {
  return _interstitialView;
}

- (void)load {
  [self.interstitial loadRequest:_adRequest.asGADRequest];
}

- (void)show {
  if (self.interstitial.isReady) {
    [self.interstitial presentFromRootViewController:_rootViewController];
  } else {
    NSLog(@"InterstitialAd failed to show because the ad was not ready.");
  }
}

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
  [_manager onAdLoaded:self];
}

- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error {
  [_manager onAdFailedToLoad:self error:[[FLTLoadAdError alloc] initWithError:error]];
}

- (void)interstitialWillPresentScreen:(GADInterstitial *)ad {
  [_manager onAdOpened:self];
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
  [_manager onAdClosed:self];
}

- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad {
  [_manager onApplicationExit:self];
}
@end

@implementation FLTPublisherInterstitialAd {
  DFPInterstitial *_insterstitial;
  FLTPublisherAdRequest *_adRequest;
  UIViewController *_rootViewController;
}

- (instancetype)initWithAdUnitId:(NSString *_Nonnull)adUnitId
                         request:(FLTPublisherAdRequest *_Nonnull)request
              rootViewController:(UIViewController *_Nonnull)rootViewController {
  self = [super init];
  if (self) {
    _adRequest = request;
    _insterstitial = [[DFPInterstitial alloc] initWithAdUnitID:adUnitId];
    _insterstitial.delegate = self;
    _rootViewController = rootViewController;
  }
  return self;
}

- (GADInterstitial *_Nonnull)interstitial {
  return _insterstitial;
}

- (void)load {
  [self.interstitial loadRequest:[_adRequest asDFPRequest]];
}

- (void)show {
  if (self.interstitial.isReady) {
    [self.interstitial presentFromRootViewController:_rootViewController];
  } else {
    NSLog(@"InterstitialAd failed to show because the ad was not ready.");
  }
}
@end

@implementation FLTRewardedAd {
  GADRewardedAd *_rewardedView;
  FLTAdRequest *_adRequest;
  UIViewController *_rootViewController;
  FLTServerSideVerificationOptions *_serverSideVerificationOptions;
}

- (instancetype)initWithAdUnitId:(NSString *_Nonnull)adUnitId
                         request:(FLTAdRequest *_Nonnull)request
              rootViewController:(UIViewController *_Nonnull)rootViewController
              serverSideVerificationOptions: (FLTServerSideVerificationOptions *_Nullable)serverSideVerificationOptions {
  self = [super init];
  if (self) {
    _adRequest = request;
    _rewardedView = [[GADRewardedAd alloc] initWithAdUnitID:adUnitId];
    _rootViewController = rootViewController;
    _serverSideVerificationOptions = serverSideVerificationOptions;
  }
  return self;
}

- (GADRewardedAd *_Nonnull)rewardedAd {
  return _rewardedView;
}

- (void)load {
  GADRequest *request;
  if ([_adRequest isKindOfClass:[FLTPublisherAdRequest class]]) {
    FLTPublisherAdRequest *publisherRequest = (FLTPublisherAdRequest *)_adRequest;
    request = publisherRequest.asDFPRequest;
  } else if ([_adRequest isKindOfClass:[FLTAdRequest class]]) {
    request = _adRequest.asGADRequest;
  } else {
    NSLog(@"A null or invalid ad request was provided.");
    return;
  }
  if (_serverSideVerificationOptions != NULL && ![_serverSideVerificationOptions isEqual:[NSNull null]]) {
    _rewardedView.serverSideVerificationOptions = [_serverSideVerificationOptions asGADServerSideVerificationOptions];
  }

  [self.rewardedAd loadRequest:request
             completionHandler:^(GADRequestError *_Nullable error) {
               if (error) {
                 [self->_manager onAdFailedToLoad:self
                                            error:[[FLTLoadAdError alloc] initWithError:error]];
               } else {
                 [self->_manager onAdLoaded:self];
               }
             }];
}

- (void)show {
  if (self.rewardedAd.isReady) {
    [self.rewardedAd presentFromRootViewController:_rootViewController delegate:self];
  } else {
    NSLog(@"RewardedAd failed to show because the ad was not ready.");
  }
}

- (void)rewardedAd:(nonnull GADRewardedAd *)rewardedAd
    userDidEarnReward:(nonnull GADAdReward *)reward {
  [_manager onRewardedAdUserEarnedReward:self
                                  reward:[[FLTRewardItem alloc] initWithAmount:reward.amount
                                                                          type:reward.type]];
}

- (void)rewardedAdDidPresent:(GADRewardedAd *)rewardedAd {
  [_manager onAdOpened:self];
}

- (void)rewardedAdDidDismiss:(GADRewardedAd *)rewardedAd {
  [_manager onAdClosed:self];
}
@end

@implementation FLTNativeAd {
  NSString *_adUnitId;
  FLTAdRequest *_adRequest;
  NSObject<FLTNativeAdFactory> *_nativeAdFactory;
  NSDictionary<NSString *, id> *_customOptions;
  GADUnifiedNativeAdView *_view;
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
                                              adTypes:@[ kGADAdLoaderAdTypeUnifiedNative ]
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
  if ([_adRequest isKindOfClass:[FLTPublisherAdRequest class]]) {
    FLTPublisherAdRequest *publisherRequest = (FLTPublisherAdRequest *)_adRequest;
    request = publisherRequest.asDFPRequest;
  } else {
    request = _adRequest.asGADRequest;
  }

  [self.adLoader loadRequest:request];
}

- (void)adLoader:(GADAdLoader *)adLoader didReceiveUnifiedNativeAd:(GADUnifiedNativeAd *)nativeAd {
  _view = [_nativeAdFactory createNativeAd:nativeAd customOptions:_customOptions];
  nativeAd.delegate = self;
  [_manager onAdLoaded:self];
}

- (void)adLoader:(GADAdLoader *)adLoader didFailToReceiveAdWithError:(GADRequestError *)error {
  [_manager onAdFailedToLoad:self error:[[FLTLoadAdError alloc] initWithError:error]];
}

- (void)nativeAdDidRecordClick:(GADUnifiedNativeAd *)nativeAd {
  [_manager onNativeAdClicked:self];
}

- (void)nativeAdDidRecordImpression:(GADUnifiedNativeAd *)nativeAd {
  [_manager onNativeAdImpression:self];
}

- (void)nativeAdWillPresentScreen:(GADUnifiedNativeAd *)nativeAd {
  [_manager onAdOpened:self];
}

- (void)nativeAdWillLeaveApplication:(GADUnifiedNativeAd *)nativeAd {
  [_manager onApplicationExit:self];
}

- (void)nativeAdDidDismissScreen:(GADUnifiedNativeAd *)nativeAd {
  [_manager onAdClosed:self];
}

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
