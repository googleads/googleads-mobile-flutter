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
