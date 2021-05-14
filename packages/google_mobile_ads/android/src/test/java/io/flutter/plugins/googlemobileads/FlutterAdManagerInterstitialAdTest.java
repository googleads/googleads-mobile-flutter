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
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.doAnswer;
import static org.mockito.Mockito.doReturn;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.spy;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import android.app.Activity;
import android.content.Context;
import com.google.android.gms.ads.AdError;
import com.google.android.gms.ads.FullScreenContentCallback;
import com.google.android.gms.ads.LoadAdError;
import com.google.android.gms.ads.ResponseInfo;
import com.google.android.gms.ads.admanager.AdManagerAdRequest;
import com.google.android.gms.ads.admanager.AdManagerInterstitialAd;
import com.google.android.gms.ads.admanager.AdManagerInterstitialAdLoadCallback;
import com.google.android.gms.ads.admanager.AppEventListener;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugins.googlemobileads.FlutterAd.FlutterLoadAdError;
import org.junit.Before;
import org.junit.Test;
import org.mockito.invocation.InvocationOnMock;
import org.mockito.stubbing.Answer;

public class FlutterAdManagerInterstitialAdTest {

  private AdInstanceManager mockManager;
  private FlutterAdLoader mockFlutterAdLoader;
  private AdManagerAdRequest mockRequest;
  // The system under test.
  private FlutterAdManagerInterstitialAd flutterAdManagerInterstitialAd;

  @Before
  public void setup() {
    mockManager = spy(new AdInstanceManager(mock(Activity.class), mock(BinaryMessenger.class)));
    final FlutterAdManagerAdRequest mockFlutterRequest = mock(FlutterAdManagerAdRequest.class);
    mockRequest = mock(AdManagerAdRequest.class);
    mockFlutterAdLoader = mock(FlutterAdLoader.class);
    when(mockFlutterRequest.asAdManagerAdRequest()).thenReturn(mockRequest);
    flutterAdManagerInterstitialAd =
        new FlutterAdManagerInterstitialAd(
            mockManager, "testId", mockFlutterRequest, mockFlutterAdLoader);
  }

  @Test
  public void loadAdManagerInterstitialAd_failedToLoad() {
    final LoadAdError loadAdError = mock(LoadAdError.class);
    doReturn(1).when(loadAdError).getCode();
    doReturn("2").when(loadAdError).getDomain();
    doReturn("3").when(loadAdError).getMessage();
    doReturn(null).when(loadAdError).getResponseInfo();
    doAnswer(
            new Answer() {
              @Override
              public Object answer(InvocationOnMock invocation) throws Throwable {
                AdManagerInterstitialAdLoadCallback adLoadCallback = invocation.getArgument(3);
                // Pass back null for ad
                adLoadCallback.onAdFailedToLoad(loadAdError);
                return null;
              }
            })
        .when(mockFlutterAdLoader)
        .loadAdManagerInterstitial(
            any(Activity.class),
            anyString(),
            any(AdManagerAdRequest.class),
            any(AdManagerInterstitialAdLoadCallback.class));

    flutterAdManagerInterstitialAd.load();

    verify(mockFlutterAdLoader)
        .loadAdManagerInterstitial(
            eq(mockManager.activity),
            eq("testId"),
            eq(mockRequest),
            any(AdManagerInterstitialAdLoadCallback.class));

    FlutterLoadAdError flutterLoadAdError = new FlutterLoadAdError(loadAdError);
    verify(mockManager)
        .onAdFailedToLoad(eq(flutterAdManagerInterstitialAd), eq(flutterLoadAdError));
  }

