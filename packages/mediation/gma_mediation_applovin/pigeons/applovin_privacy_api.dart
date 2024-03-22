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

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/applovin_sdk_api.g.dart',
  dartOptions: DartOptions(),
  kotlinOut:
      'android/src/main/kotlin/io/flutter/plugins/googlemobileads/mediation/gma_mediation_applovin/AppLovinSDKApi.g.kt',
  kotlinOptions: KotlinOptions(
      package:
          "io.flutter.plugins.googlemobileads.mediation.gma_mediation_applovin"),
  swiftOut: 'ios/Classes/AppLovinSDKApi.g.swift',
  swiftOptions: SwiftOptions(),
  dartPackageName: 'gma_mediation_applovin',
))
@HostApi()
abstract class AppLovinSDKApi {
  void setHasUserConsent(bool hasUserConsent);

  void setIsAgeRestrictedUser(bool isAgeRestrictedUser);

  void setDoNotSell(bool doNotSell);

  void initializeSdk(String sdkKey);
}
