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

#import <OCMock/OCMock.h>
#import <XCTest/XCTest.h>

#import "../Classes/FLTAdInstanceManager_Internal.h"
#import "../Classes/FLTAd_Internal.h"

@interface FLTNativeAdTest : XCTestCase
@end

@implementation FLTNativeAdTest {
  FLTAdInstanceManager *mockManager;
}

- (void)setUp {
  mockManager = (OCMClassMock([FLTAdInstanceManager class]));
}

- (void)testLoadNativeAd {
  FLTAdRequest *request = [[FLTAdRequest alloc] init];
  request.keywords = @[ @"apple" ];
  [self testLoadNativeAd:request];
}

- (void)testLoadNativeAdWithGAMRequest {
  FLTGAMAdRequest *request = [[FLTGAMAdRequest alloc] init];
  request.keywords = @[ @"apple" ];
  [self testLoadNativeAd:request];
}

- (void)testLoadNativeAd:(FLTAdRequest *)gadOrGAMRequest {
  id mockNativeAdFactory = OCMProtocolMock(@protocol(FLTNativeAdFactory));

  FLTNativeAd *ad = [[FLTNativeAd alloc] initWithAdUnitId:@"testAdUnitId"
                                                  request:gadOrGAMRequest
                                          nativeAdFactory:mockNativeAdFactory
                                            customOptions:nil
                                       rootViewController:OCMClassMock([UIViewController class])];
  ad.manager = mockManager;
  
  XCTAssertEqual(ad.adLoader.adUnitID, @"testAdUnitId");
  XCTAssertEqual(ad.adLoader.delegate, ad);
  
  
  FLTNativeAd *mockNativeAd = OCMPartialMock(ad);
  GADAdLoader *mockLoader = OCMPartialMock([ad adLoader]);
  OCMStub([mockNativeAd adLoader]).andReturn(mockLoader);
  [mockNativeAd load];
  
  OCMVerify([mockLoader loadRequest:[OCMArg checkWithBlock:^BOOL(id obj) {
                          GADRequest *requestArg = obj;
                          return [requestArg.keywords isEqualToArray:@[ @"apple" ]];
                        }]]);

  // Check that nil is used instead of null when customOptions is Null
  GADNativeAd *mockGADNativeAd = OCMClassMock([GADNativeAd class]);
  [ad adLoader:mockLoader didReceiveNativeAd:mockGADNativeAd];
  OCMVerify([mockNativeAdFactory createNativeAd:mockGADNativeAd customOptions:[OCMArg isNil]]);
  
  OCMStub([mockGADNativeAd setDelegate:[OCMArg checkWithBlock:^BOOL(id obj) {
    id<GADNativeAdDelegate> delegate = obj;
    [delegate nativeAdDidRecordClick:mockGADNativeAd];
    [delegate nativeAdDidRecordImpression:mockGADNativeAd];
    [delegate nativeAdWillPresentScreen:mockGADNativeAd];
    [delegate nativeAdDidDismissScreen:mockGADNativeAd];
    [delegate nativeAdWillDismissScreen:mockGADNativeAd];
    return YES;
  }]]);
  
  // Check ad loader delegate methods forward to ad instance manager.
  [(id<GADNativeAdLoaderDelegate>)ad.adLoader.delegate adLoader:mockLoader
                                             didReceiveNativeAd:mockGADNativeAd];
  
  OCMVerify([mockManager onAdLoaded:[OCMArg isEqual:ad]]);
  
  NSError *error = OCMClassMock([NSError class]);
  [(id<GADNativeAdLoaderDelegate>)ad.adLoader.delegate adLoader:mockLoader
                                    didFailToReceiveAdWithError:error];
  OCMVerify([mockManager onAdFailedToLoad:[OCMArg isEqual:ad]
                                    error:[OCMArg isEqual:error]]);
  
  // Check GADNativeAdDelegate methods forward to ad instance manager.
  OCMVerify([mockGADNativeAd setDelegate:[OCMArg isEqual:ad]]);
  OCMVerify([mockManager onNativeAdClicked:[OCMArg isEqual:ad]]);
  OCMVerify([mockManager onNativeAdImpression:[OCMArg isEqual:ad]]);
  OCMVerify([mockManager onNativeAdWillPresentScreen:[OCMArg isEqual:ad]]);
  OCMVerify([mockManager onNativeAdDidDismissScreen:[OCMArg isEqual:ad]]);
  OCMVerify([mockManager onNativeAdWillDismissScreen:[OCMArg isEqual:ad]]);
}

@end

