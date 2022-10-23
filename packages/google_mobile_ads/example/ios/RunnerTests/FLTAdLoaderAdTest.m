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

#import <OCMock/OCMock.h>
#import <XCTest/XCTest.h>

#import "FLTAd_Internal.h"

@interface FLTAdLoaderAdTest : XCTestCase
@end

@implementation FLTAdLoaderAdTest
- (void)testDelegates {
  UIViewController *viewController = OCMClassMock([UIViewController class]);
  FLTAdInstanceManager *manager = OCMClassMock([FLTAdInstanceManager class]);

  FLTAdLoaderAd *ad =
      [[FLTAdLoaderAd alloc] initWithAdUnitId:@"testAdUnitId"
                                      request:[[FLTAdRequest alloc] init]
                           rootViewController:viewController
                                         adId:@0];

  ad.manager = manager;

  [ad load];

  XCTAssertEqual(ad.adLoader.delegate, ad);

  // GADAdLoaderDelegate
  NSError *error = [NSError errorWithDomain:@"domain" code:1 userInfo:nil];
  [ad.adLoader.delegate adLoader:ad.adLoader.delegate
      didFailToReceiveAdWithError:error];

  OCMVerify([manager onAdFailedToLoad:[OCMArg isEqual:ad]
                                error:[OCMArg isEqual:error]]);
}

- (void)testLoadAdLoaderAd {
  FLTAdRequest *request = [[FLTAdRequest alloc] init];
  request.keywords = @[ @"apple" ];
  [self testLoadAdLoaderAd:request];
}

- (void)testLoadAdLoaderAdWithGAMRequest {
  FLTGAMAdRequest *request = [[FLTGAMAdRequest alloc] init];
  request.keywords = @[ @"apple" ];
  [self testLoadAdLoaderAd:request];
}

- (void)testLoadAdLoaderAd:(FLTAdRequest *)request {
  UIViewController *viewController = OCMClassMock([UIViewController class]);

  FLTAdLoaderAd *ad = [[FLTAdLoaderAd alloc] initWithAdUnitId:@"testAdUnitId"
                                                      request:request
                                           rootViewController:viewController
                                                         adId:@1];

  XCTAssertEqual(ad.adLoader.adUnitID, @"testAdUnitId");
  XCTAssertEqual(ad.adLoader.delegate, ad);

  FLTAdLoaderAd *mockAdLoaderAd = OCMPartialMock(ad);
  GADAdLoader *mockLoader = OCMPartialMock([ad adLoader]);
  OCMStub([mockAdLoaderAd adLoader]).andReturn(mockLoader);
  [mockAdLoaderAd load];

  OCMVerify([mockLoader loadRequest:[OCMArg checkWithBlock:^BOOL(id obj) {
                          GADRequest *requestArg = obj;
                          return [requestArg.keywords
                              isEqualToArray:@[ @"apple" ]];
                        }]]);
}
@end
