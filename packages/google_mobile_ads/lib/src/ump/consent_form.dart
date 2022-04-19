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

import 'package:google_mobile_ads/src/ump/user_messaging_channel.dart';

import 'form_error.dart';

typedef OnConsentFormDismissedListener = void Function(FormError? formError);

class ConsentForm {

  ConsentForm(this.hash);

  final int hash;
  void show(OnConsentFormDismissedListener onConsentFormDismissedListener) {
    UserMessagingChannel.instance.show(this, onConsentFormDismissedListener);
  }
}