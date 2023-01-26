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
import static org.junit.Assert.assertNull;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.ArgumentMatchers.isNull;
import static org.mockito.Mockito.doReturn;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.spy;
import static org.mockito.Mockito.verify;

import android.content.Context;
import android.graphics.Color;
import android.graphics.Typeface;
import android.graphics.drawable.ColorDrawable;
import android.view.LayoutInflater;
import com.google.android.ads.nativetemplates.NativeTemplateStyle;
import com.google.android.ads.nativetemplates.TemplateView;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.robolectric.RobolectricTestRunner;

/** Tests for {@link FlutterNativeTemplateStyle}. */
@RunWith(RobolectricTestRunner.class)
public class FlutterNativeTemplateStyleTest {

  private Context mockContext = mock(Context.class);
  private LayoutInflater mockLayoutInflater = mock(LayoutInflater.class);
  private TemplateView mockTemplateView = mock(TemplateView.class);

  @Before
  public void setup() {
    doReturn(mockLayoutInflater)
        .when(mockContext)
        .getSystemService(eq(Context.LAYOUT_INFLATER_SERVICE));
    doReturn(mockTemplateView).when(mockLayoutInflater).inflate(anyInt(), isNull());
  }

  @Test
  public void testAsTemplateView_noStylesDefined() {
    FlutterNativeTemplateStyle flutterNativeTemplateStyle =
        new FlutterNativeTemplateStyle(
            FlutterNativeTemplateType.MEDIUM, null, null, null, null, null);

    FlutterNativeTemplateStyle spy = spy(flutterNativeTemplateStyle);
    NativeTemplateStyle mockNativeTemplateStyle = mock(NativeTemplateStyle.class);
    doReturn(mockNativeTemplateStyle).when(spy).asNativeTemplateStyle();

    TemplateView templateView = spy.asTemplateView(mockContext);

    verify(mockLayoutInflater).inflate(eq(FlutterNativeTemplateType.MEDIUM.resourceId()), isNull());
    verify(mockTemplateView).setStyles(eq(mockNativeTemplateStyle));
    assertEquals(templateView, mockTemplateView);
  }

  @Test
  public void testAsTemplateView_stylesDefined() {
    ColorDrawable mainBackgroundColor = new ColorDrawable(Color.argb(1, 2, 3, 4));
    FlutterNativeTemplateTextStyle ctaStyle = mock(FlutterNativeTemplateTextStyle.class);
    FlutterNativeTemplateTextStyle primaryStyle = mock(FlutterNativeTemplateTextStyle.class);
    FlutterNativeTemplateTextStyle secondaryStyle = mock(FlutterNativeTemplateTextStyle.class);
    FlutterNativeTemplateTextStyle tertiaryStyle = mock(FlutterNativeTemplateTextStyle.class);

    FlutterNativeTemplateStyle flutterNativeTemplateStyle =
        new FlutterNativeTemplateStyle(
            FlutterNativeTemplateType.SMALL,
            mainBackgroundColor,
            ctaStyle,
            primaryStyle,
            secondaryStyle,
            tertiaryStyle);

    FlutterNativeTemplateStyle spy = spy(flutterNativeTemplateStyle);
    NativeTemplateStyle mockNativeTemplateStyle = mock(NativeTemplateStyle.class);
    doReturn(mockNativeTemplateStyle).when(spy).asNativeTemplateStyle();

    TemplateView templateView = spy.asTemplateView(mockContext);

    verify(mockLayoutInflater).inflate(eq(FlutterNativeTemplateType.SMALL.resourceId()), isNull());
    verify(mockTemplateView).setStyles(eq(mockNativeTemplateStyle));
    assertEquals(templateView, mockTemplateView);
  }

