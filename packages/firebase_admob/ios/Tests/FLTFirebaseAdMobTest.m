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
  FLTNewBannerAd *bannerAd = [[FLTNewBannerAd alloc] initWithAdUnitId:@"wef" size:size];

  FLTNewBannerAd *mockBannerAd = OCMPartialMock(bannerAd);
  OCMStub([mockBannerAd load]);

  [_manager loadAd:bannerAd adId:@(1)];

  OCMVerify([mockBannerAd load]);
  XCTAssertEqual([_manager adFor:@(1)], bannerAd);
  XCTAssertEqualObjects([_manager adIdFor:bannerAd], @(1));
}

- (void)testDisposeAd {
  FLTAdSize *size = [[FLTAdSize alloc] initWithWidth:@(1) height:@(2)];
  FLTNewBannerAd *bannerAd = [[FLTNewBannerAd alloc] initWithAdUnitId:@"wef" size:size];
  FLTNewBannerAd *mockBannerAd = OCMPartialMock(bannerAd);
  OCMStub([mockBannerAd load]);

  [_manager loadAd:bannerAd adId:@(1)];
  [_manager dispose:bannerAd];

  XCTAssertNil([_manager adFor:@(1)]);
  XCTAssertNil([_manager adIdFor:bannerAd]);
}

- (void)testAdEvents {
  FLTAdSize *size = [[FLTAdSize alloc] initWithWidth:@(1) height:@(2)];
  FLTNewBannerAd *bannerAd = [[FLTNewBannerAd alloc] initWithAdUnitId:@"wef" size:size];

  [_manager loadAd:bannerAd adId:@(1)];

  [_manager onAdLoaded:bannerAd];
  NSData *data = [_methodCodec
      encodeMethodCall:[FlutterMethodCall
                           methodCallWithMethodName:@"onAdEvent"
                                          arguments:@{@"adId" : @1, @"eventName" : @"onAdLoaded"}]];
  OCMVerify([_mockMessenger sendOnChannel:@"plugins.flutter.io/firebase_admob" message:data]);

  [_manager onAdFailedToLoad:bannerAd];
  data = [_methodCodec
      encodeMethodCall:[FlutterMethodCall methodCallWithMethodName:@"onAdEvent"
                                                         arguments:@{
                                                           @"adId" : @1,
                                                           @"eventName" : @"onAdFailedToLoad"
                                                         }]];
  OCMVerify([_mockMessenger sendOnChannel:@"plugins.flutter.io/firebase_admob" message:data]);

  [_manager onNativeAdClicked:bannerAd];
  data = [_methodCodec
      encodeMethodCall:[FlutterMethodCall methodCallWithMethodName:@"onAdEvent"
                                                         arguments:@{
                                                           @"adId" : @1,
                                                           @"eventName" : @"onNativeAdClicked"
                                                         }]];
  OCMVerify([_mockMessenger sendOnChannel:@"plugins.flutter.io/firebase_admob" message:data]);

  [_manager onNativeAdImpression:bannerAd];
  data = [_methodCodec
      encodeMethodCall:[FlutterMethodCall methodCallWithMethodName:@"onAdEvent"
                                                         arguments:@{
                                                           @"adId" : @1,
                                                           @"eventName" : @"onNativeAdImpression"
                                                         }]];
  OCMVerify([_mockMessenger sendOnChannel:@"plugins.flutter.io/firebase_admob" message:data]);

  [_manager onAdOpened:bannerAd];
  data = [_methodCodec
      encodeMethodCall:[FlutterMethodCall
                           methodCallWithMethodName:@"onAdEvent"
                                          arguments:@{@"adId" : @1, @"eventName" : @"onAdOpened"}]];
  OCMVerify([_mockMessenger sendOnChannel:@"plugins.flutter.io/firebase_admob" message:data]);

  [_manager onApplicationExit:bannerAd];
  data = [_methodCodec
      encodeMethodCall:[FlutterMethodCall methodCallWithMethodName:@"onAdEvent"
                                                         arguments:@{
                                                           @"adId" : @1,
                                                           @"eventName" : @"onApplicationExit"
                                                         }]];
  OCMVerify([_mockMessenger sendOnChannel:@"plugins.flutter.io/firebase_admob" message:data]);

  [_manager onAdClosed:bannerAd];
  data = [_methodCodec
      encodeMethodCall:[FlutterMethodCall
                           methodCallWithMethodName:@"onAdEvent"
                                          arguments:@{@"adId" : @1, @"eventName" : @"onAdClosed"}]];
  OCMVerify([_mockMessenger sendOnChannel:@"plugins.flutter.io/firebase_admob" message:data]);
}
@end
