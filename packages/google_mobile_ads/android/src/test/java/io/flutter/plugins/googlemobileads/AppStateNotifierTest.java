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

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.spy;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.Result;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.robolectric.RobolectricTestRunner;

/** Tests for {@link AppStateNotifier}. */
@RunWith(RobolectricTestRunner.class)
public class AppStateNotifierTest {

  private AppStateNotifier appStateNotifier;
  private BinaryMessenger mockBinaryMessenger;

  @Before
  public void setup() {
    mockBinaryMessenger = mock(BinaryMessenger.class);
    appStateNotifier = spy(new AppStateNotifier(mockBinaryMessenger));
  }

  @Test
  public void onMethodCall_start() {
    MethodCall call = new MethodCall("start", null);
    Result mockResult = mock(Result.class);

    appStateNotifier.onMethodCall(call, mockResult);

    verify(appStateNotifier).start();
    verify(mockResult).success(null);
  }

  @Test
  public void onMethodCall_stop() {
    MethodCall call = new MethodCall("stop", null);
    Result mockResult = mock(Result.class);

    appStateNotifier.onMethodCall(call, mockResult);

    verify(appStateNotifier).stop();
    verify(mockResult).success(null);
  }

  @Test
  public void onMethodCall_unknownMethod() {
    MethodCall call = new MethodCall("unknown", null);
    Result mockResult = mock(Result.class);

    appStateNotifier.onMethodCall(call, mockResult);

    verify(mockResult).notImplemented();
  }
}
