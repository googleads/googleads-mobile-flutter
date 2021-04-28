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

@interface FLTInterstitialAdTest : XCTestCase
@end

@implementation FLTInterstitialAdTest {
  FLTAdInstanceManager *mockManager;
}

- (void)setUp {
  mockManager = (OCMClassMock([FLTAdInstanceManager class]));
}

- (void)tearDown {
  mockManager = nil;
}

- (void)testLoadShowInterstitialAd {
  FLTAdRequest *request = OCMClassMock([FLTAdRequest class]);
  OCMStub([request keywords]).andReturn(@[ @"apple" ]);
  GADRequest *gadRequest = OCMClassMock([GADRequest class]);
  OCMStub([request asGADRequest]).andReturn(gadRequest);

  UIViewController *mockRootViewController = OCMClassMock([UIViewController class]);
  FLTInterstitialAd *ad =
      [[FLTInterstitialAd alloc] initWithAdUnitId:@"testId"
                                          request:request
                               rootViewController:mockRootViewController];
  ad.manager = mockManager;
  
  id interstitialClassMock = OCMClassMock([GADInterstitialAd class]);
  OCMStub(ClassMethod([interstitialClassMock loadWithAdUnitID:[OCMArg any]
                                                      request:[OCMArg any]
                                            completionHandler:[OCMArg any]]))
    .andDo(^(NSInvocation *invocation) {
      void (^completionHandler)(GADInterstitialAd *ad, NSError *error);
      [invocation getArgument:&completionHandler atIndex:4];
      completionHandler(interstitialClassMock, nil);
    });
  NSError *error = OCMClassMock([NSError class]);
  OCMStub([interstitialClassMock setFullScreenContentDelegate:[OCMArg any]])
  .andDo(^(NSInvocation *invocation) {
    id<GADFullScreenContentDelegate> delegate;
    [invocation getArgument:&delegate atIndex:2];
    XCTAssertEqual(delegate, ad);
    [delegate adDidRecordImpression:interstitialClassMock];
    [delegate adDidDismissFullScreenContent:interstitialClassMock];
    [delegate adDidPresentFullScreenContent:interstitialClassMock];
    [delegate adWillDismissFullScreenContent:interstitialClassMock];
    [delegate ad:interstitialClassMock didFailToPresentFullScreenContentWithError:error];
  });

  [ad load];

  OCMVerify(ClassMethod([interstitialClassMock loadWithAdUnitID:[OCMArg any]
                                          request:[OCMArg any]
                                completionHandler:[OCMArg any]]));
  OCMVerify([mockManager onAdLoaded:[OCMArg isEqual:ad]]);
  OCMVerify([interstitialClassMock setFullScreenContentDelegate:[OCMArg isEqual:ad]]);
  XCTAssertEqual(ad.interstitial, interstitialClassMock);
  
  // Show the ad
  [ad show];
  
  // Verify full screen callbacks.
  OCMVerify([mockManager onAdDidPresentFullScreenContent:[OCMArg isEqual:ad]]);
  OCMVerify([mockManager adDidDismissFullScreenContent:[OCMArg isEqual:ad]]);
  OCMVerify([mockManager adWillDismissFullScreenContent:[OCMArg isEqual:ad]]);
  OCMVerify([mockManager adDidRecordImpression:[OCMArg isEqual:ad]]);
  OCMVerify([mockManager
             didFailToPresentFullScreenContentWithError:[OCMArg isEqual:ad]
             error: [OCMArg isEqual:error]]);
}

- (void)testFailedToLoad {
  FLTAdRequest *request = OCMClassMock([FLTAdRequest class]);
  OCMStub([request keywords]).andReturn(@[ @"apple" ]);
  GADRequest *gadRequest = OCMClassMock([GADRequest class]);
  OCMStub([request asGADRequest]).andReturn(gadRequest);

  UIViewController *mockRootViewController = OCMClassMock([UIViewController class]);
  FLTInterstitialAd *ad =
      [[FLTInterstitialAd alloc] initWithAdUnitId:@"testId"
                                          request:request
                               rootViewController:mockRootViewController];
  ad.manager = mockManager;
  
  id interstitialClassMock = OCMClassMock([GADInterstitialAd class]);
  NSError *error = OCMClassMock([NSError class]);
  OCMStub(ClassMethod([interstitialClassMock loadWithAdUnitID:[OCMArg any]
                                                      request:[OCMArg any]
                                            completionHandler:[OCMArg any]]))
    .andDo(^(NSInvocation *invocation) {
      void (^completionHandler)(GADInterstitialAd *ad, NSError *error);
      [invocation getArgument:&completionHandler atIndex:4];
      completionHandler(nil, error);
    });

  [ad load];

  OCMVerify(ClassMethod([interstitialClassMock loadWithAdUnitID:[OCMArg any]
                                          request:[OCMArg any]
                                completionHandler:[OCMArg any]]));
  OCMVerify([mockManager onAdFailedToLoad:[OCMArg isEqual:ad] error:[OCMArg isEqual:error]]);
}

@end
