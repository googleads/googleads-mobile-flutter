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
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.ArgumentMatchers.isNull;
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
import com.google.android.libraries.ads.mobile.sdk.common.RequestConfiguration;
import com.google.android.libraries.ads.mobile.sdk.initialization.InitializationConfig;
import com.google.android.libraries.ads.mobile.sdk.initialization.OnAdapterInitializationCompleteListener;
import io.flutter.plugin.common.MethodChannel.Result;
import java.lang.reflect.Field;
import java.lang.reflect.Modifier;
import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Queue;
import java.util.concurrent.atomic.AtomicReference;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.MockedStatic;
import org.robolectric.RobolectricTestRunner;
import org.robolectric.Shadows;

@RunWith(RobolectricTestRunner.class)
public class FlutterMobileAdsWrapperTest {

  private static final String TEST_APP_ID = "ca-app-pub-3940256099942544~3347511713";

  private Queue<Runnable> executorTasks;
  private FlutterMobileAdsWrapper wrapper;
  private Context mockContext;
  private Result mockResult;

  @Before
  public void setUp() throws Exception {
    FlutterMobileAdsWrapper.resetForTesting();
    FlutterRequestConfiguration.clearPendingRequestConfiguration();
    executorTasks = new ArrayDeque<>();
    wrapper =
        new FlutterMobileAdsWrapper(executorTasks::add, new Handler(Looper.getMainLooper()));
    mockContext = mockContextWithAppId(TEST_APP_ID);
    mockResult = mock(Result.class);
  }

  @After
  public void tearDown() {
    FlutterMobileAdsWrapper.resetForTesting();
    FlutterRequestConfiguration.clearPendingRequestConfiguration();
  }

  static Context mockContextWithAppId(String appId) throws Exception {
    Context context = mock(Context.class);
    PackageManager pm = mock(PackageManager.class);
    ApplicationInfo appInfo = new ApplicationInfo();
    if (appId != null) {
      Bundle metaData = new Bundle();
      metaData.putString("com.google.android.gms.ads.APPLICATION_ID", appId);
      appInfo.metaData = metaData;
    }
    when(context.getPackageName()).thenReturn("com.example.app");
    when(context.getPackageManager()).thenReturn(pm);
    when(pm.getApplicationInfo("com.example.app", PackageManager.GET_META_DATA))
        .thenReturn(appInfo);
    return context;
  }

  private void stubRequestConfiguration(MockedStatic<MobileAds> mobileAds) {
    mobileAds
        .when(MobileAds::getRequestConfiguration)
        .thenReturn(new RequestConfiguration.Builder().build());
  }

  private void runNextInitTask() {
    executorTasks.poll().run();
    Shadows.shadowOf(Looper.getMainLooper()).idle();
  }

  @Test
  public void setPlugin_setsVersionedRequestAgent() throws Exception {
    InitializationConfig.Builder builder = new InitializationConfig.Builder("test-app-id");
    FlutterMobileAdsWrapper.setPlugin(builder);
    InitializationConfig config = builder.build();

    List<String> nonAppIdStrings = new ArrayList<>();
    for (Field field : InitializationConfig.class.getDeclaredFields()) {
      if (Modifier.isStatic(field.getModifiers()) || field.getType() != String.class) {
        continue;
      }
      field.setAccessible(true);
      String value = (String) field.get(config);
      if (!"test-app-id".equals(value)) {
        nonAppIdStrings.add(value);
      }
    }
    assertEquals(1, nonAppIdStrings.size());
    assertEquals(Constants.REQUEST_AGENT_PREFIX_VERSIONED, nonAppIdStrings.get(0));
  }

  @Test
  public void enqueueIfInitializing_beforeInit_returnsFalse() {
    assertFalse(wrapper.enqueueIfInitializing(new Object(), () -> {}, e -> {}));
  }

