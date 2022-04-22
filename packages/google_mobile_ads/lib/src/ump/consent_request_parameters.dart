// Copyright 2022 Google LLC
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

/// Parameters sent on updating user consent info.
class ConsentRequestParameters {
  /// Construct a [ConsentRequestParameters].
  ConsentRequestParameters(
      {this.tagForUnderAgeOfConsent, this.consentDebugSettings});

  /// Tag for underage of consent.
  ///
  /// False means users are not underage.
  bool? tagForUnderAgeOfConsent;

  /// Debug settings to hardcode in test requests.
  ConsentDebugSettings? consentDebugSettings;
}

/// Debug settings to hardcode in test requests.
class ConsentDebugSettings {
  /// Construct a [ConsentDebugSettings].
  ConsentDebugSettings({this.debugGeography});

  /// Debug geography. TODO - define debugGeography enum
  int? debugGeography;

  /// TODO - add test device identifiers
}
