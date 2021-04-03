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

#import "FLTGoogleMobileAdsPlugin.h"

@interface FLTGoogleMobileAdsPlugin ()
@property(nonatomic, retain) FlutterMethodChannel *channel;
@property NSMutableDictionary<NSString *, id<FLTNativeAdFactory>> *nativeAdFactories;
@end

@implementation FLTGoogleMobileAdsPlugin {
  NSMutableDictionary<NSString *, id<FLTNativeAdFactory>> *_nativeAdFactories;
  FLTAdInstanceManager *_manager;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  FLTGoogleMobileAdsPlugin *instance =
      [[FLTGoogleMobileAdsPlugin alloc] initWithBinaryMessenger:registrar.messenger];
  [registrar publish:instance];

  FLTGoogleMobileAdsReaderWriter *readerWriter = [[FLTGoogleMobileAdsReaderWriter alloc] init];
  NSObject<FlutterMethodCodec> *codec =
      [FlutterStandardMethodCodec codecWithReaderWriter:readerWriter];

  FlutterMethodChannel *channel =
      [FlutterMethodChannel methodChannelWithName:@"plugins.flutter.io/google_mobile_ads"
                                  binaryMessenger:[registrar messenger]
                                            codec:codec];
  [registrar addMethodCallDelegate:instance channel:channel];

  FLTNewGoogleMobileAdsViewFactory *viewFactory =
      [[FLTNewGoogleMobileAdsViewFactory alloc] initWithManager:instance->_manager];
  [registrar registerViewFactory:viewFactory
                          withId:@"plugins.flutter.io/google_mobile_ads/ad_widget"];
}

- (instancetype)init {
  self = [super init];
  return self;
}

- (instancetype)initWithBinaryMessenger:(id<FlutterBinaryMessenger>)binaryMessenger {
  self = [self init];
  if (self) {
    _nativeAdFactories = [NSMutableDictionary dictionary];
    _manager = [[FLTAdInstanceManager alloc] initWithBinaryMessenger:binaryMessenger];
  }

  return self;
}

+ (BOOL)registerNativeAdFactory:(id<FlutterPluginRegistry>)registry
                      factoryId:(NSString *)factoryId
                nativeAdFactory:(id<FLTNativeAdFactory>)nativeAdFactory {
  NSString *pluginClassName = NSStringFromClass([FLTGoogleMobileAdsPlugin class]);
  FLTGoogleMobileAdsPlugin *adMobPlugin =
      (FLTGoogleMobileAdsPlugin *)[registry valuePublishedByPlugin:pluginClassName];
  if (!adMobPlugin) {
    NSString *reason = [NSString
        stringWithFormat:@"Could not find a %@ instance. The plugin may have not been registered.",
                         pluginClassName];
    [NSException exceptionWithName:NSInvalidArgumentException reason:reason userInfo:nil];
  }

  if (adMobPlugin.nativeAdFactories[factoryId]) {
    NSLog(@"A NativeAdFactory with the following factoryId already exists: %@", factoryId);
    return NO;
  }

  [adMobPlugin.nativeAdFactories setValue:nativeAdFactory forKey:factoryId];
  return YES;
}

