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
#import "../Classes/FLTGoogleMobileAdsCollection_Internal.h"
#import "../Classes/FLTGoogleMobileAdsPlugin.h"
#import "../Classes/FLTGoogleMobileAdsReaderWriter_Internal.h"
#import "../Classes/FLTMobileAds_Internal.h"

@interface FLTGoogleMobileAdsReaderWriterTest : XCTestCase
@end

@implementation FLTGoogleMobileAdsReaderWriterTest {
  FlutterStandardMessageCodec *_messageCodec;
}

- (void)setUp {
  FLTGoogleMobileAdsReaderWriter *readerWriter = [[FLTGoogleMobileAdsReaderWriter alloc] init];
  _messageCodec = [FlutterStandardMessageCodec codecWithReaderWriter:readerWriter];
}

- (void)testEncodeDecodeAdSize {
  FLTAdSize *size = [[FLTAdSize alloc] initWithWidth:@(1) height:@(2)];
  NSData *encodedMessage = [_messageCodec encode:size];

  FLTAdSize *decodedSize = [_messageCodec decode:encodedMessage];
  XCTAssertEqualObjects(decodedSize.width, @(1));
  XCTAssertEqualObjects(decodedSize.height, @(2));
}

- (void)testEncodeDecodeAdRequest {
  FLTAdRequest *request = [[FLTAdRequest alloc] init];
  request.keywords = @[ @"apple" ];
  request.contentURL = @"banana";
  request.testDevices = @[ @"orange" ];
  request.nonPersonalizedAds = YES;

  NSData *encodedMessage = [_messageCodec encode:request];

  FLTAdRequest *decodedRequest = [_messageCodec decode:encodedMessage];
  XCTAssertTrue([decodedRequest.keywords isEqualToArray:@[ @"apple" ]]);
  XCTAssertEqualObjects(decodedRequest.contentURL, @"banana");
  XCTAssertTrue([decodedRequest.testDevices isEqualToArray:@[ @"orange" ]]);
  XCTAssertTrue(decodedRequest.nonPersonalizedAds);
}

- (void)testEncodeDecodePublisherAdRequest {
  FLTPublisherAdRequest *request = [[FLTPublisherAdRequest alloc] init];
  request.keywords = @[ @"apple" ];
  request.contentURL = @"banana";
  request.customTargeting = @{@"table" : @"linen"};
  request.customTargetingLists = @{@"go" : @[ @"lakers" ]};
  request.nonPersonalizedAds = YES;
  NSData *encodedMessage = [_messageCodec encode:request];

  FLTPublisherAdRequest *decodedRequest = [_messageCodec decode:encodedMessage];
  XCTAssertTrue([decodedRequest.keywords isEqualToArray:@[ @"apple" ]]);
  XCTAssertEqualObjects(decodedRequest.contentURL, @"banana");
  XCTAssertTrue([decodedRequest.customTargeting isEqualToDictionary:@{@"table" : @"linen"}]);
  XCTAssertTrue(
      [decodedRequest.customTargetingLists isEqualToDictionary:@{@"go" : @[ @"lakers" ]}]);
  XCTAssertTrue(decodedRequest.nonPersonalizedAds);
}

- (void)testEncodeDecodeRewardItem {
  FLTRewardItem *item = [[FLTRewardItem alloc] initWithAmount:@(1) type:@"apple"];
  NSData *encodedMessage = [_messageCodec encode:item];

  FLTRewardItem *decodedItem = [_messageCodec decode:encodedMessage];
  XCTAssertEqualObjects(decodedItem.amount, @(1));
  XCTAssertEqualObjects(decodedItem.type, @"apple");
}

- (void)testEncodeDecodeLoadAdError {
  FLTLoadAdError *error = [[FLTLoadAdError alloc] initWithCode:@(1)
                                                        domain:@"domain"
                                                       message:@"message"];
  NSData *encodedMessage = [_messageCodec encode:error];

  FLTLoadAdError *decodedError = [_messageCodec decode:encodedMessage];
  XCTAssertEqualObjects(decodedError.code, @(1));
  XCTAssertEqualObjects(decodedError.domain, @"domain");
  XCTAssertEqualObjects(decodedError.message, @"message");
}

- (void)testEncodeDecodeAdapterStatus {
  FLTAdapterStatus *status = [[FLTAdapterStatus alloc] init];
  status.state = @(1);
  status.statusDescription = @"desc";
  status.latency = @(23);

  NSData *encodedMessage = [_messageCodec encode:status];

  FLTAdapterStatus *decodedStatus = [_messageCodec decode:encodedMessage];
  XCTAssertEqualObjects(decodedStatus.state, @(1));
  XCTAssertEqualObjects(decodedStatus.statusDescription, @"desc");
  XCTAssertEqualObjects(decodedStatus.latency, @(23));
}

- (void)testEncodeDecodeInitializationStatus {
  FLTInitializationStatus *status = [[FLTInitializationStatus alloc] init];
  status.adapterStatuses = @{@"name" : [[FLTAdapterStatus alloc] init]};

  NSData *encodedMessage = [_messageCodec encode:status];

  FLTInitializationStatus *decodedStatus = [_messageCodec decode:encodedMessage];
  XCTAssertEqual(decodedStatus.adapterStatuses.count, 1);
  XCTAssertEqualObjects(decodedStatus.adapterStatuses.allKeys[0], @"name");
  XCTAssertNil(decodedStatus.adapterStatuses.allValues[0].state);
  XCTAssertNil(decodedStatus.adapterStatuses.allValues[0].statusDescription);
  XCTAssertNil(decodedStatus.adapterStatuses.allValues[0].latency);
}

@end
