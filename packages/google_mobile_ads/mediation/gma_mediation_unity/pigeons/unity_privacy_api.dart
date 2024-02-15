import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/unity_privacy_api.g.dart',
  dartOptions: DartOptions(),
  kotlinOut:
  'android/src/main/kotlin/io/flutter/plugins/googlemobileads/mediation/gma_mediation_unity/UnityPrivacyApi.g.kt',
  kotlinOptions: KotlinOptions(package: "io.flutter.plugins.googlemobileads.mediation.gma_mediation_unity"),
  swiftOut: 'ios/Classes/UnityPrivacyApi.g.swift',
  swiftOptions: SwiftOptions(),
  dartPackageName: 'gma_mediation_unity',
))

@HostApi()
abstract class UnityPrivacyApi {
  void setGDPRConsent(bool gdprConsent);

  void setCCPAConsent(bool ccpaConsent);
}