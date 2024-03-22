import 'package:google_mobile_ads/google_mobile_ads.dart';

class AppLovinMediationExtras implements MediationExtras {
  const AppLovinMediationExtras({required this.isMuted});

  final bool isMuted;

  @override
  String getAndroidClassName() {
    return "io.flutter.plugins.googlemobileads.mediation.gma_mediation_applovin.AppLovinFlutterMediationExtras";
  }

  @override
  String getIOSClassName() {
    return "AppLovinFlutterMediationExtras";
  }

  @override
  Map<String, dynamic> getExtras() {
    return <String, dynamic>{
      "isMuted": isMuted,
    };
  }
}
