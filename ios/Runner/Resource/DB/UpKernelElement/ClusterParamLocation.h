#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClusterParamLocation : NSObject

@property (nonatomic) NSString * localizationExceptShape;

@property (nonatomic) NSMutableDictionary * sinkPerSystem;

+ (instancetype) clusterParamLocationWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) previewVersusLayer;

- (NSMutableDictionary *) interpolationNearEnvironment;

- (int) popupStateBottom;

- (NSMutableSet *) expandedAmongSingleton;

- (NSMutableArray *) statePatternOrigin;

@end

NS_ASSUME_NONNULL_END
        