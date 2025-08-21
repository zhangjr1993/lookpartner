#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TransitionStateOrientation : NSObject

@property (nonatomic) NSMutableArray * transitionAlongEnvironment;

+ (instancetype) transitionStateOrientationWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) methodAsState;

- (NSMutableDictionary *) immutableMapVelocity;

- (int) priorityAgainstMemento;

- (NSMutableSet *) parallelFutureInterval;

- (NSMutableArray *) delegateThroughOperation;

@end

NS_ASSUME_NONNULL_END
        