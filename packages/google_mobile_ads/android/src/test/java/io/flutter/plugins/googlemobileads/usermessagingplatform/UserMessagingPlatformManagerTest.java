// Copyright 2022 Google LLC
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

package io.flutter.plugins.googlemobileads.usermessagingplatform;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.ArgumentMatchers.isNull;
import static org.mockito.Mockito.doReturn;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;

import android.app.Activity;
import android.content.Context;
import androidx.test.core.app.ApplicationProvider;
import com.google.android.ump.ConsentForm;
import com.google.android.ump.ConsentForm.OnConsentFormDismissedListener;
import com.google.android.ump.ConsentInformation;
import com.google.android.ump.ConsentInformation.ConsentStatus;
import com.google.android.ump.ConsentInformation.OnConsentInfoUpdateFailureListener;
import com.google.android.ump.ConsentInformation.OnConsentInfoUpdateSuccessListener;
import com.google.android.ump.ConsentRequestParameters;
import com.google.android.ump.FormError;
import com.google.android.ump.UserMessagingPlatform;
import com.google.android.ump.UserMessagingPlatform.OnConsentFormLoadFailureListener;
import com.google.android.ump.UserMessagingPlatform.OnConsentFormLoadSuccessListener;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.Result;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.ArgumentCaptor;
import org.mockito.MockedStatic;
import org.mockito.Mockito;
import org.robolectric.RobolectricTestRunner;

/** Tests for {@link UserMessagingPlatformManager}. */
@RunWith(RobolectricTestRunner.class)
public class UserMessagingPlatformManagerTest {

  private Context context;
  private BinaryMessenger mockMessenger;
  private UserMessagingPlatformManager manager;
  private Activity activity;

  @Before
  public void setup() {
    context = ApplicationProvider.getApplicationContext();
    mockMessenger = mock(BinaryMessenger.class);
    manager = new UserMessagingPlatformManager(mockMessenger, context);
    activity = mock(Activity.class);
  }

  @Test
  public void testConsentInformation_reset() {
    ConsentInformation consentInformation = mock(ConsentInformation.class);
    Map<String, Object> args = Collections.singletonMap("consentInformation", consentInformation);
    MethodCall methodCall = new MethodCall("ConsentInformation#reset", args);
    Result result = mock(Result.class);

    manager.onMethodCall(methodCall, result);

    verify(consentInformation).reset();
    verify(result).success(isNull());
  }

  @Test
  public void testConsentInformation_reset_error() {
    ConsentInformation consentInformation = mock(ConsentInformation.class);
    // Provide incorrect argument mapping
    Map<String, Object> args = Collections.singletonMap("abcdef", consentInformation);
    MethodCall methodCall = new MethodCall("ConsentInformation#reset", args);
    Result result = mock(Result.class);

    manager.onMethodCall(methodCall, result);

    verify(consentInformation, never()).reset();
    verify(result)
        .error(
            eq("UserMessagingPlatformManager"),
            eq("Unable to find ConsentInfo in ConsentInformation#reset"),
            isNull());
  }

  @Test
  public void testConsentInformation_getConsentStatus() {
    ConsentInformation consentInformation = mock(ConsentInformation.class);
    doReturn(ConsentStatus.REQUIRED).when(consentInformation).getConsentStatus();
    Map<String, Object> args = Collections.singletonMap("consentInformation", consentInformation);
    MethodCall methodCall = new MethodCall("ConsentInformation#getConsentStatus", args);
    Result result = mock(Result.class);

    manager.onMethodCall(methodCall, result);

    verify(result).success(eq(ConsentStatus.REQUIRED));
  }

  @Test
  public void testConsentInformation_getConsentStatus_error() {
    // Provide incorrect argument mapping
    MethodCall methodCall = new MethodCall("ConsentInformation#getConsentStatus", null);
    Result result = mock(Result.class);

    manager.onMethodCall(methodCall, result);

    verify(result)
        .error(
            eq("UserMessagingPlatformManager"),
            eq("Unable to find ConsentInfo in ConsentInformation#getConsentStatus"),
            isNull());
  }

  @Test
  public void testConsentInformation_requestConsentInfoUpdate_activityNotSet() {
    manager.setActivity(null);
    MethodCall methodCall = new MethodCall("ConsentInformation#requestConsentInfoUpdate", null);
    Result result = mock(Result.class);

    manager.onMethodCall(methodCall, result);

    verify(result)
        .error(
            eq("UserMessagingPlatformManager"),
            eq(
                "ConsentInformation#requestConsentInfoUpdate called before plugin has been "
                    + "registered to an activity."),
            isNull());
  }

  @Test
  public void testConsentInformation_requestConsentInfoUpdate_errorNoConsentInfo() {
    manager.setActivity(activity);
    MethodCall methodCall = new MethodCall("ConsentInformation#requestConsentInfoUpdate", null);
    Result result = mock(Result.class);

    manager.onMethodCall(methodCall, result);

    verify(result)
        .error(
            eq("UserMessagingPlatformManager"),
            eq("Unable to find ConsentInfo in ConsentInformation#requestConsentInfoUpdate"),
            isNull());
  }

