#import "MobileTrajectoryPool.h"
#import "DiscardedLocalizationSubscriber.h"

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PositionDeliveryDelegate : NSObject


- (void) observeInjectForExtension;

- (void) invokeExplicitHistogram;

@end

NS_ASSUME_NONNULL_END
        