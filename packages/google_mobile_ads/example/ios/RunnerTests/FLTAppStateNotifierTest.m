// Copyright 2026 Google LLC
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

#import "google_mobile_ads/FLTAppStateNotifier.h"

@interface FLTAppStateNotifier ()
- (void)handleWillEnterForeground;
- (void)handleDidEnterBackground;
- (void)addAppStateObservers;
- (void)removeAppStateObservers;
- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result;
@end

@interface FLTAppStateNotifierTest : XCTestCase
@end

@implementation FLTAppStateNotifierTest {
  NSObject<FlutterBinaryMessenger> *_mockMessenger;
  FLTAppStateNotifier *_appStateNotifier;
}

- (void)setUp {
  [super setUp];
  _mockMessenger = OCMProtocolMock(@protocol(FlutterBinaryMessenger));
  _appStateNotifier = [[FLTAppStateNotifier alloc] initWithBinaryMessenger:_mockMessenger];
}

- (void)tearDown {
  [_appStateNotifier removeAppStateObservers];
  [super tearDown];
}

- (void)testHandleDidEnterBackground_whenEventsIsNil_doesNotCrash {
  XCTAssertNoThrow([_appStateNotifier handleDidEnterBackground]);
}

- (void)testHandleWillEnterForeground_whenEventsIsNil_doesNotCrash {
  [_appStateNotifier handleDidEnterBackground];
  XCTAssertNoThrow([_appStateNotifier handleWillEnterForeground]);
}

- (void)testHandleDidEnterBackground_whenEventsIsPresent_sendsBackgroundEvent {
  NSMutableArray *receivedEvents = [NSMutableArray array];
  FlutterEventSink eventSink = ^(id event) {
    [receivedEvents addObject:event];
  };

  [_appStateNotifier onListenWithArguments:nil eventSink:eventSink];
  [_appStateNotifier handleDidEnterBackground];

  XCTAssertEqual(receivedEvents.count, 1);
  XCTAssertEqualObjects(receivedEvents.firstObject, @"background");
}

- (void)testHandleWillEnterForeground_whenEventsIsPresent_sendsForegroundEvent {
  NSMutableArray *receivedEvents = [NSMutableArray array];
  FlutterEventSink eventSink = ^(id event) {
    [receivedEvents addObject:event];
  };

  [_appStateNotifier onListenWithArguments:nil eventSink:eventSink];
  [_appStateNotifier handleDidEnterBackground];
  [_appStateNotifier handleWillEnterForeground];

  XCTAssertEqual(receivedEvents.count, 2);
  XCTAssertEqualObjects(receivedEvents[0], @"background");
  XCTAssertEqualObjects(receivedEvents[1], @"foreground");
}

- (void)testOnCancel_clearsEventSink {
  NSMutableArray *receivedEvents = [NSMutableArray array];
  FlutterEventSink eventSink = ^(id event) {
    [receivedEvents addObject:event];
  };

  [_appStateNotifier onListenWithArguments:nil eventSink:eventSink];
  [_appStateNotifier onCancelWithArguments:nil];

  // Triggering background after cancel should not crash and not send events to sink
  XCTAssertNoThrow([_appStateNotifier handleDidEnterBackground]);
  XCTAssertEqual(receivedEvents.count, 0);
}

- (void)testMethodCall_startAndStop {
  __block BOOL startResultCalled = NO;
  FlutterMethodCall *startCall = [FlutterMethodCall methodCallWithMethodName:@"start" arguments:nil];
  [_appStateNotifier handleMethodCall:startCall result:^(id result) {
    startResultCalled = YES;
    XCTAssertNil(result);
  }];
  XCTAssertTrue(startResultCalled);

  __block BOOL stopResultCalled = NO;
  FlutterMethodCall *stopCall = [FlutterMethodCall methodCallWithMethodName:@"stop" arguments:nil];
  [_appStateNotifier handleMethodCall:stopCall result:^(id result) {
    stopResultCalled = YES;
    XCTAssertNil(result);
  }];
  XCTAssertTrue(stopResultCalled);
}

- (void)testNotificationObservers_receiveApplicationEvents {
  NSMutableArray *receivedEvents = [NSMutableArray array];
  FlutterEventSink eventSink = ^(id event) {
    [receivedEvents addObject:event];
  };

  [_appStateNotifier onListenWithArguments:nil eventSink:eventSink];
  [_appStateNotifier addAppStateObservers];

  [NSNotificationCenter.defaultCenter postNotificationName:UIApplicationDidEnterBackgroundNotification
                                                    object:nil];
  XCTAssertEqual(receivedEvents.count, 1);
  XCTAssertEqualObjects(receivedEvents.firstObject, @"background");

  [NSNotificationCenter.defaultCenter postNotificationName:UIApplicationWillEnterForegroundNotification
                                                    object:nil];
  XCTAssertEqual(receivedEvents.count, 2);
  XCTAssertEqualObjects(receivedEvents[1], @"foreground");
}

@end
