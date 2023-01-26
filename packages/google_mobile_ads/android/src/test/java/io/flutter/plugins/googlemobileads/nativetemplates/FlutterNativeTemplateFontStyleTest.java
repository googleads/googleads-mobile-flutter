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

package io.flutter.plugins.googlemobileads.nativetemplates;

import static org.junit.Assert.assertEquals;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.robolectric.RobolectricTestRunner;

/** Tests for {@link FlutterNativeTemplateFontStyle}. */
@RunWith(RobolectricTestRunner.class)
public class FlutterNativeTemplateFontStyleTest {

  @Test
  public void testFromIntValue() {
    for (int i = 0; i < FlutterNativeTemplateFontStyle.values().length; i++) {
      FlutterNativeTemplateFontStyle style = FlutterNativeTemplateFontStyle.fromIntValue(i);
      assertEquals(style, FlutterNativeTemplateFontStyle.values()[i]);
    }
  }

  @Test
  public void testFromIntValue_unknownValue() {
    FlutterNativeTemplateFontStyle type = FlutterNativeTemplateFontStyle.fromIntValue(-1);
    assertEquals(type, FlutterNativeTemplateFontStyle.NORMAL);
  }
}
