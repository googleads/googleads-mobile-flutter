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

#import "FLTAdInstanceManager_Internal.h"

@implementation FLTAdInstanceManager {
  FLTGoogleMobileAdsCollection<NSNumber *, id<FLTAd>> *_ads;
  FlutterMethodChannel *_channel;
}

- (instancetype _Nonnull)initWithBinaryMessenger:
    (id<FlutterBinaryMessenger> _Nonnull)binaryMessenger {
  self = [super init];
  if (self) {
    _ads = [[FLTGoogleMobileAdsCollection alloc] init];
    NSObject<FlutterMethodCodec> *methodCodec = [FlutterStandardMethodCodec
        codecWithReaderWriter:[[FLTGoogleMobileAdsReaderWriter alloc] init]];
    _channel = [[FlutterMethodChannel alloc] initWithName:@"plugins.flutter.io/google_mobile_ads"
                                          binaryMessenger:binaryMessenger
                                                    codec:methodCodec];
  }
  return self;
}

- (id<FLTAd> _Nullable)adFor:(NSNumber *_Nonnull)adId {
  return [_ads objectForKey:adId];
}

- (NSNumber *_Nullable)adIdFor:(id<FLTAd> _Nonnull)ad {
  NSArray<NSNumber *> *keys = [_ads allKeysForObject:ad];

  if (keys.count > 1) {
    NSLog(@"%@Error: Multiple keys for a single ad.",
          NSStringFromClass([FLTAdInstanceManager class]));
  }

  if (keys.count > 0) {
    return keys[0];
  }

  return nil;
}

- (void)loadAd:(id<FLTAd> _Nonnull)ad adId:(NSNumber *_Nonnull)adId {
  [_ads setObject:ad forKey:adId];
  ad.manager = self;
  [ad load];
}

- (void)dispose:(NSNumber *_Nonnull)adId {
  [_ads removeObjectForKey:adId];
}

- (void)disposeAllAds {
  [_ads removeAllObjects];
}

- (void)showAdWithID:(NSNumber *_Nonnull)adId {
  id<FLTAdWithoutView> ad = (id<FLTAdWithoutView>)[self adFor:adId];

  if (!ad) {
    NSLog(@"Can't find ad with id: %@", adId);
    return;
  }

  [ad show];
}

- (void)onAdLoaded:(id<FLTAd> _Nonnull)ad {
  [_channel invokeMethod:@"onAdEvent"
               arguments:@{@"adId" : [self adIdFor:ad], @"eventName" : @"onAdLoaded"}];
}

- (void)onAdFailedToLoad:(id<FLTAd> _Nonnull)ad error:(NSError *_Nonnull)error {
  [_channel invokeMethod:@"onAdEvent"
               arguments:@{
                 @"adId" : [self adIdFor:ad],
                 @"eventName" : @"onAdFailedToLoad",
                 @"loadAdError" : error
               }];
}

- (void)onAppEvent:(id<FLTAd> _Nonnull)ad name:(NSString *)name data:(NSString *)data {
  [_channel invokeMethod:@"onAdEvent"
               arguments:@{
                 @"adId" : [self adIdFor:ad],
                 @"eventName" : @"onAppEvent",
                 @"name" : name,
                 @"data" : data
               }];
}

- (void)onNativeAdClicked:(FLTNativeAd *_Nonnull)ad {
  [_channel invokeMethod:@"onAdEvent"
               arguments:@{@"adId" : [self adIdFor:ad], @"eventName" : @"onNativeAdClicked"}];
}

- (void)onNativeAdImpression:(FLTNativeAd *_Nonnull)ad {
  [_channel invokeMethod:@"onAdEvent"
               arguments:@{@"adId" : [self adIdFor:ad], @"eventName" : @"onNativeAdImpression"}];
}

- (void)onNativeAdWillPresentScreen:(FLTNativeAd *_Nonnull)ad {
  [_channel invokeMethod:@"onAdEvent"
               arguments:@{@"adId" : [self adIdFor:ad], @"eventName" : @"onNativeAdWillPresentScreen"}];
}

