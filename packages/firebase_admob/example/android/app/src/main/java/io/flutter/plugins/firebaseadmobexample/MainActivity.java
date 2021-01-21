// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.firebaseadmobexample;

import dev.flutter.plugins.e2e.E2EPlugin;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.firebaseadmob.FirebaseAdMobPlugin;
import io.flutter.plugins.firebaseadmob.FirebaseAdMobPlugin.NativeAdFactory;

public class MainActivity extends FlutterActivity {
  @Override
  public void configureFlutterEngine(FlutterEngine flutterEngine) {
    super.configureFlutterEngine(flutterEngine);
    final NativeAdFactory factory = new NativeAdFactoryExample(getLayoutInflater());
    FirebaseAdMobPlugin.registerNativeAdFactory(flutterEngine, "adFactoryExample", factory);
  }

  @Override
  public void cleanUpFlutterEngine(FlutterEngine flutterEngine) {
    FirebaseAdMobPlugin.unregisterNativeAdFactory(flutterEngine, "adFactoryExample");
  }
}
