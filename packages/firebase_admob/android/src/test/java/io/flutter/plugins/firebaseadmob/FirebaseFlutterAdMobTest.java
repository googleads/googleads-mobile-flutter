// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.firebaseadmob;

import static org.hamcrest.Matchers.hasEntry;
import static org.junit.Assert.*;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.ArgumentMatchers.isNull;
import static org.mockito.Mockito.any;
import static org.mockito.Mockito.doReturn;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.spy;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import android.app.Activity;
import com.google.android.gms.ads.AdLoader;
import com.google.android.gms.ads.doubleclick.PublisherAdRequest;
import com.google.android.gms.ads.doubleclick.PublisherInterstitialAd;
import com.google.android.gms.ads.formats.UnifiedNativeAd;
import com.google.android.gms.ads.formats.UnifiedNativeAdView;
import com.google.android.gms.ads.rewarded.RewardedAd;
import com.google.android.gms.ads.rewarded.RewardedAdCallback;
import com.google.android.gms.ads.rewarded.RewardedAdLoadCallback;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.StandardMethodCodec;
import java.nio.ByteBuffer;
import java.util.Arrays;
import java.util.Collections;
import java.util.Date;
import java.util.Map;
import org.hamcrest.Matcher;
import org.junit.Before;
import org.junit.Test;
import org.mockito.ArgumentCaptor;
import org.mockito.ArgumentMatchers;

public class FirebaseFlutterAdMobTest {
  private AdInstanceManager testManager;
  private final FlutterAdRequest request = new FlutterAdRequest.Builder().build();
  private static BinaryMessenger mockMessenger;

  private static MethodCall getLastMethodCall() {
    final ArgumentCaptor<ByteBuffer> byteBufferCaptor = ArgumentCaptor.forClass(ByteBuffer.class);
    verify(mockMessenger)
        .send(
            eq("plugins.flutter.io/firebase_admob"),
            byteBufferCaptor.capture(),
            (BinaryMessenger.BinaryReply) isNull());

    return new StandardMethodCodec(new AdMessageCodec())
        .decodeMethodCall((ByteBuffer) byteBufferCaptor.getValue().position(0));
  }

  @Before
  public void setup() {
    mockMessenger = mock(BinaryMessenger.class);
    testManager = new AdInstanceManager(mock(Activity.class), mockMessenger);
  }

  @Test
  public void loadAd() {
    final FlutterBannerAd bannerAd =
        new FlutterBannerAd.Builder()
            .setManager(testManager)
            .setAdUnitId("testId")
            .setSize(new FlutterAdSize(1, 2))
            .setRequest(request)
            .build();
    testManager.trackAd(bannerAd, 0);

    assertNotNull(testManager.adForId(0));
    assertEquals(bannerAd, testManager.adForId(0));
    assertEquals(0, testManager.adIdFor(bannerAd).intValue());
  }

  @Test
  public void loadNativeAdWithPublisherRequest() {
    final FlutterPublisherAdRequest mockFlutterRequest = mock(FlutterPublisherAdRequest.class);
    final PublisherAdRequest mockRequest = mock(PublisherAdRequest.class);
    when(mockFlutterRequest.asPublisherAdRequest()).thenReturn(mockRequest);

    final FlutterNativeAd nativeAd =
        new FlutterNativeAd.Builder()
            .setManager(testManager)
            .setAdUnitId("testId")
            .setAdFactory(mock(FirebaseAdMobPlugin.NativeAdFactory.class))
            .setRequest(null)
            .setPublisherRequest(mockFlutterRequest)
            .build();

    final FlutterNativeAd mockFlutterAd = spy(nativeAd);
    final AdLoader mockAdLoader = mock(AdLoader.class);
    doReturn(mockAdLoader).when(mockFlutterAd).buildAdLoader();
    mockFlutterAd.load();

    final ArgumentCaptor<PublisherAdRequest> captor =
        ArgumentCaptor.forClass(PublisherAdRequest.class);
    verify(mockAdLoader).loadAd(captor.capture());

    assertEquals(captor.getValue(), mockRequest);
  }

  @Test(expected = IllegalStateException.class)
  public void nativeAdBuilderNullManager() {
    new FlutterNativeAd.Builder()
        .setManager(null)
        .setAdUnitId("testId")
        .setAdFactory(mock(FirebaseAdMobPlugin.NativeAdFactory.class))
        .setRequest(request)
        .build();
  }

  @Test(expected = IllegalStateException.class)
  public void nativeAdBuilderNullAdUnitId() {
    new FlutterNativeAd.Builder()
        .setManager(testManager)
        .setAdUnitId(null)
        .setAdFactory(mock(FirebaseAdMobPlugin.NativeAdFactory.class))
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
        .setAdFactory(mock(FirebaseAdMobPlugin.NativeAdFactory.class))
        .build();
  }

