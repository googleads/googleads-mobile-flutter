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

#import <GoogleMobileAds/GoogleMobileAds.h>
#import "FLTAdInstanceManager_Internal.h"
#import "FLTGoogleMobileAdsPlugin.h"
#import "FLTMobileAds_Internal.h"

@class FLTAdInstanceManager;
@protocol FLTNativeAdFactory;

@interface FLTAdSize : NSObject
@property(readonly) GADAdSize size;
@property(readonly) NSNumber *_Nonnull width;
@property(readonly) NSNumber *_Nonnull height;
- (instancetype _Nonnull)initWithWidth:(NSNumber *_Nonnull)width height:(NSNumber *_Nonnull)height;
- (instancetype _Nonnull)initWithAdSize:(GADAdSize)size;
@end

/**
 * Wrapper around top level methods for `GADAdSize` for the Google Mobile Ads Plugin.
 */
@interface FLTAdSizeFactory : NSObject
- (GADAdSize)portraitAnchoredAdaptiveBannerAdSizeWithWidth:(NSNumber *_Nonnull)width;
- (GADAdSize)landscapeAnchoredAdaptiveBannerAdSizeWithWidth:(NSNumber *_Nonnull)width;
- (GADAdSize)currentOrientationAnchoredAdaptiveBannerAdSizeWithWidth:(NSNumber *_Nonnull)width;
- (GADAdSize)currentOrientationInlineAdaptiveBannerSizeWithWidth:(NSNumber *_Nonnull)width;
- (GADAdSize)portraitOrientationInlineAdaptiveBannerSizeWithWidth:(NSNumber *_Nonnull)width;
- (GADAdSize)landscapeInlineAdaptiveBannerAdSizeWithWidth:(NSNumber *_Nonnull)width;
- (GADAdSize)inlineAdaptiveBannerAdSizeWithWidthAndMaxHeight:(NSNumber *_Nonnull)width
                                                   maxHeight:(NSNumber *_Nonnull)maxHeight;

@end

@interface FLTAnchoredAdaptiveBannerSize : FLTAdSize
@property(readonly) NSString *_Nonnull orientation;
- (instancetype _Nonnull)initWithFactory:(FLTAdSizeFactory *_Nonnull)factory
                             orientation:(NSString *_Nullable)orientation
                                   width:(NSNumber *_Nonnull)width;
@end

@interface FLTInlineAdaptiveBannerSize : FLTAdSize
@property(readonly) NSNumber *_Nullable orientation;
@property(readonly) NSNumber *_Nullable maxHeight;
- (instancetype _Nonnull)initWithFactory:(FLTAdSizeFactory *_Nonnull)factory
                                   width:(NSNumber *_Nonnull)width
                               maxHeight:(NSNumber *_Nullable)maxHeight
                             orientation:(NSNumber *_Nullable)orientation;
@end

@interface FLTSmartBannerSize : FLTAdSize
@property(readonly) NSString *_Nonnull orientation;
- (instancetype _Nonnull)initWithOrientation:(NSString *_Nonnull)orientation;
@end

@interface FLTLocationParams : NSObject

@property NSNumber *_Nullable accuracy;
@property NSNumber *_Nullable longitude;
@property NSNumber *_Nullable latitude;

- (instancetype _Nonnull)initWithAccuracy:(NSNumber *_Nonnull)accuracy
                                longitude:(NSNumber *_Nonnull)longitude
                                 latitude:(NSNumber *_Nonnull)latitude;
@end

@interface FLTFluidSize : FLTAdSize
@end

@interface FLTAdRequest : NSObject
@property NSArray<NSString *> *_Nullable keywords;
@property NSString *_Nullable contentURL;
@property BOOL nonPersonalizedAds;
@property NSArray<NSString *> *_Nullable neighboringContentURLs;
@property FLTLocationParams *_Nullable location;
- (GADRequest *_Nonnull)asGADRequest;
@end

/**
 * Wrapper around `GADAdNetworkResponseInfo`.
 */
@interface FLTGADAdNetworkResponseInfo : NSObject

@property NSString *_Nullable adNetworkClassName;
@property NSNumber *_Nullable latency;
@property NSString *_Nullable dictionaryDescription;
@property NSString *_Nullable credentialsDescription;
@property NSError *_Nullable error;

- (instancetype _Nonnull)initWithResponseInfo:(GADAdNetworkResponseInfo *_Nonnull)responseInfo;
@end

/**
 * Wrapper around `GADResponseInfo`.
 */
