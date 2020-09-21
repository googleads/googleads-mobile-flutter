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
  FLTNewBannerAd *bannerAd =
      [[FLTNewBannerAd alloc] initWithAdUnitId:@"testId"
                                          size:size
                                       request:[[FLTAdRequest alloc] init]
                            rootViewController:OCMClassMock([UIViewController class])];

  FLTNewBannerAd *mockBannerAd = OCMPartialMock(bannerAd);
  OCMStub([mockBannerAd load]);

  [_manager loadAd:bannerAd adId:@(1)];

  OCMVerify([mockBannerAd load]);
  XCTAssertEqual([_manager adFor:@(1)], bannerAd);
  XCTAssertEqualObjects([_manager adIdFor:bannerAd], @(1));
}

- (void)testDisposeAd {
  FLTAdSize *size = [[FLTAdSize alloc] initWithWidth:@(1) height:@(2)];
  FLTNewBannerAd *bannerAd =
      [[FLTNewBannerAd alloc] initWithAdUnitId:@"testId"
                                          size:size
                                       request:[[FLTAdRequest alloc] init]
                            rootViewController:OCMClassMock([UIViewController class])];
  FLTNewBannerAd *mockBannerAd = OCMPartialMock(bannerAd);
  OCMStub([mockBannerAd load]);

  [_manager loadAd:bannerAd adId:@(1)];
  [_manager dispose:bannerAd];

  XCTAssertNil([_manager adFor:@(1)]);
  XCTAssertNil([_manager adIdFor:bannerAd]);
}

- (void)testOnAdLoaded {
  FLTNewNativeAd *ad =
      [[FLTNewNativeAd alloc] initWithAdUnitId:@"testAdUnitId"
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
  FLTNewNativeAd *ad =
      [[FLTNewNativeAd alloc] initWithAdUnitId:@"testAdUnitId"
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
  FLTNewNativeAd *ad =
      [[FLTNewNativeAd alloc] initWithAdUnitId:@"testAdUnitId"
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
  FLTNewNativeAd *ad =
      [[FLTNewNativeAd alloc] initWithAdUnitId:@"testAdUnitId"
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
  FLTNewNativeAd *ad =
      [[FLTNewNativeAd alloc] initWithAdUnitId:@"testAdUnitId"
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
  FLTNewNativeAd *ad =
      [[FLTNewNativeAd alloc] initWithAdUnitId:@"testAdUnitId"
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
  FLTNewNativeAd *ad =
      [[FLTNewNativeAd alloc] initWithAdUnitId:@"testAdUnitId"
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
  FLTNewRewardedAd *ad =
      [[FLTNewRewardedAd alloc] initWithAdUnitId:@"testId"
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
