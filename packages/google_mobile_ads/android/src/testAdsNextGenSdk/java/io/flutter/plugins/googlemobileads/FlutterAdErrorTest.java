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
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.robolectric.Shadows.shadowOf;

import android.os.Looper;
import com.google.android.libraries.ads.mobile.sdk.common.FullScreenContentError;
import com.google.android.libraries.ads.mobile.sdk.common.MediationAdError;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.googlemobileads.FlutterAd.FlutterAdError;
import java.util.Map;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.ArgumentCaptor;
import org.robolectric.RobolectricTestRunner;

/** Tests for the Next-Gen SDK {@link FlutterAdError} conversion of show errors. */
@RunWith(RobolectricTestRunner.class)
public class FlutterAdErrorTest {

  private static final String MEDIATION_DOMAIN = "com.mbridge.msdk";
  private static final String MEDIATION_MESSAGE = "can't show because load is failed";

  @Test
  public void fullScreenContentError_withMediationAdError_populatesMediationError() {
    final FullScreenContentError sdkError =
        new FullScreenContentError(
            FullScreenContentError.ErrorCode.MEDIATION_SHOW_ERROR,
            "Error occurred to show a mediation Ad.",
            new MediationAdError(3900, MEDIATION_MESSAGE, MEDIATION_DOMAIN));

    final FlutterAdError error = new FlutterAdError(sdkError);

    assertEquals(FullScreenContentError.ErrorCode.MEDIATION_SHOW_ERROR.getValue(), error.code);
    assertEquals(AdInstanceManager.NEXT_GEN_DOMAIN, error.domain);
    assertEquals("Error occurred to show a mediation Ad.", error.message);
    assertNotNull(error.mediationError);
    assertEquals(3900, error.mediationError.code);
    assertEquals(MEDIATION_DOMAIN, error.mediationError.domain);
    assertEquals(MEDIATION_MESSAGE, error.mediationError.message);
    assertNull(error.mediationError.mediationError);
  }

  @Test
  public void fullScreenContentError_withoutMediationAdError_hasNullMediationError() {
    final FullScreenContentError sdkError =
        new FullScreenContentError(
            FullScreenContentError.ErrorCode.AD_REUSED, "The ad has already been shown.", null);

    final FlutterAdError error = new FlutterAdError(sdkError);

    assertEquals(FullScreenContentError.ErrorCode.AD_REUSED.getValue(), error.code);
    assertEquals(AdInstanceManager.NEXT_GEN_DOMAIN, error.domain);
    assertEquals("The ad has already been shown.", error.message);
    assertNull(error.mediationError);
  }

  @Test
  @SuppressWarnings("unchecked")
  public void onFailedToShowFullScreenContent_sendsMediationErrorToDart() {
    final MethodChannel channel = mock(MethodChannel.class);
    final AdInstanceManager manager = new AdInstanceManager(channel);

    manager.onFailedToShowFullScreenContent(
        1,
        new FlutterAdError(
            new FullScreenContentError(
                FullScreenContentError.ErrorCode.MEDIATION_SHOW_ERROR,
                "Error occurred to show a mediation Ad.",
                new MediationAdError(3900, MEDIATION_MESSAGE, MEDIATION_DOMAIN))));
    shadowOf(Looper.getMainLooper()).idle();

    final ArgumentCaptor<Map<Object, Object>> captor = ArgumentCaptor.forClass(Map.class);
    verify(channel).invokeMethod(eq("onAdEvent"), captor.capture());
    final Map<Object, Object> arguments = captor.getValue();
    assertEquals(1, arguments.get("adId"));
    assertEquals("onFailedToShowFullScreenContent", arguments.get("eventName"));
    assertEquals(
        new FlutterAdError(
            FullScreenContentError.ErrorCode.MEDIATION_SHOW_ERROR.getValue(),
            AdInstanceManager.NEXT_GEN_DOMAIN,
            "Error occurred to show a mediation Ad.",
            new FlutterAdError(3900, MEDIATION_DOMAIN, MEDIATION_MESSAGE)),
        arguments.get("error"));
  }
}
