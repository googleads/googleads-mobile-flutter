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
import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.FullScreenContentCallback;
import com.google.android.gms.ads.LoadAdError;
import com.google.android.gms.ads.OnUserEarnedRewardListener;
import com.google.android.gms.ads.admanager.AdManagerAdRequest;
import com.google.android.gms.ads.rewarded.OnAdMetadataChangedListener;
import com.google.android.gms.ads.rewarded.RewardItem;
import com.google.android.gms.ads.rewarded.RewardedAd;
import com.google.android.gms.ads.rewarded.RewardedAdLoadCallback;
import com.google.android.gms.ads.rewarded.ServerSideVerificationOptions;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugins.googlemobileads.FlutterAd.FlutterLoadAdError;
import io.flutter.plugins.googlemobileads.FlutterRewardedAd.FlutterRewardItem;
import org.junit.Before;
import org.junit.Test;
import org.mockito.ArgumentMatcher;
import org.mockito.ArgumentMatchers;
import org.mockito.invocation.InvocationOnMock;
import org.mockito.stubbing.Answer;

public class FlutterRewardedAdTest {


  private AdInstanceManager testManager;
  private final FlutterAdRequest request = new FlutterAdRequest.Builder().build();
  private static BinaryMessenger mockMessenger;
  private FlutterAdLoader mockFlutterAdLoader = mock(FlutterAdLoader.class);

  @Before
  public void setup() {
    mockMessenger = mock(BinaryMessenger.class);
    testManager = new AdInstanceManager(mock(Activity.class), mockMessenger);
  }

  @Test
  public void loadAdManagerRewardedAd_failedToLoad() {
    AdInstanceManager mockManager = spy(testManager);
    final FlutterAdManagerAdRequest mockFlutterRequest = mock(FlutterAdManagerAdRequest.class);
    final AdManagerAdRequest mockRequest = mock(AdManagerAdRequest.class);
    when(mockFlutterRequest.asAdManagerAdRequest()).thenReturn(mockRequest);

    final FlutterRewardedAd rewardedAd = new FlutterRewardedAd(
      mockManager, "testId", mockFlutterRequest, null, mockFlutterAdLoader);

    final LoadAdError loadAdError = new LoadAdError(1, "2", "3", null, null);
    doAnswer(new Answer() {
      @Override
      public Object answer(InvocationOnMock invocation) throws Throwable {
        RewardedAdLoadCallback adLoadCallback = invocation.getArgument(3);
        // Pass back null for ad
        adLoadCallback.onAdFailedToLoad(loadAdError);
        return null;
      }
    }).when(mockFlutterAdLoader)
      .loadAdManagerRewarded(
        any(Context.class),
        anyString(),
        any(AdManagerAdRequest.class),
        any(RewardedAdLoadCallback.class));

    rewardedAd.load();

    verify(mockFlutterAdLoader).loadAdManagerRewarded(
      eq(mockManager.activity),
      eq("testId"),
      eq(mockRequest),
      any(RewardedAdLoadCallback.class));

    verify(mockManager).onAdFailedToLoad(eq(rewardedAd), eq(new FlutterLoadAdError(loadAdError)));
  }

  @Test
  public void loadAdManagerRewardedAd_showSuccessWithReward() {
    AdInstanceManager mockManager = spy(testManager);
    final FlutterAdManagerAdRequest mockFlutterRequest = mock(FlutterAdManagerAdRequest.class);
    final AdManagerAdRequest mockRequest = mock(AdManagerAdRequest.class);
    when(mockFlutterRequest.asAdManagerAdRequest()).thenReturn(mockRequest);
    final FlutterServerSideVerificationOptions options =
      new FlutterServerSideVerificationOptions("userId", "customData");

    final FlutterRewardedAd rewardedAd = new FlutterRewardedAd(
      mockManager, "testId", mockFlutterRequest, options, mockFlutterAdLoader);

    final FlutterRewardedAd mockFlutterAd = spy(rewardedAd);
    final RewardedAd mockAdManagerAd = mock(RewardedAd.class);
    final LoadAdError loadAdError = new LoadAdError(1, "2", "3", null, null);
    doAnswer(new Answer() {
      @Override
      public Object answer(InvocationOnMock invocation) throws Throwable {
        RewardedAdLoadCallback adLoadCallback = invocation.getArgument(3);
        // Pass back null for ad
        adLoadCallback.onAdLoaded(mockAdManagerAd);
        return null;
      }
    }).when(mockFlutterAdLoader)
      .loadAdManagerRewarded(
        any(Context.class),
        anyString(),
        any(AdManagerAdRequest.class),
        any(RewardedAdLoadCallback.class));

    mockFlutterAd.load();

    verify(mockFlutterAdLoader).loadAdManagerRewarded(
      eq(mockManager.activity),
      eq("testId"),
      eq(mockRequest),
      any(RewardedAdLoadCallback.class));

    verify(mockManager).onAdLoaded(mockFlutterAd);

    doAnswer(new Answer() {
      @Override
      public Object answer(InvocationOnMock invocation) throws Throwable {
        FullScreenContentCallback callback = invocation.getArgument(0);
        callback.onAdShowedFullScreenContent();
        return null;
      }
    }).when(mockAdManagerAd).setFullScreenContentCallback(any(FullScreenContentCallback.class));

    final RewardItem mockRewardItem = mock(RewardItem.class);
    doReturn(5).when(mockRewardItem).getAmount();
    doReturn("$$").when(mockRewardItem).getType();
    doAnswer(new Answer() {
      @Override
      public Object answer(InvocationOnMock invocation) throws Throwable {
        OnUserEarnedRewardListener listener = invocation.getArgument(1);
        listener.onUserEarnedReward(mockRewardItem);
        return null;
      }
    }).when(mockAdManagerAd).show(any(Activity.class), any(OnUserEarnedRewardListener.class));

    mockFlutterAd.show();
    verify(mockAdManagerAd).setFullScreenContentCallback(any(FullScreenContentCallback.class));
    verify(mockAdManagerAd).show(eq(testManager.activity), any(OnUserEarnedRewardListener.class));
    verify(mockAdManagerAd).setOnAdMetadataChangedListener(any(OnAdMetadataChangedListener.class));
    ArgumentMatcher<ServerSideVerificationOptions> serverSideVerificationOptionsArgumentMatcher =
      new ArgumentMatcher<ServerSideVerificationOptions>() {
        @Override
        public boolean matches(ServerSideVerificationOptions argument) {
          return argument.getCustomData().equals(options.getCustomData())
            && argument.getUserId().equals(options.getUserId());
        }
      };
    verify(mockAdManagerAd)
      .setServerSideVerificationOptions(
        ArgumentMatchers.argThat(serverSideVerificationOptionsArgumentMatcher));
    verify(mockManager).onRewardedAdUserEarnedReward(mockFlutterAd, new FlutterRewardItem(5, "$$"));
  }

