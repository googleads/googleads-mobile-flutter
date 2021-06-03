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

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:reference/reference.dart';

import 'ad_containers.g.dart';

/// Register channels for ad container classes.
class ChannelRegistrar extends $ChannelRegistrar {
  /// Default constructor for [ChannelRegistrar].
  ChannelRegistrar(LibraryImplementations implementations)
      : super(implementations);

  final Set<AdWithView> _mountedAds = <AdWithView>{};

  /// Default [ChannelRegistrar] instance.
  ///
  /// Replace this for custom usability.
  static ChannelRegistrar instance =
      ChannelRegistrar(LibraryImplementations(MethodChannelMessenger.instance))
        ..registerHandlers();

  /// Returns true if the [adId] is already mounted in a [WidgetAd].
  bool isAdMounted(AdWithView ad) => _mountedAds.contains(ad);

  /// Indicates that [adId] is mounted in widget tree.
  void mountAd(AdWithView ad) => _mountedAds.add(ad);

  /// Indicates that [adId] is unmounted from the widget tree.
  void unmountAd(AdWithView ad) => _mountedAds.remove(ad);
}

/// Type channel implementations for ad container classes.
///
/// Most implementations are generated.
class LibraryImplementations extends $LibraryImplementations {
  /// Default constructor for [LibraryImplementations].
  LibraryImplementations(TypeChannelMessenger messenger) : super(messenger);

  @override
  AdErrorHandler get handlerAdError => AdErrorHandler();

  @override
  ResponseInfoHandler get handlerResponseInfo => ResponseInfoHandler();

  @override
  AdapterResponseInfoHandler get handlerAdapterResponseInfo =>
      AdapterResponseInfoHandler();

  @override
  LoadAdErrorHandler get handlerLoadAdError => LoadAdErrorHandler();

  @override
  $AdSizeHandler get handlerAdSize => AdSizeHandler();

  @override
  InterstitialAdHandler get handlerInterstitialAd => InterstitialAdHandler();

  @override
  $AdManagerInterstitialAdHandler get handlerAdManagerInterstitialAd =>
      AdManagerInterstitialAdHandler();

  @override
  RewardedAdHandler get handlerRewardedAd => RewardedAdHandler();

  @override
  RewardItemHandler get handlerRewardItem => RewardItemHandler();

  @override
  ServerSideVerificationOptionsHandler
      get handlerServerSideVerificationOptions =>
          ServerSideVerificationOptionsHandler();
}

class AdErrorHandler extends $AdErrorHandler {
  @override
  AdError $$create(
    TypeChannelMessenger messenger,
    int code,
    String domain,
    String message,
  ) {
    return AdError(code, domain, message);
  }
}

class ResponseInfoHandler extends $ResponseInfoHandler {
  @override
  ResponseInfo $$create(
    TypeChannelMessenger messenger,
    String? responseId,
    String? mediationAdapterClassName,
    List<$AdapterResponseInfo>? adapterResponses,
  ) {
    return ResponseInfo(
      responseId: responseId,
      mediationAdapterClassName: mediationAdapterClassName,
      adapterResponses: adapterResponses?.cast<AdapterResponseInfo>(),
    );
  }
}

class AdapterResponseInfoHandler extends $AdapterResponseInfoHandler {
  @override
  AdapterResponseInfo $$create(
      TypeChannelMessenger messenger,
      String adapterClassName,
      int latencyMillis,
      String description,
      String credentials,
      covariant AdError? adError) {
    return AdapterResponseInfo(
      adapterClassName: adapterClassName,
      latencyMillis: latencyMillis,
      description: description,
      credentials: credentials,
      adError: adError,
    );
  }
}

class LoadAdErrorHandler extends $LoadAdErrorHandler {
  @override
  LoadAdError $$create(
    TypeChannelMessenger messenger,
    int code,
    String domain,
    String message,
    covariant ResponseInfo? responseInfo,
  ) {
    return LoadAdError(
      code,
      domain,
      message,
      responseInfo,
    );
  }
}

class AdSizeHandler extends $AdSizeHandler {
  @override
  AdSize $$create(
    TypeChannelMessenger messenger,
    int width,
    int height,
    String? constant,
  ) {
    return AdSize(width: width, height: height, constant: constant);
  }
}

class InterstitialAdHandler extends $InterstitialAdHandler {
  @override
  InterstitialAd $$create(TypeChannelMessenger messenger) {
    return InterstitialAd();
  }
}

class AdManagerInterstitialAdHandler extends $AdManagerInterstitialAdHandler {
  @override
  $AdManagerInterstitialAd $$create(TypeChannelMessenger messenger) {
    return AdManagerInterstitialAd();
  }
}

class RewardedAdHandler extends $RewardedAdHandler {
  @override
  RewardedAd $$create(TypeChannelMessenger messenger) {
    return RewardedAd();
  }
}

class RewardItemHandler extends $RewardItemHandler {
  @override
  RewardItem $$create(TypeChannelMessenger messenger, num amount, String type) {
    return RewardItem(amount, type);
  }
}

class ServerSideVerificationOptionsHandler
    extends $ServerSideVerificationOptionsHandler {
  @override
  ServerSideVerificationOptions $$create(
      TypeChannelMessenger messenger, String? userId, String? customData) {
    return ServerSideVerificationOptions(
      userId: userId,
      customData: customData,
    );
  }
}
