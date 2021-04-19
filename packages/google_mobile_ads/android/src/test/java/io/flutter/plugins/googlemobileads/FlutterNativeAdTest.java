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
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import android.app.Activity;
import com.google.android.gms.ads.AdListener;
import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.admanager.AdManagerAdRequest;
import com.google.android.gms.ads.nativead.NativeAd.OnNativeAdLoadedListener;
import com.google.android.gms.ads.nativead.NativeAdOptions;
import io.flutter.plugin.common.BinaryMessenger;
import org.junit.Before;
import org.junit.Test;

public class FlutterNativeAdTest {

  private AdInstanceManager testManager;
  private final FlutterAdRequest request = new FlutterAdRequest.Builder().build();
  private static BinaryMessenger mockMessenger;

  @Before
  public void setup() {
    mockMessenger = mock(BinaryMessenger.class);
    testManager = new AdInstanceManager(mock(Activity.class), mockMessenger);
  }

  @Test
  public void loadNativeAdWithAdManagerAdRequest() {
    final FlutterAdManagerAdRequest mockFlutterRequest = mock(FlutterAdManagerAdRequest.class);
    final AdManagerAdRequest mockRequest = mock(AdManagerAdRequest.class);
    when(mockFlutterRequest.asAdManagerAdRequest()).thenReturn(mockRequest);
    FlutterAdLoader mockLoader = mock(FlutterAdLoader.class);
    final FlutterNativeAd nativeAd =
      new FlutterNativeAd(
        testManager,
        "testId",
        mock(GoogleMobileAdsPlugin.NativeAdFactory.class),
        mockFlutterRequest,
        mockLoader);

    nativeAd.load();
    verify(mockLoader).loadAdManagerNativeAd(
      eq(testManager.activity),
      eq("testId"),
      any(OnNativeAdLoadedListener.class),
      any(NativeAdOptions.class),
      any(AdListener.class),
      eq(mockRequest));
  }

  @Test
  public void loadNativeAdWithAdRequest() {
    final FlutterAdRequest mockFlutterRequest = mock(FlutterAdRequest.class);
    final AdRequest mockRequest = mock(AdRequest.class);
    when(mockFlutterRequest.asAdRequest()).thenReturn(mockRequest);
    FlutterAdLoader mockLoader = mock(FlutterAdLoader.class);
    final FlutterNativeAd nativeAd =
      new FlutterNativeAd(
        testManager,
        "testId",
        mock(GoogleMobileAdsPlugin.NativeAdFactory.class),
        mockFlutterRequest,
        mockLoader);

    nativeAd.load();
    verify(mockLoader).loadNativeAd(
      eq(testManager.activity),
      eq("testId"),
      any(OnNativeAdLoadedListener.class),
      any(NativeAdOptions.class),
      any(AdListener.class),
      eq(mockRequest));
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
