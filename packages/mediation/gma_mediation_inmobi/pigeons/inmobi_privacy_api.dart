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
    dartOut: 'lib/inmobi_privacy_api.g.dart',
    dartOptions: DartOptions(),
    kotlinOut:
    'android/src/main/kotlin/io/flutter/plugins/googlemobileads/mediation/gma_mediation_inmobi/InMobiPrivacyApi.g.kt',
    kotlinOptions: KotlinOptions(
      package:
      'io.flutter.plugins.googlemobileads.mediation.gma_mediation_inmobi',
    ),
    swiftOut: 'ios/Classes/InMobiPrivacyApi.g.swift',
    swiftOptions: SwiftOptions(),
    dartPackageName: 'gma_mediation_inmobi',
  ),
)
@HostApi()

/// The generated classes set the channels to call the methods in the corresponding kotlin InMobiPrivacyApi interface and swift InMobiPrivacyApi protocol from the dart layer.
abstract class InMobiPrivacyApi {
  /// Used to configure GDPR on the Android or iOS InMobi SDK
  void updateGDPRConsent(bool isGDPRApplicable, bool gdprConsent);
}
