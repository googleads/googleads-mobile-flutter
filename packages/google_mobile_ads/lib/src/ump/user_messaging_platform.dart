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

import 'consent_form.dart';
import 'consent_information.dart';
import 'form_error.dart';
import 'user_messaging_channel.dart';


typedef OnConsentFormLoadSuccessListener = void Function(ConsentForm consentForm);
typedef OnConsentFormLoadFailureListener = void Function(FormError formError);

class UserMessagingPlatform {

  /// Gets [ConsentInformation].
  ///
  ///
  static Future<ConsentInformation> getConsentInformation() {
    return UserMessagingChannel.instance.getConsentInformation();
  }

  static void loadConsentForm(
      OnConsentFormLoadSuccessListener successListener,
      OnConsentFormLoadFailureListener failureListener) {
    UserMessagingChannel.instance.loadConsentForm(successListener, failureListener);
  }
}