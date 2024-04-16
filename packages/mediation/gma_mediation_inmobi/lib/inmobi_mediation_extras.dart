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

import 'package:gma_mediation_inmobi/gma_mediation_inmobi.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Class with additional parameters to attach to the [AdRequest] or [AdManagerAdRequest] when using the [GmaMediationInMobi] adapter.
class InMobiMediationExtras implements MediationExtras {
  InMobiMediationExtras({
    this.ageGroup,
    this.education,
    this.age,
    this.yearOfBirth,
    this.postalCode,
    this.areaCode,
    this.language,
    this.city,
    this.state,
    this.country,
    this.keywords,
    this.interests,
    this.logLevel,
  });

  InMobiAgeGroups? ageGroup;
  InMobiEducation? education;
  int? age;
  int? yearOfBirth;
  String? postalCode;
  String? areaCode;
  String? language;
  String? city;
  String? state;
  String? country;
  String? interests;
  String? keywords;
  InMobiLogLevel? logLevel;

  @override
  String getAndroidClassName() {
    return "io.flutter.plugins.googlemobileads.mediation.gma_mediation_inmobi.InMobiFlutterMediationExtras";
  }

  @override
  String getIOSClassName() {
    return "InMobiFlutterMediationExtras";
  }

  @override
  Map<String, dynamic> getExtras() {
    return <String, dynamic>{
      "ageGroup": ageGroup?.intValue,
      "education": education?.intValue,
      "age": age,
      "yearOfBirth": yearOfBirth,
      "postalCode": postalCode,
      "areaCode": areaCode,
      "language": language,
      "city": city,
      "state": state,
      "country": country,
      "keywords": keywords,
      "interests": interests,
      "logLevel": logLevel?.intValue,
    };
  }
}

/// Definition of the age groups.
enum InMobiAgeGroups {
  below18, // index = 0
  between18And24,
  between25And29,
  between30And34,
  between35And44,
  between45And54,
  between55And65,
  above65;

  int get intValue => index;
}

/// Definition of different level of education.
enum InMobiEducation {
  highschoolOrLess, // index = 0
  collegeOrGraduate,
  postgraduateOrAbove;

  int get intValue => index;
}

/// Used in the InMobiSDK to set the log level.
enum InMobiLogLevel {
  none,
  debug,
  error;

  int get intValue => index;
}
