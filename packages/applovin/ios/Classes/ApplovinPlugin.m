#import "ApplovinPlugin.h"

#import <AppLovinSDK/AppLovinSDK.h>

@implementation ApplovinPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"applovin"
            binaryMessenger:[registrar messenger]];
  ApplovinPlugin* instance = [[ApplovinPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)setDoNotSell: (BOOL)doNotSell {
  [ALPrivacySettings setDoNotSell: doNotSell];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"setDoNotSell" isEqualToString:call.method]) {
    id value = call.arguments[@"doNotSell"];
    if (![value isKindOfClass:[NSNumber class]] ) {
      NSLog(@"doNotSell is not an NSNumber");
      return;
    }
    [self setDoNotSell: [value boolValue]];
    result(nil);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
