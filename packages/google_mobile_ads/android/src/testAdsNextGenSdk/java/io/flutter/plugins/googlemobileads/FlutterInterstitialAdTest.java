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

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;

import com.google.android.libraries.ads.mobile.sdk.interstitial.InterstitialAd;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.robolectric.RobolectricTestRunner;

/** Tests for the Next-Gen SDK {@link FlutterInterstitialAd}. */
@RunWith(RobolectricTestRunner.class)
public class FlutterInterstitialAdTest {

  @Test
  public void dispose_destroysLoadedAd() {
    FlutterInterstitialAd flutterInterstitialAd =
        new FlutterInterstitialAd(
            /* adId= */ 1,
            mock(AdInstanceManager.class),
            "testId",
            new FlutterAdRequest.Builder().setRequestAgent("test").build(),
            mock(FlutterAdLoader.class));
    InterstitialAd mockAd = mock(InterstitialAd.class);
    flutterInterstitialAd.onAdLoaded(mockAd);

    flutterInterstitialAd.dispose();

    verify(mockAd).destroy();
  }
}
