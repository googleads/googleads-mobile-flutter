// Copyright 2026 Google LLC
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

#import "FLTAdPreloader.h"
#import "FLTAd_Internal.h"

@implementation FLTAdPreloader {
  FlutterMethodChannel *_channel;
}

- (instancetype)initWithChannel:(FlutterMethodChannel *)channel {
  self = [super init];
  if (self) {
    _channel = channel;
  }
  return self;
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
  if ([call.method isEqualToString:@"MobileAds#startPreloading"]) {
    NSString *preloadId = call.arguments[@"preloadId"];
    NSString *adUnitId = call.arguments[@"adUnitId"];
    NSNumber *bufferSize = call.arguments[@"bufferSize"];

    GADPreloadConfigurationV2 *config = [[GADPreloadConfigurationV2 alloc] init];
    if ([config respondsToSelector:@selector(initWithAdUnitID:)]) {
      config = [config initWithAdUnitID:adUnitId];
    } else if ([config respondsToSelector:@selector(setAdUnitID:)]) {
      [config performSelector:@selector(setAdUnitID:) withObject:adUnitId];
    } else {
      [config setValue:adUnitId forKey:@"adUnitID"];
    }

    if (bufferSize && bufferSize != (id)[NSNull null]) {
      if ([config respondsToSelector:@selector(setBufferSize:)]) {
        [config setValue:bufferSize forKey:@"bufferSize"];
      }
    }

    [[GADInterstitialAdPreloader sharedInstance] preloadForPreloadID:preloadId
                                               configuration:config
                                                           delegate:self];
    result(nil);
  } else if ([call.method isEqualToString:@"MobileAds#destroyPreloader"]) {
    NSString *preloadId = call.arguments[@"preloadId"];
    [[GADInterstitialAdPreloader sharedInstance] stopPreloadingAndRemoveAdsForPreloadID:preloadId];
    result(nil);
  } else if ([call.method isEqualToString:@"MobileAds#destroyAllPreloaders"]) {
    [[GADInterstitialAdPreloader sharedInstance] stopPreloadingAndRemoveAllAds];
    result(nil);
  } else if ([call.method isEqualToString:@"MobileAds#isPreloadedAdAvailable"]) {
    NSString *preloadId = call.arguments[@"preloadId"];
    BOOL available = [[GADInterstitialAdPreloader sharedInstance] isAdAvailableWithPreloadID:preloadId];
    result(@(available));
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)preloader:(GADInterstitialAdPreloader *)preloader didPreloadAd:(GADInterstitialAd *)ad {
  NSString *preloadId = nil;
  if ([preloader respondsToSelector:@selector(preloadID)]) {
    preloadId = [preloader performSelector:@selector(preloadID)];
  } else if ([preloader respondsToSelector:@selector(preloadId)]) {
    preloadId = [preloader performSelector:@selector(preloadId)];
  }

  if (!preloadId) {
    return;
  }

  FLTGADResponseInfo *responseInfo = [[FLTGADResponseInfo alloc] initWithResponseInfo:ad.responseInfo];
  [_channel invokeMethod:@"onPreloadEvent"
               arguments:@{
                 @"preloadId" : preloadId,
                 @"eventName" : @"onAdPreloaded",
                 @"responseInfo" : responseInfo
               }];
}

- (void)preloader:(GADInterstitialAdPreloader *)preloader didFailToPreloadAdWithError:(NSError *)error {
  NSString *preloadId = nil;
  if ([preloader respondsToSelector:@selector(preloadID)]) {
    preloadId = [preloader performSelector:@selector(preloadID)];
  } else if ([preloader respondsToSelector:@selector(preloadId)]) {
    preloadId = [preloader performSelector:@selector(preloadId)];
  }

  if (!preloadId) {
    return;
  }

  FLTLoadAdError *loadAdError = [[FLTLoadAdError alloc] initWithError:error];
  [_channel invokeMethod:@"onPreloadEvent"
               arguments:@{
                 @"preloadId" : preloadId,
                 @"eventName" : @"onAdFailedToPreload",
                 @"error" : loadAdError
               }];
}

- (void)preloaderDidExhaustPreloadedAds:(GADInterstitialAdPreloader *)preloader {
  NSString *preloadId = nil;
  if ([preloader respondsToSelector:@selector(preloadID)]) {
    preloadId = [preloader performSelector:@selector(preloadID)];
  } else if ([preloader respondsToSelector:@selector(preloadId)]) {
    preloadId = [preloader performSelector:@selector(preloadId)];
  }

  if (!preloadId) {
    return;
  }

  [_channel invokeMethod:@"onPreloadEvent"
               arguments:@{
                 @"preloadId" : preloadId,
                 @"eventName" : @"onAdsExhausted"
               }];
}

@end
