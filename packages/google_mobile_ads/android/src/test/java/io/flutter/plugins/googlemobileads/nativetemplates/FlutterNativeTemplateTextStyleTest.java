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
import static org.mockito.Mockito.mock;

import android.graphics.drawable.ColorDrawable;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.robolectric.RobolectricTestRunner;

/** Tests for {@link FlutterNativeTemplateTextStyle}. */
@RunWith(RobolectricTestRunner.class)
public class FlutterNativeTemplateTextStyleTest {

  @Test
  public void testGetters() {
    ColorDrawable textColor = mock(ColorDrawable.class);
    ColorDrawable backgroundColor = mock(ColorDrawable.class);
    FlutterNativeTemplateFontStyle fontStyle = mock(FlutterNativeTemplateFontStyle.class);
    Double size = 1.;
    FlutterNativeTemplateTextStyle style =
        new FlutterNativeTemplateTextStyle(textColor, backgroundColor, fontStyle, size);
    assertEquals(style.getTextColor(), textColor);
    assertEquals(style.getBackgroundColor(), backgroundColor);
    assertEquals(style.getFontStyle(), fontStyle);
    assertEquals(style.getSize(), 1f, 0);
  }
}
