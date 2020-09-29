// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <OCMock/OCMock.h>
#import <XCTest/XCTest.h>

@import firebase_admob;

@interface FLTFirebaseAdMobTest : XCTestCase
@end

@implementation FLTFirebaseAdMobTest {
  FLTAdInstanceManager *_manager;
  NSObject<FlutterBinaryMessenger> *_mockMessenger;
  NSObject<FlutterMethodCodec> *_methodCodec;
}

- (void)setUp {
  _mockMessenger = OCMProtocolMock(@protocol(FlutterBinaryMessenger));
  _manager = [[FLTAdInstanceManager alloc] initWithBinaryMessenger:_mockMessenger];
  _methodCodec = [FlutterStandardMethodCodec
      codecWithReaderWriter:[[FLTFirebaseAdMobReaderWriter alloc] init]];
}

- (void)testLoadAd {
  FLTAdSize *size = [[FLTAdSize alloc] initWithWidth:@(1) height:@(2)];
  FLTBannerAd *bannerAd =
      [[FLTBannerAd alloc] initWithAdUnitId:@"testId"
                                       size:size
                                    request:[[FLTAdRequest alloc] init]
                         rootViewController:OCMClassMock([UIViewController class])];

  FLTBannerAd *mockBannerAd = OCMPartialMock(bannerAd);
  OCMStub([mockBannerAd load]);

  [_manager loadAd:bannerAd adId:@(1)];

  OCMVerify([mockBannerAd load]);
  XCTAssertEqual([_manager adFor:@(1)], bannerAd);
  XCTAssertEqualObjects([_manager adIdFor:bannerAd], @(1));
}

- (void)testLoadInterstitialAd {
  FLTAdRequest *request = [[FLTAdRequest alloc] init];
  request.keywords = @[ @"apple" ];
  FLTInterstitialAd *ad =
      [[FLTInterstitialAd alloc] initWithAdUnitId:@"testId"
                                          request:request
                               rootViewController:OCMClassMock([UIViewController class])];

  FLTInterstitialAd *mockInterstitialAd = OCMPartialMock(ad);
  GADInterstitial *mockInterstitial = OCMClassMock([GADInterstitial class]);
  OCMStub([mockInterstitialAd interstitial]).andReturn(mockInterstitial);
  [mockInterstitialAd load];

  OCMVerify([mockInterstitial loadRequest:[OCMArg checkWithBlock:^BOOL(id obj) {
                                GADRequest *requestArg = obj;
                                return [requestArg.keywords isEqualToArray:@[ @"apple" ]];
                              }]]);
}

- (void)testLoadBannerAd {
  FLTAdRequest *request = [[FLTAdRequest alloc] init];
  request.keywords = @[ @"apple" ];
  FLTBannerAd *ad = [[FLTBannerAd alloc] initWithAdUnitId:@"testId"
                                                     size:[[FLTAdSize alloc] initWithWidth:@(1)
                                                                                    height:@(2)]
                                                  request:request
                                       rootViewController:OCMClassMock([UIViewController class])];

  FLTBannerAd *mockBannerAd = OCMPartialMock(ad);
  GADBannerView *mockView = OCMClassMock([GADBannerView class]);
  OCMStub([mockBannerAd bannerView]).andReturn(mockView);
  [mockBannerAd load];

  OCMVerify([mockView loadRequest:[OCMArg checkWithBlock:^BOOL(id obj) {
                        GADRequest *requestArg = obj;
                        return [requestArg.keywords isEqualToArray:@[ @"apple" ]];
                      }]]);
}

- (void)testLoadPublisherBannerAd {
  FLTPublisherAdRequest *request = [[FLTPublisherAdRequest alloc] init];
  request.keywords = @[ @"apple" ];
  FLTPublisherBannerAd *ad = [[FLTPublisherBannerAd alloc]
        initWithAdUnitId:@"testId"
                   sizes:@[ [[FLTAdSize alloc] initWithWidth:@(1) height:@(2)] ]
                 request:request
      rootViewController:OCMClassMock([UIViewController class])];

  FLTPublisherBannerAd *mockBannerAd = OCMPartialMock(ad);
  DFPBannerView *mockView = OCMClassMock([DFPBannerView class]);
  OCMStub([mockBannerAd bannerView]).andReturn(mockView);
  [mockBannerAd load];

  OCMVerify([mockView loadRequest:[OCMArg checkWithBlock:^BOOL(id obj) {
                        GADRequest *requestArg = obj;
                        return [requestArg.keywords isEqualToArray:@[ @"apple" ]];
                      }]]);
}

