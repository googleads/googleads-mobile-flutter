// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.firebaseadmob;

import androidx.annotation.NonNull;
import com.google.android.gms.ads.initialization.AdapterStatus;
import com.google.android.gms.ads.initialization.InitializationStatus;
import java.util.HashMap;
import java.util.Map;

/**
 * Wrapper around {@link com.google.android.gms.ads.initialization.InitializationStatus} for the
 * Flutter Firebase AdMob Plugin.
 */
class FlutterInitializationStatus {
  @NonNull final Map<String, FlutterAdapterStatus> adapterStatuses;

  FlutterInitializationStatus(@NonNull Map<String, FlutterAdapterStatus> adapterStatuses) {
    this.adapterStatuses = adapterStatuses;
  }

  FlutterInitializationStatus(@NonNull InitializationStatus initializationStatus) {
    final HashMap<String, FlutterAdapterStatus> newStatusMap = new HashMap<>();
    final Map<String, AdapterStatus> adapterStatusMap = initializationStatus.getAdapterStatusMap();

    for (Map.Entry<String, AdapterStatus> status : adapterStatusMap.entrySet()) {
      newStatusMap.put(status.getKey(), new FlutterAdapterStatus(status.getValue()));
    }

    this.adapterStatuses = newStatusMap;
  }
}
