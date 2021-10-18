/**
 * TODO - this.
 */
@protocol FLTMediationNetworkExtrasProvider
@required
/**
 * TODO - this
 */
- (NSDictionary *_Nullable)getMediationExtras:(NSString * _Nonnull)adUnitId
                    mediationExtrasIdentifier:(NSString *_Nullable)mediationExtrasIdentifier;

@end
