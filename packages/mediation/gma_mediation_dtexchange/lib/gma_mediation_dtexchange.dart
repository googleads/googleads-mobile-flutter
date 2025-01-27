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

import 'package:gma_mediation_dtexchange/dtexchange_privacy_api.g.dart';

/// This class has entrypoint to call DT Exchange's SDK APIs.
class GmaMediationDTExchange {
  Future<void> setLgpdConsent(bool wasConsentGiven) async {
    DTExchangePrivacyApi().setLgpdConsent(wasConsentGiven);
  }

  Future<void> clearLgpdConsentData() async {
    DTExchangePrivacyApi().clearLgpdConsentData();
  }

  Future<void> setUSPrivacyString(String usPrivacyString) async {
    DTExchangePrivacyApi().setUSPrivacyString(usPrivacyString);
  }

  Future<void> clearUSPrivacyString() async {
    DTExchangePrivacyApi().clearUSPrivacyString();
  }
}