  @Test
  public void loadPublisherInterstitialAd() {
    final FlutterPublisherAdRequest mockFlutterRequest = mock(FlutterPublisherAdRequest.class);
    final PublisherAdRequest mockRequest = mock(PublisherAdRequest.class);
    when(mockFlutterRequest.asPublisherAdRequest()).thenReturn(mockRequest);

    final FlutterPublisherInterstitialAd interstitialAd =
        new FlutterPublisherInterstitialAd(testManager, "testId", mockFlutterRequest);

    final FlutterPublisherInterstitialAd mockFlutterAd = spy(interstitialAd);
    final PublisherInterstitialAd mockPublisherAd = mock(PublisherInterstitialAd.class);
    doReturn(mockPublisherAd).when(mockFlutterAd).createPublisherInterstitialAd();
    mockFlutterAd.load();
    verify(mockPublisherAd).setAdUnitId("testId");

    final ArgumentCaptor<PublisherAdRequest> captor =
        ArgumentCaptor.forClass(PublisherAdRequest.class);
    verify(mockPublisherAd).loadAd(captor.capture());
    assertEquals(captor.getValue(), mockRequest);
  }

  @Test
  public void showPublisherInterstitialAd() {
    final FlutterPublisherAdRequest mockFlutterRequest = mock(FlutterPublisherAdRequest.class);

    final FlutterPublisherInterstitialAd interstitialAd =
        new FlutterPublisherInterstitialAd(testManager, "testId", mockFlutterRequest);

    final FlutterPublisherInterstitialAd mockFlutterAd = spy(interstitialAd);
    final PublisherInterstitialAd mockPublisherAd = mock(PublisherInterstitialAd.class);
    doReturn(mockPublisherAd).when(mockFlutterAd).createPublisherInterstitialAd();
    mockFlutterAd.load();

    when(mockPublisherAd.isLoaded()).thenReturn(true);
    mockFlutterAd.show();
    verify(mockPublisherAd).show();
  }

  @Test
  public void loadRewardedAdWithPublisherRequest() {
    final FlutterPublisherAdRequest mockFlutterRequest = mock(FlutterPublisherAdRequest.class);
    final PublisherAdRequest mockRequest = mock(PublisherAdRequest.class);
    when(mockFlutterRequest.asPublisherAdRequest()).thenReturn(mockRequest);

    final FlutterRewardedAd rewardedAd =
        new FlutterRewardedAd(testManager, "testId", mockFlutterRequest);

    final FlutterRewardedAd mockFlutterAd = spy(rewardedAd);
    final RewardedAd mockPublisherAd = mock(RewardedAd.class);
    doReturn(mockPublisherAd).when(mockFlutterAd).createRewardedAd();
    mockFlutterAd.load();

    final ArgumentCaptor<PublisherAdRequest> captor =
        ArgumentCaptor.forClass(PublisherAdRequest.class);
    verify(mockPublisherAd)
        .loadAd(captor.capture(), ArgumentMatchers.any(RewardedAdLoadCallback.class));
    assertEquals(captor.getValue(), mockRequest);
  }

  @Test
  public void showRewardedAd() {
    final FlutterAdRequest mockFlutterRequest = mock(FlutterAdRequest.class);

    final FlutterRewardedAd rewardedAd =
        new FlutterRewardedAd(testManager, "testId", mockFlutterRequest);

    final FlutterRewardedAd mockFlutterAd = spy(rewardedAd);
    final RewardedAd mockRewardedAd = mock(RewardedAd.class);
    doReturn(mockRewardedAd).when(mockFlutterAd).createRewardedAd();
    mockFlutterAd.load();

    when(mockRewardedAd.isLoaded()).thenReturn(true);
    mockFlutterAd.show();
    verify(mockRewardedAd).show(any(Activity.class), any(RewardedAdCallback.class));
  }

  @Test
  public void disposeAd() {
    final FlutterBannerAd bannerAd =
        new FlutterBannerAd.Builder()
            .setManager(testManager)
            .setAdUnitId("testId")
            .setSize(new FlutterAdSize(1, 2))
            .setRequest(request)
            .build();
    testManager.trackAd(bannerAd, 2);
    assertNotNull(testManager.adForId(2));
    assertNotNull(testManager.adIdFor(bannerAd));
    testManager.disposeAd(2);
    assertNull(testManager.adForId(2));
    assertNull(testManager.adIdFor(bannerAd));
  }

