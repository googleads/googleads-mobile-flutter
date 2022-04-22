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

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'consent_form.dart';
import 'consent_information.dart';
import 'consent_request_parameters.dart';
import 'form_error.dart';
import 'user_messaging_codec.dart';
import 'user_messaging_platform.dart';

/// Platform channel for ump sdk.
class UserMessagingChannel {
  static const _methodChannelName = 'plugins.flutter.io/google_mobile_ads/ump';

  static UserMessagingChannel instance = UserMessagingChannel();

  final MethodChannel _methodChannel = MethodChannel(
    _methodChannelName,
    StandardMethodCodec(UserMessagingCodec()),
  );

  Future<ConsentInformation> getConsentInformation() async {
    try {
      return (await _methodChannel.invokeMethod<ConsentInformation>(
          'UserMessagingPlatform#getConsentInformation'))!;
    } on PlatformException catch (e) {
      return Future.error(e);
    }
  }

  void requestConsentInfoUpdate(
      ConsentRequestParameters params,
      OnConsentInfoUpdateSuccessListener successListener,
      OnConsentInfoUpdateFailureListener failureListener,
      ConsentInformation consentInformation) async {
    try {
      await _methodChannel.invokeMethod<void>(
        'ConsentInfo#requestConsentInfoUpdate',
        <dynamic, dynamic>{
          'params': params,
          'contentInformation': consentInformation,
        },
      );
      successListener();
    } on PlatformException catch (e) {
      failureListener(
          FormError(errorCode: int.parse(e.code), message: e.message));
    }
  }

  Future<bool> isConsentFormAvailable(ConsentInformation consentInfo) async {
    return (await _methodChannel.invokeMethod<bool>(
      'ConsentInfo#isConsentFormAvailable',
      <dynamic, dynamic>{
        'consentInformation': consentInfo,
      },
    ))!;
  }

  Future<ConsentStatus> getConsentStatus(ConsentInformation consentInfo) async {
    int consentStatus = (await _methodChannel.invokeMethod<int>(
      'ConsentInformation#getConsentStatus',
      <dynamic, dynamic>{
        'consentInformation': consentInfo,
      },
    ))!;

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      switch (consentStatus) {
        case 0:
          return ConsentStatus.unknown;
        case 1:
          return ConsentStatus.required;
        case 2:
          return ConsentStatus.notRequired;
        case 3:
          return ConsentStatus.obtained;
        default:
          debugPrint('Error: unknown ConsentStatus value: $consentStatus');
          return ConsentStatus.unknown;
      }
    } else {
      switch (consentStatus) {
        case 0:
          return ConsentStatus.unknown;
        case 1:
          return ConsentStatus.notRequired;
        case 2:
          return ConsentStatus.required;
        case 3:
          return ConsentStatus.obtained;
        default:
          debugPrint('Error: unknown ConsentStatus value: $consentStatus');
          return ConsentStatus.unknown;
      }
    }
  }

  Future<void> reset(ConsentInformation consentInfo) async {
    return _methodChannel.invokeMethod<void>(
      'ConsentInformation#reset',
      <dynamic, dynamic>{
        'consentInformation': consentInfo,
      },
    );
  }

  void loadConsentForm(OnConsentFormLoadSuccessListener successListener,
      OnConsentFormLoadFailureListener failureListener) async {
    try {
      ConsentForm form = (await _methodChannel
          .invokeMethod<ConsentForm>('UserMessagingPlatform#loadConsentForm'))!;
      successListener(form);
    } on PlatformException catch (e) {
      failureListener(
          FormError(errorCode: int.parse(e.code), message: e.message));
    }
  }

  void show(ConsentForm consentForm,
      OnConsentFormDismissedListener onConsentFormDismissedListener) async {
    FormError? formError = (await _methodChannel.invokeMethod<FormError?>(
      'ConsentForm#show',
      <dynamic, dynamic>{
        'consentForm': consentForm,
      },
    ));
    onConsentFormDismissedListener(formError);
  }
}
