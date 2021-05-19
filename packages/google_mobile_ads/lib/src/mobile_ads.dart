// Copyright 2021 Google LLC
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

import 'ad_instance_manager.dart';
import 'request_configuration.dart';
import 'package:flutter/foundation.dart';

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

  static final MobileAds _instance = MobileAds._().._init();

  /// Shared instance to initialize the AdMob SDK.
  static MobileAds get instance => _instance;

  /// Initializes the Google Mobile Ads SDK.
  ///
  /// Call this method as early as possible after the app launches to reduce
  /// latency on the session's first ad request.
  ///
  /// If this method is not called, the first ad request automatically
  /// initializes the Google Mobile Ads SDK.
  Future<InitializationStatus> initialize() async {
    return (await instanceManager.channel.invokeMethod<InitializationStatus>(
      'MobileAds#initialize',
    ))!;
  }

  /// Update the [RequestConfiguration] to apply for future ad requests.
  Future<void> updateRequestConfiguration(
      RequestConfiguration requestConfiguration) {
    return instanceManager.updateRequestConfiguration(requestConfiguration);
  }

  /// Set whether the Google Mobile Ads SDK Same App Key is enabled (iOS only).
  ///
  /// The value set persists across app sessions. The key is enabled by default.
  /// This is a no-op on Android.
  /// More documentation on same app key is available at
  /// https://developers.google.com/admob/ios/global-settings#same_app_key.
  Future<void> setSameAppKeyEnabled(bool isEnabled) {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return instanceManager.setSameAppKeyEnabled(isEnabled);
    } else {
      return Future.value();
    }
  }

  /// Internal init to cleanup state for hot restart.
  /// This is a workaround for https://github.com/flutter/flutter/issues/7160.
  void _init() {
    instanceManager.channel.invokeMethod('_init');
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
  /// Default constructor to create an [AdapterStatus].
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
