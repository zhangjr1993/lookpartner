#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeferredRouteLatency : NSObject

@property (nonatomic) NSMutableArray * nextBorderOrientation;

+ (instancetype) deferredRouteLatencyWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) sortedTransitionIndex;

- (NSMutableDictionary *) priorGateDepth;

- (int) providerByComposite;

- (NSMutableSet *) groupInsideLevel;

- (NSMutableArray *) topicAsLayer;

@end

NS_ASSUME_NONNULL_END
        