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

#import "FLTAdUtil.h"
#import "FLTConstants.h"
@import webview_flutter_wkwebview;

@implementation FLTAdUtil

static NSString *_requestAgent;

+ (BOOL)isNull:(id)object {
  return object == nil || [[NSNull null] isEqual:object];
}

+ (BOOL)isNotNull:(id)object {
  return ![FLTAdUtil isNull:object];
}

+ (NSString *)requestAgent {
  NSString *newsTemplateString = @"";
  id newsTemplateVersion = [NSBundle.mainBundle
      objectForInfoDictionaryKey:@"FLTNewsTemplateVersion"];
  if ([newsTemplateVersion isKindOfClass:[NSString class]]) {
    newsTemplateString =
        [NSString stringWithFormat:@"_News-%@", newsTemplateVersion];
  }

  NSString *gameTemplateString = @"";
  id gameTemplateVersion = [NSBundle.mainBundle
      objectForInfoDictionaryKey:@"FLTGameTemplateVersion"];
  if ([gameTemplateVersion isKindOfClass:[NSString class]]) {
    gameTemplateString =
        [NSString stringWithFormat:@"_Game-%@", gameTemplateVersion];
  }
  return [NSString stringWithFormat:@"%@%@%@", FLT_REQUEST_AGENT_VERSIONED,
                                    newsTemplateString, gameTemplateString];
}

+ (WKWebView *)getWebView:(NSNumber *)webViewId
    flutterPluginRegistry:(id<FlutterPluginRegistry>)flutterPluginRegistry {
  return (WKWebView *)[FWFWebViewFlutterWKWebViewExternalAPI
      webViewForIdentifier:webViewId.longValue
        withPluginRegistry:flutterPluginRegistry];
}

+ (UIViewController *)rootViewControllerFromRegistrar:
    (NSObject<FlutterPluginRegistrar> *)registrar {
  UIViewController *root = registrar.viewController;
  if ([FLTAdUtil isNull:root]) {
// UIApplication.sharedApplication.delegate.window is not guaranteed to be
// set. Use the keyWindow in this case.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    root = UIApplication.sharedApplication.keyWindow.rootViewController;
#pragma clang diagnostic pop
  }

  // Get the presented view controller. This fixes an issue in the add to app
  // case: https://github.com/googleads/googleads-mobile-flutter/issues/700
  UIViewController *presentedViewController = root;
  while (presentedViewController.presentedViewController &&
         ![presentedViewController.presentedViewController isBeingDismissed]) {
    if ([presentedViewController isKindOfClass:[UITabBarController class]]) {
      UITabBarController *tabBarController =
          (UITabBarController *)presentedViewController;
      presentedViewController = tabBarController.selectedViewController;
    } else if ([presentedViewController
                   isKindOfClass:[UINavigationController class]]) {
      UINavigationController *navigationController =
          (UINavigationController *)presentedViewController;
      presentedViewController = navigationController.visibleViewController;
    } else {
      presentedViewController = presentedViewController.presentedViewController;
    }
  }
  return presentedViewController;
}

@end
