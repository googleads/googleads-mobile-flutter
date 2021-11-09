import 'package:flutter/services.dart';

/// A wrapper around a [MethodChannel] for 3p mediation sdks.
///
/// You may need a method channel to call APIs in 3P SDKs used for mediation.
class MyMethodChannel {
  final MethodChannel _methodChannel =
      MethodChannel('com.example.mediationexample/mediation-channel');

  /// Sets whether the user is age restricted in AppLovin.
  Future<void> setAppLovinIsAgeRestrictedUser(bool isAgeRestricted) async {
    return _methodChannel.invokeMethod(
      'setIsAgeRestrictedUser',
      {
        'isAgeRestricted': isAgeRestricted,
      },
    );
  }

  /// Sets whether we have user consent for the user in AppLovin.
  Future<void> setHasUserConsent(bool hasUserConsent) async {
    return _methodChannel.invokeMethod(
      'setHasUserConsent',
      {
        'hasUserConsent': hasUserConsent,
      },
    );
  }
}
