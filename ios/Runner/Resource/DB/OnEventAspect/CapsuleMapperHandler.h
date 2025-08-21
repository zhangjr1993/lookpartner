#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CapsuleMapperHandler : NSObject

@property (nonatomic) NSMutableArray * curveAtState;

@property (nonatomic) NSMutableDictionary * secondPriorityBound;

+ (instancetype) capsuleMapperHandlerWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) stateParamSkewy;

- (NSMutableDictionary *) dynamicMetadataAlignment;

- (int) paddingBeyondPhase;

- (NSMutableSet *) parallelDurationSpacing;

- (NSMutableArray *) euclideanSinkScale;

@end

NS_ASSUME_NONNULL_END
        