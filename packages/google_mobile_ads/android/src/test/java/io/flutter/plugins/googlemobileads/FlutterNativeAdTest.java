// Copyright 2021 Google LLC
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
import static org.mockito.Mockito.doAnswer;
import static org.mockito.Mockito.doReturn;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.spy;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import android.app.Activity;
import com.google.android.gms.ads.AdListener;
import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.LoadAdError;
import com.google.android.gms.ads.ResponseInfo;
import com.google.android.gms.ads.admanager.AdManagerAdRequest;
import com.google.android.gms.ads.nativead.NativeAd;
import com.google.android.gms.ads.nativead.NativeAd.OnNativeAdLoadedListener;
import com.google.android.gms.ads.nativead.NativeAdOptions;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugins.googlemobileads.FlutterAd.FlutterLoadAdError;
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin.NativeAdFactory;
import java.util.Map;
import org.junit.Before;
import org.junit.Test;
import org.mockito.invocation.InvocationOnMock;
import org.mockito.stubbing.Answer;

public class FlutterNativeAdTest {

  private AdInstanceManager testManager;
  private final FlutterAdRequest request = new FlutterAdRequest.Builder().build();

  @Before
  public void setup() {
    testManager = spy(new AdInstanceManager(mock(Activity.class), mock(BinaryMessenger.class)));
  }

  @Test
  public void loadNativeAdWithAdManagerAdRequest() {
    final FlutterAdManagerAdRequest mockFlutterRequest = mock(FlutterAdManagerAdRequest.class);
    final AdManagerAdRequest mockRequest = mock(AdManagerAdRequest.class);
    when(mockFlutterRequest.asAdManagerAdRequest()).thenReturn(mockRequest);
    FlutterAdLoader mockLoader = mock(FlutterAdLoader.class);
    NativeAdFactory mockNativeAdFactory = mock(NativeAdFactory.class);
    @SuppressWarnings("unchecked")
    Map<String, Object> mockOptions = mock(Map.class);
    final FlutterNativeAd nativeAd =
        new FlutterNativeAd(
            testManager,
            "testId",
            mockNativeAdFactory,
            mockFlutterRequest,
            mockLoader,
            mockOptions);

    final ResponseInfo responseInfo = mock(ResponseInfo.class);
    final NativeAd mockNativeAd = mock(NativeAd.class);
    doReturn(responseInfo).when(mockNativeAd).getResponseInfo();
    final LoadAdError loadAdError = mock(LoadAdError.class);
    doReturn(1).when(loadAdError).getCode();
    doReturn("2").when(loadAdError).getDomain();
    doReturn("3").when(loadAdError).getMessage();
    doReturn(null).when(loadAdError).getResponseInfo();
    doAnswer(new Answer() {
      @Override
      public Object answer(InvocationOnMock invocation) throws Throwable {
        OnNativeAdLoadedListener adLoadCallback = invocation.getArgument(2);
        adLoadCallback.onNativeAdLoaded(mockNativeAd);

        AdListener listener = invocation.getArgument(4);
        listener.onAdOpened();
        listener.onAdClosed();
        listener.onAdClicked();
        listener.onAdImpression();
        listener.onAdLoaded();
        listener.onAdFailedToLoad(loadAdError);
        return null;
      }
    }).when(mockLoader)
        .loadAdManagerNativeAd(
            eq(testManager.activity),
            eq("testId"),
            any(OnNativeAdLoadedListener.class),
            any(NativeAdOptions.class),
            any(AdListener.class),
            eq(mockRequest));

    nativeAd.load();
    verify(mockLoader).loadAdManagerNativeAd(
        eq(testManager.activity),
        eq("testId"),
        any(OnNativeAdLoadedListener.class),
        any(NativeAdOptions.class),
        any(AdListener.class),
        eq(mockRequest));

    verify(mockNativeAdFactory)
        .createNativeAd(eq(mockNativeAd), eq(mockOptions));
    verify(testManager).onAdOpened(eq(nativeAd));
    verify(testManager).onAdClosed(eq(nativeAd));
    verify(testManager).onNativeAdClicked(eq(nativeAd));
    verify(testManager).onAdImpression(eq(nativeAd));
    verify(testManager).onAdLoaded(eq(nativeAd), eq(responseInfo));
    FlutterLoadAdError expectedError = new FlutterLoadAdError(loadAdError);
    verify(testManager).onAdFailedToLoad(eq(nativeAd), eq(expectedError));
  }

