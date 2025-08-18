#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LostCurrentEvent : NSObject

@property (nonatomic) NSMutableSet * reducerOrSystem;

+ (instancetype) lostCurrentEventWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) deferredSliderStyle;

- (NSMutableDictionary *) oldConstraintFeedback;

- (int) assetParamDelay;

- (NSMutableSet *) temporaryGestureSkewy;

- (NSMutableArray *) iconChainVelocity;

@end

NS_ASSUME_NONNULL_END
        