  @Test
  public void adMessageCodec_encodeFlutterAdSize() {
    final AdMessageCodec codec = new AdMessageCodec();
    final ByteBuffer message = codec.encodeMessage(new FlutterAdSize(1, 2));

    assertEquals(codec.decodeMessage((ByteBuffer) message.position(0)), new FlutterAdSize(1, 2));
  }

  @Test
  public void adMessageCodec_encodeFlutterAdRequest() {
    final AdMessageCodec codec = new AdMessageCodec();
    final ByteBuffer message =
        codec.encodeMessage(
            new FlutterAdRequest.Builder()
                .setKeywords(Arrays.asList("1", "2", "3"))
                .setContentUrl("contentUrl")
                .setBirthday(new Date(23))
                .setGender(FlutterAdRequest.MobileAdGender.UNKNOWN)
                .setDesignedForFamilies(false)
                .setChildDirected(true)
                .setTestDevices(Arrays.asList("Android", "iOS"))
                .setNonPersonalizedAds(false)
                .build());

    assertEquals(
        codec.decodeMessage((ByteBuffer) message.position(0)),
        new FlutterAdRequest.Builder()
            .setKeywords(Arrays.asList("1", "2", "3"))
            .setContentUrl("contentUrl")
            .setBirthday(new Date(23))
            .setGender(FlutterAdRequest.MobileAdGender.UNKNOWN)
            .setDesignedForFamilies(false)
            .setChildDirected(true)
            .setTestDevices(Arrays.asList("Android", "iOS"))
            .setNonPersonalizedAds(false)
            .build());
  }

  @Test
  public void adMessageCodec_encodeFlutterPublisherAdRequest() {
    final AdMessageCodec codec = new AdMessageCodec();
    final ByteBuffer message =
        codec.encodeMessage(
            new FlutterPublisherAdRequest.Builder()
                .setKeywords(Arrays.asList("1", "2", "3"))
                .setContentUrl("contentUrl")
                .setCustomTargeting(Collections.singletonMap("apple", "banana"))
                .setCustomTargetingLists(
                    Collections.singletonMap("cherry", Collections.singletonList("pie")))
                .build());

    assertEquals(
        codec.decodeMessage((ByteBuffer) message.position(0)),
        new FlutterPublisherAdRequest.Builder()
            .setKeywords(Arrays.asList("1", "2", "3"))
            .setContentUrl("contentUrl")
            .setCustomTargeting(Collections.singletonMap("apple", "banana"))
            .setCustomTargetingLists(
                Collections.singletonMap("cherry", Collections.singletonList("pie")))
            .build());
  }

  @Test
  public void adMessageCodec_encodeFlutterRewardItem() {
    final AdMessageCodec codec = new AdMessageCodec();
    final ByteBuffer message =
        codec.encodeMessage(new FlutterRewardedAd.FlutterRewardItem(23, "coins"));

    assertEquals(
        codec.decodeMessage((ByteBuffer) message.position(0)),
        new FlutterRewardedAd.FlutterRewardItem(23, "coins"));
  }

  @Test
  public void adMessageCodec_encodeFlutterLoadAdError() {
    final AdMessageCodec codec = new AdMessageCodec();
    final ByteBuffer message =
        codec.encodeMessage(new FlutterBannerAd.FlutterLoadAdError(1, "domain", "message"));

    final FlutterAd.FlutterLoadAdError error =
        (FlutterAd.FlutterLoadAdError) codec.decodeMessage((ByteBuffer) message.position(0));
    assertNotNull(error);
    assertEquals(error.code, 1);
    assertEquals(error.domain, "domain");
    assertEquals(error.message, "message");
  }

  @Test
  public void mobileAdGender_indexMapsToGADGender() {
    assertEquals(FlutterAdRequest.MobileAdGender.UNKNOWN.ordinal(), 0);
    assertEquals(FlutterAdRequest.MobileAdGender.MALE.ordinal(), 1);
    assertEquals(FlutterAdRequest.MobileAdGender.FEMALE.ordinal(), 2);
  }

  @Test
  public void flutterAdListener_onAdLoaded() {
    final FlutterBannerAd bannerAd =
        new FlutterBannerAd.Builder()
            .setManager(testManager)
            .setAdUnitId("testId")
            .setSize(new FlutterAdSize(1, 2))
            .setRequest(request)
            .build();
    testManager.trackAd(bannerAd, 0);

    testManager.onAdLoaded(bannerAd);

    final MethodCall call = getLastMethodCall();
    assertEquals("onAdEvent", call.method);
    //noinspection rawtypes
    assertThat(call.arguments, (Matcher) hasEntry("eventName", "onAdLoaded"));
    //noinspection rawtypes
    assertThat(call.arguments, (Matcher) hasEntry("adId", 0));
  }

