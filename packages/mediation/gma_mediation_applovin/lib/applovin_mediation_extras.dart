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

import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Extra information sent to the AppLovin adapter through an [AdRequest] or an [AdManagerAdRequest].
class AppLovinMediationExtras implements MediationExtras {
  /// Default constructor with required extras value.
  const AppLovinMediationExtras({required this.isMuted});

  /// Specifies whether the loaded AppLovin ad will be muted or not.
  final bool isMuted;

  @override
  String getAndroidClassName() {
    return "io.flutter.plugins.googlemobileads.mediation.gma_mediation_applovin.AppLovinFlutterMediationExtras";
  }

  @override
  String getIOSClassName() {
    return "AppLovinFlutterMediationExtras";
  }

  @override
  Map<String, dynamic> getExtras() {
    return <String, dynamic>{
      "isMuted": isMuted,
    };
  }
}
