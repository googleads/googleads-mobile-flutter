#import "AppDelegate.h"
#import "FLTGoogleMobileAdsPlugin.h"
#import "GeneratedPluginRegistrant.h"
#import "MyFLTMediationNetworkExtrasProvider.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];

  MyFLTMediationNetworkExtrasProvider *networkExtrasProvider =
      [[MyFLTMediationNetworkExtrasProvider alloc] init];
  [FLTGoogleMobileAdsPlugin registerMediationNetworkExtrasProvider:networkExtrasProvider
                                                         registery:self];

  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
