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

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.robolectric.Shadows.shadowOf;

import android.os.Looper;
import androidx.test.core.app.ApplicationProvider;
import com.google.android.libraries.ads.mobile.sdk.nativead.NativeAd;
import com.google.android.libraries.ads.mobile.sdk.nativead.NativeAdView;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.robolectric.RobolectricTestRunner;

/** Tests for the Next-Gen SDK {@link FlutterNativeAd}. */
@RunWith(RobolectricTestRunner.class)
public class FlutterNativeAdTest {

  private AdInstanceManager mockManager;
  private NativeAdFactory mockAdFactory;
  private NativeAdView mockNativeAdView;
  private NativeAd mockNativeAd;
  private FlutterNativeAd flutterNativeAd;

  @Before
  public void setup() {
    mockManager = mock(AdInstanceManager.class);
    mockNativeAd = mock(NativeAd.class);
    mockNativeAdView = mock(NativeAdView.class);
    mockAdFactory = mock(NativeAdFactory.class);
    when(mockAdFactory.createNativeAd(any(), any())).thenReturn(mockNativeAdView);
    flutterNativeAd =
        new FlutterNativeAd.Builder(ApplicationProvider.getApplicationContext())
            .setId(1)
            .setManager(mockManager)
            .setAdUnitId("testId")
            .setAdFactory(mockAdFactory)
            .setRequest(new FlutterAdRequest.Builder().setRequestAgent("test").build())
            .setFlutterAdLoader(mock(FlutterAdLoader.class))
            .build();
  }

  @Test
  public void dispose_factoryAd_destroysViewAndNativeAd() {
    flutterNativeAd.onNativeAdLoaded(mockNativeAd);

    flutterNativeAd.dispose();

    verify(mockNativeAdView).destroy();
    verify(mockNativeAd).destroy();
  }

  @Test
  public void onNativeAdLoaded_afterDispose_destroysNativeAd() {
    flutterNativeAd.dispose();

    flutterNativeAd.onNativeAdLoaded(mockNativeAd);

    verify(mockNativeAd).destroy();
    verify(mockAdFactory, never()).createNativeAd(any(), any());
    verify(mockManager, never()).onAdLoaded(anyInt(), any());
  }

  @Test
  public void loadedListener_adAlreadyCollected_destroysNativeAd() {
    // A null referent stands in for a FlutterNativeAd that was disposed and garbage collected.
    new FlutterNativeAdLoadedListener(null).onNativeAdLoaded(mockNativeAd);
    shadowOf(Looper.getMainLooper()).idle();

    verify(mockNativeAd).destroy();
  }
}
