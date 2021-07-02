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

import static org.hamcrest.Matchers.hasEntry;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertThat;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.ArgumentMatchers.isNull;
import static org.mockito.Mockito.doAnswer;
import static org.mockito.Mockito.doReturn;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.spy;
import static org.mockito.Mockito.verify;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import com.google.android.gms.ads.AdError;
import com.google.android.gms.ads.AdapterResponseInfo;
import com.google.android.gms.ads.ResponseInfo;
import com.google.android.gms.ads.initialization.InitializationStatus;
import com.google.android.gms.ads.initialization.OnInitializationCompleteListener;
import com.google.android.gms.ads.nativead.NativeAd;
import com.google.android.gms.ads.nativead.NativeAdView;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.StandardMethodCodec;
import io.flutter.plugins.googlemobileads.FlutterAd.FlutterAdapterResponseInfo;
import io.flutter.plugins.googlemobileads.FlutterAd.FlutterResponseInfo;
import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import org.hamcrest.Matcher;
import org.junit.Before;
import org.junit.Test;
import org.mockito.ArgumentCaptor;
import org.mockito.ArgumentMatchers;
import org.mockito.invocation.InvocationOnMock;
import org.mockito.stubbing.Answer;

/** Tests {@link AdInstanceManager}. */
public class GoogleMobileAdsTest {
  private AdInstanceManager testManager;
  private final FlutterAdRequest request = new FlutterAdRequest.Builder().build();
  private Activity mockActivity;
  private static BinaryMessenger mockMessenger;

  private static MethodCall getLastMethodCall() {
    final ArgumentCaptor<ByteBuffer> byteBufferCaptor = ArgumentCaptor.forClass(ByteBuffer.class);
    verify(mockMessenger)
        .send(
            eq("plugins.flutter.io/google_mobile_ads"),
            byteBufferCaptor.capture(),
            (BinaryMessenger.BinaryReply) isNull());

    return new StandardMethodCodec(new AdMessageCodec(null))
        .decodeMethodCall((ByteBuffer) byteBufferCaptor.getValue().position(0));
  }

  @Before
  public void setup() {
    mockMessenger = mock(BinaryMessenger.class);
    mockActivity = mock(Activity.class);
    doAnswer(
            new Answer() {
              @Override
              public Object answer(InvocationOnMock invocation) {
                Runnable runnable = invocation.getArgument(0);
                runnable.run();
                return null;
              }
            })
        .when(mockActivity)
        .runOnUiThread(ArgumentMatchers.any(Runnable.class));
    testManager = new AdInstanceManager(mockActivity, mockMessenger);
  }

  @Test
  public void loadAd() {
    final FlutterBannerAd bannerAd =
        new FlutterBannerAd(
            1,
            testManager,
            "testId",
            request,
            new FlutterAdSize(1, 2),
            new BannerAdCreator(testManager.activity));
    testManager.trackAd(bannerAd, 0);

    assertNotNull(testManager.adForId(0));
    assertEquals(bannerAd, testManager.adForId(0));
    assertEquals(0, testManager.adIdFor(bannerAd).intValue());
  }

  @Test
  public void disposeAd_banner() {
    FlutterBannerAd bannerAd = mock(FlutterBannerAd.class);

    testManager.trackAd(bannerAd, 2);
    assertNotNull(testManager.adForId(2));
    assertNotNull(testManager.adIdFor(bannerAd));
    testManager.disposeAd(2);
    verify(bannerAd).dispose();
    assertNull(testManager.adForId(2));
    assertNull(testManager.adIdFor(bannerAd));
  }

  @Test
  public void disposeAd_adManagerBanner() {
    FlutterAdManagerBannerAd adManagerBannerAd = mock(FlutterAdManagerBannerAd.class);

    testManager.trackAd(adManagerBannerAd, 2);
    assertNotNull(testManager.adForId(2));
    assertNotNull(testManager.adIdFor(adManagerBannerAd));
    testManager.disposeAd(2);
    verify(adManagerBannerAd).dispose();
    assertNull(testManager.adForId(2));
    assertNull(testManager.adIdFor(adManagerBannerAd));
  }

