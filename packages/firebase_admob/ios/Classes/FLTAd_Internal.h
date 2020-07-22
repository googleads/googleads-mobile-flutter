#import <GoogleMobileAds/GoogleMobileAds.h>
#import "FLTFirebaseAdMobPlugin.h"

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

@protocol FLTAd <NSObject>
- (void)load;
@end

// TODO(bparrishMines): Change name to FLTBannerAd once refactor is finished.
@interface FLTNewBannerAd : NSObject <FLTAd>
- (instancetype _Nonnull)initWithAdUnitId:(NSString *_Nonnull)adUnitId
                                     size:(FLTAdSize *_Nonnull)size;
@end
