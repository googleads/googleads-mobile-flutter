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

import 'package:flutter/services.dart';

/// A wrapper around a [MethodChannel] for 3p mediation sdks.
///
/// You may need a method channel to call APIs in 3P SDKs used for mediation.
class MyMethodChannel {
  final MethodChannel _methodChannel =
      MethodChannel('com.example.mediationexample/mediation-channel');

  /// Sets whether the user is age restricted in AppLovin.
  Future<void> setAppLovinIsAgeRestrictedUser(bool isAgeRestricted) async {
    return _methodChannel.invokeMethod(
      'setIsAgeRestrictedUser',
      {
        'isAgeRestricted': isAgeRestricted,
      },
    );
  }

  /// Sets whether we have user consent for the user in AppLovin.
  Future<void> setHasUserConsent(bool hasUserConsent) async {
    return _methodChannel.invokeMethod(
      'setHasUserConsent',
      {
        'hasUserConsent': hasUserConsent,
      },
    );
  }
}
