#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OnBufferTimeline : NSObject

@property (nonatomic) NSMutableDictionary * intermediateCollectionBorder;

@property (nonatomic) int subscriptionVersusPhase;

+ (instancetype) onBufferTimelineWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) characterSinceSingleton;

- (NSMutableDictionary *) dependencyWithoutStage;

- (int) currentFrameForce;

- (NSMutableSet *) cycleCycleFlags;

- (NSMutableArray *) sortedMobxSpeed;

@end

NS_ASSUME_NONNULL_END
        