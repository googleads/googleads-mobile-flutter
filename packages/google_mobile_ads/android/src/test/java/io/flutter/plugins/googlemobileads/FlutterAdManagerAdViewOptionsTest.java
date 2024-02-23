// Copyright 2022 Google LLC
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

package io.flutter.plugins.googlemobileads;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import com.google.android.gms.ads.formats.AdManagerAdViewOptions;
import org.junit.Test;

/** Tests for {@link FlutterAdManagerAdViewOptions}. */
public class FlutterAdManagerAdViewOptionsTest {

  @Test
  public void testAsAdManagerAdViewOptions_null() {
    FlutterAdManagerAdViewOptions flutterAdManagerAdViewOptions =
        new FlutterAdManagerAdViewOptions(null);

    AdManagerAdViewOptions adManagerAdViewOptions =
        flutterAdManagerAdViewOptions.asAdManagerAdViewOptions();
    AdManagerAdViewOptions defaultOptions = new AdManagerAdViewOptions.Builder().build();
    assertEquals(
        adManagerAdViewOptions.getManualImpressionsEnabled(),
        defaultOptions.getManualImpressionsEnabled());
  }

  @Test
  public void testAsAdManagerAdViewOptions_true() {
    FlutterAdManagerAdViewOptions flutterAdManagerAdViewOptions =
        new FlutterAdManagerAdViewOptions(true);

    AdManagerAdViewOptions adManagerAdViewOptions =
        flutterAdManagerAdViewOptions.asAdManagerAdViewOptions();
    assertTrue(adManagerAdViewOptions.getManualImpressionsEnabled());
  }

  @Test
  public void testAsAdManagerAdViewOptions_false() {
    FlutterAdManagerAdViewOptions flutterAdManagerAdViewOptions =
        new FlutterAdManagerAdViewOptions(false);

    AdManagerAdViewOptions adManagerAdViewOptions =
        flutterAdManagerAdViewOptions.asAdManagerAdViewOptions();
    assertFalse(adManagerAdViewOptions.getManualImpressionsEnabled());
  }
}
