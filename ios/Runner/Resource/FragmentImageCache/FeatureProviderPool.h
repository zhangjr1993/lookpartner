#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FeatureProviderPool : NSObject

@property (nonatomic) NSString * elasticStoreBorder;

+ (instancetype) featureProviderPoolWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) overlayViaStrategy;

- (NSMutableDictionary *) storyboardPhaseVisibility;

- (int) cartesianCurveScale;

- (NSMutableSet *) disabledBaseAlignment;

- (NSMutableArray *) textfieldByAction;

@end

NS_ASSUME_NONNULL_END
        