- (void)onNativeAdDidDismissScreen:(FLTNativeAd *_Nonnull)ad {
  [_channel invokeMethod:@"onAdEvent"
               arguments:@{@"adId" : [self adIdFor:ad], @"eventName" : @"onNativeAdDidDismissScreen"}];
}

- (void)onNativeAdWillDismissScreen:(FLTNativeAd *_Nonnull)ad {
  [_channel invokeMethod:@"onAdEvent"
               arguments:@{@"adId" : [self adIdFor:ad], @"eventName" : @"onNativeAdWillDismissScreen"}];
}

- (void)onRewardedAdUserEarnedReward:(FLTRewardedAd *_Nonnull)ad
                              reward:(FLTRewardItem *_Nonnull)reward {
  [_channel invokeMethod:@"onAdEvent"
               arguments:@{
                 @"adId" : [self adIdFor:ad],
                 @"eventName" : @"onRewardedAdUserEarnedReward",
                 @"rewardItem" : reward,
               }];
}

- (void)onBannerImpression:(FLTBannerAd *_Nonnull)ad {
  [_channel invokeMethod:@"onBannerImpression"
               arguments:@{
                 @"adId" : [self adIdFor:ad],
               }];
}

- (void)onBannerWillDismissScreen:(FLTBannerAd *)ad {
  [_channel invokeMethod:@"onBannerWillDismissScreen"
               arguments:@{
                 @"adId" : [self adIdFor:ad],
               }];
}

- (void)onBannerDidDismissScreen:(FLTBannerAd *)ad {
  [_channel invokeMethod:@"onBannerDidDismissScreen"
               arguments:@{
                 @"adId" : [self adIdFor:ad],
               }];
}

- (void)onBannerWillPresentScreen:(FLTBannerAd *_Nonnull) ad {
  [_channel invokeMethod:@"onBannerWillPresentScreen"
               arguments:@{
                 @"adId" : [self adIdFor:ad],
               }];
}
- (void)onAdDidPresentFullScreenContent:(id<FLTAd> _Nonnull)ad {
  [self invokeMethod:@"onAdDidPresentFullScreenContent" ad:ad];
}

- (void)adDidDismissFullScreenContent:(id<FLTAd> _Nonnull)ad {
  [self invokeMethod:@"adDidDismissFullScreenContent" ad:ad];
}

- (void)adWillDismissFullScreenContent:(id<FLTAd> _Nonnull)ad {
  [self invokeMethod:@"adWillDismissFullScreenContent" ad:ad];
}

- (void)adDidRecordImpression:(id<FLTAd> _Nonnull)ad {
  [self invokeMethod:@"adDidRecordImpression" ad:ad];
}

- (void)didFailToPresentFullScreenContentWithError:(id<FLTAd> _Nonnull)ad
                                             error:(NSError *_Nonnull)error {
  [_channel invokeMethod:@"didFailToPresentFullScreenContentWithError"
               arguments:@{
                 @"adId" : [self adIdFor:ad],
                 @"error" : error
               }];
}

- (void)invokeMethod:(NSString *_Nonnull)method
                          ad:(id<FLTAd>)ad {
  [_channel invokeMethod:method
               arguments:@{
                 @"adId" : [self adIdFor:ad],
               }];
}
  


@end

@implementation FLTNewGoogleMobileAdsViewFactory
- (instancetype)initWithManager:(FLTAdInstanceManager *_Nonnull)manager {
  self = [super init];
  if (self) {
    _manager = manager;
  }
  return self;
}

- (nonnull NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame
                                            viewIdentifier:(int64_t)viewId
                                                 arguments:(id _Nullable)args {
  NSNumber *adId = args;
  NSObject<FlutterPlatformView> *view = (NSObject<FlutterPlatformView> *)[_manager adFor:adId];

  if (!view) {
    NSString *reason = [NSString
        stringWithFormat:@"Could not find an ad with id: %@. Was this ad already disposed?", adId];
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:reason userInfo:nil];
  }

  return view;
}

- (NSObject<FlutterMessageCodec> *)createArgsCodec {
  return [FlutterStandardMessageCodec sharedInstance];
}
@end