  @Test
  public void disposeAd_native() {
    FlutterNativeAd flutterNativeAd = mock(FlutterNativeAd.class);

    testManager.trackAd(flutterNativeAd, 2);
    assertNotNull(testManager.adForId(2));
    assertNotNull(testManager.adIdFor(flutterNativeAd));
    testManager.disposeAd(2);
    verify(flutterNativeAd).dispose();
    assertNull(testManager.adForId(2));
    assertNull(testManager.adIdFor(flutterNativeAd));
  }

  @Test
  public void adMessageCodec_encodeFlutterAdSize() {
    final AdMessageCodec codec = new AdMessageCodec(null);
    final ByteBuffer message = codec.encodeMessage(new FlutterAdSize(1, 2));

    assertEquals(codec.decodeMessage((ByteBuffer) message.position(0)), new FlutterAdSize(1, 2));
  }

  @Test
  public void adMessageCodec_encodeFlutterAdRequest() {
    final AdMessageCodec codec = new AdMessageCodec(null);
    final ByteBuffer message =
        codec.encodeMessage(
            new FlutterAdRequest.Builder()
                .setKeywords(Arrays.asList("1", "2", "3"))
                .setContentUrl("contentUrl")
                .setNonPersonalizedAds(false)
                .build());

    final FlutterAdRequest request =
        (FlutterAdRequest) codec.decodeMessage((ByteBuffer) message.position(0));
    assertEquals(Arrays.asList("1", "2", "3"), request.getKeywords());
    assertEquals("contentUrl", request.getContentUrl());
    assertEquals(false, request.getNonPersonalizedAds());
  }

  @Test
  public void adMessageCodec_encodeFlutterAdManagerAdRequest() {
    final AdMessageCodec codec = new AdMessageCodec(null);
    final ByteBuffer message =
        codec.encodeMessage(
            new FlutterAdManagerAdRequest.Builder()
                .setKeywords(Arrays.asList("1", "2", "3"))
                .setContentUrl("contentUrl")
                .setCustomTargeting(Collections.singletonMap("apple", "banana"))
                .setCustomTargetingLists(
                    Collections.singletonMap("cherry", Collections.singletonList("pie")))
                .build());

    assertEquals(
        codec.decodeMessage((ByteBuffer) message.position(0)),
        new FlutterAdManagerAdRequest.Builder()
            .setKeywords(Arrays.asList("1", "2", "3"))
            .setContentUrl("contentUrl")
            .setCustomTargeting(Collections.singletonMap("apple", "banana"))
            .setCustomTargetingLists(
                Collections.singletonMap("cherry", Collections.singletonList("pie")))
            .build());
  }

  @Test
  public void adMessageCodec_encodeFlutterRewardItem() {
    final AdMessageCodec codec = new AdMessageCodec(null);
    final ByteBuffer message =
        codec.encodeMessage(new FlutterRewardedAd.FlutterRewardItem(23, "coins"));

    assertEquals(
        codec.decodeMessage((ByteBuffer) message.position(0)),
        new FlutterRewardedAd.FlutterRewardItem(23, "coins"));
  }

  @Test
  public void adMessageCodec_encodeFlutterLoadAdError() {
    final AdMessageCodec codec = new AdMessageCodec(null);
    List<FlutterAdapterResponseInfo> adapterResponseInfos = new ArrayList<>();
    adapterResponseInfos.add(
        new FlutterAdapterResponseInfo("adapter-class", 9999, "description", "credentials", null));
    FlutterResponseInfo info =
        new FlutterResponseInfo("responseId", "className", adapterResponseInfos);
    final ByteBuffer message =
        codec.encodeMessage(new FlutterBannerAd.FlutterLoadAdError(1, "domain", "message", info));

    final FlutterAd.FlutterLoadAdError error =
        (FlutterAd.FlutterLoadAdError) codec.decodeMessage((ByteBuffer) message.position(0));
    assertNotNull(error);
    assertEquals(error.code, 1);
    assertEquals(error.domain, "domain");
    assertEquals(error.message, "message");
    assertEquals(error.responseInfo, info);
  }