- (void)testLoadNativeAd {
  FLTAdRequest *request = [[FLTAdRequest alloc] init];
  request.keywords = @[ @"apple" ];
  FLTNativeAd *ad =
      [[FLTNativeAd alloc] initWithAdUnitId:@"testAdUnitId"
                                    request:request
                            nativeAdFactory:OCMProtocolMock(@protocol(FLTNativeAdFactory))
                              customOptions:nil
                         rootViewController:OCMClassMock([UIViewController class])];

  FLTNativeAd *mockNativeAd = OCMPartialMock(ad);
  GADAdLoader *mockLoader = OCMClassMock([GADAdLoader class]);
  OCMStub([mockNativeAd adLoader]).andReturn(mockLoader);
  [mockNativeAd load];

  OCMVerify([mockLoader loadRequest:[OCMArg checkWithBlock:^BOOL(id obj) {
                          GADRequest *requestArg = obj;
                          return [requestArg.keywords isEqualToArray:@[ @"apple" ]];
                        }]]);
}

- (void)testLoadRewardedAd {
  FLTAdRequest *request = [[FLTAdRequest alloc] init];
  request.keywords = @[ @"apple" ];
  FLTRewardedAd *ad =
      [[FLTRewardedAd alloc] initWithAdUnitId:@"testId"
                                      request:request
                           rootViewController:OCMClassMock([UIViewController class])];

  FLTRewardedAd *mockFltAd = OCMPartialMock(ad);
  GADRewardedAd *mockRewardedAd = OCMClassMock([GADRewardedAd class]);
  OCMStub([mockFltAd rewardedAd]).andReturn(mockRewardedAd);
  [mockFltAd load];

  OCMVerify([mockRewardedAd loadRequest:[OCMArg checkWithBlock:^BOOL(id obj) {
                              GADRequest *requestArg = obj;
                              return [requestArg.keywords isEqualToArray:@[ @"apple" ]];
                            }]
                      completionHandler:[OCMArg any]]);
}

- (void)testDisposeAd {
  FLTAdSize *size = [[FLTAdSize alloc] initWithWidth:@(1) height:@(2)];
  FLTBannerAd *bannerAd =
      [[FLTBannerAd alloc] initWithAdUnitId:@"testId"
                                       size:size
                                    request:[[FLTAdRequest alloc] init]
                         rootViewController:OCMClassMock([UIViewController class])];
  FLTBannerAd *mockBannerAd = OCMPartialMock(bannerAd);
  OCMStub([mockBannerAd load]);

  [_manager loadAd:bannerAd adId:@(1)];
  [_manager dispose:bannerAd];

  XCTAssertNil([_manager adFor:@(1)]);
  XCTAssertNil([_manager adIdFor:bannerAd]);
}

- (void)testOnAdLoaded {
  FLTNativeAd *ad =
      [[FLTNativeAd alloc] initWithAdUnitId:@"testAdUnitId"
                                    request:[[FLTAdRequest alloc] init]
                            nativeAdFactory:OCMProtocolMock(@protocol(FLTNativeAdFactory))
                              customOptions:nil
                         rootViewController:OCMClassMock([UIViewController class])];
  [_manager loadAd:ad adId:@(1)];

  [_manager onAdLoaded:ad];
  NSData *data = [_methodCodec
      encodeMethodCall:[FlutterMethodCall
                           methodCallWithMethodName:@"onAdEvent"
                                          arguments:@{@"adId" : @1, @"eventName" : @"onAdLoaded"}]];
  OCMVerify([_mockMessenger sendOnChannel:@"plugins.flutter.io/firebase_admob" message:data]);
}

- (void)testOnAdFailedToLoad {
  FLTNativeAd *ad =
      [[FLTNativeAd alloc] initWithAdUnitId:@"testAdUnitId"
                                    request:[[FLTAdRequest alloc] init]
                            nativeAdFactory:OCMProtocolMock(@protocol(FLTNativeAdFactory))
                              customOptions:nil
                         rootViewController:OCMClassMock([UIViewController class])];
  [_manager loadAd:ad adId:@(1)];

  FLTLoadAdError *error = [[FLTLoadAdError alloc] initWithCode:@(1)
                                                        domain:@"domain"
                                                       message:@"message"];
  [_manager onAdFailedToLoad:ad error:error];
  NSData *data = [_methodCodec
      encodeMethodCall:[FlutterMethodCall methodCallWithMethodName:@"onAdEvent"
                                                         arguments:@{
                                                           @"adId" : @1,
                                                           @"eventName" : @"onAdFailedToLoad",
                                                           @"loadAdError" : error,
                                                         }]];
  OCMVerify([_mockMessenger sendOnChannel:@"plugins.flutter.io/firebase_admob" message:data]);
}

- (void)testOnNativeAdClicked {
  FLTNativeAd *ad =
      [[FLTNativeAd alloc] initWithAdUnitId:@"testAdUnitId"
                                    request:[[FLTAdRequest alloc] init]
                            nativeAdFactory:OCMProtocolMock(@protocol(FLTNativeAdFactory))
                              customOptions:nil
                         rootViewController:OCMClassMock([UIViewController class])];
  [_manager loadAd:ad adId:@(1)];

  [_manager onNativeAdClicked:ad];
  NSData *data = [_methodCodec
      encodeMethodCall:[FlutterMethodCall methodCallWithMethodName:@"onAdEvent"
                                                         arguments:@{
                                                           @"adId" : @1,
                                                           @"eventName" : @"onNativeAdClicked"
                                                         }]];
  OCMVerify([_mockMessenger sendOnChannel:@"plugins.flutter.io/firebase_admob" message:data]);
}

