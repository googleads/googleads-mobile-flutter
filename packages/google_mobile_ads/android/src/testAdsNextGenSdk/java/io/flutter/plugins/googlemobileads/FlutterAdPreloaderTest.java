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
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.mock;

import android.content.Context;
import androidx.test.core.app.ApplicationProvider;
import com.google.android.libraries.ads.mobile.sdk.common.PreloadCallback;
import com.google.android.libraries.ads.mobile.sdk.common.PreloadConfiguration;
import com.google.android.libraries.ads.mobile.sdk.interstitial.InterstitialAdPreloader;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.Result;
import java.util.HashMap;
import java.util.Map;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.ArgumentCaptor;
import org.mockito.MockedStatic;
import org.mockito.Mockito;
import org.robolectric.RobolectricTestRunner;

@RunWith(RobolectricTestRunner.class)
public class FlutterAdPreloaderTest {

  private FlutterAdPreloader preloader;
  private MockedStatic<InterstitialAdPreloader> mockedInterstitialPreloader;

  @Before
  public void setup() {
    Context context = ApplicationProvider.getApplicationContext();
    preloader =
        new FlutterAdPreloader(
            context, mock(AdInstanceManager.class), mock(MethodChannel.class));
    mockedInterstitialPreloader = Mockito.mockStatic(InterstitialAdPreloader.class);
  }

  @After
  public void tearDown() {
    mockedInterstitialPreloader.close();
  }

  @Test
  public void startPreloading_withNullRequest_setsRequestAgent() {
    Map<String, Object> args = new HashMap<>();
    args.put("preloadId", "preload-id-1");
    args.put("adUnitId", "unit-id");
    args.put("className", "InterstitialAd");
    args.put("request", null);

    preloader.onMethodCall(new MethodCall("MobileAds#startPreloading", args), mock(Result.class));

    ArgumentCaptor<PreloadConfiguration> captor =
        ArgumentCaptor.forClass(PreloadConfiguration.class);
    mockedInterstitialPreloader.verify(
        () ->
            InterstitialAdPreloader.start(
                eq("preload-id-1"), captor.capture(), any(PreloadCallback.class)));
    assertEquals(
        Constants.REQUEST_AGENT_PREFIX_VERSIONED, captor.getValue().getRequest().getRequestAgent());
  }
}
