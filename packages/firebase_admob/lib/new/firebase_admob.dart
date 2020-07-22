// ignore_for_file: public_member_api_docs
// ignore_for_file: deprecated_member_use_from_same_package
// TODO(gonzchristian): Document all public members

import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import 'ad_instance_manager.dart';

/// Loads and disposes [BannerAds] and [InterstitialAds].
@visibleForTesting
final AdInstanceManager instanceManager =
    AdInstanceManager('plugins.flutter.io/firebase_admob');

/// The user's gender for the sake of ad targeting using [AdRequest].
// Warning: the index values of the enums must match the values of the corresponding
// AdMob constants. For example MobileAdGender.female.index == kGADGenderFemale.
@Deprecated('This functionality is deprecated in AdMob without replacement.')
enum MobileAdGender {
  unknown,
  male,
  female,
}

/// Targeting info per the native AdMob API.
///
/// This class's properties mirror the native AdRequest API. See for example:
/// [AdRequest.Builder for Android](https://firebase.google.com/docs/reference/android/com/google/android/gms/ads/AdRequest.Builder).
class AdRequest {
  const AdRequest(
      {this.keywords,
      this.contentUrl,
      @Deprecated('This functionality is deprecated in AdMob without replacement.')
          this.birthday,
      @Deprecated('This functionality is deprecated in AdMob without replacement.')
          this.gender,
      @Deprecated('Use `childDirected` instead.')
          this.designedForFamilies,
      this.childDirected,
      this.testDevices,
      this.nonPersonalizedAds});

  final List<String> keywords;
  final String contentUrl;
  @Deprecated('This functionality is deprecated in AdMob without replacement.')
  final DateTime birthday;
  @Deprecated('This functionality is deprecated in AdMob without replacement.')
  final MobileAdGender gender;
  @Deprecated(
      'This functionality is deprecated in AdMob.  Use `childDirected` instead.')
  final bool designedForFamilies;
  final bool childDirected;
  final List<String> testDevices;
  final bool nonPersonalizedAds;

  @override
  bool operator ==(other) {
    return this.keywords.toString() == other.keywords.toString() &&
        this.contentUrl == other.contentUrl &&
        this.birthday == other.birthday &&
        this.gender == other.gender &&
        this.designedForFamilies == other.designedForFamilies &&
        this.testDevices.toString() == other.testDevices.toString() &&
        this.nonPersonalizedAds == other.nonPersonalizedAds;
  }
}

/// The types of ad sizes supported for banners.
///
/// The names of the values are used in MethodChannel calls to iOS and Android, and should not be changed.
enum AdSizeType {
  /// Ads that are sized according to the set width and height.
  WidthAndHeight,

  /// Ads that don't use declared width and height values.
  SmartBanner,
}

/// [AdSize] represents the size of a banner ad.
///
/// There are six sizes available, which are the same for both iOS and Android.
/// See the guides for banners on [Android](https://developers.google.com/admob/android/banner#banner_sizes)
/// and [iOS](https://developers.google.com/admob/ios/banner#banner_sizes) for
/// additional details.
class AdSize {
  // Apps should use the static constants rather than
  // create their own instances of [AdSize].
  const AdSize._({
    @required this.width,
    @required this.height,
    this.adSizeType,
  })  : assert(width != null),
        assert(height != null);

  /// The vertical span of an ad.
  ///
  /// [SmartBanner] ad heights are 0 by default.
  final int height;

  /// The horizontal span of an ad.
  ///
  /// [SmartBanner] ad widths are 0 by default.
  final int width;

  /// The type of ad size for an ad.
  ///
  /// [WidthAndHeight] sets size based on height and width,
  /// whereas [SmartBanner] ignores these values.
  final AdSizeType adSizeType;

  /// The standard banner (320x50) size.
  static const AdSize banner = AdSize._(
    width: 320,
    height: 50,
    adSizeType: AdSizeType.WidthAndHeight,
  );

  /// The large banner (320x100) size.
  static const AdSize largeBanner = AdSize._(
    width: 320,
    height: 100,
    adSizeType: AdSizeType.WidthAndHeight,
  );

  /// The medium rectangle (300x250) size.
  static const AdSize mediumRectangle = AdSize._(
    width: 300,
    height: 250,
    adSizeType: AdSizeType.WidthAndHeight,
  );

