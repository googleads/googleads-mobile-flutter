import 'package:google_mobile_ads/google_mobile_ads.dart';

class LiftoffMediationExtras implements MediationExtras {
  LiftoffMediationExtras({this.userId, this.orientation, this.nativeAdPosition, this.isInterstitial});

  String? userId;
  int? orientation;
  int? nativeAdPosition;
  bool? isInterstitial;

  @override
  String getAndroidClassName() {
    return 'io.flutter.plugins.googlemobileads.mediation.gma_mediation_liftoffmonetize.LiftoffFlutterMediationExtras';
  }

  @override
  String getIOSClassName() {
    return 'LiftoffFlutterMediationExtras';
  }

  @override
  Map<String, dynamic> getExtras() {
    return <String, dynamic> {
      'userId': userId,
    };
  }
}
