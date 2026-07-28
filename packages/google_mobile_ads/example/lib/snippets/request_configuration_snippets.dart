// Copyright 2026 Google LLC
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

// ignore_for_file: public_member_api_docs, unused_field, unused_element

import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Dart snippets for the developer guide.
class _RequestConfigurationSnippets {
  void _setAgeRestrictedTreatmentChild() {
    // [START age_restricted_treatment_child]
    RequestConfiguration requestConfiguration = RequestConfiguration(
      // Indicates that ad requests should have child age treatment.
      ageRestrictedTreatment: AgeRestrictedTreatment.child,
    );
    MobileAds.instance.updateRequestConfiguration(requestConfiguration);
    // [END age_restricted_treatment_child]
  }

  void _setAgeRestrictedTreatmentTeen() {
    // [START age_restricted_treatment_teen]
    RequestConfiguration requestConfiguration = RequestConfiguration(
      // Indicates that ad requests should have teen age treatment.
      ageRestrictedTreatment: AgeRestrictedTreatment.teen,
    );
    MobileAds.instance.updateRequestConfiguration(requestConfiguration);
    // [END age_restricted_treatment_teen]
  }

  void _setAgeRestrictedTreatmentUnspecified() {
    // [START age_restricted_treatment_unspecified]
    RequestConfiguration requestConfiguration = RequestConfiguration(
      // Indicates that ad requests should have unspecified age treatment.
      ageRestrictedTreatment: AgeRestrictedTreatment.unspecified,
    );
    MobileAds.instance.updateRequestConfiguration(requestConfiguration);
    // [END age_restricted_treatment_unspecified]
  }
}
