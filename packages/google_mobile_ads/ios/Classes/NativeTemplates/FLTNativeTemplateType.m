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

#import "FLTNativeTemplateType.h"

@implementation FLTNativeTemplateType {
  int _intValue;
}

- (instancetype _Nonnull)initWithInt:(int)intValue {
  self = [super init];
  if (self) {
    _intValue = intValue;
  }
  return self;
}

- (NSString *)xibName {
  switch (_intValue) {
  case 0:
    return @"GADTSmallTemplateView";
  case 1:
    return @"GADTMediumTemplateView";
  default:
    NSLog(@"Unknown template type value: %d", _intValue);
    return @"GADTMediumTemplateView";
  }
}

@end