  @Test
  public void flutterAdListener_onAdLoaded() {
    final FlutterBannerAd bannerAd =
        new FlutterBannerAd(
            0,
            testManager,
            "testId",
            request,
            new FlutterAdSize(1, 2),
            new BannerAdCreator(testManager.activity));
    testManager.trackAd(bannerAd, 0);

    AdError adError = mock(AdError.class);
    doReturn(1).when(adError).getCode();
    doReturn("domain").when(adError).getDomain();
    doReturn("message").when(adError).getMessage();

    Bundle credentials = mock(Bundle.class);
    doReturn("credentials").when(credentials).toString();

    AdapterResponseInfo adapterInfo = mock(AdapterResponseInfo.class);
    doReturn("adapter-class").when(adapterInfo).getAdapterClassName();
    doReturn(adError).when(adapterInfo).getAdError();
    doReturn(123L).when(adapterInfo).getLatencyMillis();
    doReturn(credentials).when(adapterInfo).getCredentials();
    doReturn("description").when(adapterInfo).toString();

    AdapterResponseInfo adapterInfoWithNullError = mock(AdapterResponseInfo.class);
    doReturn("adapter-class").when(adapterInfoWithNullError).getAdapterClassName();
    doReturn(null).when(adapterInfoWithNullError).getAdError();
    doReturn(123L).when(adapterInfoWithNullError).getLatencyMillis();
    doReturn(null).when(adapterInfoWithNullError).getCredentials();
    doReturn("description").when(adapterInfoWithNullError).toString();

    List<AdapterResponseInfo> adapterResponses = new ArrayList<>();
    adapterResponses.add(adapterInfo);
    adapterResponses.add(adapterInfoWithNullError);

    ResponseInfo responseInfo = mock(ResponseInfo.class);
    doReturn("response-id").when(responseInfo).getResponseId();
    doReturn("class-name").when(responseInfo).getMediationAdapterClassName();
    doReturn(adapterResponses).when(responseInfo).getAdapterResponses();

    testManager.onAdLoaded(0, responseInfo);

    final MethodCall call = getLastMethodCall();
    assertEquals("onAdEvent", call.method);
    //noinspection rawtypes
    assertThat(call.arguments, (Matcher) hasEntry("eventName", "onAdLoaded"));
    //noinspection rawtypes
    assertThat(call.arguments, (Matcher) hasEntry("adId", 0));
    assertThat(
        call.arguments, (Matcher) hasEntry("responseInfo", new FlutterResponseInfo(responseInfo)));
  }

  @Test
  public void flutterAdListener_onAdLoaded_responseInfoNull() {
    final FlutterBannerAd bannerAd =
        new FlutterBannerAd(
            0,
            testManager,
            "testId",
            request,
            new FlutterAdSize(1, 2),
            new BannerAdCreator(testManager.activity));
    testManager.trackAd(bannerAd, 0);

    testManager.onAdLoaded(0, null);

    final MethodCall call = getLastMethodCall();
    assertEquals("onAdEvent", call.method);
    //noinspection rawtypes
    assertThat(call.arguments, (Matcher) hasEntry("eventName", "onAdLoaded"));
    //noinspection rawtypes
    assertThat(call.arguments, (Matcher) hasEntry("adId", 0));
    assertThat(call.arguments, (Matcher) hasEntry("responseInfo", null));
  }

  @Test
  public void flutterAdListener_onAdFailedToLoad() {
    final FlutterBannerAd bannerAd =
        new FlutterBannerAd(
            0,
            testManager,
            "testId",
            request,
            new FlutterAdSize(1, 2),
            new BannerAdCreator(testManager.activity));
    testManager.trackAd(bannerAd, 0);

    testManager.onAdFailedToLoad(0, new FlutterAd.FlutterLoadAdError(1, "hi", "friend", null));

    final MethodCall call = getLastMethodCall();
    assertEquals("onAdEvent", call.method);
    //noinspection rawtypes
    assertThat(call.arguments, (Matcher) hasEntry("eventName", "onAdFailedToLoad"));
    //noinspection rawtypes
    assertThat(call.arguments, (Matcher) hasEntry("adId", 0));
    //noinspection rawtypes
    assertThat(
        call.arguments,
        (Matcher)
            hasEntry("loadAdError", new FlutterAd.FlutterLoadAdError(1, "hi", "friend", null)));
  }

