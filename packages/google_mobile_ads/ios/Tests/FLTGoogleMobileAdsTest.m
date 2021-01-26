// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "../Classes/FLTGoogleMobileAdsReaderWriter_Internal.h"
#import "../Classes/FLTMobileAds_Internal.h"
#import "../Classes/FLTGoogleMobileAdsPlugin.h"
#import "../Classes/FLTGoogleMobileAdsCollection_Internal.h"
#import "../Classes/FLTAd_Internal.h"
#import "../Classes/FLTAdInstanceManager_Internal.h"

@interface FLTGoogleMobileAdsTest : XCTestCase
@end

@implementation FLTGoogleMobileAdsTest {
  FLTAdInstanceManager *_manager;
  NSObject<FlutterBinaryMessenger> *_mockMessenger;
  NSObject<FlutterMethodCodec> *_methodCodec;
}

- (void)setUp {
  _mockMessenger = OCMProtocolMock(@protocol(FlutterBinaryMessenger));
  _manager = [[FLTAdInstanceManager alloc] initWithBinaryMessenger:_mockMessenger];
  _methodCodec = [FlutterStandardMethodCodec
      codecWithReaderWriter:[[FLTGoogleMobileAdsReaderWriter alloc] init]];
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

- (void)testLoadPublisherInterstitialAd {
  FLTPublisherAdRequest *request = [[FLTPublisherAdRequest alloc] init];
  request.keywords = @[ @"apple" ];
  FLTPublisherInterstitialAd *ad =
      [[FLTPublisherInterstitialAd alloc] initWithAdUnitId:@"testId"
                                                   request:request
                                        rootViewController:OCMClassMock([UIViewController class])];

  FLTPublisherInterstitialAd *mockInterstitialAd = OCMPartialMock(ad);
  DFPInterstitial *mockAd = OCMClassMock([DFPInterstitial class]);
  OCMStub([mockInterstitialAd interstitial]).andReturn(mockAd);
  [mockInterstitialAd load];

  OCMVerify([mockAd loadRequest:[OCMArg checkWithBlock:^BOOL(id obj) {
                      DFPRequest *requestArg = obj;
                      return [requestArg.keywords isEqualToArray:@[ @"apple" ]];
                    }]]);
}

- (void)testShowPublisherInterstitialAd {
  FLTPublisherAdRequest *request = [[FLTPublisherAdRequest alloc] init];
  FLTPublisherInterstitialAd *ad =
      [[FLTPublisherInterstitialAd alloc] initWithAdUnitId:@"testId"
                                                   request:request
                                        rootViewController:OCMClassMock([UIViewController class])];

  FLTPublisherInterstitialAd *mockInterstitialAd = OCMPartialMock(ad);
  DFPInterstitial *mockAd = OCMClassMock([DFPInterstitial class]);
  OCMStub([mockInterstitialAd interstitial]).andReturn(mockAd);

  OCMStub([mockAd isReady]).andReturn(YES);
  [mockInterstitialAd show];
  OCMVerify([mockAd presentFromRootViewController:OCMOCK_ANY]);
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

- (void)testShowRewardedAd {
  FLTAdRequest *request = [[FLTAdRequest alloc] init];
  request.keywords = @[ @"apple" ];
  FLTRewardedAd *ad =
      [[FLTRewardedAd alloc] initWithAdUnitId:@"testId"
                                      request:request
                           rootViewController:OCMClassMock([UIViewController class])];

  FLTRewardedAd *mockFltAd = OCMPartialMock(ad);
  GADRewardedAd *mockRewardedAd = OCMClassMock([GADRewardedAd class]);
  OCMStub([mockFltAd rewardedAd]).andReturn(mockRewardedAd);

  OCMStub([mockRewardedAd isReady]).andReturn(YES);
  [mockFltAd show];
  OCMVerify([mockRewardedAd presentFromRootViewController:OCMOCK_ANY delegate:OCMOCK_ANY]);
}

- (void)testLoadRewardedAdWithPublisherRequest {
  FLTPublisherAdRequest *request = [[FLTPublisherAdRequest alloc] init];
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
                              DFPRequest *requestArg = obj;
                              return [requestArg.keywords isEqualToArray:@[ @"apple" ]];
                            }]
                      completionHandler:[OCMArg any]]);
}

- (void)testLoadNativeAdWithPublisherRequest {
  FLTPublisherAdRequest *request = [[FLTPublisherAdRequest alloc] init];
  request.keywords = @[ @"apple" ];
  FLTNativeAd *ad =
      [[FLTNativeAd alloc] initWithAdUnitId:@"testId"
                                    request:request
                            nativeAdFactory:OCMProtocolMock(@protocol(FLTNativeAdFactory))
                              customOptions:nil
                         rootViewController:OCMClassMock([UIViewController class])];

  FLTNativeAd *mockFltAd = OCMPartialMock(ad);
  GADAdLoader *mockAdLoader = OCMClassMock([GADAdLoader class]);
  OCMStub([mockFltAd adLoader]).andReturn(mockAdLoader);
  [mockFltAd load];

  OCMVerify([mockAdLoader loadRequest:[OCMArg checkWithBlock:^BOOL(id obj) {
                            DFPRequest *requestArg = obj;
                            return [requestArg.keywords isEqualToArray:@[ @"apple" ]];
                          }]]);
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
  OCMVerify([_mockMessenger sendOnChannel:@"plugins.flutter.io/google_mobile_ads" message:data]);
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
  OCMVerify([_mockMessenger sendOnChannel:@"plugins.flutter.io/google_mobile_ads" message:data]);
}

- (void)testOnAppEvent {
  FLTNativeAd *ad =
      [[FLTNativeAd alloc] initWithAdUnitId:@"testAdUnitId"
                                    request:[[FLTAdRequest alloc] init]
                            nativeAdFactory:OCMProtocolMock(@protocol(FLTNativeAdFactory))
                              customOptions:nil
                         rootViewController:OCMClassMock([UIViewController class])];
  [_manager loadAd:ad adId:@(1)];

  [_manager onAppEvent:ad name:@"color" data:@"red"];

  NSData *data = [_methodCodec
      encodeMethodCall:[FlutterMethodCall methodCallWithMethodName:@"onAdEvent"
                                                         arguments:@{
                                                           @"adId" : @1,
                                                           @"eventName" : @"onAppEvent",
                                                           @"name" : @"color",
                                                           @"data" : @"red"
                                                         }]];
  OCMVerify([_mockMessenger sendOnChannel:@"plugins.flutter.io/google_mobile_ads" message:data]);
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
  OCMVerify([_mockMessenger sendOnChannel:@"plugins.flutter.io/google_mobile_ads" message:data]);
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
  OCMVerify([_mockMessenger sendOnChannel:@"plugins.flutter.io/google_mobile_ads" message:data]);
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
  OCMVerify([_mockMessenger sendOnChannel:@"plugins.flutter.io/google_mobile_ads" message:data]);
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
  OCMVerify([_mockMessenger sendOnChannel:@"plugins.flutter.io/google_mobile_ads" message:data]);
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
  OCMVerify([_mockMessenger sendOnChannel:@"plugins.flutter.io/google_mobile_ads" message:data]);
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
  OCMVerify([_mockMessenger sendOnChannel:@"plugins.flutter.io/google_mobile_ads" message:data]);
}
@end
