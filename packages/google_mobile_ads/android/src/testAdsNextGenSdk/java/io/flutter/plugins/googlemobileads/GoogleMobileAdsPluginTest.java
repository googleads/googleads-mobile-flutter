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
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.ArgumentMatchers.isNull;
import static org.mockito.Mockito.inOrder;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.mockStatic;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import com.google.android.libraries.ads.mobile.sdk.MobileAds;
import com.google.android.libraries.ads.mobile.sdk.common.RequestConfiguration;
import com.google.android.libraries.ads.mobile.sdk.common.VersionInfo;
import com.google.android.libraries.ads.mobile.sdk.initialization.InitializationConfig;
import com.google.android.libraries.ads.mobile.sdk.initialization.OnAdapterInitializationCompleteListener;
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.Result;
import java.util.ArrayDeque;
import java.util.Collections;
import java.util.Queue;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InOrder;
import org.mockito.MockedStatic;
import org.robolectric.RobolectricTestRunner;
import org.robolectric.Shadows;

@RunWith(RobolectricTestRunner.class)
public class GoogleMobileAdsPluginTest {

  private static final String TEST_APP_ID = "ca-app-pub-3940256099942544~3347511713";

  private Queue<Runnable> executorTasks;
  private FlutterMobileAdsWrapper wrapper;
  private FlutterPluginBinding mockBinding;
  private AdInstanceManager mockInstanceManager;
  private GoogleMobileAdsPlugin plugin;

  @Before
  public void setUp() throws Exception {
    FlutterMobileAdsWrapper.resetForTesting();
    FlutterRequestConfiguration.clearPendingRequestConfiguration();
    executorTasks = new ArrayDeque<>();
    wrapper =
        new FlutterMobileAdsWrapper(executorTasks::add, new Handler(Looper.getMainLooper()));

    Context mockContext = FlutterMobileAdsWrapperTest.mockContextWithAppId(TEST_APP_ID);
    mockBinding = mock(FlutterPluginBinding.class);
    when(mockBinding.getApplicationContext()).thenReturn(mockContext);
    mockInstanceManager = mock(AdInstanceManager.class);
    plugin = new GoogleMobileAdsPlugin(mockBinding, mockInstanceManager, wrapper);
  }

  @After
  public void tearDown() {
    FlutterMobileAdsWrapper.resetForTesting();
    FlutterRequestConfiguration.clearPendingRequestConfiguration();
  }

  private void stubMobileAdsInit(MockedStatic<MobileAds> mobileAds) {
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
  }

  private void completeBackgroundInit() {
    while (!executorTasks.isEmpty()) {
      executorTasks.poll().run();
    }
    Shadows.shadowOf(Looper.getMainLooper()).idle();
  }

  @Test
  public void onMethodCall_gatedCallDuringInit_runsAfterInitReturns() {
    try (MockedStatic<MobileAds> mobileAds = mockStatic(MobileAds.class)) {
      stubMobileAdsInit(mobileAds);

      plugin.onMethodCall(new MethodCall("MobileAds#initialize", null), mock(Result.class));

      Result muteResult = mock(Result.class);
      plugin.onMethodCall(
          new MethodCall("MobileAds#setAppMuted", Collections.singletonMap("muted", true)),
          muteResult);

      mobileAds.verify(() -> MobileAds.setUserMutedApp(true), never());
      verify(muteResult, never()).success(any());

      completeBackgroundInit();

      mobileAds.verify(() -> MobileAds.setUserMutedApp(true));
      verify(muteResult).success(null);
    }
  }

  @Test
  public void onMethodCall_ungatedCallDuringInit_runsImmediately() {
    try (MockedStatic<MobileAds> mobileAds = mockStatic(MobileAds.class)) {
      stubMobileAdsInit(mobileAds);
      mobileAds.when(MobileAds::getVersion).thenReturn(new VersionInfo(1, 5, 0));

      plugin.onMethodCall(new MethodCall("MobileAds#initialize", null), mock(Result.class));

      Result versionResult = mock(Result.class);
      plugin.onMethodCall(new MethodCall("MobileAds#getVersionString", null), versionResult);

      verify(versionResult).success("1.5.0");
    }
  }

  @Test
  public void onMethodCall_deferredFailure_reportsInitializationError() {
    try (MockedStatic<MobileAds> mobileAds = mockStatic(MobileAds.class)) {
      stubMobileAdsInit(mobileAds);
      mobileAds
          .when(() -> MobileAds.setUserMutedApp(true))
          .thenThrow(new IllegalStateException("sdk not initialized"));

      plugin.onMethodCall(new MethodCall("MobileAds#initialize", null), mock(Result.class));

      Result muteResult = mock(Result.class);
      plugin.onMethodCall(
          new MethodCall("MobileAds#setAppMuted", Collections.singletonMap("muted", true)),
          muteResult);

      completeBackgroundInit();

      verify(muteResult).error(eq("InitializationError"), eq("sdk not initialized"), isNull());
    }
  }

  @Test
  public void onMethodCall_getRequestConfigurationDuringInit_runsAfterQueuedUpdate() {
    try (MockedStatic<MobileAds> mobileAds = mockStatic(MobileAds.class)) {
      stubMobileAdsInit(mobileAds);

      plugin.onMethodCall(new MethodCall("MobileAds#initialize", null), mock(Result.class));

      Result updateResult = mock(Result.class);
      plugin.onMethodCall(
          new MethodCall(
              "MobileAds#updateRequestConfiguration",
              Collections.singletonMap("testDeviceIds", Collections.singletonList("device-x"))),
          updateResult);
      Result getResult = mock(Result.class);
      plugin.onMethodCall(new MethodCall("MobileAds#getRequestConfiguration", null), getResult);

      verify(updateResult, never()).success(any());
      verify(getResult, never()).success(any());

      completeBackgroundInit();

      InOrder inOrder = inOrder(updateResult, getResult);
      inOrder.verify(updateResult).success(null);
      inOrder.verify(getResult).success(any(FlutterRequestConfiguration.class));
    }
  }

  @Test
  public void onMethodCall_initAndDetach_clearsOnlyOwnPendingCalls() {
    try (MockedStatic<MobileAds> mobileAds = mockStatic(MobileAds.class)) {
      stubMobileAdsInit(mobileAds);

      GoogleMobileAdsPlugin otherPlugin =
          new GoogleMobileAdsPlugin(mockBinding, mock(AdInstanceManager.class), wrapper);

      plugin.onMethodCall(new MethodCall("MobileAds#initialize", null), mock(Result.class));

      Result firstResult = mock(Result.class);
      plugin.onMethodCall(
          new MethodCall("MobileAds#setAppMuted", Collections.singletonMap("muted", true)),
          firstResult);

      Result otherResult = mock(Result.class);
      otherPlugin.onMethodCall(
          new MethodCall("MobileAds#setAppVolume", Collections.singletonMap("volume", 0.5)),
          otherResult);

      plugin.onMethodCall(new MethodCall("_init", null), mock(Result.class));
      completeBackgroundInit();

      mobileAds.verify(() -> MobileAds.setUserMutedApp(true), never());
      verify(firstResult, never()).success(any());
      mobileAds.verify(() -> MobileAds.setUserControlledAppVolume(0.5f));
      verify(otherResult).success(null);
    }
  }
}
