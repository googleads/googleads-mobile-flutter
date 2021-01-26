// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "FLTAd_Internal.h"
#import "FLTGoogleMobileAdsCollection_Internal.h"
#import "FLTGoogleMobileAdsReaderWriter_Internal.h"

@protocol FLTAd;
@class FLTNativeAd;
@class FLTRewardedAd;
@class FLTRewardItem;
@class FLTLoadAdError;

@interface FLTAdInstanceManager : NSObject
- (instancetype _Nonnull)initWithBinaryMessenger:
    (id<FlutterBinaryMessenger> _Nonnull)binaryMessenger;
- (id<FLTAd> _Nullable)adFor:(NSNumber *_Nonnull)adId;
- (NSNumber *_Nullable)adIdFor:(id<FLTAd> _Nonnull)ad;
- (void)loadAd:(id<FLTAd> _Nonnull)ad adId:(NSNumber *_Nonnull)adId;
- (void)dispose:(id<FLTAd> _Nonnull)ad;
- (void)showAdWithID:(NSNumber *_Nonnull)adId;
- (void)onAdLoaded:(id<FLTAd> _Nonnull)ad;
- (void)onAdFailedToLoad:(id<FLTAd> _Nonnull)ad error:(FLTLoadAdError *_Nonnull)error;
- (void)onAppEvent:(id<FLTAd> _Nonnull)ad
              name:(NSString *_Nullable)name
              data:(NSString *_Nullable)data;
- (void)onNativeAdClicked:(FLTNativeAd *_Nonnull)ad;
- (void)onNativeAdImpression:(FLTNativeAd *_Nonnull)ad;
- (void)onAdOpened:(id<FLTAd> _Nonnull)ad;
- (void)onApplicationExit:(id<FLTAd> _Nonnull)ad;
- (void)onAdClosed:(id<FLTAd> _Nonnull)ad;
- (void)onRewardedAdUserEarnedReward:(FLTRewardedAd *_Nonnull)ad
                              reward:(FLTRewardItem *_Nonnull)reward;
@end

@interface FLTNewGoogleMobileAdsViewFactory : NSObject <FlutterPlatformViewFactory>
@property(readonly) FLTAdInstanceManager *_Nonnull manager;
- (instancetype _Nonnull)initWithManager:(FLTAdInstanceManager *_Nonnull)manager;
@end
