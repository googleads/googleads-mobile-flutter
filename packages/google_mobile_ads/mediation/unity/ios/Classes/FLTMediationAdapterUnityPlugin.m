#import "FLTMediationAdapterUnityPlugin.h"

#import <UnityAds/UnityAds.h>

@implementation FLTMediationAdapterUnityPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"unity"
            binaryMessenger:[registrar messenger]];
  FLTMediationAdapterUnityPlugin* instance = [[FLTMediationAdapterUnityPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"setGDPRConsent" isEqualToString:call.method]) {
    id value = call.arguments[@"gdprConsent"];
    if (![value isKindOfClass:[NSNumber class]]) {
      NSLog(@"Invalid gdprConsent parameter, Boolean expected");
      result(FlutterMethodNotImplemented);
      return;
    }
    UADSMetaData *gdprMetaData = [[UADSMetaData alloc] init];
    [gdprMetaData set:@"gdpr.consent" value:value];
    [gdprMetaData commit];
    result(nil);
  } else if ([@"setCCPAConsent" isEqualToString:call.method]) {
    id value = call.arguments[@"ccpaConsent"];
    if (![value isKindOfClass:[NSNumber class]]) {
      NSLog(@"Invalid ccpaConsent parameter, Boolean expected");
      result(FlutterMethodNotImplemented);
      return;
    }
    UADSMetaData *ccpaMetaData = [[UADSMetaData alloc] init];
    [ccpaMetaData set:@"privacy.consent" value:value];
    [ccpaMetaData commit];
    result(nil);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
