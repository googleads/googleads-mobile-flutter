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

import 'consent_information.dart';
import 'consent_request_parameters.dart';
import 'user_messaging_channel.dart';

/// Implementation for ConsentInformation.
class ConsentInformationImpl extends ConsentInformation {
  /// Constructor for [ConsentInformationImpl].
  ConsentInformationImpl(this.platformHash);

  /// An identifier to the corresponding platform object.
  final int platformHash;

  /// Requests a consent information update.
  @override
  void requestConsentInfoUpdate(
      ConsentRequestParameters params,
      OnConsentInfoUpdateSuccessListener successListener,
      OnConsentInfoUpdateFailureListener failureListener) {
    UserMessagingChannel.instance.requestConsentInfoUpdate(
        params, successListener, failureListener, this);
  }

  /// Returns true if a ConsentForm is available, false otherwise.
  @override
  Future<bool> isConsentFormAvailable() {
    return UserMessagingChannel.instance.isConsentFormAvailable(this);
  }

  /// Get the user’s consent status.
  ///
  /// This value is cached between app sessions and can be read before
  /// requesting updated parameters.
  @override
  Future<ConsentStatus> getConsentStatus() {
    return UserMessagingChannel.instance.getConsentStatus(this);
  }

  /// Resets the consent information to initialized status.
  ///
  /// Should only be used for testing. Returns a [Future] that completes when
  /// the platform API has been called.
  @override
  Future<void> reset() {
    return UserMessagingChannel.instance.reset(this);
  }
}
