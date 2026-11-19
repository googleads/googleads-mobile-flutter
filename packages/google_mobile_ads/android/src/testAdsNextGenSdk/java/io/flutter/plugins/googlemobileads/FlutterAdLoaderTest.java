// Copyright 2026 Google LLC
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

import com.google.android.gms.ads.VideoOptions;
import com.google.android.gms.ads.nativead.NativeAdOptions;
import com.google.android.libraries.ads.mobile.sdk.common.AdChoicesPlacement;
import com.google.android.libraries.ads.mobile.sdk.nativead.NativeAd.NativeAdType;
import com.google.android.libraries.ads.mobile.sdk.nativead.NativeAd.NativeMediaAspectRatio;
import com.google.android.libraries.ads.mobile.sdk.nativead.NativeAdRequest;
import java.util.List;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.robolectric.RobolectricTestRunner;

/** Tests for the Next-Gen SDK {@link FlutterAdLoader}. */
@RunWith(RobolectricTestRunner.class)
public class FlutterAdLoaderTest {

  private static final String AD_UNIT_ID = "testAdUnitId";

  @Test
  public void buildNativeAdRequest_carriesOverNativeAdOptions() {
    NativeAdOptions options =
        new NativeAdOptions.Builder()
            .setMediaAspectRatio(NativeAdOptions.NATIVE_MEDIA_ASPECT_RATIO_LANDSCAPE)
            .setAdChoicesPlacement(NativeAdOptions.ADCHOICES_BOTTOM_LEFT)
            .setReturnUrlsForImageAssets(true)
            .setVideoOptions(new VideoOptions.Builder().setStartMuted(false).build())
            .build();

    NativeAdRequest request = FlutterAdLoader.buildNativeAdRequest(AD_UNIT_ID, options);

    assertEquals(AD_UNIT_ID, request.getAdUnitId());
    assertEquals(NativeMediaAspectRatio.LANDSCAPE, request.getMediaAspectRatio());
    assertEquals(AdChoicesPlacement.BOTTOM_LEFT, request.getAdChoicesPlacement());
    assertTrue(request.isImageLoadingDisabled());
    assertFalse(request.getVideoOptions().getStartMuted());
  }

  @Test
  public void buildNativeAdRequest_mapsEveryMediaAspectRatio() {
    int[] ratios = {
      NativeAdOptions.NATIVE_MEDIA_ASPECT_RATIO_ANY,
      NativeAdOptions.NATIVE_MEDIA_ASPECT_RATIO_LANDSCAPE,
      NativeAdOptions.NATIVE_MEDIA_ASPECT_RATIO_PORTRAIT,
      NativeAdOptions.NATIVE_MEDIA_ASPECT_RATIO_SQUARE,
    };
    NativeMediaAspectRatio[] expected = {
      NativeMediaAspectRatio.ANY,
      NativeMediaAspectRatio.LANDSCAPE,
      NativeMediaAspectRatio.PORTRAIT,
      NativeMediaAspectRatio.SQUARE,
    };
    for (int i = 0; i < ratios.length; i++) {
      NativeAdOptions options =
          new NativeAdOptions.Builder().setMediaAspectRatio(ratios[i]).build();

      assertEquals(
          expected[i],
          FlutterAdLoader.buildNativeAdRequest(AD_UNIT_ID, options).getMediaAspectRatio());
    }
  }

  @Test
  public void buildNativeAdRequest_defaultOptionsKeepSdkDefaults() {
    NativeAdRequest defaults =
        new NativeAdRequest.Builder(AD_UNIT_ID, List.of(NativeAdType.NATIVE)).build();

    NativeAdRequest request =
        FlutterAdLoader.buildNativeAdRequest(AD_UNIT_ID, new NativeAdOptions.Builder().build());

    assertEquals(defaults.getMediaAspectRatio(), request.getMediaAspectRatio());
    assertEquals(defaults.getAdChoicesPlacement(), request.getAdChoicesPlacement());
    assertFalse(request.isImageLoadingDisabled());
  }
}