+ (id<FLTNativeAdFactory>)unregisterNativeAdFactory:(id<FlutterPluginRegistry>)registry
                                          factoryId:(NSString *)factoryId {
  FLTGoogleMobileAdsPlugin *adMobPlugin = (FLTGoogleMobileAdsPlugin *)[registry
      valuePublishedByPlugin:NSStringFromClass([FLTGoogleMobileAdsPlugin class])];

  id<FLTNativeAdFactory> factory = adMobPlugin.nativeAdFactories[factoryId];
  if (factory) [adMobPlugin.nativeAdFactories removeObjectForKey:factoryId];
  return factory;
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
  UIViewController *rootController =
      UIApplication.sharedApplication.delegate.window.rootViewController;

  if ([call.method isEqualToString:@"MobileAds#initialize"]) {
    [[GADMobileAds sharedInstance]
        startWithCompletionHandler:^(GADInitializationStatus *_Nonnull status) {
          result([[FLTInitializationStatus alloc] initWithStatus:status]);
        }];
  } else if ([call.method isEqualToString:@"_init"]) {
    [_manager disposeAllAds];
    result(nil);
  } else if ([call.method isEqualToString:@"MobileAds#updateRequestConfiguration"]) {
    NSString *maxAdContentRating = call.arguments[@"maxAdContentRating"];
    NSNumber *tagForChildDirectedTreatment = call.arguments[@"tagForChildDirectedTreatment"];
    NSNumber *tagForUnderAgeOfConsent = call.arguments[@"tagForUnderAgeOfConsent"];
    NSArray<NSString *> *testDeviceIds = call.arguments[@"testDeviceIds"];

    if (maxAdContentRating != NULL && maxAdContentRating != (id)[NSNull null]) {
      if ([maxAdContentRating isEqualToString:@"G"]) {
        GADMobileAds.sharedInstance.requestConfiguration.maxAdContentRating =
            GADMaxAdContentRatingGeneral;
      } else if ([maxAdContentRating isEqualToString:@"PG"]) {
        GADMobileAds.sharedInstance.requestConfiguration.maxAdContentRating =
            GADMaxAdContentRatingParentalGuidance;
      } else if ([maxAdContentRating isEqualToString:@"T"]) {
        GADMobileAds.sharedInstance.requestConfiguration.maxAdContentRating =
            GADMaxAdContentRatingTeen;
      } else if ([maxAdContentRating isEqualToString:@"MA"]) {
        GADMobileAds.sharedInstance.requestConfiguration.maxAdContentRating =
            GADMaxAdContentRatingMatureAudience;
      }
    }
    if (tagForChildDirectedTreatment != NULL && tagForChildDirectedTreatment != (id)[NSNull null]) {
      switch ([tagForChildDirectedTreatment intValue]) {
        case 0:
          [GADMobileAds.sharedInstance.requestConfiguration tagForChildDirectedTreatment:NO];
          break;
        case 1:
          [GADMobileAds.sharedInstance.requestConfiguration tagForChildDirectedTreatment:YES];
          break;
      }
    }
    if (tagForUnderAgeOfConsent != NULL && tagForUnderAgeOfConsent != (id)[NSNull null]) {
      switch ([tagForUnderAgeOfConsent intValue]) {
        case 0:
          [GADMobileAds.sharedInstance.requestConfiguration tagForUnderAgeOfConsent:NO];
          break;
        case 1:
          [GADMobileAds.sharedInstance.requestConfiguration tagForUnderAgeOfConsent:YES];
          break;
      }
    }
    if (testDeviceIds != NULL && testDeviceIds != (id)[NSNull null]) {
      GADMobileAds.sharedInstance.requestConfiguration.testDeviceIdentifiers = testDeviceIds;
    }
    result(nil);
  } else if ([call.method isEqualToString:@"loadBannerAd"]) {
    FLTBannerAd *ad = [[FLTBannerAd alloc] initWithAdUnitId:call.arguments[@"adUnitId"]
                                                       size:call.arguments[@"size"]
                                                    request:call.arguments[@"request"]
                                         rootViewController:rootController];
    [_manager loadAd:ad adId:call.arguments[@"adId"]];
    result(nil);
  } else if ([call.method isEqualToString:@"loadPublisherBannerAd"]) {
    FLTPublisherBannerAd *ad =
        [[FLTPublisherBannerAd alloc] initWithAdUnitId:call.arguments[@"adUnitId"]
                                                 sizes:call.arguments[@"sizes"]
                                               request:call.arguments[@"request"]
                                    rootViewController:rootController];
    [_manager loadAd:ad adId:call.arguments[@"adId"]];
    result(nil);
  } else if ([call.method isEqualToString:@"loadNativeAd"]) {
    NSString *factoryId = call.arguments[@"factoryId"];
    id<FLTNativeAdFactory> factory = _nativeAdFactories[factoryId];

    if (!factory) {
      NSString *message =
          [NSString stringWithFormat:@"Can't find NativeAdFactory with id: %@", factoryId];
      result([FlutterError errorWithCode:@"NativeAdError" message:message details:nil]);
      return;
    }

    FLTAdRequest *request;
    if (![call.arguments[@"request"] isEqual:[NSNull null]]) {
      request = call.arguments[@"request"];
    } else if (![call.arguments[@"publisherRequest"] isEqual:[NSNull null]]) {
      request = call.arguments[@"publisherRequest"];
    }

    FLTNativeAd *ad = [[FLTNativeAd alloc] initWithAdUnitId:call.arguments[@"adUnitId"]
                                                    request:request
                                            nativeAdFactory:(id)factory
                                              customOptions:call.arguments[@"customOptions"]
                                         rootViewController:rootController];
    [_manager loadAd:ad adId:call.arguments[@"adId"]];
    result(nil);
  } else if ([call.method isEqualToString:@"loadInterstitialAd"]) {
    FLTInterstitialAd *ad = [[FLTInterstitialAd alloc] initWithAdUnitId:call.arguments[@"adUnitId"]
                                                                request:call.arguments[@"request"]
                                                     rootViewController:rootController];

    [_manager loadAd:ad adId:call.arguments[@"adId"]];
    result(nil);
  } else if ([call.method isEqualToString:@"loadPublisherInterstitialAd"]) {
    FLTPublisherInterstitialAd *ad =
        [[FLTPublisherInterstitialAd alloc] initWithAdUnitId:call.arguments[@"adUnitId"]
                                                     request:call.arguments[@"request"]
                                          rootViewController:rootController];

    [_manager loadAd:ad adId:call.arguments[@"adId"]];
    result(nil);
  } else if ([call.method isEqualToString:@"loadRewardedAd"]) {
    FLTAdRequest *request;
    if (![call.arguments[@"request"] isEqual:[NSNull null]]) {
      request = call.arguments[@"request"];
    } else if (![call.arguments[@"publisherRequest"] isEqual:[NSNull null]]) {
      request = call.arguments[@"publisherRequest"];
    } else {
      result([FlutterError errorWithCode:@"InvalidRequest"
                                 message:@"A null or invalid ad request was provided."
                                 details:nil]);
      return;
    }

    FLTRewardedAd *ad =
        [[FLTRewardedAd alloc] initWithAdUnitId:call.arguments[@"adUnitId"]
                                        request:request
                             rootViewController:rootController
                  serverSideVerificationOptions:call.arguments[@"serverSideVerificationOptions"]];
    [_manager loadAd:ad adId:call.arguments[@"adId"]];
    result(nil);
  } else if ([call.method isEqualToString:@"disposeAd"]) {
    [_manager dispose:call.arguments[@"adId"]];
    result(nil);
  } else if ([call.method isEqualToString:@"showAdWithoutView"]) {
    [_manager showAdWithID:call.arguments[@"adId"]];
    result(nil);
  } else {
    result(FlutterMethodNotImplemented);
  }
}
@end