@interface FLTGADResponseInfo : NSObject
@property NSString *_Nullable responseIdentifier;
@property NSString *_Nullable adNetworkClassName;
@property NSArray<FLTGADAdNetworkResponseInfo *> *_Nullable adNetworkInfoArray;

- (instancetype _Nonnull)initWithResponseInfo:(GADResponseInfo *_Nonnull)responseInfo;
@end

/**
 * Wrapper around `GAMRequest` for the Google Mobile Ads Plugin.
 * Extracts response info from the userInfo dict.
 */
@interface FLTLoadAdError : NSObject
@property NSInteger code;
@property NSString *_Nullable domain;
@property NSString *_Nullable message;
@property FLTGADResponseInfo *_Nullable responseInfo;

- (instancetype _Nonnull)initWithError:(NSError *_Nonnull)error;
@end

/**
 * Wrapper around `GAMRequest` for the Google Mobile Ads Plugin.
 */
@interface FLTGAMAdRequest : FLTAdRequest
@property NSDictionary<NSString *, NSString *> *_Nullable customTargeting;
@property NSDictionary<NSString *, NSArray<NSString *> *> *_Nullable customTargetingLists;
@property NSString *_Nullable pubProvidedID;

- (GAMRequest *_Nonnull)asGAMRequest;
@end

@protocol FLTAd <NSObject>
@property(weak) FLTAdInstanceManager *_Nullable manager;
@property(readonly) NSNumber *_Nonnull adId;
- (void)load;
@end

@protocol FLTAdWithoutView
- (void)show;
@end

@interface FLTBaseAd : NSObject
@property(readonly) NSNumber *_Nonnull adId;
@end

@interface FLTBannerAd : FLTBaseAd <FLTAd, FlutterPlatformView, GADBannerViewDelegate>
- (instancetype _Nonnull)initWithAdUnitId:(NSString *_Nonnull)adUnitId
                                     size:(FLTAdSize *_Nonnull)size
                                  request:(FLTAdRequest *_Nonnull)request
                       rootViewController:(UIViewController *_Nonnull)rootViewController
                                     adId:(NSNumber *_Nonnull)adId;
- (FLTAdSize *_Nullable)getAdSize;
- (GADBannerView *_Nonnull)bannerView;
@end

/**
 * Wrapper around `GAMBannerAd` for the Google Mobile Ads Plugin.
 */
@interface FLTGAMBannerAd : FLTBannerAd <GADAppEventDelegate>
- (instancetype _Nonnull)initWithAdUnitId:(NSString *_Nonnull)adUnitId
                                    sizes:(NSArray<FLTAdSize *> *_Nonnull)sizes
                                  request:(FLTGAMAdRequest *_Nonnull)request
                       rootViewController:(UIViewController *_Nonnull)rootViewController
                                     adId:(NSNumber *_Nonnull)adId;

@end

/**
 * An extension of`GAMBannerAd` for fluid ad size.
 */
@interface FLTFluidGAMBannerAd : FLTGAMBannerAd <GADAdSizeDelegate>
- (instancetype _Nonnull)initWithAdUnitId:(NSString *_Nonnull)adUnitId
                                  request:(FLTGAMAdRequest *_Nonnull)request
                       rootViewController:(UIViewController *_Nonnull)rootViewController
                                     adId:(NSNumber *_Nonnull)adId;
@end

@interface FLTInterstitialAd : FLTBaseAd <FLTAd, FLTAdWithoutView, GADFullScreenContentDelegate>
- (instancetype _Nonnull)initWithAdUnitId:(NSString *_Nonnull)adUnitId
                                  request:(FLTAdRequest *_Nonnull)request
                       rootViewController:(UIViewController *_Nonnull)rootViewController
                                     adId:(NSNumber *_Nonnull)adId;
- (GADInterstitialAd *_Nullable)interstitial;
- (NSString *_Nonnull)adUnitId;
- (void)load;

@end

@interface FLTGAMInterstitialAd : FLTInterstitialAd <GADAppEventDelegate>
- (instancetype _Nonnull)initWithAdUnitId:(NSString *_Nonnull)adUnitId
                                  request:(FLTGAMAdRequest *_Nonnull)request
                       rootViewController:(UIViewController *_Nonnull)rootViewController
                                     adId:(NSNumber *_Nonnull)adId;
@end

