#import <OCMock/OCMock.h>
#import <XCTest/XCTest.h>

@import firebase_admob;

@interface FLTFirebaseAdMobReaderWriterTest : XCTestCase
@end

@implementation FLTFirebaseAdMobReaderWriterTest {
  FlutterStandardMessageCodec *_messageCodec;
}

- (void)setUp {
  FLTFirebaseAdMobReaderWriter *readerWriter = [[FLTFirebaseAdMobReaderWriter alloc] init];
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
@end