  @Test
  public void flutterAdListener_onAppEvent() {
    final FlutterBannerAd bannerAd =
        new FlutterBannerAd(
            0,
            testManager,
            "testId",
            request,
            new FlutterAdSize(1, 2),
            new BannerAdCreator(testManager.activity));
    testManager.trackAd(bannerAd, 0);

    testManager.onAppEvent(0, "color", "red");

    final MethodCall call = getLastMethodCall();
    assertEquals("onAdEvent", call.method);
    //noinspection rawtypes
    assertThat(call.arguments, (Matcher) hasEntry("eventName", "onAppEvent"));
    //noinspection rawtypes
    assertThat(call.arguments, (Matcher) hasEntry("adId", 0));
    //noinspection rawtypes
    assertThat(call.arguments, (Matcher) hasEntry("name", "color"));
    //noinspection rawtypes
    assertThat(call.arguments, (Matcher) hasEntry("data", "red"));
  }

  @Test
  public void flutterAdListener_onAdOpened() {
    final FlutterBannerAd bannerAd =
        new FlutterBannerAd(
            0,
            testManager,
            "testId",
            request,
            new FlutterAdSize(1, 2),
            new BannerAdCreator(testManager.activity));
    testManager.trackAd(bannerAd, 0);

    testManager.onAdOpened(0);

    final MethodCall call = getLastMethodCall();
    assertEquals("onAdEvent", call.method);
    //noinspection rawtypes
    assertThat(call.arguments, (Matcher) hasEntry("eventName", "onAdOpened"));
    //noinspection rawtypes
    assertThat(call.arguments, (Matcher) hasEntry("adId", 0));
  }

  @Test
  public void flutterAdListener_onNativeAdClicked() {
    final FlutterNativeAd nativeAd =
        new FlutterNativeAd.Builder()
            .setManager(testManager)
            .setAdUnitId("testId")
            .setRequest(request)
            .setAdFactory(
                new GoogleMobileAdsPlugin.NativeAdFactory() {
                  @Override
                  public NativeAdView createNativeAd(
                      NativeAd nativeAd, Map<String, Object> customOptions) {
                    return null;
                  }
                })
            .setId(0)
            .build();
    testManager.trackAd(nativeAd, 0);

    testManager.onNativeAdClicked(0);

    final MethodCall call = getLastMethodCall();
    assertEquals("onAdEvent", call.method);
    //noinspection rawtypes
    assertThat(call.arguments, (Matcher) hasEntry("eventName", "onNativeAdClicked"));
    //noinspection rawtypes
    assertThat(call.arguments, (Matcher) hasEntry("adId", 0));
  }

  @Test
  public void flutterAdListener_onNativeAdImpression() {
    final FlutterNativeAd nativeAd =
        new FlutterNativeAd.Builder()
            .setManager(testManager)
            .setAdUnitId("testId")
            .setRequest(request)
            .setAdFactory(
                new GoogleMobileAdsPlugin.NativeAdFactory() {
                  @Override
                  public NativeAdView createNativeAd(
                      NativeAd nativeAd, Map<String, Object> customOptions) {
                    return null;
                  }
                })
            .setId(0)
            .build();
    testManager.trackAd(nativeAd, 0);

    testManager.onAdImpression(0);

    final MethodCall call = getLastMethodCall();
    assertEquals("onAdEvent", call.method);
    //noinspection rawtypes
    assertThat(call.arguments, (Matcher) hasEntry("eventName", "onAdImpression"));
    //noinspection rawtypes
    assertThat(call.arguments, (Matcher) hasEntry("adId", 0));
  }

  @Test
  public void flutterAdListener_onAdClosed() {
    final FlutterBannerAd bannerAd =
        new FlutterBannerAd(
            0,
            testManager,
            "testId",
            request,
            new FlutterAdSize(1, 2),
            new BannerAdCreator(testManager.activity));
    testManager.trackAd(bannerAd, 0);

    testManager.onAdClosed(0);

    final MethodCall call = getLastMethodCall();
    assertEquals("onAdEvent", call.method);
    //noinspection rawtypes
    assertThat(call.arguments, (Matcher) hasEntry("eventName", "onAdClosed"));
    //noinspection rawtypes
    assertThat(call.arguments, (Matcher) hasEntry("adId", 0));
  }

