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
@end

@interface FLTAdRequest : NSObject
@property NSArray<NSString *> *_Nullable keywords;
@property NSString *_Nullable contentURL;
@property NSArray<NSString *> *_Nullable testDevices;
@property BOOL nonPersonalizedAds;
- (GADRequest *_Nonnull)asGADRequest;
@end

/**
 * Wrapper around `DFPRequest` for the Google Mobile Ads Plugin.
 */
@interface FLTPublisherAdRequest : FLTAdRequest
@property NSDictionary<NSString *, NSString *> *_Nullable customTargeting;
@property NSDictionary<NSString *, NSArray<NSString *> *> *_Nullable customTargetingLists;
- (DFPRequest *_Nonnull)asDFPRequest;
@end

@protocol FLTAd <NSObject>
@property(weak) FLTAdInstanceManager *_Nullable manager;
- (void)load;
@end

@interface FLTLoadAdError : NSObject
@property(readonly) NSNumber *_Nonnull code;
@property(readonly) NSString *_Nonnull domain;
@property(readonly) NSString *_Nonnull message;
- (instancetype _Nonnull)initWithCode:(NSNumber *_Nonnull)code
                               domain:(NSString *_Nonnull)domain
                              message:(NSString *_Nonnull)message;
- (instancetype _Nonnull)initWithError:(GADRequestError *_Nonnull)error;
@end

@protocol FLTAdWithoutView
- (void)show;
@end

@interface FLTBannerAd : NSObject <FLTAd, FlutterPlatformView, GADBannerViewDelegate>
@property(weak) FLTAdInstanceManager *_Nullable manager;
- (instancetype _Nonnull)initWithAdUnitId:(NSString *_Nonnull)adUnitId
                                     size:(FLTAdSize *_Nonnull)size
                                  request:(FLTAdRequest *_Nonnull)request
                       rootViewController:(UIViewController *_Nonnull)rootViewController;
- (GADBannerView *_Nonnull)bannerView;
@end

/**
 * Wrapper around `DFPBannerAd` for the Google Mobile Ads Plugin.
 */
@interface FLTPublisherBannerAd : FLTBannerAd <DFPBannerAdLoaderDelegate, GADAppEventDelegate>
- (instancetype _Nonnull)initWithAdUnitId:(NSString *_Nonnull)adUnitId
                                    sizes:(NSArray<FLTAdSize *> *_Nonnull)sizes
                                  request:(FLTPublisherAdRequest *_Nonnull)request
                       rootViewController:(UIViewController *_Nonnull)rootViewController;
@end

@interface FLTInterstitialAd : NSObject <FLTAd, FLTAdWithoutView, GADInterstitialDelegate>
@property(weak) FLTAdInstanceManager *_Nullable manager;
- (instancetype _Nonnull)initWithAdUnitId:(NSString *_Nonnull)adUnitId
                                  request:(FLTAdRequest *_Nonnull)request
                       rootViewController:(UIViewController *_Nonnull)rootViewController;
- (GADInterstitial *_Nonnull)interstitial;
@end

@interface FLTPublisherInterstitialAd : FLTInterstitialAd
- (instancetype _Nonnull)initWithAdUnitId:(NSString *_Nonnull)adUnitId
                                  request:(FLTPublisherAdRequest *_Nonnull)request
                       rootViewController:(UIViewController *_Nonnull)rootViewController;
@end

@interface FLTRewardedAd : NSObject <FLTAd, FLTAdWithoutView, GADRewardedAdDelegate>
@property(weak) FLTAdInstanceManager *_Nullable manager;
- (instancetype _Nonnull)initWithAdUnitId:(NSString *_Nonnull)adUnitId
                                  request:(FLTAdRequest *_Nonnull)request
                       rootViewController:(UIViewController *_Nonnull)rootViewController
            serverSideVerificationOptions:
                (FLTServerSideVerificationOptions *_Nullable)serverSideVerificationOptions;
- (GADRewardedAd *_Nonnull)rewardedAd;
@end

@interface FLTNativeAd : NSObject <FLTAd,
                                   FlutterPlatformView,
                                   GADUnifiedNativeAdDelegate,
                                   GADUnifiedNativeAdLoaderDelegate>
@property(weak) FLTAdInstanceManager *_Nullable manager;
- (instancetype _Nonnull)initWithAdUnitId:(NSString *_Nonnull)adUnitId
                                  request:(FLTAdRequest *_Nonnull)request
                          nativeAdFactory:(NSObject<FLTNativeAdFactory> *_Nonnull)nativeAdFactory
                            customOptions:(NSDictionary<NSString *, id> *_Nullable)customOptions
                       rootViewController:(UIViewController *_Nonnull)rootViewController;
- (GADAdLoader *_Nonnull)adLoader;
@end

@interface FLTRewardItem : NSObject
@property(readonly) NSNumber *_Nonnull amount;
@property(readonly) NSString *_Nonnull type;
- (instancetype _Nonnull)initWithAmount:(NSNumber *_Nonnull)amount type:(NSString *_Nonnull)type;
@end
