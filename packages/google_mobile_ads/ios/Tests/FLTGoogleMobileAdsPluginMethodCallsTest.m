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
#import "../Classes/FLTGoogleMobileAdsPlugin.h"
#import "../Classes/FLTGoogleMobileAdsReaderWriter_Internal.h"
#import "../Classes/FLTMobileAds_Internal.h"

@interface FLTGoogleMobileAdsPluginMethodCallsTest : XCTestCase
@end

@implementation FLTGoogleMobileAdsPluginMethodCallsTest {
  FLTGoogleMobileAdsPlugin *_fltGoogleMobileAdsPlugin;
  FLTAdInstanceManager *_mockAdInstanceManager;
}

- (void)setUp {
  _mockAdInstanceManager = OCMClassMock([FLTAdInstanceManager class]);
  _fltGoogleMobileAdsPlugin = [[FLTGoogleMobileAdsPlugin alloc] init];
  [_fltGoogleMobileAdsPlugin setValue:_mockAdInstanceManager forKey:@"_manager"];
}

- (void)testDisposeAd {
  FlutterMethodCall *methodCall = [FlutterMethodCall methodCallWithMethodName:@"disposeAd"
                                                                    arguments:@{@"adId" : @1}];
  __block bool resultInvoked = false;
  __block id _Nullable returnedResult;
  FlutterResult result = ^(id _Nullable result) {
    resultInvoked = true;
    returnedResult = result;
  };

  [_fltGoogleMobileAdsPlugin handleMethodCall:methodCall result:result];

  XCTAssertTrue(resultInvoked);
  XCTAssertNil(returnedResult);
  OCMVerify([_mockAdInstanceManager dispose:@1]);
}

- (void)testLoadRewardedAd {
  FLTAdRequest *request = [[FLTAdRequest alloc] init];
  request.keywords = @[ @"apple" ];
  FLTServerSideVerificationOptions *serverSideVerificationOptions =
      [[FLTServerSideVerificationOptions alloc] init];
  serverSideVerificationOptions.customRewardString = @"reward";
  serverSideVerificationOptions.userIdentifier = @"user-id";
  FlutterMethodCall *methodCall = [FlutterMethodCall
      methodCallWithMethodName:@"loadRewardedAd"
                     arguments:@{
                       @"adId" : @2,
                       @"adUnitId" : @"testId",
                       @"request" : request,
                       @"serverSideVerificationOptions" : serverSideVerificationOptions
                     }];

  __block bool resultInvoked = false;
  __block id _Nullable returnedResult;
  FlutterResult result = ^(id _Nullable result) {
    resultInvoked = true;
    returnedResult = result;
  };

  [_fltGoogleMobileAdsPlugin handleMethodCall:methodCall result:result];

  XCTAssertTrue(resultInvoked);
  XCTAssertNil(returnedResult);
  BOOL (^verificationBlock)(FLTRewardedAd *) = ^BOOL(FLTRewardedAd *ad) {
    FLTAdRequest *adRequest = [ad valueForKey:@"_adRequest"];
    NSString *adUnit = [ad valueForKey:@"_adUnitId"];
    FLTServerSideVerificationOptions *options = [ad valueForKey:@"_serverSideVerificationOptions"];
    XCTAssertEqualObjects(adRequest, request);
    XCTAssertEqualObjects(adUnit, @"testId");
    XCTAssertEqualObjects(options, serverSideVerificationOptions);
    return YES;
  };
  OCMVerify([_mockAdInstanceManager loadAd:[OCMArg checkWithBlock:verificationBlock]]);
}

- (void)testInternalInit {
  FlutterMethodCall *methodCall = [FlutterMethodCall methodCallWithMethodName:@"_init"
                                                                    arguments:@{}];

  __block bool resultInvoked = false;
  __block id _Nullable returnedResult;
  FlutterResult result = ^(id _Nullable result) {
    resultInvoked = true;
    returnedResult = result;
  };

  [_fltGoogleMobileAdsPlugin handleMethodCall:methodCall result:result];

  XCTAssertTrue(resultInvoked);
  XCTAssertNil(returnedResult);
  OCMVerify([_mockAdInstanceManager disposeAllAds]);
}

