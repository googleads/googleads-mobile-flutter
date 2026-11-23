// Copyright 2026 Google LLC
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

package io.flutter.plugins.googlemobileads;

import static org.junit.Assert.assertEquals;

import com.google.android.libraries.ads.mobile.sdk.initialization.InitializationConfig;
import java.lang.reflect.Field;
import java.lang.reflect.Modifier;
import java.util.ArrayList;
import java.util.List;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.robolectric.RobolectricTestRunner;

@RunWith(RobolectricTestRunner.class)
public class FlutterMobileAdsWrapperTest {

  @Test
  public void setPlugin_setsVersionedRequestAgent() throws Exception {
    InitializationConfig.Builder builder = new InitializationConfig.Builder("test-app-id");
    FlutterMobileAdsWrapper.setPlugin(builder);
    InitializationConfig config = builder.build();

    List<String> nonAppIdStrings = new ArrayList<>();
    for (Field field : InitializationConfig.class.getDeclaredFields()) {
      if (Modifier.isStatic(field.getModifiers()) || field.getType() != String.class) {
        continue;
      }
      field.setAccessible(true);
      String value = (String) field.get(config);
      if (!"test-app-id".equals(value)) {
        nonAppIdStrings.add(value);
      }
    }
    assertEquals(1, nonAppIdStrings.size());
    assertEquals(Constants.REQUEST_AGENT_PREFIX_VERSIONED, nonAppIdStrings.get(0));
  }
}