  /// The full banner (468x60) size.
  static const AdSize fullBanner = AdSize._(
    width: 468,
    height: 60,
    adSizeType: AdSizeType.WidthAndHeight,
  );

  /// The leaderboard (728x90) size.
  static const AdSize leaderboard = AdSize._(
    width: 728,
    height: 90,
    adSizeType: AdSizeType.WidthAndHeight,
  );

  /// The smart banner size.
  ///
  /// Smart banners are unique in that the width and height values declared here
  /// aren't used. At runtime, the Mobile Ads SDK will automatically adjust the banner's
  /// width to match the width of the displaying device's screen. It will also set the
  /// banner's height using a calculation based on the displaying device's height.
  /// For more info see the [Android](https://developers.google.com/admob/android/banner)
  /// and [iOS](https://developers.google.com/admob/ios/banner) banner ad guides.
  static const AdSize smartBanner = AdSize._(
    width: 0,
    height: 0,
    adSizeType: AdSizeType.SmartBanner,
  );

  @override
  bool operator ==(other) {
    return width == other.width && height == other.height;
  }
}

/// TODO(cg021: Add documentation
class AdListener {
  const AdListener({
    this.onAdLoaded,
    this.onAdFailedToLoad,
    this.onNativeAdClicked,
    this.onNativeAdImpression,
    this.onAdOpened,
    this.onApplicationExit,
    this.onAdClosed,
  });

  final void Function(Ad ad) onAdLoaded;
  final void Function(Ad ad) onAdFailedToLoad;
  final void Function(Ad ad) onNativeAdClicked;
  final void Function(Ad ad) onNativeAdImpression;
  final void Function(Ad ad) onAdOpened;
  final void Function(Ad ad) onApplicationExit;
  final void Function(Ad ad) onAdClosed;
}

/// A mobile [BannerAd] or [InterstitialAd] for the [FirebaseAdMobPlugin].
///
/// A valid [adUnitId] is required.
abstract class Ad {
  /// Default constructor, used by subclasses.
  const Ad({
    @required this.adUnitId,
    @required this.listener,
    @required this.request,
  })  : assert(adUnitId != null),
        assert(listener != null),
        assert(request != null);

  /// Called when the status of the ad changes.
  final AdListener listener;

  /// TODO(cg021): Add documentation
  final AdRequest request;

  /// Identifies the source of ads for your application.
  ///
  /// For testing use a [sample ad unit](https://developers.google.com/admob/ios/test-ads#sample_ad_units).
  final String adUnitId;

  /// Free the plugin resources associated with this ad.
  Future<void> dispose();

  /// Start loading this ad.
  Future<void> load();
}

/// A mobile [Ad] for the [FirebaseAdMobPlugin] that can be loaded or disposed.
///
/// A valid [adUnitId] and [size] are required.
abstract class AdWithView extends Ad {
  /// Default constructor, used by subclasses.
  const AdWithView({
    @required String adUnitId,
    @required AdListener listener,
    @required AdRequest request,
  }) : super(
          adUnitId: adUnitId,
          listener: listener,
          request: request,
        );

  /// Free the plugin resources associated with this ad.
  Future<void> dispose();
}

/// Displays an [Ad] as a Flutter widget.
///
/// This widget takes ads inheriting from [AdWithView]
/// (e.g. [BannerAd] and [NativeAd]) and allows them to be added to the Flutter
/// widget tree.
///
/// Must call `load()` first before showing the widget. Otherwise, a
/// [PlatformException] will be thrown.
///
/// Currently only supported on iOS.
class AdWidget extends StatelessWidget {
  const AdWidget({Key key, @required this.ad})
      : assert(ad != null),
        super(key: key);

  /// Ad to be displayed as a widget.
  final AdWithView ad;

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return PlatformViewLink(
        viewType: '${instanceManager.channel.name}/ad_widget',
        surfaceFactory:
            (BuildContext context, PlatformViewController controller) {
          return AndroidViewSurface(
            controller: controller,
            gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
            hitTestBehavior: PlatformViewHitTestBehavior.opaque,
          );
        },
        onCreatePlatformView: (PlatformViewCreationParams params) {
          return PlatformViewsService.initSurfaceAndroidView(
            id: params.id,
            viewType: '${instanceManager.channel.name}/ad_widget',
            layoutDirection: TextDirection.ltr,
            creationParams: instanceManager.adIdFor(ad),
            creationParamsCodec: StandardMessageCodec(),
          )
            ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
            ..create();
        },
      );
    }
    return UiKitView(
      viewType: '${instanceManager.channel.name}/ad_widget',
      creationParams: instanceManager.adIdFor(ad),
      creationParamsCodec: StandardMessageCodec(),
    );
  }
}

