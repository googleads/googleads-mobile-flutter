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

/// Entry point for the User Messaging Platform SDK.
class UserMessagingPlatform {
  /// Gets the [ConsentInformation].
  static Future<ConsentInformation> getConsentInformation() {
    return UserMessagingChannel.instance.getConsentInformation();
  }
}