- (void)testMobileAdsInitialize {
  id gadMobileAdsClassMock = OCMClassMock([GADMobileAds class]);
  OCMStub(ClassMethod([gadMobileAdsClassMock sharedInstance]))
      .andReturn((GADMobileAds *)gadMobileAdsClassMock);
  GADInitializationStatus *mockInitStatus = OCMClassMock([GADInitializationStatus class]);
  OCMStub([mockInitStatus adapterStatusesByClassName]).andReturn(@{});
  OCMStub([gadMobileAdsClassMock startWithCompletionHandler:[OCMArg any]])
      .andDo(^(NSInvocation *invocation) {
        // Invoke the init handler twice.
        GADInitializationCompletionHandler completionHandler;
        [invocation getArgument:&completionHandler atIndex:2];
        completionHandler(mockInitStatus);
        completionHandler(mockInitStatus);
      });

  FlutterMethodCall *methodCall =
      [FlutterMethodCall methodCallWithMethodName:@"MobileAds#initialize" arguments:@{}];
  __block int resultInvokedCount = 0;
  __block id _Nullable returnedResult;
  FlutterResult result = ^(id _Nullable result) {
    resultInvokedCount += 1;
    returnedResult = result;
  };

  [_fltGoogleMobileAdsPlugin handleMethodCall:methodCall result:result];
  XCTAssertEqual(resultInvokedCount, 1);
  XCTAssertEqual([((FLTInitializationStatus *)returnedResult) adapterStatuses].count, 0);
}

- (void)testSetSameAppKeyEnabledYes {
  id gadMobileAdsClassMock = OCMClassMock([GADMobileAds class]);
  OCMStub(ClassMethod([gadMobileAdsClassMock sharedInstance]))
      .andReturn((GADMobileAds *)gadMobileAdsClassMock);
  GADRequestConfiguration *gadRequestConfigurationMock =
      OCMClassMock([GADRequestConfiguration class]);
  OCMStub([gadMobileAdsClassMock requestConfiguration]).andReturn(gadRequestConfigurationMock);

  FlutterMethodCall *methodCall =
      [FlutterMethodCall methodCallWithMethodName:@"MobileAds#setSameAppKeyEnabled"
                                        arguments:@{@"isEnabled" : @(YES)}];

  __block bool resultInvoked = false;
  __block id _Nullable returnedResult;
  FlutterResult result = ^(id _Nullable result) {
    resultInvoked = true;
    returnedResult = result;
  };

  [_fltGoogleMobileAdsPlugin handleMethodCall:methodCall result:result];

  XCTAssertTrue(resultInvoked);
  XCTAssertNil(returnedResult);
  OCMVerify([gadRequestConfigurationMock setSameAppKeyEnabled:[OCMArg isEqual:@(YES)]]);
}

- (void)testSetSameAppKeyEnabledNo {
  id gadMobileAdsClassMock = OCMClassMock([GADMobileAds class]);
  OCMStub(ClassMethod([gadMobileAdsClassMock sharedInstance]))
      .andReturn((GADMobileAds *)gadMobileAdsClassMock);
  GADRequestConfiguration *gadRequestConfigurationMock =
      OCMClassMock([GADRequestConfiguration class]);
  OCMStub([gadMobileAdsClassMock requestConfiguration]).andReturn(gadRequestConfigurationMock);

  FlutterMethodCall *methodCall =
      [FlutterMethodCall methodCallWithMethodName:@"MobileAds#setSameAppKeyEnabled"
                                        arguments:@{@"isEnabled" : @0}];

  __block bool resultInvoked = false;
  __block id _Nullable returnedResult;
  FlutterResult result = ^(id _Nullable result) {
    resultInvoked = true;
    returnedResult = result;
  };

  [_fltGoogleMobileAdsPlugin handleMethodCall:methodCall result:result];

  XCTAssertTrue(resultInvoked);
  XCTAssertNil(returnedResult);
  OCMVerify([gadRequestConfigurationMock setSameAppKeyEnabled:NO]);

  FlutterMethodCall *methodCallWithBool =
      [FlutterMethodCall methodCallWithMethodName:@"MobileAds#setSameAppKeyEnabled"
                                        arguments:@{@"isEnabled" : @NO}];

  __block bool resultInvokedWithBool = false;
  __block id _Nullable returnedResultWithBool;
  FlutterResult resultWithBool = ^(id _Nullable result) {
    resultInvokedWithBool = true;
    returnedResultWithBool = result;
  };

  [_fltGoogleMobileAdsPlugin handleMethodCall:methodCallWithBool result:resultWithBool];

  XCTAssertTrue(resultInvokedWithBool);
  XCTAssertNil(returnedResultWithBool);
  OCMVerify([gadRequestConfigurationMock setSameAppKeyEnabled:NO]);
}

@end
