import 'package:google_mobile_ads/google_mobile_ads.dart';

class DTExchangeMediationExtras implements MediationExtras {
  DTExchangeMediationExtras({
    this.muteVideo,
    this.age,
    this.gender,
    this.zipCode,
  });

  bool? muteVideo;
  int? age;
  int? gender;
  String? zipCode;

  @override
  String getAndroidClassName() {
    return "io.flutter.plugins.googlemobileads.mediation.gma_mediation_dtexchange.DTExchangeFlutterMediationExtras";
  }

  @override
  String getIOSClassName() {
    return "DTExchangeFlutterMediationExtras";
  }

  @override
  Map<String, dynamic> getExtras() {
    return <String, dynamic>{
      "muteVideo": muteVideo,
      "age": age,
      "gender": gender,
      "zipCode": zipCode,
    };
  }
}
