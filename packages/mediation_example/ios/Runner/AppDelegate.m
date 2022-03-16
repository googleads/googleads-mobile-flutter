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

#import <AppLovinSDK/AppLovinSDK.h>
#import <Flutter/Flutter.h>

#import "AppDelegate.h"
#import "FLTGoogleMobileAdsPlugin.h"
#import "GeneratedPluginRegistrant.h"
#import "MyFLTMediationNetworkExtrasProvider.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];

  // Register your network extras provider if you want to provide
  // network extras to specific ad requests.
  MyFLTMediationNetworkExtrasProvider *networkExtrasProvider =
      [[MyFLTMediationNetworkExtrasProvider alloc] init];
  [FLTGoogleMobileAdsPlugin
      registerMediationNetworkExtrasProvider:networkExtrasProvider
                                    registry:self];

  // Set up a method channel for calling methods in 3P SDKs.
  FlutterViewController *controller =
      (FlutterViewController *)self.window.rootViewController;

  FlutterMethodChannel *methodChannel = [FlutterMethodChannel
      methodChannelWithName:@"com.example.mediationexample/mediation-channel"
            binaryMessenger:controller.binaryMessenger];
  [methodChannel setMethodCallHandler:^(FlutterMethodCall *call,
                                        FlutterResult result) {
    if ([call.method isEqualToString:@"setIsAgeRestrictedUser"]) {
      [ALPrivacySettings
          setIsAgeRestrictedUser:call.arguments[@"isAgeRestricted"]];
      result(nil);
    } else if ([call.method isEqualToString:@"setHasUserConsent"]) {
      [ALPrivacySettings setHasUserConsent:call.arguments[@"hasUserConsent"]];
      result(nil);
    } else {
      result(FlutterMethodNotImplemented);
    }
  }];

  return [super application:application
      didFinishLaunchingWithOptions:launchOptions];
}

@end
