#import "FLTAd_Internal.h"
#import "FLTFirebaseAdMobCollection_Internal.h"
#import "FLTFirebaseAdMobReaderWriter_Internal.h"

@interface FLTAdInstanceManager : NSObject
- (instancetype _Nonnull)initWithBinaryMessenger:
    (id<FlutterBinaryMessenger> _Nonnull)binaryMessenger;
- (id<FLTAd> _Nullable)adFor:(NSNumber *_Nonnull)adId;
- (NSNumber *_Nullable)adIdFor:(id<FLTAd> _Nonnull)ad;
- (void)loadAd:(id<FLTAd> _Nonnull)ad adId:(NSNumber *_Nonnull)adId;
- (void)dispose:(id<FLTAd> _Nonnull)ad;
- (void)onAdLoaded:(id<FLTAd> _Nonnull)ad;
- (void)onAdFailedToLoad:(id<FLTAd> _Nonnull)ad;
// TODO(bparrishMines): Require a NativeAd in the 2 methods below once supported.
- (void)onNativeAdClicked:(id<FLTAd> _Nonnull)ad;
- (void)onNativeAdImpression:(id<FLTAd> _Nonnull)ad;
- (void)onAdOpened:(id<FLTAd> _Nonnull)ad;
- (void)onApplicationExit:(id<FLTAd> _Nonnull)ad;
- (void)onAdClosed:(id<FLTAd> _Nonnull)ad;
@end
