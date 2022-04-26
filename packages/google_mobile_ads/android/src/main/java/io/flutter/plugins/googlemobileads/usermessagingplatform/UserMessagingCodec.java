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

package io.flutter.plugins.googlemobileads.usermessagingplatform;

import android.content.Context;
import androidx.annotation.NonNull;
import com.google.android.ump.ConsentDebugSettings;
import com.google.android.ump.ConsentForm;
import com.google.android.ump.ConsentInformation;
import com.google.android.ump.ConsentRequestParameters;
import io.flutter.plugin.common.StandardMessageCodec;
import java.io.ByteArrayOutputStream;
import java.nio.ByteBuffer;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class UserMessagingCodec extends StandardMessageCodec {

  private static final byte VALUE_CONSENT_INFORMATION = (byte) 128;
  private static final byte VALUE_CONSENT_REQUEST_PARAMETERS = (byte) 129;
  private static final byte VALUE_CONSENT_DEBUG_SETTINGS = (byte) 130;
  private static final byte VALUE_CONSENT_FORM = (byte) 131;

  private final Context context;

  private final Map<Integer, ConsentForm> consentFormMap;
  private final Map<Integer, ConsentInformation> consentInformationMap;

  UserMessagingCodec(@NonNull Context context) {
    this.context = context;
    consentFormMap = new HashMap<>();
    consentInformationMap = new HashMap<>();
  }

  @Override
  protected void writeValue(ByteArrayOutputStream stream, Object value) {
    if (value instanceof ConsentInformation) {
      stream.write(VALUE_CONSENT_INFORMATION);
      consentInformationMap.put(value.hashCode(), (ConsentInformation) value);
      writeValue(stream, value.hashCode());
    } else if (value instanceof ConsentForm) {
      stream.write(VALUE_CONSENT_FORM);
      consentFormMap.put(value.hashCode(), (ConsentForm) value);
      writeValue(stream, value.hashCode());
    } else {
      super.writeValue(stream, value);
    }
  }

  @Override
  protected Object readValueOfType(byte type, ByteBuffer buffer) {
    switch (type) {
      case VALUE_CONSENT_INFORMATION:
        {
          Integer hash = (Integer) readValueOfType(buffer.get(), buffer);
          return consentInformationMap.get(hash);
        }
      case VALUE_CONSENT_REQUEST_PARAMETERS:
        {
          Boolean tfuac = (Boolean) readValueOfType(buffer.get(), buffer);
          ConsentDebugSettings debugSettings =
              (ConsentDebugSettings) readValueOfType(buffer.get(), buffer);
          ConsentRequestParameters.Builder builder = new ConsentRequestParameters.Builder();

          if (tfuac != null) {
            builder.setTagForUnderAgeOfConsent(tfuac);
          }
          if (debugSettings != null) {
            builder.setConsentDebugSettings(debugSettings);
          }
          return builder.build();
        }
      case VALUE_CONSENT_DEBUG_SETTINGS:
        {
          Integer settings = (Integer) readValueOfType(buffer.get(), buffer);
          List<String> testIdentifiers = (List<String>) readValueOfType(buffer.get(), buffer);
          ConsentDebugSettings.Builder builder = new ConsentDebugSettings.Builder(context);
          if (settings != null) {
            builder.setDebugGeography(settings);
          }
          if (testIdentifiers != null) {
            for (String testIdentifier : testIdentifiers) {
              builder.addTestDeviceHashedId(testIdentifier);
            }
          }
          return builder.build();
        }
      case VALUE_CONSENT_FORM:
        {
          Integer hash = (Integer) readValueOfType(buffer.get(), buffer);
          return consentFormMap.get(hash);
        }
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}
