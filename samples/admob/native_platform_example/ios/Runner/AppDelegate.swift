import UIKit
import Flutter

@objc class NativeAdFactoryExample: NSObject, FLTNativeAdFactory {
  func createNativeAd(_ nativeAd: GADNativeAd, customOptions: [AnyHashable : Any]? = nil) -> GADNativeAdView? {

    // Create and place ad in view hierarchy.
    let nativeAdView = Bundle.main.loadNibNamed(
            "NativeAdView",
            owner: nil,
            options: nil)?.first as! GADNativeAdView

    // Associate the native ad view with the native ad object. This is
    // required to make the ad clickable.
    nativeAdView.nativeAd = nativeAd;

    (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline

    nativeAdView.mediaView?.mediaContent = nativeAd.mediaContent

    (nativeAdView.bodyView as? UILabel)?.text = nativeAd.body

    (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image

    (nativeAdView.starRatingView as? UIImageView)?.image = imageOfStars(from: nativeAd.starRating)

    (nativeAdView.storeView as? UILabel)?.text = nativeAd.store

    (nativeAdView.priceView as? UILabel)?.text = nativeAd.price

    (nativeAdView.advertiserView as? UILabel)?.text = nativeAd.advertiser

    (nativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)

    // In order for the SDK to process touch events properly, user interaction should be disabled.
    nativeAdView.callToActionView?.isUserInteractionEnabled = false

    // Associate the native ad view with the native ad object. This is required to make the ad clickable.
    // Note: this should always be done after populating the ad views.
    nativeAdView.nativeAd = nativeAd

    return nativeAdView
  }

  private func imageOfStars(from starRating: NSDecimalNumber?) -> UIImage? {
    guard let rating = starRating?.doubleValue else {
      return nil
    }
    if rating >= 5 {
      return UIImage(named: "stars_5")
    } else if rating >= 4.5 {
      return UIImage(named: "stars_4_5")
    } else if rating >= 4 {
      return UIImage(named: "stars_4")
    } else if rating >= 3.5 {
      return UIImage(named: "stars_3_5")
    } else {
      return nil
    }
  }
}

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    FLTGoogleMobileAdsPlugin.registerNativeAdFactory(self, factoryId: "adFactoryExample", nativeAdFactory: NativeAdFactoryExample())

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
