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
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.spy;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import android.app.Activity;
import android.content.Context;
import com.google.android.gms.ads.FullScreenContentCallback;
import com.google.android.gms.ads.LoadAdError;
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

  private AdInstanceManager testManager;
  private final FlutterAdRequest request = new FlutterAdRequest.Builder().build();
  private static BinaryMessenger mockMessenger;

  @Before
  public void setup() {
    mockMessenger = mock(BinaryMessenger.class);
    testManager = new AdInstanceManager(mock(Activity.class), mockMessenger);
  }

  @Test
  public void loadAdManagerInterstitialAd_failedToLoad() {
    AdInstanceManager mockManager = spy(testManager);
    final FlutterAdManagerAdRequest mockFlutterRequest = mock(FlutterAdManagerAdRequest.class);
    final AdManagerAdRequest mockRequest = mock(AdManagerAdRequest.class);
    final FlutterAdLoader mockFlutterAdLoader = mock(FlutterAdLoader.class);
    when(mockFlutterRequest.asAdManagerAdRequest()).thenReturn(mockRequest);

    final FlutterAdManagerInterstitialAd interstitialAd = new FlutterAdManagerInterstitialAd(
      mockManager, "testId", mockFlutterRequest, mockFlutterAdLoader);

    final LoadAdError loadAdError = new LoadAdError(1, "2", "3", null, null);
    doAnswer(new Answer() {
      @Override
      public Object answer(InvocationOnMock invocation) throws Throwable {
        AdManagerInterstitialAdLoadCallback adLoadCallback = invocation.getArgument(3);
        // Pass back null for ad
        adLoadCallback.onAdFailedToLoad(loadAdError);
        return null;
      }
    }).when(mockFlutterAdLoader)
      .loadAdManagerInterstitial(
        any(Activity.class),
        anyString(),
        any(AdManagerAdRequest.class),
        any(AdManagerInterstitialAdLoadCallback.class));

    interstitialAd.load();

    verify(mockFlutterAdLoader).loadAdManagerInterstitial(
      eq(mockManager.activity),
      eq("testId"),
      eq(mockRequest),
      any(AdManagerInterstitialAdLoadCallback.class));

    verify(mockManager)
      .onAdFailedToLoad(eq(interstitialAd), eq(new FlutterLoadAdError(loadAdError)));
  }

  @Test
  public void loadAdManagerInterstitialAd_showSuccess() {
    AdInstanceManager mockManager = spy(testManager);
    final FlutterAdManagerAdRequest mockFlutterRequest = mock(FlutterAdManagerAdRequest.class);
    final AdManagerAdRequest mockRequest = mock(AdManagerAdRequest.class);
    final FlutterAdLoader mockFlutterAdLoader = mock(FlutterAdLoader.class);
    when(mockFlutterRequest.asAdManagerAdRequest()).thenReturn(mockRequest);

    final FlutterAdManagerInterstitialAd interstitialAd = new FlutterAdManagerInterstitialAd(
      mockManager, "testId", mockFlutterRequest, mockFlutterAdLoader);

    final AdManagerInterstitialAd mockAdManagerAd = mock(AdManagerInterstitialAd.class);
    doAnswer(new Answer() {
      @Override
      public Object answer(InvocationOnMock invocation) throws Throwable {
        AdManagerInterstitialAdLoadCallback adLoadCallback = invocation.getArgument(3);
        // Pass back null for ad
        adLoadCallback.onAdLoaded(mockAdManagerAd);
        return null;
      }
    }).when(mockFlutterAdLoader)
      .loadAdManagerInterstitial(
        any(Context.class),
        anyString(),
        any(AdManagerAdRequest.class),
        any(AdManagerInterstitialAdLoadCallback.class));

    interstitialAd.load();

    verify(mockFlutterAdLoader).loadAdManagerInterstitial(
      eq(testManager.activity),
      eq("testId"),
      eq(mockRequest),
      any(AdManagerInterstitialAdLoadCallback.class));

    verify(mockManager).onAdLoaded(interstitialAd);

    doAnswer(new Answer() {
      @Override
      public Object answer(InvocationOnMock invocation) throws Throwable {
        FullScreenContentCallback callback = invocation.getArgument(0);
        callback.onAdShowedFullScreenContent();
        return null;
      }
    }).when(mockAdManagerAd).setFullScreenContentCallback(any(FullScreenContentCallback.class));

    interstitialAd.show();
    verify(mockAdManagerAd).setFullScreenContentCallback(any(FullScreenContentCallback.class));
    verify(mockAdManagerAd).show(testManager.activity);
    verify(mockAdManagerAd).setAppEventListener(any(AppEventListener.class));
    // TODO - show callback.
  }

  // TODO - other listener tests.
}
