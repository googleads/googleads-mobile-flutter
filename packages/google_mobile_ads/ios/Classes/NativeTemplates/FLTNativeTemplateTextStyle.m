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

#import "FLTNativeTemplateTextStyle.h"
#import "FLTAdUtil.h"

@implementation FLTNativeTemplateTextStyle

- (instancetype _Nonnull)
    initWithTextColor:(FLTNativeTemplateColor *_Nullable)textColor
      backgroundColor:(FLTNativeTemplateColor *_Nullable)backgroundColor
            fontStyle:(FLTNativeTemplateFontStyleWrapper *_Nullable)fontStyle
                 size:(NSNumber *_Nullable)size {
  self = [super init];
  if (self) {
    _textColor = textColor;
    _backgroundColor = backgroundColor;
    _fontStyle = fontStyle;
    _size = size;
  }
  return self;
}

- (UIFont *_Nullable)uiFont {
  if ([FLTAdUtil isNull:_fontStyle] && [FLTAdUtil isNull:_size]) {
    return nil;
  }

  CGFloat size =
      [FLTAdUtil isNull:_size] ? UIFont.systemFontSize : _size.floatValue;
  if ([FLTAdUtil isNull:_fontStyle]) {
    return [UIFont systemFontOfSize:size];
  } else {
    switch (_fontStyle.fontStyle) {
    case FLTNativeTemplateFontNormal:
      return [UIFont systemFontOfSize:size];
    case FLTNativeTemplateFontBold:
      return [UIFont boldSystemFontOfSize:size];
    case FLTNativeTemplateFontItalic:
      return [UIFont italicSystemFontOfSize:size];
    case FLTNativeTemplateFontMonospace:
      if (@available(iOS 13.0, *)) {
        return [UIFont monospacedSystemFontOfSize:size
                                           weight:UIFontWeightRegular];
      } else {
        return [UIFont monospacedDigitSystemFontOfSize:size
                                                weight:UIFontWeightRegular];
      }
    default:
      NSLog(@"Unknown fontStyle case: %ld", _fontStyle.fontStyle);
      return [UIFont systemFontOfSize:size];
    }
  }
}

@end
