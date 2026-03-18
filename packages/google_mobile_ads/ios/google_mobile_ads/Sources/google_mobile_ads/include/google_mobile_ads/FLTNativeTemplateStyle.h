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
#import "FLTNativeTemplateTextStyle.h"
#import "FLTNativeTemplateType.h"
#import "GADTTemplateView.h"
#import <Foundation/Foundation.h>
#import <GoogleMobileAds/GADNativeAd.h>
#import <UIKit/UIKit.h>

/**
 * Wraps a GADTTemplateView for being displayed as a platform view.
 * Exists to override layoutSubviews, so we can attach layout constraints.
 */
@interface FLTNativeTemplateViewWrapper : UIView

/** The GADTTemplateView that is being wrapped.  */
@property GADTTemplateView *_Nullable templateView;
@end

@interface FLTNativeTemplateStyle : NSObject

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
            cornerRadius:(NSNumber *_Nullable)cornerRadius;
@property(readonly) FLTNativeTemplateType *_Nonnull templateType;
@property(readonly) FLTNativeTemplateColor *_Nullable mainBackgroundColor;
@property(readonly) FLTNativeTemplateTextStyle *_Nullable callToActionStyle;
@property(readonly) FLTNativeTemplateTextStyle *_Nullable primaryTextStyle;
@property(readonly) FLTNativeTemplateTextStyle *_Nullable secondaryTextStyle;
@property(readonly) FLTNativeTemplateTextStyle *_Nullable tertiaryTextStyle;
@property(readonly) NSNumber *_Nullable cornerRadius;

/** The actual view to be displayed. */
- (FLTNativeTemplateViewWrapper *_Nonnull)getDisplayedView:
    (GADNativeAd *_Nonnull)gadNativeAd;

@end
