#import <Foundation/Foundation.h>
#import <GoogleMobileAds/GADAdNetworkExtras.h>

@protocol FlutterMediationExtras

@property NSMutableDictionary * _Nullable extras;

- (id<GADAdNetworkExtras> _Nonnull) getMediationExtras;

@end
