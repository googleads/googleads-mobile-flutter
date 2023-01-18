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

#import <Foundation/Foundation.h>

/**
 * Predefined font types for native templates.
 */
typedef NS_ENUM(NSInteger, FLTNativeTemplateFontStyle) {
  FLTNativeTemplateFontNormal,
  FLTNativeTemplateFontBold,
  FLTNativeTemplateFontItalic,
  FLTNativeTemplateFontMonospace
};

/**
 * Handles mapping int values to FLTNativeTemplateFontStyle.
 */
@interface FLTNativeTemplateFontStyleWrapper : NSObject

- (instancetype _Nonnull)initWithInt:(int)intValue;
- (FLTNativeTemplateFontStyle)fontStyle;

@property(readonly) int intValue;
@end
