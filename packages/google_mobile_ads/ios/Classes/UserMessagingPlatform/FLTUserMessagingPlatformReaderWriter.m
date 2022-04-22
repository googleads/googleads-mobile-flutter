// Copyright 2022 Google LLC
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

#import "FLTUserMessagingPlatformReaderWriter.h"
#include <UserMessagingPlatform/UserMessagingPlatform.h>

// The type values below must be consistent for each platform.
typedef NS_ENUM(NSInteger, FLTUserMessagingPlatformField) {
  FLTValueConsentInformation = 128,
  FLTValueConsentRequestParameters = 129,
  FLTValueConsentDebugSettings = 130,
  FLTValueConsentForm = 131,
};

@interface FLTUserMessagingPlatformReader : FlutterStandardReader
@property NSMutableDictionary<NSNumber *, UMPConsentForm *> *consentFormDict;
@end

@interface FLTUserMessagingPlatformWriter : FlutterStandardWriter
@property NSMutableDictionary<NSNumber *, UMPConsentForm *> *consentFormDict;
@end

@interface FLTUserMessagingPlatformReaderWriter()
@property NSMutableDictionary<NSNumber *, UMPConsentForm *> *consentFormDict;
@end

@implementation FLTUserMessagingPlatformReaderWriter


- (instancetype _Nonnull)init {
  self = [super init];
  if (self) {
    self.consentFormDict = [[NSMutableDictionary alloc] init];
  }
  return self;
}

- (FlutterStandardReader *_Nonnull)readerWithData:(NSData *_Nonnull)data {
  FLTUserMessagingPlatformReader *reader = [[FLTUserMessagingPlatformReader alloc] initWithData:data];
  reader.consentFormDict = self.consentFormDict;
  return reader;
}

- (FlutterStandardWriter *_Nonnull)writerWithData:
    (NSMutableData *_Nonnull)data {
  FLTUserMessagingPlatformWriter *writer = [[FLTUserMessagingPlatformWriter alloc] initWithData:data];
  writer.consentFormDict = self.consentFormDict;
  return writer;
}
@end


@implementation FLTUserMessagingPlatformWriter

- (void)writeValue:(id _Nonnull)value {
  if ([value isKindOfClass:[UMPConsentForm class]]) {
    UMPConsentForm *form = (UMPConsentForm *) value;
    NSNumber * hash = [[NSNumber alloc] initWithInteger:form.hash];
    _consentFormDict[hash] = form;
    [self writeByte:FLTValueConsentForm];
    [self writeValue:hash];
  } else if ([value isKindOfClass:[UMPConsentInformation class]]) {
    [self writeByte:FLTValueConsentInformation];
    // iOS just uses UMPConsentInformation.sharedInstance, so this value doesn't matter.
    [self writeValue:@(-1)];
  } else {
    [super writeValue:value];
  }
}


@end

@implementation FLTUserMessagingPlatformReader

- (id _Nullable)readValueOfType:(UInt8)type {
  FLTUserMessagingPlatformField field = (FLTUserMessagingPlatformField)type;
  switch (field) {
    case FLTValueConsentInformation:
      // Dart sends a value which is used for Android, but not needed for iOS
      [self readValueOfType:[self readByte]];
      return UMPConsentInformation.sharedInstance;
    case FLTValueConsentRequestParameters:{
      UMPRequestParameters *parameters = [[UMPRequestParameters alloc] init];
      NSNumber *tfuac = [self readValueOfType:[self readByte]];
      
      parameters.tagForUnderAgeOfConsent = tfuac.boolValue;
      UMPDebugSettings *debugSettings = [self readValueOfType:[self readByte]];
      parameters.debugSettings = debugSettings;
      return parameters;
    }
    case FLTValueConsentDebugSettings: {
      UMPDebugSettings *debugSettings = [[UMPDebugSettings alloc] init];
      NSNumber *geography = [self readValueOfType:[self readByte]];
      debugSettings.geography = geography.intValue;
      return debugSettings;
    }
    case FLTValueConsentForm: {
      NSNumber *hash = [self readValueOfType:[self readByte]];
      return _consentFormDict[hash];
    }
    default:
      return [super readValueOfType:type];
  }
}

@end




