// Copyright 2023 Google LLC
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

#import <OCMock/OCMock.h>
#import <XCTest/XCTest.h>

#import "FLTNativeTemplateColor.h"
#import "FLTNativeTemplateStyle.h"
#import "FLTNativeTemplateTextStyle.h"
#import "FLTNativeTemplateType.h"

@interface FLTNativeTemplateStyleTest : XCTestCase
@end

@implementation FLTNativeTemplateStyleTest

- (void)testInitNilParameters {
  FLTNativeTemplateType *templateType =
      [[FLTNativeTemplateType alloc] initWithInt:0];

  FLTNativeTemplateStyle *style =
      [[FLTNativeTemplateStyle alloc] initWithTemplateType:templateType
                                       mainBackgroundColor:nil
                                         callToActionStyle:nil
                                          primaryTextStyle:nil
                                        secondaryTextStyle:nil
                                         tertiaryTextStyle:nil
                                              cornerRadius:nil];
  XCTAssertEqual(style.templateType, templateType);
  XCTAssertNil(style.mainBackgroundColor);
  XCTAssertNil(style.callToActionStyle);
  XCTAssertNil(style.primaryTextStyle);
  XCTAssertNil(style.secondaryTextStyle);
  XCTAssertNil(style.tertiaryTextStyle);
  XCTAssertNil(style.cornerRadius);
}

- (void)testInit {
  FLTNativeTemplateType *templateType =
      [[FLTNativeTemplateType alloc] initWithInt:0];
  FLTNativeTemplateColor *bgColor =
      OCMClassMock([FLTNativeTemplateColor class]);
  UIColor *bgUIColor = OCMClassMock([UIColor class]);
  OCMStub([bgColor uiColor]).andReturn(bgUIColor);
  FLTNativeTemplateTextStyle *ctaStyle =
      OCMClassMock([FLTNativeTemplateTextStyle class]);
  FLTNativeTemplateTextStyle *primaryStyle =
      OCMClassMock([FLTNativeTemplateTextStyle class]);
  FLTNativeTemplateTextStyle *secondaryStyle =
      OCMClassMock([FLTNativeTemplateTextStyle class]);
  FLTNativeTemplateTextStyle *tertiaryStyle =
      OCMClassMock([FLTNativeTemplateTextStyle class]);

  FLTNativeTemplateStyle *style =
      [[FLTNativeTemplateStyle alloc] initWithTemplateType:templateType
                                       mainBackgroundColor:bgColor
                                         callToActionStyle:ctaStyle
                                          primaryTextStyle:primaryStyle
                                        secondaryTextStyle:secondaryStyle
                                         tertiaryTextStyle:tertiaryStyle
                                              cornerRadius:@14.0f];

  XCTAssertEqual(style.templateType, templateType);
  XCTAssertEqual(style.mainBackgroundColor, bgColor);
  XCTAssertEqual(style.callToActionStyle, ctaStyle);
  XCTAssertEqual(style.primaryTextStyle, primaryStyle);
  XCTAssertEqual(style.secondaryTextStyle, secondaryStyle);
  XCTAssertEqual(style.tertiaryTextStyle, tertiaryStyle);
  XCTAssertEqual(style.cornerRadius, @14.0f);
}

