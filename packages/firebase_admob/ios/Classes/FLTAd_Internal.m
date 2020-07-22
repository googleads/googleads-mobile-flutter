#import "FLTAd_Internal.h"

@implementation FLTAdSize
- (instancetype _Nonnull)initWithWidth:(NSNumber *_Nonnull)width height:(NSNumber *_Nonnull)height {
  self = [super init];
  if (self) {
    _width = width;
    _height = height;
    _size = GADAdSizeFromCGSize(CGSizeMake(width.doubleValue, height.doubleValue));
  }
  return self;
}
@end

@implementation FLTAdRequest
- (GADRequest *_Nonnull)asGADRequest {
  GADRequest *request = [GADRequest request];
  request.keywords = _keywords;
  request.contentURL = _contentURL;
  request.birthday = _birthday;
  request.gender = _gender;
  [request tagForChildDirectedTreatment:_childDirected];
  request.testDevices = _testDevices;
  if (_nonPersonalizedAds) {
    GADExtras *extras = [[GADExtras alloc] init];
    extras.additionalParameters = @{@"npa" : @"1"};
    [request registerAdNetworkExtras:extras];
  }

  return request;
}
@end

@implementation FLTNewBannerAd {
  GADBannerView *_bannerView;
}

- (instancetype)initWithAdUnitId:(NSString *_Nonnull)adUnitId size:(FLTAdSize *_Nonnull)size {
  self = [super init];
  if (self) {
    _bannerView = [[GADBannerView alloc] initWithAdSize:size.size];
    _bannerView.adUnitID = adUnitId;
  }
  return self;
}

- (void)load {
  [_bannerView loadRequest:[GADRequest request]];
}
@end
