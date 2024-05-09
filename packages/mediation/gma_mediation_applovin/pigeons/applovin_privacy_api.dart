// Copyright 2024 Google LLC
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

import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/applovin_sdk_api.g.dart',
    dartOptions: DartOptions(),
    kotlinOut:
        'android/src/main/kotlin/io/flutter/plugins/googlemobileads/mediation/gma_mediation_applovin/AppLovinSDKApi.g.kt',
    kotlinOptions: KotlinOptions(
      package:
          "io.flutter.plugins.googlemobileads.mediation.gma_mediation_applovin",
    ),
    swiftOut: 'ios/Classes/AppLovinSDKApi.g.swift',
    swiftOptions: SwiftOptions(),
    dartPackageName: 'gma_mediation_applovin',
  ),
)
@HostApi()

/// The generated classes set the channels to call the methods in the corresponding kotlin AppLovinSDKApi interface and swift AppLovinSDKApi protocol from the dart layer.
abstract class AppLovinSDKApi {
  /// Used to configure GDPR consent on the Android or iOS AppLovin SDK
  void setHasUserConsent(bool hasUserConsent);

  /// Used to acknowledge that the user is in an age-restricted category on the Android or iOS AppLovin SDK
  void setIsAgeRestrictedUser(bool isAgeRestrictedUser);

  /// Used to opt out of the sale of personal information in AppLovin SDK.
  void setDoNotSell(bool doNotSell);

  /// Used to initialize the Android or iOS AppLovin SDK. Can be called anytime before the adapter initialization to let AppLovin track events as soon as possible.
  void initializeSdk(String sdkKey);
}