/// A banner ad for the [FirebaseAdMobPlugin].
///
/// This ad can either be overlaid on top of all flutter widgets as a static
/// view or displayed as a typical Flutter widget. To use as an overlay, use
/// `show()`. To use as a widget, instantiate an [AdWidget] with this as a
/// parameter.
class BannerAd extends AdWithView {
  /// Create a BannerAd.
  ///
  /// A valid [adUnitId] is required.
  BannerAd({
    @required this.size,
    @required String adUnitId,
    @required AdListener listener,
    @required AdRequest request,
  })  : assert(size != null),
        assert(request != null),
        super(
          adUnitId: adUnitId,
          listener: listener,
          request: request,
        );

  /// [AdSize] represents the size of a banner ad.
  ///
  /// There are six sizes available, which are the same for both iOS and Android.
  /// See the guides for banners on Android](https://developers.google.com/admob/android/banner#banner_sizes)
  /// and [iOS](https://developers.google.com/admob/ios/banner#banner_sizes) for additional details.
  final AdSize size;

  /// {@template firebase_admob.testAdUnitId}
  /// A platform-specific AdMob test ad unit ID.
  ///
  /// This ad unit has been specially configured to always return test ads, and
  /// developers are encouraged to use it while building and testing their apps.
  /// {@endtemplate}
  /// {@macro firebase_admob.testAdUnitId}
  static final String testAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';

  @override
  Future<void> dispose() async {
    await instanceManager.disposeAd(this);
  }

  @override
  Future<void> load() async {
    await instanceManager.loadBannerAd(this);
  }
}

/// A NativeAd for the [FirebaseAdMobPlugin].
///
/// Native ads are ad assets that are presented to users via UI components that
/// are native to the platform. (e.g. A
/// [View](https://developer.android.com/reference/android/view/View) on Android
/// or a
/// [UIView](https://developer.apple.com/documentation/uikit/uiview?language=objc)
/// on iOS). Using Flutter widgets to create native ads is NOT supported by
/// this.
///
/// Using platform specific UI components, these ads can be formatted to match
/// the visual design of the user experience in which they live. In coding
/// terms, this means that when a native ad loads, your app receives a NativeAd
/// object that contains its assets, and the app (rather than the Google Mobile
/// Ads SDK) is then responsible for displaying them.
///
/// See the README for more details on using Native Ads.
///
/// This ad can either be overlaid on top of all flutter widgets as a static
/// view or displayed as a typical Flutter widget. To use as an overlay, use
/// `show()`. To use as a widget, instantiate an [AdWidget] with this as a
/// parameter.
class NativeAd extends AdWithView {
  /// Create a NativeAd.
  ///
  /// A valid [adUnitId] is required.
  NativeAd({
    @required String adUnitId,
    @required this.factoryId,
    this.customOptions,
    @required AdListener listener,
    @required AdRequest request,
  })  : assert(factoryId != null),
        super(
          adUnitId: adUnitId,
          listener: listener,
          request: request,
        );

  final String factoryId;

  Map<String, Object> customOptions;

  /// {@template firebase_admob.testAdUnitId}
  /// A platform-specific AdMob test ad unit ID.
  ///
  /// This ad unit has been specially configured to always return test ads, and
  /// developers are encouraged to use it while building and testing their apps.
  /// {@endtemplate}
  /// {@macro firebase_admob.testAdUnitId}
  static final String testAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';

  @override
  Future<void> dispose() async {
    await instanceManager.disposeAd(this);
  }

  @override
  Future<void> load() async {
    await instanceManager.loadNativeAd(this);
  }
}

/// A full-screen interstitial ad for the [FirebaseAdMobPlugin].
class InterstitialAd extends Ad {
  /// Create an Interstitial.
  ///
  /// A valid [adUnitId] is required.
  InterstitialAd({
    @required String adUnitId,
    AdRequest adRequest,
    AdListener listener,
    @required AdRequest request,
  }) : super(adUnitId: adUnitId, listener: listener, request: request);

