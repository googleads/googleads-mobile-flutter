import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/mediation_extras_handler.g.dart',
  dartOptions: DartOptions(),
  kotlinOut:
  'android/src/main/java/io/flutter/plugins/googlemobileads/FlutterMediationExtrasHandler.g.kt',
  kotlinOptions: KotlinOptions(package: 'io.flutter.plugins.googlemobileads'),
  objcHeaderOut: 'ios/Classes/FLTMediationExtrasHandler.g.h',
  objcSourceOut: 'ios/Classes/FLTMediationExtrasHandler.g.m',
  objcOptions: ObjcOptions(),
  dartPackageName: 'google_mobile_ads',
))

@HostApi()
abstract class FlutterMediationExtrasHandler {
  Object generateExtras(Map<String?, Object?>? extras);
}