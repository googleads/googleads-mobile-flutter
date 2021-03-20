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
- (void)dispose:(NSNumber *_Nonnull)adId;
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
- (void)disposeAllAds;
@end

@interface FLTNewGoogleMobileAdsViewFactory : NSObject <FlutterPlatformViewFactory>
@property(readonly) FLTAdInstanceManager *_Nonnull manager;
- (instancetype _Nonnull)initWithManager:(FLTAdInstanceManager *_Nonnull)manager;
@end
