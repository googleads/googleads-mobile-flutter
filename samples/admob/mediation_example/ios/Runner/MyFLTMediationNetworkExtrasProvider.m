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

#import "MyFLTMediationNetworkExtrasProvider.h"
#import <AppLovinAdapter/GADMAdapterAppLovinExtras.h>
#import <Foundation/Foundation.h>
#import <GoogleMobileAds/GADAdNetworkExtras.h>

@implementation MyFLTMediationNetworkExtrasProvider

/** Provide mediation extras for specific ad requests. */
- (NSArray<id<GADAdNetworkExtras>> *_Nullable)
           getMediationExtras:(NSString *_Nonnull)adUnitId
    mediationExtrasIdentifier:(NSString *_Nullable)mediationExtrasIdentifier {
  GADMAdapterAppLovinExtras *appLovinExtras =
      [[GADMAdapterAppLovinExtras alloc] init];
  appLovinExtras.muteAudio = NO;

  return @[ appLovinExtras ];
}

@end
