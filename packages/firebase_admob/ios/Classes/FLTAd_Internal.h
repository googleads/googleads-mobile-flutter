#import <GoogleMobileAds/GoogleMobileAds.h>
#import "FLTAdInstanceManager_Internal.h"
#import "FLTFirebaseAdMobPlugin.h"

@class FLTAdInstanceManager;
@protocol FLTNativeAdFactory;

@interface FLTAdSize : NSObject
@property(readonly) GADAdSize size;
@property(readonly) NSNumber *_Nonnull width;
@property(readonly) NSNumber *_Nonnull height;
- (instancetype _Nonnull)initWithWidth:(NSNumber *_Nonnull)width height:(NSNumber *_Nonnull)height;
@end

typedef NS_ENUM(NSInteger, FLTAdGender) {
  FLTAdGenderUnknown,
  FLTAdGenderMale,
  FLTAdGenderFemale,
};

@interface FLTAdRequest : NSObject
@property NSArray<NSString *> *_Nullable keywords;
@property NSString *_Nullable contentURL;
@property NSDate *_Nullable birthday;
@property FLTAdGender gender;
@property BOOL designedForFamilies;
@property BOOL childDirected;
@property NSArray<NSString *> *_Nullable testDevices;
@property BOOL nonPersonalizedAds;
- (GADRequest *_Nonnull)asGADRequest;
@end

/**
 * Wrapper around `DFPRequest` for the Firebase AdMob Plugin.
 */
@interface FLTPublisherAdRequest : FLTAdRequest
@property NSDictionary<NSString *, NSString *> *_Nullable customTargeting;
@property NSDictionary<NSString *, NSArray<NSString *> *> *_Nullable customTargetingLists;
- (DFPRequest *_Nonnull)asDFPRequest;
@end

@protocol FLTAd <NSObject>
@property(weak) FLTAdInstanceManager *_Nullable manager;
- (void)load;
@end

@protocol FLTAdWithoutView
- (void)show;
@end

// TODO(bparrishMines): Change name to FLTBannerAd once refactor is finished.
@interface FLTNewBannerAd : NSObject <FLTAd, FlutterPlatformView, GADBannerViewDelegate>
@property(weak) FLTAdInstanceManager *_Nullable manager;
- (instancetype _Nonnull)initWithAdUnitId:(NSString *_Nonnull)adUnitId
                                     size:(FLTAdSize *_Nonnull)size
                                  request:(FLTAdRequest *_Nonnull)request
                       rootViewController:(UIViewController *_Nonnull)rootViewController;
@end

/**
 * Wrapper around `DFPBannerAd` for the Firebase AdMob Plugin.
 */
@interface FLTPublisherBannerAd : FLTNewBannerAd <DFPBannerAdLoaderDelegate>
- (instancetype _Nonnull)initWithAdUnitId:(NSString *_Nonnull)adUnitId
                                    sizes:(NSArray<FLTAdSize *> *_Nonnull)sizes
                                  request:(FLTPublisherAdRequest *_Nonnull)request
                       rootViewController:(UIViewController *_Nonnull)rootViewController;
@end

// TODO(cg021): Change name to FLTInterstitialAd once refactor is finished.
@interface FLTNewInterstitialAd : NSObject <FLTAd, FLTAdWithoutView, GADInterstitialDelegate>
@property(weak) FLTAdInstanceManager *_Nullable manager;
- (instancetype _Nonnull)initWithAdUnitId:(NSString *_Nonnull)adUnitId
                                  request:(FLTAdRequest *_Nonnull)request
                       rootViewController:(UIViewController *_Nonnull)rootViewController;
@end

// TODO(cg021): Change name to FLTRewardedAd once refactor is finished.
@interface FLTNewRewardedAd : NSObject <FLTAd, FLTAdWithoutView, GADRewardedAdDelegate>
@property(weak) FLTAdInstanceManager *_Nullable manager;
- (instancetype _Nonnull)initWithAdUnitId:(NSString *_Nonnull)adUnitId
                                  request:(FLTAdRequest *_Nonnull)request
                       rootViewController:(UIViewController *_Nonnull)rootViewController;
@end

// TODO(bparrishMines): Change name to FLTNativeAd once refactor is finished.
@interface FLTNewNativeAd : NSObject <FLTAd,
                                      FlutterPlatformView,
                                      GADUnifiedNativeAdDelegate,
                                      GADUnifiedNativeAdLoaderDelegate>
@property(weak) FLTAdInstanceManager *_Nullable manager;
- (instancetype _Nonnull)initWithAdUnitId:(NSString *_Nonnull)adUnitId
                                  request:(FLTAdRequest *_Nonnull)request
                          nativeAdFactory:(NSObject<FLTNativeAdFactory> *_Nonnull)nativeAdFactory
                            customOptions:(NSDictionary<NSString *, id> *_Nullable)customOptions
                       rootViewController:(UIViewController *_Nonnull)rootViewController;
@end

@interface FLTRewardItem : NSObject
@property(readonly) NSNumber *_Nonnull amount;
@property(readonly) NSString *_Nonnull type;
- (instancetype _Nonnull)initWithAmount:(NSNumber *_Nonnull)amount type:(NSString *_Nonnull)type;
@end
