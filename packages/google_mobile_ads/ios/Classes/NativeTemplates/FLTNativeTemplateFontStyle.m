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

#import "FLTNativeTemplateFontStyle.h"

@implementation FLTNativeTemplateFontStyleWrapper {
  int _intValue;
}

- (instancetype _Nonnull)initWithInt:(int)intValue {
  self = [super init];
  if (self) {
    _intValue = intValue;
  }
  return self;
}

- (FLTNativeTemplateFontStyle)fontStyle {
  switch (_intValue) {
  case 0:
    return FLTNativeTemplateFontNormal;
  case 1:
    return FLTNativeTemplateFontBold;
  case 2:
    return FLTNativeTemplateFontItalic;
  case 3:
    return FLTNativeTemplateFontMonospace;
  default:
    NSLog(@"Unknown FLTNativeTemplateFontStyle value: %d", _intValue);
    return FLTNativeTemplateFontNormal;
  }
}

@end