  @Test
  public void loadRewardedAdWithAdManagerRequest_nullServerSideOptions() {
    AdInstanceManager mockManager = spy(testManager);
    final FlutterAdManagerAdRequest mockFlutterRequest = mock(FlutterAdManagerAdRequest.class);
    final AdManagerAdRequest mockRequest = mock(AdManagerAdRequest.class);
    when(mockFlutterRequest.asAdManagerAdRequest()).thenReturn(mockRequest);
    final FlutterServerSideVerificationOptions options =
      new FlutterServerSideVerificationOptions(null, null);

    final FlutterRewardedAd rewardedAd = new FlutterRewardedAd(
      mockManager, "testId", mockFlutterRequest, options, mockFlutterAdLoader);

    final FlutterRewardedAd mockFlutterAd = spy(rewardedAd);
    final RewardedAd mockAdManagerAd = mock(RewardedAd.class);
    final LoadAdError loadAdError = new LoadAdError(1, "2", "3", null, null);
    doAnswer(new Answer() {
      @Override
      public Object answer(InvocationOnMock invocation) throws Throwable {
        RewardedAdLoadCallback adLoadCallback = invocation.getArgument(3);
        // Pass back null for ad
        adLoadCallback.onAdLoaded(mockAdManagerAd);
        return null;
      }
    }).when(mockFlutterAdLoader)
      .loadAdManagerRewarded(
        any(Context.class),
        anyString(),
        any(AdManagerAdRequest.class),
        any(RewardedAdLoadCallback.class));

    mockFlutterAd.load();

    verify(mockFlutterAdLoader).loadAdManagerRewarded(
      eq(mockManager.activity),
      eq("testId"),
      eq(mockRequest),
      any(RewardedAdLoadCallback.class));

    verify(mockManager).onAdLoaded(mockFlutterAd);

    doAnswer(new Answer() {
      @Override
      public Object answer(InvocationOnMock invocation) throws Throwable {
        FullScreenContentCallback callback = invocation.getArgument(0);
        callback.onAdShowedFullScreenContent();
        return null;
      }
    }).when(mockAdManagerAd).setFullScreenContentCallback(any(FullScreenContentCallback.class));

    mockFlutterAd.show();
    verify(mockAdManagerAd).setFullScreenContentCallback(any(FullScreenContentCallback.class));
    verify(mockAdManagerAd).show(eq(testManager.activity), any(OnUserEarnedRewardListener.class));
    verify(mockAdManagerAd).setOnAdMetadataChangedListener(any(OnAdMetadataChangedListener.class));
    ArgumentMatcher<ServerSideVerificationOptions> serverSideVerificationOptionsArgumentMatcher =
      new ArgumentMatcher<ServerSideVerificationOptions>() {
        @Override
        public boolean matches(ServerSideVerificationOptions argument) {
          return argument.getCustomData().isEmpty() && argument.getUserId().isEmpty();
        }
      };
    verify(mockAdManagerAd)
      .setServerSideVerificationOptions(
        ArgumentMatchers.argThat(serverSideVerificationOptionsArgumentMatcher));
  }

  @Test
  public void loadRewardedAd() {
    AdInstanceManager mockManager = spy(testManager);
    final FlutterAdRequest mockFlutterRequest = mock(FlutterAdRequest.class);
    final AdRequest mockRequest = mock(AdRequest.class);
    when(mockFlutterRequest.asAdRequest()).thenReturn(mockRequest);
    final FlutterServerSideVerificationOptions options =
      new FlutterServerSideVerificationOptions("userId", "customData");

    final FlutterRewardedAd rewardedAd = new FlutterRewardedAd(
      mockManager, "testId", mockFlutterRequest, options, mockFlutterAdLoader);

    final RewardedAd mockAdManagerAd = mock(RewardedAd.class);
    doAnswer(new Answer() {
      @Override
      public Object answer(InvocationOnMock invocation) throws Throwable {
        RewardedAdLoadCallback adLoadCallback = invocation.getArgument(3);
        // Pass back null for ad
        adLoadCallback.onAdLoaded(mockAdManagerAd);
        return null;
      }
    }).when(mockFlutterAdLoader)
      .loadRewarded(
        any(Activity.class),
        anyString(),
        any(AdRequest.class),
        any(RewardedAdLoadCallback.class));

    rewardedAd.load();

    verify(mockFlutterAdLoader).loadRewarded(
      eq(mockManager.activity),
      eq("testId"),
      eq(mockRequest),
      any(RewardedAdLoadCallback.class));

    verify(mockManager).onAdLoaded(rewardedAd);
  }
}
