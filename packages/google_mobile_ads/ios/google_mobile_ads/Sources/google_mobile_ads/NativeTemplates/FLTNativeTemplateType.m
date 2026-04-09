// Copyright 2022 Google LLC
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

#import "FLTNativeTemplateType.h"

#ifndef SWIFTPM_MODULE_BUNDLE
    #define SWIFTPM_MODULE_BUNDLE [NSBundle bundleForClass:[FLTGoogleMobileAdsPlugin class]]
#endif

@implementation FLTNativeTemplateType {
  int _intValue;
}

- (instancetype _Nonnull)initWithInt:(int)intValue {
  self = [super init];
  if (self) {
    _intValue = intValue;
  }
  return self;
}

- (NSString *_Nonnull)xibName {
  switch (_intValue) {
  case 0:
    return @"GADTSmallTemplateView";
  case 1:
    return @"GADTMediumTemplateView";
  default:
    NSLog(@"Unknown template type value: %d", _intValue);
    return @"GADTMediumTemplateView";
  }
}

- (GADTTemplateView *_Nonnull)templateView {
  // Bundle file name is declared in Package.swift or podspec
  NSBundle *adsBundle = nil;

  NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:@"google_mobile_ads"
                                             withExtension:@"bundle"];
  if (bundleURL) {
    adsBundle = [NSBundle bundleWithURL:bundleURL];
  } else {
    #ifdef SWIFTPM_MODULE_BUNDLE
      adsBundle = SWIFTPM_MODULE_BUNDLE;
    #else
      adsBundle = [NSBundle bundleForClass:[self class]];
    #endif
  }
  if (!adsBundle) {
    adsBundle = [NSBundle mainBundle];
  }

  GADTTemplateView *templateView =
    [adsBundle loadNibNamed:self.xibName owner:nil options:nil].firstObject;
  return templateView;
}

@end