  @Test
  public void loadAdManagerInterstitialAd_showSuccess() {
    final AdManagerInterstitialAd mockAdManagerAd = mock(AdManagerInterstitialAd.class);
    doAnswer(
            new Answer() {
              @Override
              public Object answer(InvocationOnMock invocation) throws Throwable {
                AdManagerInterstitialAdLoadCallback adLoadCallback = invocation.getArgument(3);
                // Pass back null for ad
                adLoadCallback.onAdLoaded(mockAdManagerAd);
                return null;
              }
            })
        .when(mockFlutterAdLoader)
        .loadAdManagerInterstitial(
            any(Context.class),
            anyString(),
            any(AdManagerAdRequest.class),
            any(AdManagerInterstitialAdLoadCallback.class));

    final ResponseInfo responseInfo = mock(ResponseInfo.class);
    doReturn(responseInfo).when(mockAdManagerAd).getResponseInfo();

    flutterAdManagerInterstitialAd.load();

    verify(mockFlutterAdLoader)
        .loadAdManagerInterstitial(
            eq(mockManager.activity),
            eq("testId"),
            eq(mockRequest),
            any(AdManagerInterstitialAdLoadCallback.class));

    verify(mockManager).onAdLoaded(flutterAdManagerInterstitialAd, responseInfo);

    doAnswer(
            new Answer() {
              @Override
              public Object answer(InvocationOnMock invocation) throws Throwable {
                FullScreenContentCallback callback = invocation.getArgument(0);
                callback.onAdShowedFullScreenContent();
                callback.onAdImpression();
                callback.onAdDismissedFullScreenContent();
                return null;
              }
            })
        .when(mockAdManagerAd)
        .setFullScreenContentCallback(any(FullScreenContentCallback.class));

    flutterAdManagerInterstitialAd.show();
    verify(mockAdManagerAd).setFullScreenContentCallback(any(FullScreenContentCallback.class));
    verify(mockAdManagerAd).show(mockManager.activity);
    verify(mockAdManagerAd).setAppEventListener(any(AppEventListener.class));
    verify(mockManager).onAdShowedFullScreenContent(eq(flutterAdManagerInterstitialAd));
    verify(mockManager).onAdImpression(eq(flutterAdManagerInterstitialAd));
    verify(mockManager).onAdDismissedFullScreenContent(eq(flutterAdManagerInterstitialAd));
  }

  @Test
  public void loadAdManagerInterstitialAd_showFailure() {
    final AdManagerInterstitialAd mockAdManagerAd = mock(AdManagerInterstitialAd.class);
    doAnswer(
            new Answer() {
              @Override
              public Object answer(InvocationOnMock invocation) throws Throwable {
                AdManagerInterstitialAdLoadCallback adLoadCallback = invocation.getArgument(3);
                // Pass back null for ad
                adLoadCallback.onAdLoaded(mockAdManagerAd);
                return null;
              }
            })
        .when(mockFlutterAdLoader)
        .loadAdManagerInterstitial(
            any(Context.class),
            anyString(),
            any(AdManagerAdRequest.class),
            any(AdManagerInterstitialAdLoadCallback.class));
    doReturn(mock(ResponseInfo.class)).when(mockAdManagerAd).getResponseInfo();
    flutterAdManagerInterstitialAd.load();
    final AdError adError = new AdError(-1, "test", "error");
    doAnswer(
            new Answer() {
              @Override
              public Object answer(InvocationOnMock invocation) throws Throwable {
                FullScreenContentCallback callback = invocation.getArgument(0);
                callback.onAdFailedToShowFullScreenContent(adError);
                return null;
              }
            })
        .when(mockAdManagerAd)
        .setFullScreenContentCallback(any(FullScreenContentCallback.class));

    flutterAdManagerInterstitialAd.show();
    verify(mockManager)
        .onFailedToShowFullScreenContent(eq(flutterAdManagerInterstitialAd), eq(adError));
  }

  @Test
  public void loadAdManagerInterstitialAd_appEvent() {
    final AdManagerInterstitialAd mockAdManagerAd = mock(AdManagerInterstitialAd.class);
    doAnswer(
            new Answer() {
              @Override
              public Object answer(InvocationOnMock invocation) throws Throwable {
                AdManagerInterstitialAdLoadCallback adLoadCallback = invocation.getArgument(3);
                // Pass back null for ad
                adLoadCallback.onAdLoaded(mockAdManagerAd);
                return null;
              }
            })
        .when(mockFlutterAdLoader)
        .loadAdManagerInterstitial(
            any(Context.class),
            anyString(),
            any(AdManagerAdRequest.class),
            any(AdManagerInterstitialAdLoadCallback.class));

    doReturn(mock(ResponseInfo.class)).when(mockAdManagerAd).getResponseInfo();

    doAnswer(
            new Answer() {
              @Override
              public Object answer(InvocationOnMock invocation) throws Throwable {
                AppEventListener listener = invocation.getArgument(0);
                listener.onAppEvent("test", "data");
                return null;
              }
            })
        .when(mockAdManagerAd)
        .setAppEventListener(any(AppEventListener.class));

    flutterAdManagerInterstitialAd.load();

    verify(mockAdManagerAd).setAppEventListener(any(AppEventListener.class));
    verify(mockManager).onAppEvent(eq(flutterAdManagerInterstitialAd), eq("test"), eq("data"));
  }
}
