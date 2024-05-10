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

/// Class with additional parameters to attach to the [AdRequest] or [AdManagerAdRequest] when using the [GmaMediationDTExchange] adapter.
class DTExchangeMediationExtras implements MediationExtras {
  DTExchangeMediationExtras({
    this.muteVideo,
    this.age,
    this.gender,
    this.zipCode,
  });

  bool? muteVideo;
  int? age;
  DTEUserGenderType? gender;
  String? zipCode;

  @override
  String getAndroidClassName() {
    return "io.flutter.plugins.googlemobileads.mediation.gma_mediation_dtexchange.DTExchangeFlutterMediationExtras";
  }

  @override
  String getIOSClassName() {
    return "DTExchangeFlutterMediationExtras";
  }

  @override
  Map<String, dynamic> getExtras() {
    return <String, dynamic>{
      "muteVideo": muteVideo,
      "age": age,
      "gender": gender?.intValue,
      "zipCode": zipCode,
    };
  }
}

/// Available gender types to be send on the User Data. Only used by iOS adapter.
enum DTEUserGenderType {
  unknown,
  male,
  female,
  other;

  int get intValue => index;
}
