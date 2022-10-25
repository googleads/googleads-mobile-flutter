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
                                         adId:@0
                                       banner:nil];

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

- (void)testBannerDelegates {
  UIViewController *viewController = OCMClassMock([UIViewController class]);
  FLTAdInstanceManager *manager = OCMClassMock([FLTAdInstanceManager class]);

  FLTAdSize *adSize = [[FLTAdSize alloc] initWithWidth:@(1) height:@(2)];
  FLTAdLoaderAd *ad = [[FLTAdLoaderAd alloc]
        initWithAdUnitId:@"testAdUnitId"
                 request:[[FLTAdRequest alloc] init]
      rootViewController:viewController
                    adId:@0
                  banner:[[FLTBannerParameters alloc] initWithSizes:@[ adSize ]
                                                            options:nil]];

  ad.manager = manager;

  [ad load];

  // GAMBannerAdLoaderDelegate
  NSArray<NSValue *> *validSizes = [ad validBannerSizesForAdLoader:ad.adLoader];
  XCTAssertEqual(validSizes.count, 1);
  XCTAssertEqualObjects(validSizes[0], NSValueFromGADAdSize(adSize.size));

  GAMBannerView *bannerView = OCMClassMock([GAMBannerView class]);
  OCMStub([bannerView adSize]).andReturn(GADAdSizeFromCGSize(CGSizeMake(0, 0)));
  OCMStub([bannerView recordImpression]);

  [ad adLoader:ad.adLoader didReceiveGAMBannerView:bannerView];

  XCTAssertEqual([ad adLoaderAdType], FLTAdLoaderAdTypeBanner);

  OCMVerify([bannerView setAppEventDelegate:[OCMArg isEqual:ad]]);
  OCMVerify([bannerView setDelegate:[OCMArg isEqual:ad]]);
  OCMVerify([manager onAdLoaded:[OCMArg isEqual:ad]
                   responseInfo:[OCMArg isEqual:nil]]);

  FLTAdSize *size = [ad adSize];
  XCTAssertEqualObjects(size.width, @0);
  XCTAssertEqualObjects(size.height, @0);

  OCMVerify([bannerView adSize]);

  // GADBannerViewDelegate
  NSError *error = [NSError errorWithDomain:@"domain" code:1 userInfo:nil];
  [ad bannerView:bannerView didFailToReceiveAdWithError:error];
  OCMVerify([manager onAdFailedToLoad:[OCMArg isEqual:ad] error:error]);

  [ad bannerViewDidRecordImpression:bannerView];
  OCMVerify([manager onBannerImpression:[OCMArg isEqual:ad]]);

  [ad bannerViewDidRecordClick:bannerView];
  OCMVerify([manager adDidRecordClick:[OCMArg isEqual:ad]]);

  [ad bannerViewWillPresentScreen:bannerView];
  OCMVerify([manager onBannerWillPresentScreen:[OCMArg isEqual:ad]]);

  [ad bannerViewWillDismissScreen:bannerView];
  OCMVerify([manager onBannerWillDismissScreen:[OCMArg isEqual:ad]]);

  [ad bannerViewDidDismissScreen:bannerView];
  OCMVerify([manager onBannerDidDismissScreen:[OCMArg isEqual:ad]]);

  // GADAppEventDelegate
  [ad adView:bannerView didReceiveAppEvent:@"name" withInfo:@"info"];
  OCMVerify([manager onAppEvent:[OCMArg isEqual:ad]
                           name:[OCMArg isEqual:@"name"]
                           data:[OCMArg isEqual:@"info"]]);
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
                                                         adId:@1
                                                       banner:nil];

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
