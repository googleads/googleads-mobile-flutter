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

import 'package:gma_mediation_applovin/applovin_sdk_api.g.dart';

/// This class has entrypoint to call AppLovin's SDK APIs.
class GmaMediationApplovin {
  Future<void> setHasUserConsent(bool hasUserConsent) async {
    AppLovinSDKApi().setHasUserConsent(hasUserConsent);
  }

  Future<void> setIsAgeRestrictedUser(bool isAgeRestrictedUser) async {
    AppLovinSDKApi().setIsAgeRestrictedUser(isAgeRestrictedUser);
  }

  Future<void> setDoNotSell(bool doNotSell) async {
    AppLovinSDKApi().setDoNotSell(doNotSell);
  }

  Future<void> initializeSdk(String sdkKey) async {
    AppLovinSDKApi().initializeSdk(sdkKey);
  }
}
