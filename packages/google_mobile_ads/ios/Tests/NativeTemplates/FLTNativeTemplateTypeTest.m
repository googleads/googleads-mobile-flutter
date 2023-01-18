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

#import "FLTNativeTemplateType.h"
#import <XCTest/XCTest.h>

@interface FLTNativeTemplateTypeTest : XCTestCase
@end

@implementation FLTNativeTemplateTypeTest

- (void)testXibName {
  FLTNativeTemplateType *templateType =
      [[FLTNativeTemplateType alloc] initWithInt:0];
  XCTAssertEqual(templateType.xibName, @"GADTSmallTemplateView");

  templateType = [[FLTNativeTemplateType alloc] initWithInt:1];
  XCTAssertEqual(templateType.xibName, @"GADTMediumTemplateView");

  // Unknown templates default to medium
  templateType = [[FLTNativeTemplateType alloc] initWithInt:-1];
  XCTAssertEqual(templateType.xibName, @"GADTMediumTemplateView");

  templateType = [[FLTNativeTemplateType alloc] initWithInt:2];
  XCTAssertEqual(templateType.xibName, @"GADTMediumTemplateView");
}

@end
