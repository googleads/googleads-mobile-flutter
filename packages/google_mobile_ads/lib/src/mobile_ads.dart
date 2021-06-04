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

import 'package:flutter/foundation.dart';
import 'package:reference/annotations.dart';

import 'mobile_ads.g.dart';
import 'mobile_ads_channels.dart';

/// The initialization state of the mediation adapter.
@Reference('google_mobile_ads.AdapterInitializationState')
class AdapterInitializationState implements $AdapterInitializationState {
  /// Construct an [AdapterInitializationState].
  ///
  /// This should only be used by the API or for testing.
  @visibleForTesting
  const AdapterInitializationState(String value) : _value = value;

  final String _value;

  /// The mediation adapter is less likely to fill ad requests.
  static const AdapterInitializationState notReady = AdapterInitializationState(
    'notReady',
  );

  /// The mediation adapter is ready to service ad requests.
  static const AdapterInitializationState ready = AdapterInitializationState(
    'ready',
  );

  @ReferenceMethod(ignore: true)
  @override
  bool operator ==(other) {
    return other is AdapterInitializationState && other._value == _value;
  }
}

/// Class contains logic that applies to the Google Mobile Ads SDK as a whole.
///
/// Right now, the only methods in it are used for initialization.
///
/// See [instance].
@Reference('google_mobile_ads.MobileAds')
class MobileAds implements $MobileAds {
  @protected
  MobileAds._() {
    _channel.$$create(this, $owner: true);
  }

  static final MobileAds _instance = MobileAds._();

  /// Shared instance to initialize the AdMob SDK.
  static MobileAds get instance => _instance;

  static $MobileAdsChannel get _channel =>
      ChannelRegistrar.instance.implementations.channelMobileAds;

  /// Initializes the Google Mobile Ads SDK.
  ///
  /// Call this method as early as possible after the app launches to reduce
  /// latency on the session's first ad request.
  ///
  /// If this method is not called, the first ad request automatically
  /// initializes the Google Mobile Ads SDK.
  Future<InitializationStatus> initialize() async {
    return await _channel.$initialize(this) as InitializationStatus;
  }

  /// Update the [RequestConfiguration] to apply for future ad requests.
  Future<void> updateRequestConfiguration(
    RequestConfiguration requestConfiguration,
  ) {
    return _channel.$updateRequestConfiguration(this, requestConfiguration);
  }

  /// Set whether the Google Mobile Ads SDK Same App Key is enabled (iOS only).
  ///
  /// The value set persists across app sessions. The key is enabled by default.
  /// This is a no-op on Android.
  /// More documentation on same app key is available at
  /// https://developers.google.com/admob/ios/global-settings#same_app_key.
  Future<void> setSameAppKeyEnabled(bool isEnabled) {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return _channel.$setSameAppKeyEnabled(this, isEnabled);
    } else {
      return Future.value();
    }
  }
}

/// The status of the SDK initialization.
@Reference('google_mobile_ads.InitializationStatus')
class InitializationStatus implements $InitializationStatus {
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
@Reference('google_mobile_ads.AdapterStatus')
class AdapterStatus implements $AdapterStatus {
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

/// Contains targeting information that can be applied to all ad requests.
///
/// See relevant documentation at
/// https://developers.google.com/ad-manager/mobile-ads-sdk/android/targeting#requestconfiguration.
@Reference('google_mobile_ads.RequestConfiguration')
class RequestConfiguration implements $RequestConfiguration {
  /// Creates a [RequestConfiguration].
  RequestConfiguration({
    this.maxAdContentRating,
    this.tagForChildDirectedTreatment,
    this.tagForUnderAgeOfConsent,
    this.testDeviceIds,
  }) {
    _channel.$$create(
      this,
      $owner: true,
      maxAdContentRating: maxAdContentRating,
      tagForChildDirectedTreatment: tagForChildDirectedTreatment,
      tagForUnderAgeOfConsent: tagForUnderAgeOfConsent,
      testDeviceIds: testDeviceIds,
    );
  }

  static $RequestConfigurationChannel get _channel =>
      ChannelRegistrar.instance.implementations.channelRequestConfiguration;

  /// Maximum content rating that will be shown.
  final String? maxAdContentRating;

  /// Whether to tag as child directed.
  final int? tagForChildDirectedTreatment;

  /// Whether to tag as under age of consent.
  final int? tagForUnderAgeOfConsent;

  /// List of test device ids to set.
  final List<String>? testDeviceIds;
}

/// Values for [RequestConfiguration.maxAdContentRating].
class MaxAdContentRating {
  /// No specified content rating.
  static final String unspecified = '';

  /// Content suitable for general audiences, including families.
  static final String g = 'G';

  /// Content suitable for most audiences with parental guidance.
  static final String pg = 'PG';

  /// Content suitable for most audiences with parental guidance.
  static final String t = 'T';

  /// Content suitable only for mature audiences.
  static final String ma = 'MA';
}

/// Values for [RequestConfiguration.tagForUnderAgeOfConsent].
class TagForUnderAgeOfConsent {
  /// Tag as under age of consent.
  ///
  /// Indicates the publisher specified that the ad request should receive
  /// treatment for users in the European Economic Area (EEA) under the age
  /// of consent.
  static final int yes = 1;

  /// Tag as NOT under age of consent.
  ///
  /// Indicates the publisher specified that the ad request should not receive
  /// treatment for users in the European Economic Area (EEA) under the age of
  /// consent.
  static final int no = 0;

  /// Do not specify tag for under age of consent.
  ///
  /// Indicates that the publisher has not specified whether the ad request
  /// should receive treatment for users in the European Economic Area (EEA)
  /// under the age of consent.
  static final int unspecified = -1;
}

/// Values for [RequestConfiguration.tagForChildDirectedTreatment].
class TagForChildDirectedTreatment {
  /// Tag for child directed treatment.
  ///
  /// Indicates the publisher specified that the ad request should receive
  /// treatment for users in the European Economic Area (EEA) under the age
  /// of consent.
  static final int yes = 1;

  /// Tag for NOT child directed treatment.
  ///
  /// Indicates the publisher specified that the ad request should not receive
  /// treatment for users in the European Economic Area (EEA) under the age
  /// of consent.
  static final int no = 0;

  /// Do not specify tag for child directed treatment.
  ///
  /// Indicates that the publisher has not specified whether the ad request
  /// should receive treatment for users in the European Economic Area (EEA)
  /// under the age of consent.
  static final int unspecified = -1;
}
