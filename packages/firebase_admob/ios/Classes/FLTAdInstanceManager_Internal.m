// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "FLTAdInstanceManager_Internal.h"

@implementation FLTAdInstanceManager {
  FLTFirebaseAdMobCollection<NSNumber *, id<FLTAd>> *_ads;
  FlutterMethodChannel *_channel;
}

- (instancetype _Nonnull)initWithBinaryMessenger:
    (id<FlutterBinaryMessenger> _Nonnull)binaryMessenger {
  self = [super init];
  if (self) {
    _ads = [[FLTFirebaseAdMobCollection alloc] init];
    NSObject<FlutterMethodCodec> *methodCodec = [FlutterStandardMethodCodec
        codecWithReaderWriter:[[FLTFirebaseAdMobReaderWriter alloc] init]];
    _channel = [[FlutterMethodChannel alloc] initWithName:@"plugins.flutter.io/firebase_admob"
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

- (void)dispose:(id<FLTAd> _Nonnull)ad {
  [_ads removeObjectForKey:[self adIdFor:ad]];
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

- (void)onAdFailedToLoad:(id<FLTAd> _Nonnull)ad error:(FLTLoadAdError *_Nonnull)error {
  [_channel invokeMethod:@"onAdEvent"
               arguments:@{
                 @"adId" : [self adIdFor:ad],
                 @"eventName" : @"onAdFailedToLoad",
                 @"loadAdError" : error
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

- (void)onAdOpened:(id<FLTAd> _Nonnull)ad {
  [_channel invokeMethod:@"onAdEvent"
               arguments:@{@"adId" : [self adIdFor:ad], @"eventName" : @"onAdOpened"}];
}

- (void)onApplicationExit:(id<FLTAd> _Nonnull)ad {
  [_channel invokeMethod:@"onAdEvent"
               arguments:@{@"adId" : [self adIdFor:ad], @"eventName" : @"onApplicationExit"}];
}

- (void)onAdClosed:(id<FLTAd> _Nonnull)ad {
  [_channel invokeMethod:@"onAdEvent"
               arguments:@{@"adId" : [self adIdFor:ad], @"eventName" : @"onAdClosed"}];
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
@end

@implementation FLTNewFirebaseAdmobViewFactory
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
