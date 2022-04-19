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

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/src/ump/consent_form.dart';

import 'consent_information.dart';
import 'consent_request_parameters.dart';

/// Codec for coding and decoding types in the ump sdk.
class UserMessagingCodec extends StandardMessageCodec {

  static const int _valueConsentInformation = 128;
  static const int _valueConsentRequestParameters = 129;
  static const int _valueConsentDebugSettings = 130;
  static const int _valueConsentForm = 131;

  @override
  void writeValue(WriteBuffer buffer, dynamic value) {
    if (value is ConsentRequestParameters) {
      buffer.putUint8(_valueConsentRequestParameters);
      writeValue(buffer, value.tagForUnderAgeOfConsent);
      writeValue(buffer, value.consentDebugSettings);
    } else if (value is ConsentDebugSettings) {
      buffer.putUint8(_valueConsentDebugSettings);
      writeValue(buffer, value.debugGeography);
    } else if (value is ConsentInformation) {
      buffer.putUint8(_valueConsentInformation);
      writeValue(buffer, value.hash);
    } else if (value is ConsentForm) {
      buffer.putUint8(_valueConsentForm);
      writeValue(buffer, value.hash);
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  dynamic readValueOfType(dynamic type, ReadBuffer buffer) {
    switch (type) {
      case _valueConsentInformation:
        final int hashCode = readValueOfType(buffer.getUint8(), buffer);
        return ConsentInformation(hashCode);
      case _valueConsentForm:
        final int hashCode = readValueOfType(buffer.getUint8(), buffer);
        return ConsentForm(hashCode);
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}