  /// {@macro firebase_admob.testAdUnitId}
  static final String testAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/1033173712'
      : 'ca-app-pub-3940256099942544/4411468910';

  @override
  Future<void> dispose() async {
    await instanceManager.disposeAd(this);
  }

  @override
  Future<void> load() async {
    await instanceManager.loadInterstitialAd(this);
  }
}

/// An AdMob rewarded video ad.
///
/// Only one rewarded video ad can be loaded at a time. Because the video assets
/// are so large, it's a good idea to start loading an ad well in advance of
/// when it's likely to be needed.
class RewardedAd extends Ad {
  /// Create a RewardedAd.
  ///
  /// A valid [adUnitId] is required.
  RewardedAd({
    @required String adUnitId,
    @required AdListener listener,
    @required AdRequest request,
  }) : super(
          adUnitId: adUnitId,
          listener: listener,
          request: request,
        );

  /// {@template firebase_admob.testAdUnitId}
  /// A platform-specific AdMob test ad unit ID.
  ///
  /// This ad unit has been specially configured to always return test ads, and
  /// developers are encouraged to use it while building and testing their apps.
  /// {@endtemplate}
  /// {@macro firebase_admob.testAdUnitId}
  static final String testAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';

  /// Disposes a rewarded video ad with the provided ad unit ID.
  @override
  Future<void> dispose() async {
    await instanceManager.disposeAd(this);
  }

  /// Loads a rewarded video ad using the provided ad unit ID.
  @override
  Future<void> load() async {
    await instanceManager.loadRewardedAd(this);
  }
}

class AdMessageCodec extends StandardMessageCodec {
  const AdMessageCodec();

  static const int _valueAdSize = 128;
  static const int _valueAdRequest = 129;
  static const int _valueDateTime = 130;
  static const int _valueMobileAdGender = 131;

  @override
  void writeValue(WriteBuffer buffer, dynamic value) {
    if (value is AdSize) {
      buffer.putUint8(_valueAdSize);
      writeValue(buffer, value.width);
      writeValue(buffer, value.height);
    } else if (value is AdRequest) {
      buffer.putUint8(_valueAdRequest);
      writeValue(buffer, value.keywords);
      writeValue(buffer, value.contentUrl);
      writeValue(buffer, value.birthday);
      writeValue(buffer, value.gender);
      writeValue(buffer, value.designedForFamilies);
      writeValue(buffer, value.childDirected);
      writeValue(buffer, value.testDevices);
      writeValue(buffer, value.nonPersonalizedAds);
    } else if (value is DateTime) {
      buffer.putUint8(_valueDateTime);
      writeValue(buffer, value.millisecondsSinceEpoch);
    } else if (value is MobileAdGender) {
      buffer.putUint8(_valueMobileAdGender);
      writeValue(buffer, value.index);
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  dynamic readValueOfType(dynamic type, ReadBuffer buffer) {
    switch (type) {
      case _valueAdSize:
        return AdSize._(
          width: readValueOfType(buffer.getUint8(), buffer),
          height: readValueOfType(buffer.getUint8(), buffer),
        );
      case _valueAdRequest:
        return AdRequest(
          keywords: readValueOfType(buffer.getUint8(), buffer)?.cast<String>(),
          contentUrl: readValueOfType(buffer.getUint8(), buffer),
          birthday: readValueOfType(buffer.getUint8(), buffer),
          gender: readValueOfType(buffer.getUint8(), buffer),
          designedForFamilies: readValueOfType(buffer.getUint8(), buffer),
          childDirected: readValueOfType(buffer.getUint8(), buffer),
          testDevices:
              readValueOfType(buffer.getUint8(), buffer)?.cast<String>(),
          nonPersonalizedAds: readValueOfType(buffer.getUint8(), buffer),
        );
      case _valueDateTime:
        return DateTime.fromMillisecondsSinceEpoch(
            readValueOfType(buffer.getUint8(), buffer));
      case _valueMobileAdGender:
        int gender = readValueOfType(buffer.getUint8(), buffer);
        switch (gender) {
          case 1:
            return MobileAdGender.male;
          case 2:
            return MobileAdGender.female;
        }
        return MobileAdGender.unknown;
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}