- (void)testGetDisplayedView {
  FLTNativeTemplateType *templateType =
      OCMClassMock([FLTNativeTemplateType class]);
  GADTTemplateView *templateView = OCMClassMock([GADTTemplateView class]);
  OCMStub([templateType templateView]).andReturn(templateView);

  FLTNativeTemplateColor *bgColor =
      OCMClassMock([FLTNativeTemplateColor class]);
  UIColor *bgUIColor = OCMClassMock([UIColor class]);
  OCMStub([bgColor uiColor]).andReturn(bgUIColor);

  // Setup mocks for cta
  FLTNativeTemplateTextStyle *ctaStyle =
      OCMClassMock([FLTNativeTemplateTextStyle class]);
  UIColor *ctaBackgroundUIColor = OCMClassMock([UIColor class]);
  FLTNativeTemplateColor *ctaBackgroundColor =
      OCMClassMock([FLTNativeTemplateColor class]);
  OCMStub([ctaBackgroundColor uiColor]).andReturn(ctaBackgroundUIColor);
  OCMStub([ctaStyle backgroundColor]).andReturn(ctaBackgroundColor);

  UIColor *ctaTextUIColor = OCMClassMock([UIColor class]);
  FLTNativeTemplateColor *ctaTextcolor =
      OCMClassMock([FLTNativeTemplateColor class]);
  OCMStub([ctaTextcolor uiColor]).andReturn(ctaTextUIColor);
  OCMStub([ctaStyle textColor]).andReturn(ctaTextcolor);

  UIFont *ctaFont = OCMClassMock([UIFont class]);
  OCMStub([ctaStyle uiFont]).andReturn(ctaFont);

  // Setup mocks for primary
  FLTNativeTemplateTextStyle *primaryStyle =
      OCMClassMock([FLTNativeTemplateTextStyle class]);
  UIColor *primaryBackgroundUIColor = OCMClassMock([UIColor class]);
  FLTNativeTemplateColor *primaryBackgroundColor =
      OCMClassMock([FLTNativeTemplateColor class]);
  OCMStub([primaryBackgroundColor uiColor]).andReturn(primaryBackgroundUIColor);
  OCMStub([primaryStyle backgroundColor]).andReturn(primaryBackgroundColor);

  UIColor *primaryTextUIColor = OCMClassMock([UIColor class]);
  FLTNativeTemplateColor *primaryTextcolor =
      OCMClassMock([FLTNativeTemplateColor class]);
  OCMStub([primaryTextcolor uiColor]).andReturn(primaryTextUIColor);
  OCMStub([primaryStyle textColor]).andReturn(primaryTextcolor);

  UIFont *primaryFont = OCMClassMock([UIFont class]);
  OCMStub([primaryStyle uiFont]).andReturn(primaryFont);

  // Setup mocks for secondary
  FLTNativeTemplateTextStyle *secondaryStyle =
      OCMClassMock([FLTNativeTemplateTextStyle class]);
  UIColor *secondaryBackgroundUIColor = OCMClassMock([UIColor class]);
  FLTNativeTemplateColor *secondaryBackgroundColor =
      OCMClassMock([FLTNativeTemplateColor class]);
  OCMStub([secondaryBackgroundColor uiColor])
      .andReturn(secondaryBackgroundUIColor);
  OCMStub([secondaryStyle backgroundColor]).andReturn(secondaryBackgroundColor);

  UIColor *secondaryTextUIColor = OCMClassMock([UIColor class]);
  FLTNativeTemplateColor *secondaryTextcolor =
      OCMClassMock([FLTNativeTemplateColor class]);
  OCMStub([secondaryTextcolor uiColor]).andReturn(secondaryTextUIColor);
  OCMStub([secondaryStyle textColor]).andReturn(secondaryTextcolor);

  UIFont *secondaryFont = OCMClassMock([UIFont class]);
  OCMStub([secondaryStyle uiFont]).andReturn(secondaryFont);

  // Setup mocks for tertiary
  FLTNativeTemplateTextStyle *tertiaryStyle =
      OCMClassMock([FLTNativeTemplateTextStyle class]);
  UIColor *tertiaryBackgroundUIColor = OCMClassMock([UIColor class]);
  FLTNativeTemplateColor *tertiaryBackgroundColor =
      OCMClassMock([FLTNativeTemplateColor class]);
  OCMStub([tertiaryBackgroundColor uiColor])
      .andReturn(tertiaryBackgroundUIColor);
  OCMStub([tertiaryStyle backgroundColor]).andReturn(tertiaryBackgroundColor);

  UIColor *tertiaryTextUIColor = OCMClassMock([UIColor class]);
  FLTNativeTemplateColor *tertiaryTextcolor =
      OCMClassMock([FLTNativeTemplateColor class]);
  OCMStub([tertiaryTextcolor uiColor]).andReturn(tertiaryTextUIColor);
  OCMStub([tertiaryStyle textColor]).andReturn(tertiaryTextcolor);

  UIFont *tertiaryFont = OCMClassMock([UIFont class]);
  OCMStub([tertiaryStyle uiFont]).andReturn(tertiaryFont);

  FLTNativeTemplateStyle *style =
      [[FLTNativeTemplateStyle alloc] initWithTemplateType:templateType
                                       mainBackgroundColor:bgColor
                                         callToActionStyle:ctaStyle
                                          primaryTextStyle:primaryStyle
                                        secondaryTextStyle:secondaryStyle
                                         tertiaryTextStyle:tertiaryStyle
                                              cornerRadius:@14.0f];

  GADNativeAd *gadNativeAd = OCMClassMock([GADNativeAd class]);

  FLTNativeTemplateViewWrapper *templateViewWrapper =
      [style getDisplayedView:gadNativeAd];
  XCTAssertEqual(templateViewWrapper.templateView, templateView);
  OCMVerify([templateView setNativeAd:[OCMArg isEqual:gadNativeAd]]);
  OCMVerify([templateView
      setStyles:[OCMArg checkWithBlock:^BOOL(id obj) {
        NSDictionary *styles = obj;
        XCTAssertEqual(styles[GADTNativeTemplateStyleKeyCornerRadius], @14.0f);

        XCTAssertEqual(
            styles[GADTNativeTemplateStyleKeyCallToActionBackgroundColor],
            ctaBackgroundUIColor);
        XCTAssertEqual(styles[GADTNativeTemplateStyleKeyCallToActionFontColor],
                       ctaTextUIColor);
        XCTAssertEqual(styles[GADTNativeTemplateStyleKeyCallToActionFont],
                       ctaFont);

        XCTAssertEqual(styles[GADTNativeTemplateStyleKeyPrimaryBackgroundColor],
                       primaryBackgroundUIColor);
        XCTAssertEqual(styles[GADTNativeTemplateStyleKeyPrimaryFontColor],
                       primaryTextUIColor);
        XCTAssertEqual(styles[GADTNativeTemplateStyleKeyPrimaryFont],
                       primaryFont);

        XCTAssertEqual(
            styles[GADTNativeTemplateStyleKeySecondaryBackgroundColor],
            secondaryBackgroundUIColor);
        XCTAssertEqual(styles[GADTNativeTemplateStyleKeySecondaryFontColor],
                       secondaryTextUIColor);
        XCTAssertEqual(styles[GADTNativeTemplateStyleKeySecondaryFont],
                       secondaryFont);

        XCTAssertEqual(
            styles[GADTNativeTemplateStyleKeyTertiaryBackgroundColor],
            tertiaryBackgroundUIColor);
        XCTAssertEqual(styles[GADTNativeTemplateStyleKeyTertiaryFontColor],
                       tertiaryTextUIColor);
        XCTAssertEqual(styles[GADTNativeTemplateStyleKeyTertiaryFont],
                       tertiaryFont);
        return YES;
      }]]);
}

@end
