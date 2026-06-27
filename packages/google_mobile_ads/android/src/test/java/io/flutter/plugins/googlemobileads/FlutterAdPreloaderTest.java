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
import static org.junit.Assert.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.spy;
import static org.mockito.Mockito.doReturn;

import android.content.Context;
import androidx.test.core.app.ApplicationProvider;
import com.google.android.gms.ads.interstitial.InterstitialAdPreloader;
import com.google.android.gms.ads.rewarded.RewardedAdPreloader;
import com.google.android.gms.ads.appopen.AppOpenAdPreloader;
import com.google.android.gms.ads.preload.PreloadCallbackV2;
import com.google.android.gms.ads.preload.PreloadConfiguration;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.Result;
import java.util.HashMap;
import java.util.Map;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.MockedStatic;
import org.mockito.Mockito;
import org.robolectric.RobolectricTestRunner;

@RunWith(RobolectricTestRunner.class)
public class FlutterAdPreloaderTest {

  private Context context;
  private AdInstanceManager mockManager;
  private MethodChannel mockChannel;
  private FlutterAdPreloader preloader;

  private MockedStatic<InterstitialAdPreloader> mockedInterstitialPreloader;
  private MockedStatic<RewardedAdPreloader> mockedRewardedPreloader;
  private MockedStatic<AppOpenAdPreloader> mockedAppOpenPreloader;

  @Before
  public void setup() {
    context = ApplicationProvider.getApplicationContext();
    mockManager = mock(AdInstanceManager.class);
    mockChannel = mock(MethodChannel.class);
    preloader = new FlutterAdPreloader(context, mockManager, mockChannel);

    mockedInterstitialPreloader = Mockito.mockStatic(InterstitialAdPreloader.class);
    mockedRewardedPreloader = Mockito.mockStatic(RewardedAdPreloader.class);
    mockedAppOpenPreloader = Mockito.mockStatic(AppOpenAdPreloader.class);
  }

  @After
  public void tearDown() {
    mockedInterstitialPreloader.close();
    mockedRewardedPreloader.close();
    mockedAppOpenPreloader.close();
  }

  @Test
  public void testStartPreloading_interstitial() {
    Map<String, Object> args = new HashMap<>();
    args.put("preloadId", "preload-id-1");
    args.put("adUnitId", "unit-id");
    args.put("bufferSize", 3);
    args.put("className", "InterstitialAd");
    args.put("request", null);

    MethodCall methodCall = new MethodCall("MobileAds#startPreloading", args);
    Result mockResult = mock(Result.class);

    preloader.onMethodCall(methodCall, mockResult);

    mockedInterstitialPreloader.verify(() -> 
        InterstitialAdPreloader.start(eq("preload-id-1"), any(PreloadConfiguration.class), any(PreloadCallbackV2.class))
    );
    verify(mockResult).success(null);
  }

  @Test
  public void testDestroyPreloader_interstitial() {
    Map<String, Object> args = new HashMap<>();
    args.put("preloadId", "preload-id-1");
    args.put("className", "InterstitialAd");

    MethodCall methodCall = new MethodCall("MobileAds#destroyPreloader", args);
    Result mockResult = mock(Result.class);

    preloader.onMethodCall(methodCall, mockResult);

    mockedInterstitialPreloader.verify(() -> 
        InterstitialAdPreloader.destroy(eq("preload-id-1"))
    );
    verify(mockResult).success(null);
  }

  @Test
  public void testDestroyAllPreloaders_interstitial() {
    Map<String, Object> args = new HashMap<>();
    args.put("className", "InterstitialAd");

    MethodCall methodCall = new MethodCall("MobileAds#destroyAllPreloaders", args);
    Result mockResult = mock(Result.class);

    preloader.onMethodCall(methodCall, mockResult);

    mockedInterstitialPreloader.verify(InterstitialAdPreloader::destroyAll);
    verify(mockResult).success(null);
  }

  @Test
  public void testIsPreloadedAdAvailable_interstitial() {
    mockedInterstitialPreloader.when(() -> InterstitialAdPreloader.isAdAvailable("preload-id-1"))
        .thenReturn(true);

    Map<String, Object> args = new HashMap<>();
    args.put("preloadId", "preload-id-1");
    args.put("className", "InterstitialAd");

    MethodCall methodCall = new MethodCall("MobileAds#isPreloadedAdAvailable", args);
    Result mockResult = mock(Result.class);

    preloader.onMethodCall(methodCall, mockResult);

    verify(mockResult).success(true);
  }

  @Test
  public void testGetNumAdsAvailable_interstitial() {
    mockedInterstitialPreloader.when(() -> InterstitialAdPreloader.getNumAdsAvailable("preload-id-1"))
        .thenReturn(5);

    Map<String, Object> args = new HashMap<>();
    args.put("preloadId", "preload-id-1");
    args.put("className", "InterstitialAd");

    MethodCall methodCall = new MethodCall("MobileAds#getNumAdsAvailable", args);
    Result mockResult = mock(Result.class);

    preloader.onMethodCall(methodCall, mockResult);

    verify(mockResult).success(5);
  }
}
