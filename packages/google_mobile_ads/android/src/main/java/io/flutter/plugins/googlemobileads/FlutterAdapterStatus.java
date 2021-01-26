// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.googlemobileads;

import androidx.annotation.NonNull;
import com.google.android.gms.ads.initialization.AdapterStatus;

/**
 * Wrapper around {@link com.google.android.gms.ads.initialization.AdapterStatus} for the Flutter
 * Google Mobile Ads Plugin.
 */
class FlutterAdapterStatus {
  @NonNull final AdapterInitializationState state;
  @NonNull final String description;
  @NonNull final Number latency;

  /**
   * Represents {@link com.google.android.gms.ads.initialization.AdapterStatus.State} for the
   * Flutter Google Mobile Ads Plugin.
   */
  enum AdapterInitializationState {
    NOT_READY,
    READY
  }

  FlutterAdapterStatus(
      @NonNull AdapterInitializationState state,
      @NonNull String description,
      @NonNull Number latency) {
    this.state = state;
    this.description = description;
    this.latency = latency;
  }

  FlutterAdapterStatus(@NonNull AdapterStatus status) {
    switch (status.getInitializationState()) {
      case NOT_READY:
        this.state = AdapterInitializationState.NOT_READY;
        break;
      case READY:
        this.state = AdapterInitializationState.READY;
        break;
      default:
        final String message =
            String.format("Unable to handle state: %s", status.getInitializationState());
        throw new IllegalArgumentException(message);
    }

    this.description = status.getDescription();
    this.latency = status.getLatency();
  }

  @Override
  public boolean equals(Object o) {
    if (this == o) {
      return true;
    } else if (!(o instanceof FlutterAdapterStatus)) {
      return false;
    }

    final FlutterAdapterStatus that = (FlutterAdapterStatus) o;
    if (state != that.state) {
      return false;
    } else if (!description.equals(that.description)) {
      return false;
    }
    return latency.equals(that.latency);
  }

  @Override
  public int hashCode() {
    int result = state.hashCode();
    result = 31 * result + description.hashCode();
    result = 31 * result + latency.hashCode();
    return result;
  }
}