  @Test
  public void testAsNativeTemplateStyle_noStylesDefined() {
    FlutterNativeTemplateStyle flutterNativeTemplateStyle =
        new FlutterNativeTemplateStyle(
            FlutterNativeTemplateType.MEDIUM, null, null, null, null, null);

    NativeTemplateStyle templateStyle = flutterNativeTemplateStyle.asNativeTemplateStyle();

    // Values should match that of an empty template style with the same type
    NativeTemplateStyle defaultStyle = new NativeTemplateStyle.Builder().build();
    assertEquals(templateStyle.getMainBackgroundColor(), defaultStyle.getMainBackgroundColor());
    assertEquals(
        templateStyle.getCallToActionBackgroundColor(),
        defaultStyle.getCallToActionBackgroundColor());
    assertEquals(
        templateStyle.getCallToActionTextSize(), defaultStyle.getCallToActionTextSize(), 0);
    assertEquals(
        templateStyle.getCallToActionTextTypeface(), defaultStyle.getCallToActionTextTypeface());
    assertEquals(
        templateStyle.getCallToActionTypefaceColor(), defaultStyle.getCallToActionTypefaceColor());
    assertEquals(
        templateStyle.getPrimaryTextBackgroundColor(),
        defaultStyle.getPrimaryTextBackgroundColor());
    assertEquals(templateStyle.getPrimaryTextSize(), defaultStyle.getPrimaryTextSize(), 0);
    assertEquals(templateStyle.getPrimaryTextTypeface(), defaultStyle.getPrimaryTextTypeface());
    assertEquals(
        templateStyle.getPrimaryTextTypefaceColor(), defaultStyle.getPrimaryTextTypefaceColor());
    assertEquals(
        templateStyle.getSecondaryTextBackgroundColor(),
        defaultStyle.getSecondaryTextBackgroundColor());
    assertEquals(templateStyle.getSecondaryTextSize(), defaultStyle.getSecondaryTextSize(), 0);
    assertEquals(templateStyle.getSecondaryTextTypeface(), defaultStyle.getSecondaryTextTypeface());
    assertEquals(
        templateStyle.getSecondaryTextTypefaceColor(),
        defaultStyle.getSecondaryTextTypefaceColor());
    assertEquals(
        templateStyle.getTertiaryTextBackgroundColor(),
        defaultStyle.getTertiaryTextBackgroundColor());
    assertEquals(templateStyle.getTertiaryTextSize(), defaultStyle.getTertiaryTextSize(), 0);
    assertEquals(templateStyle.getTertiaryTextTypeface(), defaultStyle.getTertiaryTextTypeface());
    assertEquals(
        templateStyle.getTertiaryTextTypefaceColor(), defaultStyle.getTertiaryTextTypefaceColor());
  }

