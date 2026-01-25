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

#import "FLTNativeTemplateStyle.h"
#import "FLTAdUtil.h"
#import "GADTSmallTemplateView.h"
#import "GADTTemplateView.h"

@implementation FLTNativeTemplateStyle

- (instancetype _Nonnull)
    initWithTemplateType:(FLTNativeTemplateType *_Nonnull)templateType
     mainBackgroundColor:(FLTNativeTemplateColor *_Nullable)mainBackgroundColor
       callToActionStyle:
           (FLTNativeTemplateTextStyle *_Nullable)callToActionStyle
        primaryTextStyle:(FLTNativeTemplateTextStyle *_Nullable)primaryTextStyle
      secondaryTextStyle:
          (FLTNativeTemplateTextStyle *_Nullable)secondaryTextStyle
       tertiaryTextStyle:
           (FLTNativeTemplateTextStyle *_Nullable)tertiaryTextStyle
            cornerRadius:(NSNumber *_Nullable)cornerRadius {
  self = [super init];
  if (self) {
    _templateType = templateType;
    _mainBackgroundColor = mainBackgroundColor;
    _callToActionStyle = callToActionStyle;
    _primaryTextStyle = primaryTextStyle;
    _secondaryTextStyle = secondaryTextStyle;
    _tertiaryTextStyle = tertiaryTextStyle;
    _cornerRadius = cornerRadius;
  }
  return self;
}

- (FLTNativeTemplateViewWrapper *_Nonnull)getDisplayedView:
    (GADNativeAd *_Nonnull)gadNativeAd {
  GADTTemplateView *templateView = _templateType.templateView;
  templateView.nativeAd = gadNativeAd;

  NSMutableDictionary *styles = [[NSMutableDictionary alloc] init];
  if ([FLTAdUtil isNotNull:_mainBackgroundColor]) {
    styles[GADTNativeTemplateStyleKeyMainBackgroundColor] =
        _mainBackgroundColor.uiColor;
  }
  if ([FLTAdUtil isNotNull:_cornerRadius]) {
    styles[GADTNativeTemplateStyleKeyCornerRadius] = _cornerRadius;
  }
  if ([FLTAdUtil isNotNull:_callToActionStyle]) {
    if ([FLTAdUtil isNotNull:_callToActionStyle.backgroundColor]) {
      styles[GADTNativeTemplateStyleKeyCallToActionBackgroundColor] =
          _callToActionStyle.backgroundColor.uiColor;
    }
    if ([FLTAdUtil isNotNull:_callToActionStyle.uiFont]) {
      styles[GADTNativeTemplateStyleKeyCallToActionFont] =
          _callToActionStyle.uiFont;
    }
    if ([FLTAdUtil isNotNull:_callToActionStyle.textColor]) {
      styles[GADTNativeTemplateStyleKeyCallToActionFontColor] =
          _callToActionStyle.textColor.uiColor;
    }
  }
  if ([FLTAdUtil isNotNull:_primaryTextStyle]) {
    if ([FLTAdUtil isNotNull:_primaryTextStyle.backgroundColor]) {
      styles[GADTNativeTemplateStyleKeyPrimaryBackgroundColor] =
          _primaryTextStyle.backgroundColor.uiColor;
    }
    if ([FLTAdUtil isNotNull:_primaryTextStyle.uiFont]) {
      styles[GADTNativeTemplateStyleKeyPrimaryFont] = _primaryTextStyle.uiFont;
    }
    if ([FLTAdUtil isNotNull:_primaryTextStyle.textColor]) {
      styles[GADTNativeTemplateStyleKeyPrimaryFontColor] =
          _primaryTextStyle.textColor.uiColor;
    }
  }
  if ([FLTAdUtil isNotNull:_secondaryTextStyle]) {
    if ([FLTAdUtil isNotNull:_secondaryTextStyle.backgroundColor]) {
      styles[GADTNativeTemplateStyleKeySecondaryBackgroundColor] =
          _secondaryTextStyle.backgroundColor.uiColor;
    }
    if ([FLTAdUtil isNotNull:_secondaryTextStyle.uiFont]) {
      styles[GADTNativeTemplateStyleKeySecondaryFont] =
          _secondaryTextStyle.uiFont;
    }
    if ([FLTAdUtil isNotNull:_secondaryTextStyle.textColor]) {
      styles[GADTNativeTemplateStyleKeySecondaryFontColor] =
          _secondaryTextStyle.textColor.uiColor;
    }
  }
  if ([FLTAdUtil isNotNull:_tertiaryTextStyle]) {
    if ([FLTAdUtil isNotNull:_tertiaryTextStyle.backgroundColor]) {
      styles[GADTNativeTemplateStyleKeyTertiaryBackgroundColor] =
          _tertiaryTextStyle.backgroundColor.uiColor;
    }
    if ([FLTAdUtil isNotNull:_tertiaryTextStyle.uiFont]) {
      styles[GADTNativeTemplateStyleKeyTertiaryFont] =
          _tertiaryTextStyle.uiFont;
    }
    if ([FLTAdUtil isNotNull:_tertiaryTextStyle.textColor]) {
      styles[GADTNativeTemplateStyleKeyTertiaryFontColor] =
          _tertiaryTextStyle.textColor.uiColor;
    }
  }
  templateView.styles = styles;

  FLTNativeTemplateViewWrapper *wrapper =
      [[FLTNativeTemplateViewWrapper alloc] initWithFrame:CGRectZero];
  wrapper.templateView = templateView;
  return wrapper;
}

@end

@implementation FLTNativeTemplateViewWrapper

- (void)layoutSubviews {
  [super layoutSubviews];
  if (_templateView) {
    [self addSubview:_templateView];
    // Constrain the top of the templateView to the top of this view. This top
    // aligns the template view
    if (_templateView.superview) {
      [_templateView.superview
          addConstraint:[NSLayoutConstraint
                            constraintWithItem:_templateView.superview
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:_templateView
                                     attribute:NSLayoutAttributeTop
                                    multiplier:1
                                      constant:0]];
      [_templateView.superview
          addConstraint:
              [NSLayoutConstraint
                  constraintWithItem:_templateView.superview
                           attribute:NSLayoutAttributeBottom
                           relatedBy:NSLayoutRelationGreaterThanOrEqual
                              toItem:_templateView
                           attribute:NSLayoutAttributeBottom
                          multiplier:1
                            constant:0]];
    }
    [_templateView addHorizontalConstraintsToSuperviewWidth];
  }
}

@end
