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
import static org.mockito.ArgumentMatchers.isNull;
import static org.mockito.Mockito.doThrow;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.mockStatic;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import com.google.android.libraries.ads.mobile.sdk.MobileAds;
import com.google.android.libraries.ads.mobile.sdk.banner.AdView;
import com.google.android.libraries.ads.mobile.sdk.common.AdLoadCallback;
import com.google.android.libraries.ads.mobile.sdk.common.RequestConfiguration;
import com.google.android.libraries.ads.mobile.sdk.initialization.InitializationConfig;
import com.google.android.libraries.ads.mobile.sdk.initialization.OnAdapterInitializationCompleteListener;
import com.google.android.libraries.ads.mobile.sdk.interstitial.InterstitialAdPreloader;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.Result;
import java.util.ArrayDeque;
import java.util.HashMap;
import java.util.Map;
import java.util.Queue;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.ArgumentCaptor;
import org.mockito.MockedStatic;
import org.robolectric.RobolectricTestRunner;
import org.robolectric.Shadows;

/** Tests for {@link FlutterMobileAdsWrapper} gate integration across ads, preloader, and inspector. */
@RunWith(RobolectricTestRunner.class)
public class FlutterAdGateTest {

  private static final String TEST_APP_ID = "ca-app-pub-3940256099942544~3347511713";

  private Queue<Runnable> executorTasks;
  private FlutterMobileAdsWrapper wrapper;
  private Context mockContext;
  private MethodChannel mockChannel;
  private AdInstanceManager manager;
  private BannerAdCreator mockBannerAdCreator;
  private AdView mockAdView;
  private FlutterAdRequest request;

  @Before
  public void setUp() throws Exception {
    FlutterMobileAdsWrapper.resetForTesting();
    FlutterRequestConfiguration.clearPendingRequestConfiguration();
    executorTasks = new ArrayDeque<>();
    wrapper =
        new FlutterMobileAdsWrapper(executorTasks::add, new Handler(Looper.getMainLooper()));
    mockContext = mockContextWithAppId(TEST_APP_ID);
    mockChannel = mock(MethodChannel.class);
    manager = new AdInstanceManager(mockChannel);
    mockAdView = mock(AdView.class);
    mockBannerAdCreator = mock(BannerAdCreator.class);
    when(mockBannerAdCreator.createAdView()).thenReturn(mockAdView);
    request = new FlutterAdRequest.Builder().setRequestAgent("test").build();
  }

  @After
  public void tearDown() {
    FlutterMobileAdsWrapper.resetForTesting();
    FlutterRequestConfiguration.clearPendingRequestConfiguration();
  }

  private static Context mockContextWithAppId(String appId) throws Exception {
    Context context = mock(Context.class);
    PackageManager pm = mock(PackageManager.class);
    ApplicationInfo appInfo = new ApplicationInfo();
    Bundle metaData = new Bundle();
    metaData.putString("com.google.android.gms.ads.APPLICATION_ID", appId);
    appInfo.metaData = metaData;
    when(context.getPackageName()).thenReturn("com.example.app");
    when(context.getPackageManager()).thenReturn(pm);
    when(pm.getApplicationInfo("com.example.app", PackageManager.GET_META_DATA))
        .thenReturn(appInfo);
    return context;
  }

  private void startInit(MockedStatic<MobileAds> mobileAds) {
    mobileAds
        .when(MobileAds::getRequestConfiguration)
        .thenReturn(new RequestConfiguration.Builder().build());
    mobileAds
        .when(
            () ->
                MobileAds.initialize(
                    any(Context.class),
                    any(InitializationConfig.class),
                    any(OnAdapterInitializationCompleteListener.class)))
        .thenAnswer(invocation -> null);
    wrapper.initialize(mockContext, new FlutterInitializationListener(mock(Result.class)));
  }

  private void completeBackgroundInit() {
    while (!executorTasks.isEmpty()) {
      executorTasks.poll().run();
    }
    Shadows.shadowOf(Looper.getMainLooper()).idle();
  }

  private FlutterBannerAd createTrackedBannerAd(int adId) {
    FlutterBannerAd ad =
        new FlutterBannerAd(
            adId, manager, "test-unit", request, new FlutterAdSize(320, 50), mockBannerAdCreator);
    manager.trackAd(ad, adId);
    return ad;
  }

