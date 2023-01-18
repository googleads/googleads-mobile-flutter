package io.flutter.plugins.googlemobileads.nativetemplates;

import static org.junit.Assert.assertEquals;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.robolectric.RobolectricTestRunner;

/** Tests for {@link FlutterNativeTemplateType}. */
@RunWith(RobolectricTestRunner.class)
public class FlutterNativeTemplateTypeTest {

  @Test
  public void testFromIntValue() {
    for (int i = 0; i < FlutterNativeTemplateType.values().length; i++) {
      FlutterNativeTemplateType type = FlutterNativeTemplateType.fromIntValue(i);
      assertEquals(type, FlutterNativeTemplateType.values()[i]);
    }
  }

  @Test
  public void testFromIntValue_unknownValue() {
    FlutterNativeTemplateType type = FlutterNativeTemplateType.fromIntValue(-1);
    assertEquals(type, FlutterNativeTemplateType.MEDIUM);
  }
}
