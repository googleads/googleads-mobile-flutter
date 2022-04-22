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

import 'form_error.dart';
import 'user_messaging_channel.dart';

/// Callback to be invoked when a consent form is dismissed.
///
/// An optional [FormError] is provided if an error occurred.
typedef OnConsentFormDismissedListener = void Function(FormError? formError);

/// A rendered form for collecting consent from a user.
class ConsentForm {
  /// Construct a [ConsentForm].
  ///
  /// Should be not directly instantiated. Instead use
  /// UserMessagingChannel.instance
  /// .loadConsentForm(successListener, failureListener). TODO - make this an abstract class.
  ConsentForm(this.hash);

  /// Identifier to the underlying platform object.
  final int hash;

  /// Shows the consent form.
  void show(OnConsentFormDismissedListener onConsentFormDismissedListener) {
    UserMessagingChannel.instance.show(this, onConsentFormDismissedListener);
  }
}