  @Test
  public void testAsNativeTemplateStyle_stylesDefined() {
    ColorDrawable mainBackgroundColor = new ColorDrawable(Color.argb(1, 2, 3, 4));
    FlutterNativeTemplateTextStyle ctaStyle = mock(FlutterNativeTemplateTextStyle.class);
    doReturn(new ColorDrawable(Color.MAGENTA)).when(ctaStyle).getBackgroundColor();
    doReturn(new ColorDrawable(Color.LTGRAY)).when(ctaStyle).getTextColor();
    doReturn(null).when(ctaStyle).getFontStyle();
    doReturn(100f).when(ctaStyle).getSize();

    FlutterNativeTemplateTextStyle primaryStyle = mock(FlutterNativeTemplateTextStyle.class);
    doReturn(new ColorDrawable(Color.BLUE)).when(primaryStyle).getBackgroundColor();
    doReturn(new ColorDrawable(Color.GREEN)).when(primaryStyle).getTextColor();
    FlutterNativeTemplateFontStyle mockPrimaryFontStyle =
        mock(FlutterNativeTemplateFontStyle.class);
    Typeface mockPrimaryTypeface = mock(Typeface.class);
    doReturn(mockPrimaryTypeface).when(mockPrimaryFontStyle).getTypeface();
    doReturn(mockPrimaryFontStyle).when(primaryStyle).getFontStyle();
    doReturn(200f).when(primaryStyle).getSize();

    FlutterNativeTemplateTextStyle secondaryStyle = mock(FlutterNativeTemplateTextStyle.class);
    doReturn(new ColorDrawable(Color.BLACK)).when(secondaryStyle).getBackgroundColor();
    doReturn(new ColorDrawable(Color.RED)).when(secondaryStyle).getTextColor();
    FlutterNativeTemplateFontStyle mockSecondaryFontStyle =
        mock(FlutterNativeTemplateFontStyle.class);
    Typeface mockSecondaryTypeface = mock(Typeface.class);
    doReturn(mockSecondaryTypeface).when(mockSecondaryFontStyle).getTypeface();
    doReturn(mockSecondaryFontStyle).when(secondaryStyle).getFontStyle();
    doReturn(300f).when(secondaryStyle).getSize();

    FlutterNativeTemplateTextStyle tertiaryStyle = mock(FlutterNativeTemplateTextStyle.class);
    doReturn(new ColorDrawable(Color.TRANSPARENT)).when(tertiaryStyle).getBackgroundColor();
    doReturn(new ColorDrawable(Color.DKGRAY)).when(tertiaryStyle).getTextColor();
    FlutterNativeTemplateFontStyle mockTertiaryFontStyle =
        mock(FlutterNativeTemplateFontStyle.class);
    Typeface mockTertiaryTypeface = mock(Typeface.class);
    doReturn(mockTertiaryTypeface).when(mockTertiaryFontStyle).getTypeface();
    doReturn(mockTertiaryFontStyle).when(tertiaryStyle).getFontStyle();
    doReturn(1000f).when(tertiaryStyle).getSize();

    FlutterNativeTemplateStyle flutterNativeTemplateStyle =
        new FlutterNativeTemplateStyle(
            FlutterNativeTemplateType.SMALL,
            mainBackgroundColor,
            ctaStyle,
            primaryStyle,
            secondaryStyle,
            tertiaryStyle);

    NativeTemplateStyle templateStyle = flutterNativeTemplateStyle.asNativeTemplateStyle();

    assertEquals(templateStyle.getMainBackgroundColor(), mainBackgroundColor);
    assertEquals(templateStyle.getCallToActionBackgroundColor().getColor(), Color.MAGENTA);
    assertEquals(templateStyle.getCallToActionTypefaceColor(), (Integer) Color.LTGRAY);
    assertEquals(templateStyle.getCallToActionTextSize(), 100f, 0);
    assertNull(templateStyle.getCallToActionTextTypeface());

    assertEquals(templateStyle.getPrimaryTextBackgroundColor().getColor(), Color.BLUE);
    assertEquals(templateStyle.getPrimaryTextTypefaceColor(), (Integer) Color.GREEN);
    assertEquals(templateStyle.getPrimaryTextSize(), 200f, 0);
    assertEquals(templateStyle.getPrimaryTextTypeface(), mockPrimaryTypeface);

    assertEquals(templateStyle.getSecondaryTextBackgroundColor().getColor(), Color.BLACK);
    assertEquals(templateStyle.getSecondaryTextTypefaceColor(), (Integer) Color.RED);
    assertEquals(templateStyle.getSecondaryTextSize(), 300f, 0);
    assertEquals(templateStyle.getSecondaryTextTypeface(), mockSecondaryTypeface);

    assertEquals(templateStyle.getTertiaryTextBackgroundColor().getColor(), Color.TRANSPARENT);
    assertEquals(templateStyle.getTertiaryTextTypefaceColor(), (Integer) Color.DKGRAY);
    assertEquals(templateStyle.getTertiaryTextSize(), 1000f, 0);
    assertEquals(templateStyle.getTertiaryTextTypeface(), mockTertiaryTypeface);
  }
}