  @Test
  public void flutterAdListener_onAdFailedToLoad() {
    final FlutterBannerAd bannerAd =
        new FlutterBannerAd.Builder()
            .setManager(testManager)
            .setAdUnitId("testId")
            .setSize(new FlutterAdSize(1, 2))
            .setRequest(request)
            .build();
    testManager.trackAd(bannerAd, 0);

    testManager.onAdFailedToLoad(bannerAd, new FlutterAd.FlutterLoadAdError(1, "hi", "friend"));

    final MethodCall call = getLastMethodCall();
    assertEquals("onAdEvent", call.method);
    //noinspection rawtypes
    assertThat(call.arguments, (Matcher) hasEntry("eventName", "onAdFailedToLoad"));
    //noinspection rawtypes
    assertThat(call.arguments, (Matcher) hasEntry("adId", 0));
    //noinspection rawtypes
    assertThat(
        call.arguments,
        (Matcher) hasEntry("loadAdError", new FlutterAd.FlutterLoadAdError(1, "hi", "friend")));
  }

  @Test
  public void flutterAdListener_onAppEvent() {
    final FlutterBannerAd bannerAd =
        new FlutterBannerAd.Builder()
            .setManager(testManager)
            .setAdUnitId("testId")
            .setSize(new FlutterAdSize(1, 2))
            .setRequest(request)
            .build();
    testManager.trackAd(bannerAd, 0);

    testManager.onAppEvent(bannerAd, "color", "red");

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
  public void flutterAdListener_onApplicationExit() {
    final FlutterBannerAd bannerAd =
        new FlutterBannerAd.Builder()
            .setManager(testManager)
            .setAdUnitId("testId")
            .setSize(new FlutterAdSize(1, 2))
            .setRequest(request)
            .build();
    testManager.trackAd(bannerAd, 0);

    testManager.onApplicationExit(bannerAd);

    final MethodCall call = getLastMethodCall();
    assertEquals("onAdEvent", call.method);
    //noinspection rawtypes
    assertThat(call.arguments, (Matcher) hasEntry("eventName", "onApplicationExit"));
    //noinspection rawtypes
    assertThat(call.arguments, (Matcher) hasEntry("adId", 0));
  }

  @Test
  public void flutterAdListener_onAdOpened() {
    final FlutterBannerAd bannerAd =
        new FlutterBannerAd.Builder()
            .setManager(testManager)
            .setAdUnitId("testId")
            .setSize(new FlutterAdSize(1, 2))
            .setRequest(request)
            .build();
    testManager.trackAd(bannerAd, 0);

    testManager.onAdOpened(bannerAd);

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
                new FirebaseAdMobPlugin.NativeAdFactory() {
                  @Override
                  public UnifiedNativeAdView createNativeAd(
                      UnifiedNativeAd nativeAd, Map<String, Object> customOptions) {
                    return null;
                  }
                })
            .build();
    testManager.trackAd(nativeAd, 0);

    testManager.onNativeAdClicked(nativeAd);

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
                new FirebaseAdMobPlugin.NativeAdFactory() {
                  @Override
                  public UnifiedNativeAdView createNativeAd(
                      UnifiedNativeAd nativeAd, Map<String, Object> customOptions) {
                    return null;
                  }
                })
            .build();
    testManager.trackAd(nativeAd, 0);

    testManager.onNativeAdImpression(nativeAd);

    final MethodCall call = getLastMethodCall();
    assertEquals("onAdEvent", call.method);
    //noinspection rawtypes
    assertThat(call.arguments, (Matcher) hasEntry("eventName", "onNativeAdImpression"));
    //noinspection rawtypes
    assertThat(call.arguments, (Matcher) hasEntry("adId", 0));
  }

  @Test
  public void flutterAdListener_onAdClosed() {
    final FlutterBannerAd bannerAd =
        new FlutterBannerAd.Builder()
            .setManager(testManager)
            .setAdUnitId("testId")
            .setSize(new FlutterAdSize(1, 2))
            .setRequest(request)
            .build();
    testManager.trackAd(bannerAd, 0);

    testManager.onAdClosed(bannerAd);

    final MethodCall call = getLastMethodCall();
    assertEquals("onAdEvent", call.method);
    //noinspection rawtypes
    assertThat(call.arguments, (Matcher) hasEntry("eventName", "onAdClosed"));
    //noinspection rawtypes
    assertThat(call.arguments, (Matcher) hasEntry("adId", 0));
  }

  @Test
  public void flutterAdListener_onRewardedAdUserEarnedReward() {
    final FlutterRewardedAd ad = new FlutterRewardedAd(testManager, "testId", request);
    testManager.trackAd(ad, 0);

    testManager.onRewardedAdUserEarnedReward(
        ad, new FlutterRewardedAd.FlutterRewardItem(23, "coins"));

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
}
