// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'firebase_admob.dart';

/// The initialization state of the mediation adapter.
enum AdapterInitializationState {
  /// The mediation adapter is less likely to fill ad requests.
  notReady,

  /// The mediation adapter is ready to service ad requests.
  ready,
}

/// Class contains logic that applies to the Google Mobile Ads SDK as a whole.
///
/// Right now, the only methods in it are used for initialization.
///
/// See [instance].
class MobileAds {
  MobileAds._();

  static final MobileAds _instance = MobileAds._();

  /// Shared instance to initialize the AdMob SDK.
  static MobileAds get instance => _instance;

  /// Initializes the Google Mobile Ads SDK.
  ///
  /// Call this method as early as possible after the app launches to reduce
  /// latency on the session's first ad request.
  ///
  /// If this method is not called, the first ad request automatically
  /// initializes the Google Mobile Ads SDK.
  Future<InitializationStatus> initialize() {
    return instanceManager.channel.invokeMethod<InitializationStatus>(
      'MobileAds#initialize',
    );
  }
}

/// The status of the SDK initialization.
class InitializationStatus {
  /// Default constructor to create an [InitializationStatus].
  ///
  /// Returned when calling [MobileAds.initialize];
  InitializationStatus(Map<String, AdapterStatus> adapterStatuses)
      : adapterStatuses = Map<String, AdapterStatus>.unmodifiable(
          adapterStatuses,
        );

  /// Initialization status of each known ad network, keyed by its adapter's class name.
  final Map<String, AdapterStatus> adapterStatuses;
}

/// An immutable snapshot of a mediation adapter's initialization status.
class AdapterStatus {
  /// Default constructor to create an [InitializationStatus].
  ///
  /// Returned when calling [MobileAds.initialize].
  AdapterStatus(this.state, this.description, this.latency);

  /// The adapter's initialization state.
  final AdapterInitializationState state;

  /// Detailed description of the status.
  final String description;

  /// The adapter's initialization latency in seconds.
  ///
  /// 0 if initialization has not yet ended.
  final double latency;
}
