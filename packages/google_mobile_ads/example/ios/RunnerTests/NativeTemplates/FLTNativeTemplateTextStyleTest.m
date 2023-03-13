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

#import "FLTNativeTemplateTextStyle.h"

@interface FLTNativeTemplateTextStyleTest : XCTestCase
@end

@implementation FLTNativeTemplateTextStyleTest

- (void)testInitWithNilParameters {
  FLTNativeTemplateTextStyle *textStyle =
      [[FLTNativeTemplateTextStyle alloc] initWithTextColor:nil
                                            backgroundColor:nil
                                                  fontStyle:nil
                                                       size:nil];
  XCTAssertNil(textStyle.uiFont);
  XCTAssertNil(textStyle.backgroundColor);
  XCTAssertNil(textStyle.textColor);
  XCTAssertNil(textStyle.fontStyle);
  XCTAssertNil(textStyle.size);
}

- (void)testInitWithDefinedParams {
  FLTNativeTemplateColor *textColor =
      OCMClassMock([FLTNativeTemplateColor class]);
  FLTNativeTemplateColor *backgroundColor =
      OCMClassMock([FLTNativeTemplateColor class]);
  FLTNativeTemplateFontStyleWrapper *fontStyleWrapper =
      OCMClassMock([FLTNativeTemplateFontStyleWrapper class]);
  OCMStub([fontStyleWrapper fontStyle]).andReturn(FLTNativeTemplateFontBold);
  NSNumber *size = [[NSNumber alloc] initWithFloat:14.0f];

  FLTNativeTemplateTextStyle *textStyle =
      [[FLTNativeTemplateTextStyle alloc] initWithTextColor:textColor
                                            backgroundColor:backgroundColor
                                                  fontStyle:fontStyleWrapper
                                                       size:size];

  XCTAssertEqual(textStyle.backgroundColor, backgroundColor);
  XCTAssertEqual(textStyle.textColor, textColor);
  XCTAssertEqual(textStyle.fontStyle, fontStyleWrapper);
  XCTAssertEqual(textStyle.size, size);

  UIFont *font = textStyle.uiFont;
  UIFont *expectedFont = [UIFont boldSystemFontOfSize:14.0f];
  XCTAssertEqual(font.pointSize, expectedFont.pointSize);
  XCTAssertEqual(font.fontName, expectedFont.fontName);
  XCTAssertEqual(font.familyName, expectedFont.familyName);
}

- (void)testUiFontWithMissingSize {
  FLTNativeTemplateColor *textColor =
      OCMClassMock([FLTNativeTemplateColor class]);
  FLTNativeTemplateColor *backgroundColor =
      OCMClassMock([FLTNativeTemplateColor class]);
  FLTNativeTemplateFontStyleWrapper *fontStyleWrapper =
      OCMClassMock([FLTNativeTemplateFontStyleWrapper class]);
  OCMStub([fontStyleWrapper fontStyle]).andReturn(FLTNativeTemplateFontItalic);

  FLTNativeTemplateTextStyle *textStyle =
      [[FLTNativeTemplateTextStyle alloc] initWithTextColor:textColor
                                            backgroundColor:backgroundColor
                                                  fontStyle:fontStyleWrapper
                                                       size:nil];

  XCTAssertEqual(textStyle.backgroundColor, backgroundColor);
  XCTAssertEqual(textStyle.textColor, textColor);
  XCTAssertEqual(textStyle.fontStyle, fontStyleWrapper);
  XCTAssertNil(textStyle.size);

  UIFont *font = textStyle.uiFont;
  // System font size is used when size is not defined
  UIFont *expectedFont = [UIFont italicSystemFontOfSize:UIFont.systemFontSize];
  XCTAssertEqual(font.pointSize, expectedFont.pointSize);
  XCTAssertEqual(font.fontName, expectedFont.fontName);
  XCTAssertEqual(font.familyName, expectedFont.familyName);
}

- (void)testUiFontWithMissingFontStyle {
  FLTNativeTemplateColor *textColor =
      OCMClassMock([FLTNativeTemplateColor class]);
  FLTNativeTemplateColor *backgroundColor =
      OCMClassMock([FLTNativeTemplateColor class]);
  NSNumber *size = [[NSNumber alloc] initWithFloat:14.0f];
  FLTNativeTemplateTextStyle *textStyle =
      [[FLTNativeTemplateTextStyle alloc] initWithTextColor:textColor
                                            backgroundColor:backgroundColor
                                                  fontStyle:nil
                                                       size:size];

  XCTAssertEqual(textStyle.backgroundColor, backgroundColor);
  XCTAssertEqual(textStyle.textColor, textColor);
  XCTAssertNil(textStyle.fontStyle);
  XCTAssertEqual(textStyle.size, size);

  UIFont *font = textStyle.uiFont;
  // Default system font type is used when fontStyle is not defined
  UIFont *expectedFont = [UIFont systemFontOfSize:14.0f];
  XCTAssertEqual(font.pointSize, expectedFont.pointSize);
  XCTAssertEqual(font.fontName, expectedFont.fontName);
  XCTAssertEqual(font.familyName, expectedFont.familyName);
}

- (void)testUiFontWithUnknownFontStyle {
  FLTNativeTemplateColor *textColor =
      OCMClassMock([FLTNativeTemplateColor class]);
  FLTNativeTemplateColor *backgroundColor =
      OCMClassMock([FLTNativeTemplateColor class]);
  NSNumber *size = [[NSNumber alloc] initWithFloat:14.0f];
  FLTNativeTemplateFontStyleWrapper *fontStyleWrapper =
      OCMClassMock([FLTNativeTemplateFontStyleWrapper class]);
  OCMStub([fontStyleWrapper fontStyle]).andReturn(-1);

  FLTNativeTemplateTextStyle *textStyle =
      [[FLTNativeTemplateTextStyle alloc] initWithTextColor:textColor
                                            backgroundColor:backgroundColor
                                                  fontStyle:fontStyleWrapper
                                                       size:size];

  XCTAssertEqual(textStyle.backgroundColor, backgroundColor);
  XCTAssertEqual(textStyle.textColor, textColor);
  XCTAssertEqual(textStyle.fontStyle, fontStyleWrapper);
  XCTAssertEqual(textStyle.size, size);

  UIFont *font = textStyle.uiFont;
  // Default system font type is used when fontStyle is unknown
  UIFont *expectedFont = [UIFont systemFontOfSize:14.0f];
  XCTAssertEqual(font.pointSize, expectedFont.pointSize);
  XCTAssertEqual(font.fontName, expectedFont.fontName);
  XCTAssertEqual(font.familyName, expectedFont.familyName);
}

@end
