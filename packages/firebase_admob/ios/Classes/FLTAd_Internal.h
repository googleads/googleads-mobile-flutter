// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <GoogleMobileAds/GoogleMobileAds.h>
#import "FLTAdInstanceManager_Internal.h"
#import "FLTFirebaseAdMobPlugin.h"

@class FLTAdInstanceManager;
@protocol FLTNativeAdFactory;

@interface FLTAdSize : NSObject
@property(readonly) GADAdSize size;
@property(readonly) NSNumber *_Nonnull width;
@property(readonly) NSNumber *_Nonnull height;
- (instancetype _Nonnull)initWithWidth:(NSNumber *_Nonnull)width height:(NSNumber *_Nonnull)height;
@end

typedef NS_ENUM(NSInteger, FLTAdGender) {
  FLTAdGenderUnknown,
  FLTAdGenderMale,
  FLTAdGenderFemale,
};

@interface FLTAdRequest : NSObject
@property NSArray<NSString *> *_Nullable keywords;
@property NSString *_Nullable contentURL;
@property NSDate *_Nullable birthday;
@property FLTAdGender gender;
@property BOOL designedForFamilies;
@property BOOL childDirected;
@property NSArray<NSString *> *_Nullable testDevices;
@property BOOL nonPersonalizedAds;
- (GADRequest *_Nonnull)asGADRequest;
@end

/**
 * Wrapper around `DFPRequest` for the Firebase AdMob Plugin.
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
 * Wrapper around `DFPBannerAd` for the Firebase AdMob Plugin.
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
                       rootViewController:(UIViewController *_Nonnull)rootViewController;
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
