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
