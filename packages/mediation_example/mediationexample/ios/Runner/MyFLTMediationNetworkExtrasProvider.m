//
//  MyFLTMediationNetworkExtrasProvider.m
//  Runner
//
//  Created by James Liu on 10/18/21.
//

#import "MyFLTMediationNetworkExtrasProvider.h"
#import <AppLovinAdapter/GADMAdapterAppLovinExtras.h>
#import <Foundation/Foundation.h>
#import <GoogleMobileAds/GADAdNetworkExtras.h>

@implementation MyFLTMediationNetworkExtrasProvider

/** Provide mediation extras for specific ad requests. */
- (NSArray<id<GADAdNetworkExtras>> *_Nullable)getMediationExtras:(NSString *_Nonnull)adUnitId
                                       mediationExtrasIdentifier:
                                           (NSString *_Nullable)mediationExtrasIdentifier {
  GADMAdapterAppLovinExtras *appLovinExtras = [[GADMAdapterAppLovinExtras alloc] init];
  appLovinExtras.muteAudio = NO;

  return @[ appLovinExtras ];
}

@end