  @Test
  public void loadNativeAdWithAdRequest() {
    final FlutterAdRequest mockFlutterRequest = mock(FlutterAdRequest.class);
    final AdRequest mockRequest = mock(AdRequest.class);
    when(mockFlutterRequest.asAdRequest()).thenReturn(mockRequest);
    FlutterAdLoader mockLoader = mock(FlutterAdLoader.class);
    NativeAdFactory mockNativeAdFactory = mock(GoogleMobileAdsPlugin.NativeAdFactory.class);
    @SuppressWarnings("unchecked")
    Map<String, Object> mockOptions = mock(Map.class);
    final FlutterNativeAd nativeAd =
      new FlutterNativeAd(
        testManager,
        "testId",
        mockNativeAdFactory,
        mockFlutterRequest,
        mockLoader,
        mockOptions);

    final ResponseInfo responseInfo = mock(ResponseInfo.class);
    final NativeAd mockNativeAd = mock(NativeAd.class);
    doReturn(responseInfo).when(mockNativeAd).getResponseInfo();
    final LoadAdError loadAdError = mock(LoadAdError.class);
    doReturn(1).when(loadAdError).getCode();
    doReturn("2").when(loadAdError).getDomain();
    doReturn("3").when(loadAdError).getMessage();
    doReturn(null).when(loadAdError).getResponseInfo();

    doAnswer(new Answer() {
      @Override
      public Object answer(InvocationOnMock invocation) throws Throwable {
        OnNativeAdLoadedListener adLoadCallback = invocation.getArgument(2);
        adLoadCallback.onNativeAdLoaded(mockNativeAd);

        AdListener listener = invocation.getArgument(4);
        listener.onAdOpened();
        listener.onAdClosed();
        listener.onAdClicked();
        listener.onAdImpression();
        listener.onAdLoaded();
        listener.onAdFailedToLoad(loadAdError);
        return null;
      }
    }).when(mockLoader)
        .loadNativeAd(
            eq(testManager.activity),
            eq("testId"),
            any(OnNativeAdLoadedListener.class),
            any(NativeAdOptions.class),
            any(AdListener.class),
            eq(mockRequest));

    nativeAd.load();
    verify(mockLoader).loadNativeAd(
      eq(testManager.activity),
      eq("testId"),
      any(OnNativeAdLoadedListener.class),
      any(NativeAdOptions.class),
      any(AdListener.class),
      eq(mockRequest));

    verify(mockNativeAdFactory)
        .createNativeAd(eq(mockNativeAd), eq(mockOptions));
    verify(testManager).onAdOpened(eq(nativeAd));
    verify(testManager).onAdClosed(eq(nativeAd));
    verify(testManager).onNativeAdClicked(eq(nativeAd));
    verify(testManager).onAdImpression(eq(nativeAd));
    verify(testManager).onAdLoaded(eq(nativeAd), eq(responseInfo));
    FlutterLoadAdError expectedError = new FlutterLoadAdError(loadAdError);
    verify(testManager).onAdFailedToLoad(eq(nativeAd), eq(expectedError));
  }


  @Test(expected = IllegalStateException.class)
  public void nativeAdBuilderNullManager() {
    new FlutterNativeAd.Builder()
      .setManager(null)
      .setAdUnitId("testId")
      .setAdFactory(mock(GoogleMobileAdsPlugin.NativeAdFactory.class))
      .setRequest(request)
      .build();
  }

  @Test(expected = IllegalStateException.class)
  public void nativeAdBuilderNullAdUnitId() {
    new FlutterNativeAd.Builder()
      .setManager(testManager)
      .setAdUnitId(null)
      .setAdFactory(mock(GoogleMobileAdsPlugin.NativeAdFactory.class))
      .setRequest(request)
      .build();
  }

  @Test(expected = IllegalStateException.class)
  public void nativeAdBuilderNullAdFactory() {
    new FlutterNativeAd.Builder()
      .setManager(testManager)
      .setAdUnitId("testId")
      .setAdFactory(null)
      .setRequest(request)
      .build();
  }

  @Test(expected = IllegalStateException.class)
  public void nativeAdBuilderNullRequest() {
    new FlutterNativeAd.Builder()
      .setManager(testManager)
      .setAdUnitId("testId")
      .setAdFactory(mock(GoogleMobileAdsPlugin.NativeAdFactory.class))
      .build();
  }
}
