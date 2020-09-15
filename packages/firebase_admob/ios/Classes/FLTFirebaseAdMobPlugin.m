// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "FLTFirebaseAdMobPlugin.h"

@interface FLTFirebaseAdMobPlugin ()
@property(nonatomic, retain) FlutterMethodChannel *channel;
@property NSMutableDictionary<NSString *, id<FLTNativeAdFactory>> *nativeAdFactories;
@end

@implementation FLTFirebaseAdMobPlugin {
  NSMutableDictionary<NSString *, id<FLTNativeAdFactory>> *_nativeAdFactories;
  FLTAdInstanceManager *_manager;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  FLTFirebaseAdMobPlugin *instance =
      [[FLTFirebaseAdMobPlugin alloc] initWithBinaryMessenger:registrar.messenger];
  [registrar publish:instance];

  FLTFirebaseAdMobReaderWriter *readerWriter = [[FLTFirebaseAdMobReaderWriter alloc] init];
  NSObject<FlutterMethodCodec> *codec =
      [FlutterStandardMethodCodec codecWithReaderWriter:readerWriter];

  FlutterMethodChannel *channel =
      [FlutterMethodChannel methodChannelWithName:@"plugins.flutter.io/firebase_admob"
                                  binaryMessenger:[registrar messenger]
                                            codec:codec];
  [registrar addMethodCallDelegate:instance channel:channel];

  FLTNewFirebaseAdmobViewFactory *viewFactory =
      [[FLTNewFirebaseAdmobViewFactory alloc] initWithManager:instance->_manager];
  [registrar registerViewFactory:viewFactory withId:@"plugins.flutter.io/firebase_admob/ad_widget"];
}

- (instancetype)init {
  self = [super init];
  if (self && ![FIRApp appNamed:@"__FIRAPP_DEFAULT"]) {
    NSLog(@"Configuring the default Firebase app...");
    [FIRApp configure];
    NSLog(@"Configured the default Firebase app %@.", [FIRApp defaultApp].name);
  }

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

+ (BOOL)registerNativeAdFactory:(NSObject<FlutterPluginRegistry> *)registry
                      factoryId:(NSString *)factoryId
                nativeAdFactory:(NSObject<FLTNativeAdFactory> *)nativeAdFactory {
  NSString *pluginClassName = NSStringFromClass([FLTFirebaseAdMobPlugin class]);
  FLTFirebaseAdMobPlugin *adMobPlugin =
      (FLTFirebaseAdMobPlugin *)[registry valuePublishedByPlugin:pluginClassName];
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

+ (id<FLTNativeAdFactory>)unregisterNativeAdFactory:(NSObject<FlutterPluginRegistry> *)registry
                                          factoryId:(NSString *)factoryId {
  FLTFirebaseAdMobPlugin *adMobPlugin = (FLTFirebaseAdMobPlugin *)[registry
      valuePublishedByPlugin:NSStringFromClass([FLTFirebaseAdMobPlugin class])];

  id<FLTNativeAdFactory> factory = adMobPlugin.nativeAdFactories[factoryId];
  if (factory) [adMobPlugin.nativeAdFactories removeObjectForKey:factoryId];
  return factory;
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
  UIViewController *rootController =
      UIApplication.sharedApplication.delegate.window.rootViewController;

  if ([call.method isEqualToString:@"loadBannerAd"]) {
    FLTNewBannerAd *ad = [[FLTNewBannerAd alloc] initWithAdUnitId:call.arguments[@"adUnitId"]
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
      result([FlutterError errorWithCode:@"NatvieAdError" message:message details:nil]);
      return;
    }

    FLTNewNativeAd *ad = [[FLTNewNativeAd alloc] initWithAdUnitId:call.arguments[@"adUnitId"]
                                                          request:call.arguments[@"request"]
                                                  nativeAdFactory:(id)factory
                                                    customOptions:call.arguments[@"customOptions"]
                                               rootViewController:rootController];
    [_manager loadAd:ad adId:call.arguments[@"adId"]];
    result(nil);
  } else if ([call.method isEqualToString:@"loadInterstitialAd"]) {
    FLTNewInterstitialAd *ad =
        [[FLTNewInterstitialAd alloc] initWithAdUnitId:call.arguments[@"adUnitId"]
                                               request:call.arguments[@"request"]
                                    rootViewController:rootController];

    [_manager loadAd:ad adId:call.arguments[@"adId"]];
    result(nil);
  } else if ([call.method isEqualToString:@"loadRewardedAd"]) {
    FLTNewRewardedAd *ad = [[FLTNewRewardedAd alloc] initWithAdUnitId:call.arguments[@"adUnitId"]
                                                              request:call.arguments[@"request"]
                                                   rootViewController:rootController];
    [_manager loadAd:ad adId:call.arguments[@"adId"]];
    result(nil);
  } else if ([call.method isEqualToString:@"disposeAd"]) {
    [_manager dispose:call.arguments[@"adId"]];
    result(nil);
  } else if ([call.method isEqualToString:@"showAdWithoutView"]) {
    [_manager showAdWithID:call.arguments[@"adId"]];
    result(nil);
  }
}
@end
