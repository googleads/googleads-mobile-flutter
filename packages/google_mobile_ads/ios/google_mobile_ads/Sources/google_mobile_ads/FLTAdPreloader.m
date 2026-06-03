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
#import "FLTAdUtil.h"
#import "FLTAdInstanceManager_Internal.h"

@implementation FLTAdPreloader {
  FlutterMethodChannel *_channel;
  FLTAdInstanceManager *_manager;
}

- (instancetype)initWithChannel:(FlutterMethodChannel *)channel
                        manager:(FLTAdInstanceManager *)manager {
  self = [super init];
  if (self) {
    _channel = channel;
    _manager = manager;
  }
  return self;
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
  if ([call.method isEqualToString:@"MobileAds#startPreloading"]) {
    NSString *preloadId = call.arguments[@"preloadId"];
    NSString *adUnitId = call.arguments[@"adUnitId"];
    NSNumber *bufferSize = call.arguments[@"bufferSize"];
    NSString *className = call.arguments[@"className"];
    FLTAdRequest *request = call.arguments[@"request"];

    if (!className || className == (id)[NSNull null]) {
      result([FlutterError errorWithCode:@"PreloadError" message:@"Missing className argument." details:nil]);
      return;
    }

    GADRequest *gadRequest = [FLTAdUtil isNotNull:request] ? [request asGADRequest:adUnitId] : [GADRequest request];
    id allocatedConfig = [GADPreloadConfigurationV2 alloc];
    GADPreloadConfigurationV2 *config;

    if ([allocatedConfig respondsToSelector:@selector(initWithAdUnitID:request:)]) {
      config = [allocatedConfig initWithAdUnitID:adUnitId request:gadRequest];
    } else if ([allocatedConfig respondsToSelector:@selector(initWithAdUnitID:)]) {
      config = [allocatedConfig initWithAdUnitID:adUnitId];
      if ([config respondsToSelector:@selector(setRequest:)]) {
        [config setValue:gadRequest forKey:@"request"];
      } else if ([config respondsToSelector:@selector(setAdRequest:)]) {
        [config setValue:gadRequest forKey:@"adRequest"];
      } else {
        @try {
          [config setValue:gadRequest forKey:@"request"];
        } @catch (NSException *exception) {
          // Ignore
        }
      }
    } else {
      config = [allocatedConfig init];
      if ([config respondsToSelector:@selector(setAdUnitID:)]) {
        [config performSelector:@selector(setAdUnitID:) withObject:adUnitId];
      } else {
        [config setValue:adUnitId forKey:@"adUnitID"];
      }
      if ([config respondsToSelector:@selector(setRequest:)]) {
        [config setValue:gadRequest forKey:@"request"];
      } else if ([config respondsToSelector:@selector(setAdRequest:)]) {
        [config setValue:gadRequest forKey:@"adRequest"];
      } else {
        @try {
          [config setValue:gadRequest forKey:@"request"];
        } @catch (NSException *exception) {
          // Ignore
        }
      }
    }

    if (bufferSize && bufferSize != (id)[NSNull null]) {
      if ([config respondsToSelector:@selector(setBufferSize:)]) {
        [config setValue:bufferSize forKey:@"bufferSize"];
      }
    }

    if ([className isEqualToString:@"InterstitialAd"] || [className isEqualToString:@"AdManagerInterstitialAd"]) {
      [[GADInterstitialAdPreloader sharedInstance] preloadForPreloadID:preloadId
                                                 configuration:config
                                                              delegate:self];
    } else if ([className isEqualToString:@"RewardedAd"] || [className isEqualToString:@"RewardedInterstitialAd"]) {
      [[GADRewardedAdPreloader sharedInstance] preloadForPreloadID:preloadId
                                                 configuration:config
                                                              delegate:self];
    } else if ([className isEqualToString:@"AppOpenAd"]) {
      [[GADAppOpenAdPreloader sharedInstance] preloadForPreloadID:preloadId
                                                 configuration:config
                                                              delegate:self];
    } else {
      result([FlutterError errorWithCode:@"PreloadError" message:[NSString stringWithFormat:@"Unsupported className: %@", className] details:nil]);
      return;
    }
    result(nil);
  } else if ([call.method isEqualToString:@"MobileAds#destroyPreloader"]) {
    NSString *preloadId = call.arguments[@"preloadId"];
    NSString *className = call.arguments[@"className"];

    if (!className || className == (id)[NSNull null]) {
      result([FlutterError errorWithCode:@"PreloadError" message:@"Missing className argument." details:nil]);
      return;
    }

    if ([className isEqualToString:@"InterstitialAd"] || [className isEqualToString:@"AdManagerInterstitialAd"]) {
      [[GADInterstitialAdPreloader sharedInstance] stopPreloadingAndRemoveAdsForPreloadID:preloadId];
    } else if ([className isEqualToString:@"RewardedAd"] || [className isEqualToString:@"RewardedInterstitialAd"]) {
      [[GADRewardedAdPreloader sharedInstance] stopPreloadingAndRemoveAdsForPreloadID:preloadId];
    } else if ([className isEqualToString:@"AppOpenAd"]) {
      [[GADAppOpenAdPreloader sharedInstance] stopPreloadingAndRemoveAdsForPreloadID:preloadId];
    } else {
      result([FlutterError errorWithCode:@"PreloadError" message:[NSString stringWithFormat:@"Unsupported className: %@", className] details:nil]);
      return;
    }
    result(nil);
  } else if ([call.method isEqualToString:@"MobileAds#destroyAllPreloaders"]) {
    NSString *className = call.arguments[@"className"];

    if (!className || className == (id)[NSNull null]) {
      result([FlutterError errorWithCode:@"PreloadError" message:@"Missing className argument." details:nil]);
      return;
    }

    if ([className isEqualToString:@"InterstitialAd"] || [className isEqualToString:@"AdManagerInterstitialAd"]) {
      [[GADInterstitialAdPreloader sharedInstance] stopPreloadingAndRemoveAllAds];
    } else if ([className isEqualToString:@"RewardedAd"] || [className isEqualToString:@"RewardedInterstitialAd"]) {
      [[GADRewardedAdPreloader sharedInstance] stopPreloadingAndRemoveAllAds];
    } else if ([className isEqualToString:@"AppOpenAd"]) {
      [[GADAppOpenAdPreloader sharedInstance] stopPreloadingAndRemoveAllAds];
    } else {
      result([FlutterError errorWithCode:@"PreloadError" message:[NSString stringWithFormat:@"Unsupported className: %@", className] details:nil]);
      return;
    }
    result(nil);
  } else if ([call.method isEqualToString:@"MobileAds#isPreloadedAdAvailable"]) {
    NSString *preloadId = call.arguments[@"preloadId"];
    NSString *className = call.arguments[@"className"];

    if (!className || className == (id)[NSNull null]) {
      result([FlutterError errorWithCode:@"PreloadError" message:@"Missing className argument." details:nil]);
      return;
    }

    BOOL available = NO;
    if ([className isEqualToString:@"InterstitialAd"] || [className isEqualToString:@"AdManagerInterstitialAd"]) {
      available = [[GADInterstitialAdPreloader sharedInstance] isAdAvailableWithPreloadID:preloadId];
    } else if ([className isEqualToString:@"RewardedAd"] || [className isEqualToString:@"RewardedInterstitialAd"]) {
      available = [[GADRewardedAdPreloader sharedInstance] isAdAvailableWithPreloadID:preloadId];
    } else if ([className isEqualToString:@"AppOpenAd"]) {
      available = [[GADAppOpenAdPreloader sharedInstance] isAdAvailableWithPreloadID:preloadId];
    } else {
      result([FlutterError errorWithCode:@"PreloadError" message:[NSString stringWithFormat:@"Unsupported className: %@", className] details:nil]);
      return;
    }
    result(@(available));
  } else if ([call.method isEqualToString:@"MobileAds#pollAd"]) {
    NSString *preloadId = call.arguments[@"preloadId"];
    NSString *className = call.arguments[@"className"];
    NSNumber *adId = call.arguments[@"adId"];

    if (!preloadId || !className || !adId || adId == (id)[NSNull null]) {
      result([FlutterError errorWithCode:@"PreloadError" message:@"Missing arguments." details:nil]);
      return;
    }

    NSDictionary *response = nil;
    if ([className isEqualToString:@"InterstitialAd"]) {
      id preloadedAd = [[GADInterstitialAdPreloader sharedInstance] adWithPreloadID:preloadId];
      if (preloadedAd) {
        NSString *adUnitId = [preloadedAd respondsToSelector:@selector(adUnitID)] ? [preloadedAd performSelector:@selector(adUnitID)] : @"";
        FLTInterstitialAd *adWrapper =
            [[FLTInterstitialAd alloc] initWithAdUnitId:adUnitId != nil ? adUnitId : @""
                                                request:[[FLTAdRequest alloc] init]
                                                   adId:adId
                                              preloadId:preloadId];
        [_manager loadAd:adWrapper];
        response = @{@"adUnitId" : adUnitId != nil ? adUnitId : @""};
      }
    } else if ([className isEqualToString:@"AdManagerInterstitialAd"]) {
      id preloadedAd = [[GADInterstitialAdPreloader sharedInstance] adWithPreloadID:preloadId];
      if (preloadedAd) {
        NSString *adUnitId = [preloadedAd respondsToSelector:@selector(adUnitID)] ? [preloadedAd performSelector:@selector(adUnitID)] : @"";
        FLTGAMInterstitialAd *adWrapper =
            [[FLTGAMInterstitialAd alloc] initWithAdUnitId:adUnitId != nil ? adUnitId : @""
                                                   request:[[FLTGAMAdRequest alloc] init]
                                                      adId:adId
                                                 preloadId:preloadId];
        [_manager loadAd:adWrapper];
        response = @{@"adUnitId" : adUnitId != nil ? adUnitId : @""};
      }
    } else if ([className isEqualToString:@"RewardedAd"]) {
      id preloadedAd = [[GADRewardedAdPreloader sharedInstance] adWithPreloadID:preloadId];
      if (preloadedAd) {
        NSString *adUnitId = [preloadedAd respondsToSelector:@selector(adUnitID)] ? [preloadedAd performSelector:@selector(adUnitID)] : @"";
        FLTRewardedAd *adWrapper =
            [[FLTRewardedAd alloc] initWithAdUnitId:adUnitId != nil ? adUnitId : @""
                                            request:[[FLTAdRequest alloc] init]
                                               adId:adId
                                              preloadId:preloadId];
        [_manager loadAd:adWrapper];
        response = @{@"adUnitId" : adUnitId != nil ? adUnitId : @""};
      }
    } else if ([className isEqualToString:@"AppOpenAd"]) {
      id preloadedAd = [[GADAppOpenAdPreloader sharedInstance] adWithPreloadID:preloadId];
      if (preloadedAd) {
        NSString *adUnitId = [preloadedAd respondsToSelector:@selector(adUnitID)] ? [preloadedAd performSelector:@selector(adUnitID)] : @"";
        FLTAppOpenAd *adWrapper =
            [[FLTAppOpenAd alloc] initWithAdUnitId:adUnitId != nil ? adUnitId : @""
                                           request:[[FLTAdRequest alloc] init]
                                              adId:adId
                                             preloadId:preloadId];
        [_manager loadAd:adWrapper];
        response = @{@"adUnitId" : adUnitId != nil ? adUnitId : @""};
      }
    }
    result(response);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)preloader:(id)preloader didPreloadAd:(id)ad {
  NSString *preloadId = nil;
  if ([preloader respondsToSelector:@selector(preloadID)]) {
    preloadId = [preloader performSelector:@selector(preloadID)];
  } else if ([preloader respondsToSelector:@selector(preloadId)]) {
    preloadId = [preloader performSelector:@selector(preloadId)];
  }

  if (!preloadId) {
    return;
  }

  GADResponseInfo *adResponseInfo = nil;
  if ([ad respondsToSelector:@selector(responseInfo)]) {
    adResponseInfo = [ad performSelector:@selector(responseInfo)];
  }

  FLTGADResponseInfo *responseInfo = [[FLTGADResponseInfo alloc] initWithResponseInfo:adResponseInfo];
  [_channel invokeMethod:@"onPreloadEvent"
               arguments:@{
                 @"preloadId" : preloadId,
                 @"eventName" : @"onAdPreloaded",
                 @"responseInfo" : responseInfo
               }];
}

- (void)preloader:(id)preloader didFailToPreloadAdWithError:(NSError *)error {
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

- (void)preloaderDidExhaustPreloadedAds:(id)preloader {
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

- (void)adAvailableForPreloadID:(NSString *)preloadID
                   responseInfo:(GADResponseInfo *)responseInfo {
  FLTGADResponseInfo *fltResponseInfo =
      [[FLTGADResponseInfo alloc] initWithResponseInfo:responseInfo];
  [_channel invokeMethod:@"onPreloadEvent"
               arguments:@{
                 @"preloadId" : preloadID != nil ? preloadID : @"",
                 @"eventName" : @"onAdPreloaded",
                 @"responseInfo" : fltResponseInfo
               }];
}

- (void)failedToPreloadForPreloadID:(NSString *)preloadID error:(NSError *)error {
  FLTLoadAdError *loadAdError = [[FLTLoadAdError alloc] initWithError:error];
  [_channel invokeMethod:@"onPreloadEvent"
               arguments:@{
                 @"preloadId" : preloadID != nil ? preloadID : @"",
                 @"eventName" : @"onAdFailedToPreload",
                 @"error" : loadAdError
               }];
}

- (void)adFailedToPreloadForPreloadID:(NSString *)preloadID error:(NSError *)error {
  [self failedToPreloadForPreloadID:preloadID error:error];
}

- (void)adsExhaustedForPreloadID:(NSString *)preloadID {
  [_channel invokeMethod:@"onPreloadEvent"
               arguments:@{
                 @"preloadId" : preloadID != nil ? preloadID : @"",
                 @"eventName" : @"onAdsExhausted"
               }];
}

- (void)preloaderDidExhaustAdsForPreloadID:(NSString *)preloadID {
  [self adsExhaustedForPreloadID:preloadID];
}

@end
