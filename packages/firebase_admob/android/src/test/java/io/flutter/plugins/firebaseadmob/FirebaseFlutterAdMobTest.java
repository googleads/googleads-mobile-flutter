package io.flutter.plugins.firebaseadmob;

import static org.hamcrest.Matchers.hasEntry;
import static org.junit.Assert.*;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.ArgumentMatchers.isNull;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;

import android.app.Activity;
import com.google.android.gms.ads.formats.UnifiedNativeAd;
import com.google.android.gms.ads.formats.UnifiedNativeAdView;
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
    testManager.loadAd(bannerAd, 0);

    assertNotNull(testManager.adForId(0));
    assertEquals(bannerAd, testManager.adForId(0));
    assertEquals(0, testManager.adIdFor(bannerAd).intValue());
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
    testManager.loadAd(bannerAd, 2);
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
    testManager.loadAd(bannerAd, 0);

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
    testManager.loadAd(bannerAd, 0);

    testManager.onAdFailedToLoad(bannerAd);

    final MethodCall call = getLastMethodCall();
    assertEquals("onAdEvent", call.method);
    //noinspection rawtypes
    assertThat(call.arguments, (Matcher) hasEntry("eventName", "onAdFailedToLoad"));
    //noinspection rawtypes
    assertThat(call.arguments, (Matcher) hasEntry("adId", 0));
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
    testManager.loadAd(bannerAd, 0);

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
    testManager.loadAd(bannerAd, 0);

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
    testManager.loadAd(nativeAd, 0);

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
    testManager.loadAd(nativeAd, 0);

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
    testManager.loadAd(bannerAd, 0);

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
    final FlutterRewardedAd ad =
        new FlutterRewardedAd.Builder().setManager(testManager).setAdUnitId("testId").build();
    testManager.loadAd(ad, 0);

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
