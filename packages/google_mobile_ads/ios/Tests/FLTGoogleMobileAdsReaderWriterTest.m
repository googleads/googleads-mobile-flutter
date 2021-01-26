// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <OCMock/OCMock.h>
#import <XCTest/XCTest.h>

@import google_mobile_ads;

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

- (void)testEncodeDecodeDate {
  NSDate *date = [NSDate dateWithTimeIntervalSince1970:0.1];
  NSData *encodedMessage = [_messageCodec encode:date];

  NSDate *decodedDate = [_messageCodec decode:encodedMessage];
  XCTAssertEqualObjects(decodedDate, [NSDate dateWithTimeIntervalSince1970:0.1]);
}

- (void)testEncodeDecodeAdRequest {
  FLTAdRequest *request = [[FLTAdRequest alloc] init];
  request.keywords = @[ @"apple" ];
  request.contentURL = @"banana";
  request.birthday = [NSDate dateWithTimeIntervalSince1970:0.1];
  request.gender = FLTAdGenderMale;
  request.designedForFamilies = YES;
  request.childDirected = NO;
  request.testDevices = @[ @"orange" ];
  request.nonPersonalizedAds = YES;

  NSData *encodedMessage = [_messageCodec encode:request];

  FLTAdRequest *decodedRequest = [_messageCodec decode:encodedMessage];
  XCTAssertTrue([decodedRequest.keywords isEqualToArray:@[ @"apple" ]]);
  XCTAssertEqualObjects(decodedRequest.contentURL, @"banana");
  XCTAssertEqualObjects(decodedRequest.birthday, [NSDate dateWithTimeIntervalSince1970:0.1]);
  XCTAssertEqual(decodedRequest.gender, FLTAdGenderMale);
  XCTAssertTrue(decodedRequest.designedForFamilies);
  XCTAssertFalse(decodedRequest.childDirected);
  XCTAssertTrue([decodedRequest.testDevices isEqualToArray:@[ @"orange" ]]);
  XCTAssertTrue(decodedRequest.nonPersonalizedAds);
}

- (void)testEncodeDecodePublisherAdRequest {
  FLTPublisherAdRequest *request = [[FLTPublisherAdRequest alloc] init];
  request.keywords = @[ @"apple" ];
  request.contentURL = @"banana";
  request.customTargeting = @{@"table" : @"linen"};
  request.customTargetingLists = @{@"go" : @[ @"lakers" ]};

  NSData *encodedMessage = [_messageCodec encode:request];

  FLTPublisherAdRequest *decodedRequest = [_messageCodec decode:encodedMessage];
  XCTAssertTrue([decodedRequest.keywords isEqualToArray:@[ @"apple" ]]);
  XCTAssertEqualObjects(decodedRequest.contentURL, @"banana");
  XCTAssertTrue([decodedRequest.customTargeting isEqualToDictionary:@{@"table" : @"linen"}]);
  XCTAssertTrue(
      [decodedRequest.customTargetingLists isEqualToDictionary:@{@"go" : @[ @"lakers" ]}]);
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
