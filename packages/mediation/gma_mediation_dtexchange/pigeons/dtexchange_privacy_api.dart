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
    dartOut: 'lib/dtexchange_privacy_api.g.dart',
    dartOptions: DartOptions(),
    kotlinOut:
        'android/src/main/kotlin/io/flutter/plugins/googlemobileads/mediation/gma_mediation_dtexchange/DTExchangePrivacyApi.g.kt',
    kotlinOptions: KotlinOptions(
      package:
          'io.flutter.plugins.googlemobileads.mediation.gma_mediation_dtexchange',
    ),
    swiftOut: 'ios/Classes/DTExchangePrivacyApi.g.swift',
    swiftOptions: SwiftOptions(),
    dartPackageName: 'gma_mediation_dtexchange',
  ),
)
@HostApi()

/// The generated classes set the channels to call the methods in the corresponding kotlin DTExchangePrivacyApi interface and swift DTExchangePrivacyApi protocol from the dart layer.
abstract class DTExchangePrivacyApi {
  /// Used to configure LGDP on the Android or iOS DTExchange SDK.
  void setLgpdConsent(bool wasConsentGiven);

  /// Used to clear the LGDP flag on the Android or iOS DTExchange SDK.
  void clearLgpdConsentData();

  /// Used to configure consent to Sell Personal Information on the Android or iOS DTExchange SDK.
  void setUSPrivacyString(String usPrivacyString);

  /// Used to clear the US Privacy flag on the Android or iOS DTExchange SDK.
  void clearUSPrivacyString();
}
