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

import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Dart snippets for the developer guide.
class _UmpSnippets {
  void _setConsentSyncId() {
    // [START set_consent_sync_id]
    // Create a ConsentRequestParameters object with a consent sync ID.
    final ConsentRequestParameters params = ConsentRequestParameters(
      consentSyncId: 'SAMPLE_CONSENT_SYNC_ID',
    );
    // [END set_consent_sync_id]

    ConsentInformation.instance.requestConsentInfoUpdate(
      params,
      () async {
        // Consent information updated successfully.
      },
      (FormError error) {
        debugPrint('Consent update failed: ${error.message}');
      },
    );
  }
}
