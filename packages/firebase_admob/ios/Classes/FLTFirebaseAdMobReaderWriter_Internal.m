// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "FLTFirebaseAdMobReaderWriter_Internal.h"

// The type values below must be consistent for each platform.
typedef NS_ENUM(NSInteger, FLTAdMobField) {
  FLTAdMobFieldAdSize = 128,
  FLTAdMobFieldAdRequest = 129,
  FLTAdMobFieldDateTime = 130,
  FLTAdMobFieldAdGender = 131,
  FLTADMobFieldRewardItem = 132,
  FLTAdMobFieldLoadAdError = 133,
  FLTADMobFieldPublisherAdRequest = 134,
};

@interface FLTFirebaseAdMobReader : FlutterStandardReader
@end

@interface FLTFirebaseAdMobWriter : FlutterStandardWriter
@end

@implementation FLTFirebaseAdMobReaderWriter
- (FlutterStandardReader *_Nonnull)readerWithData:(NSData *_Nonnull)data {
  return [[FLTFirebaseAdMobReader alloc] initWithData:data];
}

- (FlutterStandardWriter *_Nonnull)writerWithData:(NSMutableData *_Nonnull)data {
  return [[FLTFirebaseAdMobWriter alloc] initWithData:data];
}
@end

@implementation FLTFirebaseAdMobReader
- (id _Nullable)readValueOfType:(UInt8)type {
  FLTAdMobField field = (FLTAdMobField)type;
  switch (field) {
    case FLTAdMobFieldAdSize:
      return [[FLTAdSize alloc] initWithWidth:[self readValueOfType:[self readByte]]
                                       height:[self readValueOfType:[self readByte]]];
    case FLTAdMobFieldAdRequest: {
      FLTAdRequest *request = [[FLTAdRequest alloc] init];

      request.keywords = [self readValueOfType:[self readByte]];
      request.contentURL = [self readValueOfType:[self readByte]];
      request.birthday = [self readValueOfType:[self readByte]];

      NSNumber *gender = [self readValueOfType:[self readByte]];
      request.gender = gender.longValue;

      NSNumber *designedForFamilies = [self readValueOfType:[self readByte]];
      request.designedForFamilies = designedForFamilies.boolValue;

      NSNumber *childDirected = [self readValueOfType:[self readByte]];
      request.childDirected = childDirected.boolValue;

      request.testDevices = [self readValueOfType:[self readByte]];

      NSNumber *nonPersonalizedAds = [self readValueOfType:[self readByte]];
      request.nonPersonalizedAds = nonPersonalizedAds.boolValue;

      return request;
    }
    case FLTAdMobFieldDateTime: {
      NSNumber *milliSeconds = [self readValueOfType:[self readByte]];
      return [NSDate dateWithTimeIntervalSince1970:milliSeconds.longValue / 1000.0];
    }
    case FLTAdMobFieldAdGender: {
      return [self readValueOfType:[self readByte]];
    }
    case FLTADMobFieldRewardItem: {
      return [[FLTRewardItem alloc] initWithAmount:[self readValueOfType:[self readByte]]
                                              type:[self readValueOfType:[self readByte]]];
    }
    case FLTAdMobFieldLoadAdError: {
      return [[FLTLoadAdError alloc] initWithCode:[self readValueOfType:[self readByte]]
                                           domain:[self readValueOfType:[self readByte]]
                                          message:[self readValueOfType:[self readByte]]];
    }
    case FLTADMobFieldPublisherAdRequest: {
      FLTPublisherAdRequest *request = [[FLTPublisherAdRequest alloc] init];

      request.keywords = [self readValueOfType:[self readByte]];
      request.contentURL = [self readValueOfType:[self readByte]];
      request.customTargeting = [self readValueOfType:[self readByte]];
      request.customTargetingLists = [self readValueOfType:[self readByte]];

      return request;
    }
  }
  return [super readValueOfType:type];
}
@end

@implementation FLTFirebaseAdMobWriter
- (void)writeValue:(id _Nonnull)value {
  if ([value isKindOfClass:[FLTAdSize class]]) {
    [self writeByte:FLTAdMobFieldAdSize];
    FLTAdSize *size = value;
    [self writeValue:size.width];
    [self writeValue:size.height];
  } else if ([value isKindOfClass:[FLTPublisherAdRequest class]]) {
    [self writeByte:FLTADMobFieldPublisherAdRequest];
    FLTPublisherAdRequest *request = value;
    [self writeValue:request.keywords];
    [self writeValue:request.contentURL];
    [self writeValue:request.customTargeting];
    [self writeValue:request.customTargetingLists];
  } else if ([value isKindOfClass:[FLTAdRequest class]]) {
    [self writeByte:FLTAdMobFieldAdRequest];
    FLTAdRequest *request = value;
    [self writeValue:request.keywords];
    [self writeValue:request.contentURL];
    [self writeValue:request.birthday];

    [self writeByte:FLTAdMobFieldAdGender];
    [self writeValue:@(request.gender)];

    [self writeValue:@(request.designedForFamilies)];
    [self writeValue:@(request.childDirected)];
    [self writeValue:request.testDevices];
    [self writeValue:@(request.nonPersonalizedAds)];
  } else if ([value isKindOfClass:[NSDate class]]) {
    [self writeByte:FLTAdMobFieldDateTime];
    NSDate *date = value;
    [self writeValue:@([date timeIntervalSince1970] * 1000)];
  } else if ([value isKindOfClass:[FLTRewardItem class]]) {
    [self writeByte:FLTADMobFieldRewardItem];
    FLTRewardItem *item = value;
    [self writeValue:item.amount];
    [self writeValue:item.type];
  } else if ([value isKindOfClass:[FLTLoadAdError class]]) {
    [self writeByte:FLTAdMobFieldLoadAdError];
    FLTLoadAdError *error = value;
    [self writeValue:error.code];
    [self writeValue:error.domain];
    [self writeValue:error.message];
  } else {
    [super writeValue:value];
  }
}
@end