- (void)testOnNativeAdImpression {
  FLTNativeAd *ad =
      [[FLTNativeAd alloc] initWithAdUnitId:@"testAdUnitId"
                                    request:[[FLTAdRequest alloc] init]
                            nativeAdFactory:OCMProtocolMock(@protocol(FLTNativeAdFactory))
                              customOptions:nil
                         rootViewController:OCMClassMock([UIViewController class])];
  [_manager loadAd:ad adId:@(1)];

  [_manager onNativeAdImpression:ad];
  NSData *data = [_methodCodec
      encodeMethodCall:[FlutterMethodCall methodCallWithMethodName:@"onAdEvent"
                                                         arguments:@{
                                                           @"adId" : @1,
                                                           @"eventName" : @"onNativeAdImpression"
                                                         }]];
  OCMVerify([_mockMessenger sendOnChannel:@"plugins.flutter.io/firebase_admob" message:data]);
}

- (void)testOnAdOpened {
  FLTNativeAd *ad =
      [[FLTNativeAd alloc] initWithAdUnitId:@"testAdUnitId"
                                    request:[[FLTAdRequest alloc] init]
                            nativeAdFactory:OCMProtocolMock(@protocol(FLTNativeAdFactory))
                              customOptions:nil
                         rootViewController:OCMClassMock([UIViewController class])];
  [_manager loadAd:ad adId:@(1)];

  [_manager onAdOpened:ad];
  NSData *data = [_methodCodec
      encodeMethodCall:[FlutterMethodCall
                           methodCallWithMethodName:@"onAdEvent"
                                          arguments:@{@"adId" : @1, @"eventName" : @"onAdOpened"}]];
  OCMVerify([_mockMessenger sendOnChannel:@"plugins.flutter.io/firebase_admob" message:data]);
}

- (void)testOnApplicationExit {
  FLTNativeAd *ad =
      [[FLTNativeAd alloc] initWithAdUnitId:@"testAdUnitId"
                                    request:[[FLTAdRequest alloc] init]
                            nativeAdFactory:OCMProtocolMock(@protocol(FLTNativeAdFactory))
                              customOptions:nil
                         rootViewController:OCMClassMock([UIViewController class])];
  [_manager loadAd:ad adId:@(1)];

  [_manager onApplicationExit:ad];
  NSData *data = [_methodCodec
      encodeMethodCall:[FlutterMethodCall methodCallWithMethodName:@"onAdEvent"
                                                         arguments:@{
                                                           @"adId" : @1,
                                                           @"eventName" : @"onApplicationExit"
                                                         }]];
  OCMVerify([_mockMessenger sendOnChannel:@"plugins.flutter.io/firebase_admob" message:data]);
}

- (void)testOnAdClosed {
  FLTNativeAd *ad =
      [[FLTNativeAd alloc] initWithAdUnitId:@"testAdUnitId"
                                    request:[[FLTAdRequest alloc] init]
                            nativeAdFactory:OCMProtocolMock(@protocol(FLTNativeAdFactory))
                              customOptions:nil
                         rootViewController:OCMClassMock([UIViewController class])];
  [_manager loadAd:ad adId:@(1)];

  [_manager onAdClosed:ad];
  NSData *data = [_methodCodec
      encodeMethodCall:[FlutterMethodCall
                           methodCallWithMethodName:@"onAdEvent"
                                          arguments:@{@"adId" : @1, @"eventName" : @"onAdClosed"}]];
  OCMVerify([_mockMessenger sendOnChannel:@"plugins.flutter.io/firebase_admob" message:data]);
}

- (void)testOnRewardedAdUserEarnedReward {
  FLTRewardedAd *ad =
      [[FLTRewardedAd alloc] initWithAdUnitId:@"testId"
                                      request:[[FLTAdRequest alloc] init]
                           rootViewController:OCMClassMock([UIViewController class])];
  [_manager loadAd:ad adId:@(1)];

  [_manager onRewardedAdUserEarnedReward:ad
                                  reward:[[FLTRewardItem alloc] initWithAmount:@(1) type:@"type"]];
  NSData *data = [_methodCodec
      encodeMethodCall:[FlutterMethodCall
                           methodCallWithMethodName:@"onAdEvent"
                                          arguments:@{
                                            @"adId" : @1,
                                            @"eventName" : @"onRewardedAdUserEarnedReward",
                                            @"rewardItem" :
                                                [[FLTRewardItem alloc] initWithAmount:@(1)
                                                                                 type:@"type"]
                                          }]];
  OCMVerify([_mockMessenger sendOnChannel:@"plugins.flutter.io/firebase_admob" message:data]);
}
@end