  @Test
  public void testConsentInformation_requestConsentInfoUpdate_success() {
    manager.setActivity(activity);
    ConsentInformation consentInformation = mock(ConsentInformation.class);
    ConsentRequestParametersWrapper paramsWrapper = mock(ConsentRequestParametersWrapper.class);
    ConsentRequestParameters params = mock(ConsentRequestParameters.class);
    doReturn(params).when(paramsWrapper).getAsConsentRequestParameters(any());
    Map<String, Object> args = new HashMap<>();
    args.put("consentInformation", consentInformation);
    args.put("params", paramsWrapper);
    MethodCall methodCall = new MethodCall("ConsentInformation#requestConsentInfoUpdate", args);
    Result result = mock(Result.class);

    manager.onMethodCall(methodCall, result);

    ArgumentCaptor<OnConsentInfoUpdateSuccessListener> successCaptor =
        ArgumentCaptor.forClass(OnConsentInfoUpdateSuccessListener.class);
    ArgumentCaptor<OnConsentInfoUpdateFailureListener> errorCaptor =
        ArgumentCaptor.forClass(OnConsentInfoUpdateFailureListener.class);
    verify(consentInformation)
        .requestConsentInfoUpdate(
            eq(activity), eq(params), successCaptor.capture(), errorCaptor.capture());

    successCaptor.getValue().onConsentInfoUpdateSuccess();
    verify(result).success(isNull());

    FormError formError = mock(FormError.class);
    doReturn(1).when(formError).getErrorCode();
    doReturn("message").when(formError).getMessage();
    errorCaptor.getValue().onConsentInfoUpdateFailure(formError);
    verify(result).error(eq("1"), eq("message"), isNull());
  }

  @Test
  public void testConsentInformation_isConsentFormAvailable() {
    ConsentInformation consentInformation = mock(ConsentInformation.class);
    doReturn(false).when(consentInformation).isConsentFormAvailable();
    Map<String, Object> args = Collections.singletonMap("consentInformation", consentInformation);
    MethodCall methodCall = new MethodCall("ConsentInformation#isConsentFormAvailable", args);
    Result result = mock(Result.class);

    manager.onMethodCall(methodCall, result);

    verify(result).success(eq(false));
  }

  @Test
  public void testConsentInformation_isConsentFormAvailable_errorNoConsentInfo() {
    ConsentInformation consentInformation = mock(ConsentInformation.class);
    Map<String, Object> args = Collections.singletonMap("abcdef", consentInformation);
    MethodCall methodCall = new MethodCall("ConsentInformation#isConsentFormAvailable", args);
    Result result = mock(Result.class);

    manager.onMethodCall(methodCall, result);

    verify(result)
        .error(
            eq("UserMessagingPlatformManager"),
            eq("Unable to find ConsentInfo in ConsentInformation#isConsentFormAvailable"),
            isNull());
  }

  @Test
  public void testUserMessagingPlatform_getConsentInformation() {
    ConsentInformation consentInformation = mock(ConsentInformation.class);
    MockedStatic<UserMessagingPlatform> mockedUmp = Mockito.mockStatic(UserMessagingPlatform.class);
    mockedUmp
        .when(
            () -> {
              UserMessagingPlatform.getConsentInformation(any());
            })
        .thenReturn(consentInformation);

    doReturn(false).when(consentInformation).isConsentFormAvailable();
    MethodCall methodCall = new MethodCall("UserMessagingPlatform#getConsentInformation", null);
    Result result = mock(Result.class);

    manager.onMethodCall(methodCall, result);

    verify(result).success(eq(consentInformation));
    mockedUmp.close();
  }

  @Test
  public void testUserMessagingPlatform_loadConsentForm() {
    MockedStatic<UserMessagingPlatform> mockedUmp = Mockito.mockStatic(UserMessagingPlatform.class);

    MethodCall methodCall = new MethodCall("UserMessagingPlatform#loadConsentForm", null);
    Result result = mock(Result.class);

    manager.onMethodCall(methodCall, result);

    ArgumentCaptor<OnConsentFormLoadSuccessListener> successCaptor =
        ArgumentCaptor.forClass(OnConsentFormLoadSuccessListener.class);
    ArgumentCaptor<OnConsentFormLoadFailureListener> errorCaptor =
        ArgumentCaptor.forClass(OnConsentFormLoadFailureListener.class);
    mockedUmp.verify(
        () ->
            UserMessagingPlatform.loadConsentForm(
                eq(context), successCaptor.capture(), errorCaptor.capture()));

    ConsentForm consentForm = mock(ConsentForm.class);
    successCaptor.getValue().onConsentFormLoadSuccess(consentForm);

    verify(result).success(eq(consentForm));

    FormError formError = mock(FormError.class);
    errorCaptor.getValue().onConsentFormLoadFailure(formError);
    mockedUmp.close();
  }

  @Test
  public void testConsentForm_show() {
    manager.setActivity(activity);
    ConsentForm consentForm = mock(ConsentForm.class);
    Map<String, Object> args = Collections.singletonMap("consentForm", consentForm);
    MethodCall methodCall = new MethodCall("ConsentForm#show", args);
    Result result = mock(Result.class);

    manager.onMethodCall(methodCall, result);

    ArgumentCaptor<OnConsentFormDismissedListener> listenerCaptor =
        ArgumentCaptor.forClass(OnConsentFormDismissedListener.class);
    verify(consentForm).show(eq(activity), listenerCaptor.capture());

    listenerCaptor.getValue().onConsentFormDismissed(null);
    verify(result).success(isNull());

    FormError formError = mock(FormError.class);
    doReturn(1).when(formError).getErrorCode();
    doReturn("message").when(formError).getMessage();
    listenerCaptor.getValue().onConsentFormDismissed(formError);
    verify(result).error(eq("1"), eq("message"), isNull());
  }

  @Test
  public void testConsentForm_show_errorNoConsentForm() {
    MethodCall methodCall = new MethodCall("ConsentForm#show", null);
    Result result = mock(Result.class);
    manager.onMethodCall(methodCall, result);
    verify(result).error(eq("UserMessagingPlatformManager"), eq("ConsentForm#show"), isNull());
  }
}