  @Test
  public void initialize_queuesCallsDuringInitAndDrainsInFifoOrderWhenMobileAdsReturns() {
    try (MockedStatic<MobileAds> mobileAds = mockStatic(MobileAds.class)) {
      stubRequestConfiguration(mobileAds);
      mobileAds
          .when(
              () ->
                  MobileAds.initialize(
                      any(Context.class),
                      any(InitializationConfig.class),
                      any(OnAdapterInitializationCompleteListener.class)))
          .thenAnswer(invocation -> null);

      wrapper.initialize(mockContext, new FlutterInitializationListener(mockResult));

      Object owner = new Object();
      List<String> order = new ArrayList<>();
      assertTrue(wrapper.enqueueIfInitializing(owner, () -> order.add("first"), e -> {}));
      assertTrue(wrapper.enqueueIfInitializing(owner, () -> order.add("second"), e -> {}));
      assertTrue(order.isEmpty());

      runNextInitTask();

      assertEquals(Arrays.asList("first", "second"), order);
      verify(mockResult, never()).success(any());
      verify(mockResult, never()).error(any(), any(), any());
      assertFalse(wrapper.enqueueIfInitializing(owner, () -> {}, e -> {}));
    }
  }

  @Test
  public void initialize_whenMobileAdsThrows_reportsErrorAndDrainsPendingCalls() {
    try (MockedStatic<MobileAds> mobileAds = mockStatic(MobileAds.class)) {
      stubRequestConfiguration(mobileAds);
      mobileAds
          .when(
              () ->
                  MobileAds.initialize(
                      any(Context.class),
                      any(InitializationConfig.class),
                      any(OnAdapterInitializationCompleteListener.class)))
          .thenThrow(new IllegalStateException("init failed"));

      wrapper.initialize(mockContext, new FlutterInitializationListener(mockResult));

      Object owner = new Object();
      AtomicReference<RuntimeException> deferredError = new AtomicReference<>();
      List<String> executed = new ArrayList<>();
      assertTrue(
          wrapper.enqueueIfInitializing(
              owner,
              () -> {
                throw new IllegalStateException("sdk not initialized");
              },
              deferredError::set));
      assertTrue(wrapper.enqueueIfInitializing(owner, () -> executed.add("afterError"), e -> {}));

      runNextInitTask();

      verify(mockResult).error(eq("InitializationError"), eq("init failed"), isNull());
      assertEquals("sdk not initialized", deferredError.get().getMessage());
      assertEquals(Arrays.asList("afterError"), executed);
    }
  }

  @Test
  public void initialize_missingAppId_reportsErrorAndDoesNotQueue() throws Exception {
    Context contextWithoutAppId = mockContextWithAppId(null);

    wrapper.initialize(contextWithoutAppId, new FlutterInitializationListener(mockResult));
    Shadows.shadowOf(Looper.getMainLooper()).idle();

    verify(mockResult)
        .error(
            eq("InitializationError"),
            eq("Application ID is null. Cannot initialize the Google Mobile Ads SDK."),
            isNull());
    assertFalse(wrapper.enqueueIfInitializing(new Object(), () -> {}, e -> {}));
  }

  @Test
  public void clearPendingCalls_removesOnlyMatchingOwner() {
    try (MockedStatic<MobileAds> mobileAds = mockStatic(MobileAds.class)) {
      stubRequestConfiguration(mobileAds);
      mobileAds
          .when(
              () ->
                  MobileAds.initialize(
                      any(Context.class),
                      any(InitializationConfig.class),
                      any(OnAdapterInitializationCompleteListener.class)))
          .thenAnswer(invocation -> null);

      wrapper.initialize(mockContext, new FlutterInitializationListener(mockResult));

      Object ownerA = new Object();
      Object ownerB = new Object();
      List<String> executed = new ArrayList<>();
      wrapper.enqueueIfInitializing(ownerA, () -> executed.add("A"), e -> {});
      wrapper.enqueueIfInitializing(ownerB, () -> executed.add("B"), e -> {});

      wrapper.clearPendingCalls(ownerA);
      runNextInitTask();

      assertEquals(Arrays.asList("B"), executed);
    }
  }
}
