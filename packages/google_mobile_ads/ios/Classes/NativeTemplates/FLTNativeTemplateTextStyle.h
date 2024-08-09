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

#import "FLTNativeTemplateColor.h"
#import "FLTNativeTemplateFontStyle.h"

/**
 * Contains style options that can be applied to text in a native template.
 */
@interface FLTNativeTemplateTextStyle : NSObject

- (instancetype _Nonnull)
    initWithTextColor:(FLTNativeTemplateColor *_Nullable)textColor
      backgroundColor:(FLTNativeTemplateColor *_Nullable)backgroundColor
            fontStyle:(FLTNativeTemplateFontStyleWrapper *_Nullable)fontStyle
                 size:(NSNumber *_Nullable)size;

@property(readonly) FLTNativeTemplateColor *_Nullable textColor;
@property(readonly) FLTNativeTemplateColor *_Nullable backgroundColor;
@property(readonly) FLTNativeTemplateFontStyleWrapper *_Nullable fontStyle;
@property(readonly) NSNumber *_Nullable size;
/** UIFont that has the corresponding fontStyle and size. */
@property(readonly) UIFont *_Nullable uiFont;
@end