@interface FLTRewardedAd : FLTBaseAd <FLTAd, FLTAdWithoutView, GADFullScreenContentDelegate>
- (instancetype _Nonnull)initWithAdUnitId:(NSString *_Nonnull)adUnitId
                                  request:(FLTAdRequest *_Nonnull)request
                       rootViewController:(UIViewController *_Nonnull)rootViewController
            serverSideVerificationOptions:
                (FLTServerSideVerificationOptions *_Nullable)serverSideVerificationOptions
                                     adId:(NSNumber *_Nonnull)adId;
- (GADRewardedAd *_Nullable)rewardedAd;
@end

@interface FLTAppOpenAd : FLTBaseAd <FLTAd, FLTAdWithoutView, GADFullScreenContentDelegate>
- (instancetype _Nonnull)initWithAdUnitId:(NSString *_Nonnull)adUnitId
                                  request:(FLTAdRequest *_Nonnull)request
                       rootViewController:(UIViewController *_Nonnull)rootViewController
                              orientation:(NSNumber *_Nonnull)orientation
                                     adId:(NSNumber *_Nonnull)adId;
- (GADAppOpenAd *_Nullable)appOpenAd;
@end

@interface FLTVideoOptions : NSObject
@property(readonly) NSNumber *_Nullable clickToExpandRequested;
@property(readonly) NSNumber *_Nullable customControlsRequested;
@property(readonly) NSNumber *_Nullable startMuted;
- (instancetype _Nonnull)initWithClickToExpandRequested:(NSNumber *_Nullable)clickToExpandRequested
                                customControlsRequested:(NSNumber *_Nullable)customControlsRequested
                                             startMuted:(NSNumber *_Nullable)startMuted;
- (GADVideoOptions *_Nonnull)asGADVideoOptions;

@end

@interface FLTNativeAdOptions : NSObject
@property(readonly) NSNumber *_Nullable adChoicesPlacement;
@property(readonly) NSNumber *_Nullable mediaAspectRatio;
@property(readonly) FLTVideoOptions *_Nullable videoOptions;
@property(readonly) NSNumber *_Nullable requestCustomMuteThisAd;
@property(readonly) NSNumber *_Nullable shouldRequestMultipleImages;
@property(readonly) NSNumber *_Nullable shouldReturnUrlsForImageAssets;

- (instancetype _Nonnull)initWithAdChoicesPlacement:(NSNumber *_Nullable)adChoicesPlacement
                                   mediaAspectRatio:(NSNumber *_Nullable)mediaAspectRatio
                                       videoOptions:(FLTVideoOptions *_Nullable)videoOptions
                            requestCustomMuteThisAd:(NSNumber *_Nullable)requestCustomMuteThisAd
                        shouldRequestMultipleImages:(NSNumber *_Nullable)shouldRequestMultipleImages
                     shouldReturnUrlsForImageAssets:
                         (NSNumber *_Nullable)shouldReturnUrlsForImageAssets;

- (NSArray<GADAdLoaderOptions *> *_Nonnull)asGADAdLoaderOptions;
@end

@interface FLTNativeAd
    : FLTBaseAd <FLTAd, FlutterPlatformView, GADNativeAdDelegate, GADNativeAdLoaderDelegate>
- (instancetype _Nonnull)initWithAdUnitId:(NSString *_Nonnull)adUnitId
                                  request:(FLTAdRequest *_Nonnull)request
                          nativeAdFactory:(NSObject<FLTNativeAdFactory> *_Nonnull)nativeAdFactory
                            customOptions:(NSDictionary<NSString *, id> *_Nullable)customOptions
                       rootViewController:(UIViewController *_Nonnull)rootViewController
                                     adId:(NSNumber *_Nonnull)adId
                          nativeAdOptions:(FLTNativeAdOptions *_Nullable)nativeAdOptions;
- (GADAdLoader *_Nonnull)adLoader;
@end

@interface FLTRewardItem : NSObject
@property(readonly) NSNumber *_Nonnull amount;
@property(readonly) NSString *_Nonnull type;
- (instancetype _Nonnull)initWithAmount:(NSNumber *_Nonnull)amount type:(NSString *_Nonnull)type;
@end

@interface FLTAdValue : NSObject
@property(readonly) NSDecimalNumber *_Nonnull valueMicros;
@property(readonly) NSInteger precision;
@property(readonly) NSString *_Nonnull currencyCode;
- (instancetype _Nonnull)initWithValue:(NSDecimalNumber *_Nonnull)value
                             precision:(NSInteger)precision
                          currencyCode:(NSString *_Nonnull)currencyCode;
@end