  @Test
  @SuppressWarnings("unchecked")
  public void adLoad_duringInit_deferredUntilSdkReady() {
    try (MockedStatic<MobileAds> mobileAds = mockStatic(MobileAds.class)) {
      startInit(mobileAds);

      FlutterBannerAd ad = createTrackedBannerAd(1);
      ad.load();
      verify(mockAdView, never()).loadAd(any(), any(AdLoadCallback.class));

      completeBackgroundInit();
      verify(mockAdView).loadAd(any(), any(AdLoadCallback.class));
    }
  }

  @Test
  @SuppressWarnings("unchecked")
  public void adLoad_whenDeferredLoadThrows_reportsOnAdFailedToLoad() {
    try (MockedStatic<MobileAds> mobileAds = mockStatic(MobileAds.class)) {
      startInit(mobileAds);
      doThrow(new IllegalStateException("SDK not initialized"))
          .when(mockAdView)
          .loadAd(any(), any(AdLoadCallback.class));

      FlutterBannerAd ad = createTrackedBannerAd(2);
      ad.load();
      completeBackgroundInit();

      ArgumentCaptor<Map<Object, Object>> argsCaptor = ArgumentCaptor.forClass(Map.class);
      verify(mockChannel).invokeMethod(eq("onAdEvent"), argsCaptor.capture());
      assertEquals(2, argsCaptor.getValue().get("adId"));
      assertEquals("onAdFailedToLoad", argsCaptor.getValue().get("eventName"));
      assertEquals(
          new FlutterAd.FlutterLoadAdError(
              0, AdInstanceManager.NEXT_GEN_DOMAIN, "SDK not initialized", null),
          argsCaptor.getValue().get("loadAdError"));
    }
  }

  @Test
  @SuppressWarnings("unchecked")
  public void adLoad_whenDisposedDuringInit_skippedOnDrain() {
    try (MockedStatic<MobileAds> mobileAds = mockStatic(MobileAds.class)) {
      startInit(mobileAds);

      FlutterBannerAd ad = createTrackedBannerAd(3);
      ad.load();
      manager.disposeAd(3);

      completeBackgroundInit();

      verify(mockAdView, never()).loadAd(any(), any(AdLoadCallback.class));
      verify(mockChannel, never()).invokeMethod(any(), any());
    }
  }

  @Test
  @SuppressWarnings("unchecked")
  public void disposeAllAds_clearsPendingCalls() {
    try (MockedStatic<MobileAds> mobileAds = mockStatic(MobileAds.class)) {
      startInit(mobileAds);

      FlutterBannerAd ad = createTrackedBannerAd(4);
      ad.load();
      wrapper.setAppMuted(true);

      manager.disposeAllAds();
      completeBackgroundInit();

      verify(mockAdView, never()).loadAd(any(), any(AdLoadCallback.class));
      mobileAds.verify(() -> MobileAds.setUserMutedApp(true), never());
    }
  }

  @Test
  public void preloader_duringInit_deferredAndReportsPreloadErrorOnFailure() {
    try (MockedStatic<MobileAds> mobileAds = mockStatic(MobileAds.class);
        MockedStatic<InterstitialAdPreloader> preloaderStatic =
            mockStatic(InterstitialAdPreloader.class)) {
      startInit(mobileAds);
      preloaderStatic
          .when(() -> InterstitialAdPreloader.isAdAvailable("p1"))
          .thenThrow(new IllegalStateException("not ready"));

      FlutterAdPreloader preloader = new FlutterAdPreloader(mockContext, manager, mockChannel);
      Map<String, Object> args = new HashMap<>();
      args.put("preloadId", "p1");
      args.put("className", "InterstitialAd");
      Result result = mock(Result.class);

      preloader.onMethodCall(new MethodCall("MobileAds#isPreloadedAdAvailable", args), result);
      verify(result, never()).error(any(), any(), any());
      verify(result, never()).success(any());

      completeBackgroundInit();

      verify(result).error(eq("PreloadError"), eq("not ready"), isNull());
    }
  }

  @Test
  public void openAdInspector_duringInit_deferredAndReportsErrorOnFailure() {
    try (MockedStatic<MobileAds> mobileAds = mockStatic(MobileAds.class)) {
      startInit(mobileAds);
      mobileAds
          .when(() -> MobileAds.openAdInspector(any()))
          .thenThrow(new IllegalStateException("inspector failed"));

      Result result = mock(Result.class);
      FlutterAdInspector.openAdInspector(mockContext, wrapper, result);
      verify(result, never()).error(any(), any(), any());

      completeBackgroundInit();

      verify(result)
          .error(eq("0"), eq("inspector failed"), eq(AdInstanceManager.NEXT_GEN_DOMAIN));
    }
  }
}