  @Test
  public void flutterAdListener_onRewardedAdUserEarnedReward() {
    FlutterAdLoader mockFlutterAdLoader = mock(FlutterAdLoader.class);
    final FlutterRewardedAd ad =
        new FlutterRewardedAd(0, testManager, "testId", request, null, mockFlutterAdLoader);
    testManager.trackAd(ad, 0);

    testManager.onRewardedAdUserEarnedReward(
        0, new FlutterRewardedAd.FlutterRewardItem(23, "coins"));

    final MethodCall call = getLastMethodCall();
    assertEquals("onAdEvent", call.method);
    //noinspection rawtypes
    assertThat(call.arguments, (Matcher) hasEntry("eventName", "onRewardedAdUserEarnedReward"));
    //noinspection rawtypes
    assertThat(call.arguments, (Matcher) hasEntry("adId", 0));
    //noinspection rawtypes
    assertThat(
        call.arguments,
        (Matcher) hasEntry("rewardItem", new FlutterRewardedAd.FlutterRewardItem(23, "coins")));
  }

  @Test
  public void internalInitDisposesAds() {
    // Set up testManager so that two ads have already been loaded and tracked.
    final FlutterRewardedAd rewarded = mock(FlutterRewardedAd.class);
    final FlutterBannerAd banner = mock(FlutterBannerAd.class);

    testManager.trackAd(rewarded, 0);
    testManager.trackAd(banner, 1);

    assertEquals(testManager.adIdFor(rewarded), (Integer) 0);
    assertEquals(testManager.adIdFor(banner), (Integer) 1);
    assertEquals(testManager.adForId(0), rewarded);
    assertEquals(testManager.adForId(1), banner);

    // Check that ads are removed and disposed when "_init" is called.
    AdInstanceManager testManagerSpy = spy(testManager);
    GoogleMobileAdsPlugin plugin =
        new GoogleMobileAdsPlugin(null, testManagerSpy, new FlutterMobileAdsWrapper());
    Result result = mock(Result.class);
    MethodCall methodCall = new MethodCall("_init", null);
    plugin.onMethodCall(methodCall, result);

    verify(testManagerSpy).disposeAllAds();
    verify(result).success(null);
    verify(rewarded).dispose();
    verify(banner).dispose();
    assertNull(testManager.adForId(0));
    assertNull(testManager.adForId(1));
    assertNull(testManager.adIdFor(rewarded));
    assertNull(testManager.adIdFor(banner));
  }

  @Test
  public void initializeCallbackInvokedTwice() {
    AdInstanceManager testManagerSpy = spy(testManager);
    FlutterMobileAdsWrapper mockMobileAds = mock(FlutterMobileAdsWrapper.class);
    GoogleMobileAdsPlugin plugin = new GoogleMobileAdsPlugin(null, testManagerSpy, mockMobileAds);
    final InitializationStatus mockInitStatus = mock(InitializationStatus.class);
    doAnswer(
            new Answer() {
              @Override
              public Object answer(InvocationOnMock invocation) {
                // Invoke init listener twice.
                OnInitializationCompleteListener listener = invocation.getArgument(1);
                listener.onInitializationComplete(mockInitStatus);
                listener.onInitializationComplete(mockInitStatus);
                return null;
              }
            })
        .when(mockMobileAds)
        .initialize(
            ArgumentMatchers.any(Context.class),
            ArgumentMatchers.any(OnInitializationCompleteListener.class));

    MethodCall methodCall = new MethodCall("MobileAds#initialize", null);
    Result result = mock(Result.class);
    plugin.onMethodCall(methodCall, result);

    verify(result).success(ArgumentMatchers.any(FlutterInitializationStatus.class));
  }

  @Test(expected = IllegalArgumentException.class)
  public void trackAdThrowsErrorForDuplicateId() {
    final FlutterBannerAd banner = mock(FlutterBannerAd.class);
    testManager.trackAd(banner, 0);
    testManager.trackAd(banner, 0);
  }

  @Test
  public void testOnPaidEvent() {
    final FlutterBannerAd banner = mock(FlutterBannerAd.class);
    final FlutterAdValue flutterAdValue = new FlutterAdValue(1, "code", 1L);
    testManager.trackAd(banner, 1);
    testManager.onPaidEvent(banner, flutterAdValue);
    final MethodCall call = getLastMethodCall();
    assertEquals("onAdEvent", call.method);
    //noinspection rawtypes
    Map args = (Map) call.arguments;
    assertEquals(args.get("eventName"), "onPaidEvent");
    assertEquals(args.get("adId"), 1);
    assertEquals(args.get("valueMicros"), 1L);
    assertEquals(args.get("precision"), 1);
    assertEquals(args.get("currencyCode"), "code");
  }
}
