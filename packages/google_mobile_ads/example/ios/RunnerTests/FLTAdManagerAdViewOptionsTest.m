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

#import <XCTest/XCTest.h>

#import "FLTAd_Internal.h"

@interface FLTAdManagerAdViewOptionsTest : XCTestCase
@end

@implementation FLTAdManagerAdViewOptionsTest
- (void)testAsGADAdLoaderOptionsManualImpressionsEnabledUnset {
  FLTAdManagerAdViewOptions *options =
      [[FLTAdManagerAdViewOptions alloc] initWithManualImpressionsEnabled:nil];

  XCTAssertEqual(options.asGADAdLoaderOptions.count, 0);
}

- (void)testAsGADAdLoaderOptionsManualImpressionsEnabledYes {
  FLTAdManagerAdViewOptions *options =
      [[FLTAdManagerAdViewOptions alloc] initWithManualImpressionsEnabled:@YES];

  XCTAssertEqual(options.asGADAdLoaderOptions.count, 1);
  GADAdLoaderOptions *option = options.asGADAdLoaderOptions[0];
  XCTAssert([option isKindOfClass:[GAMBannerViewOptions class]]);
  XCTAssertTrue(((GAMBannerViewOptions *)option).enableManualImpressions);
}

- (void)testAsGADAdLoaderOptionsManualImpressionsEnabledNo {
  FLTAdManagerAdViewOptions *options =
      [[FLTAdManagerAdViewOptions alloc] initWithManualImpressionsEnabled:@NO];

  XCTAssertEqual(options.asGADAdLoaderOptions.count, 1);
  GADAdLoaderOptions *option = options.asGADAdLoaderOptions[0];
  XCTAssert([option isKindOfClass:[GAMBannerViewOptions class]]);
  XCTAssertFalse(((GAMBannerViewOptions *)option).enableManualImpressions);
}
@end
