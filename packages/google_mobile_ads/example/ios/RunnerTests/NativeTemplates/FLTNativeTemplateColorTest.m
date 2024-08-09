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

#import "FLTNativeTemplateColor.h"
#import <OCMock/OCMock.h>
#import <XCTest/XCTest.h>

@interface FLTNativeTemplateColorTest : XCTestCase
@end

@implementation FLTNativeTemplateColorTest

- (void)testConvertToUiColor {
  FLTNativeTemplateColor *color = [[FLTNativeTemplateColor alloc]
      initWithAlpha:[[NSNumber alloc] initWithFloat:5.0f]
                red:@10.0f
              green:[[NSNumber alloc] initWithFloat:15.0f]
               blue:[[NSNumber alloc] initWithFloat:20.0f]];
  CGFloat alpha;
  CGFloat red;
  CGFloat green;
  CGFloat blue;
  [color.uiColor getRed:&red green:&green blue:&blue alpha:&alpha];
  XCTAssertEqualWithAccuracy(alpha, 5.0f / 255.0f, FLT_EPSILON);
  XCTAssertEqualWithAccuracy(red, 10.0f / 255.0f, FLT_EPSILON);
  XCTAssertEqualWithAccuracy(green, 15.0f / 255.0f, FLT_EPSILON);
  XCTAssertEqualWithAccuracy(blue, 20.0f / 255.0f, FLT_EPSILON);
}

@end
