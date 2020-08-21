#import "FLTAd_Internal.h"
#import "FLTFirebaseAdMobCollection_Internal.h"
#import "FLTFirebaseAdMobReaderWriter_Internal.h"

@protocol FLTAd;
@class FLTNewNativeAd;
@class FLTNewRewardedAd;
@class FLTRewardItem;

@interface FLTAdInstanceManager : NSObject
- (instancetype _Nonnull)initWithBinaryMessenger:
    (id<FlutterBinaryMessenger> _Nonnull)binaryMessenger;
- (id<FLTAd> _Nullable)adFor:(NSNumber *_Nonnull)adId;
- (NSNumber *_Nullable)adIdFor:(id<FLTAd> _Nonnull)ad;
- (void)loadAd:(id<FLTAd> _Nonnull)ad adId:(NSNumber *_Nonnull)adId;
- (void)dispose:(id<FLTAd> _Nonnull)ad;
- (void)showAdWithID:(NSNumber *_Nonnull)adId;
- (void)onAdLoaded:(id<FLTAd> _Nonnull)ad;
- (void)onAdFailedToLoad:(id<FLTAd> _Nonnull)ad;
- (void)onNativeAdClicked:(FLTNewNativeAd *_Nonnull)ad;
- (void)onNativeAdImpression:(FLTNewNativeAd *_Nonnull)ad;
- (void)onAdOpened:(id<FLTAd> _Nonnull)ad;
- (void)onApplicationExit:(id<FLTAd> _Nonnull)ad;
- (void)onAdClosed:(id<FLTAd> _Nonnull)ad;
- (void)onRewardedAdUserEarnedReward:(FLTNewRewardedAd *_Nonnull)ad
                              reward:(FLTRewardItem *_Nonnull)reward;
@end

@interface FLTNewFirebaseAdmobViewFactory : NSObject <FlutterPlatformViewFactory>
@property(readonly) FLTAdInstanceManager *_Nonnull manager;
- (instancetype _Nonnull)initWithManager:(FLTAdInstanceManager *_Nonnull)manager;
@end
