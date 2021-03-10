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

@interface FLTGoogleMobileAdsPluginMethodCallsTest : XCTestCase
@end

@implementation FLTGoogleMobileAdsPluginMethodCallsTest {
  FLTGoogleMobileAdsPlugin *_fltGoogleMobileAdsPlugin;
  NSObject<FlutterBinaryMessenger> *_mockMessenger;
  FLTAdInstanceManager *_mockAdInstanceMessenger;
}

- (void)setUp {
  _mockAdInstanceMessenger = OCMClassMock([FLTAdInstanceManager class]);
  _fltGoogleMobileAdsPlugin = [[FLTGoogleMobileAdsPlugin alloc] init];
  [_fltGoogleMobileAdsPlugin setValue:_mockAdInstanceMessenger forKey:@"_manager"];
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
  OCMVerify([_mockAdInstanceMessenger dispose:@1]);
}
@end
