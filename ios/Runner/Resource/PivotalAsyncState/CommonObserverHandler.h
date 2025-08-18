#import "PoolScaleNode.h"
#import "MultiSliderScroller.h"

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommonObserverHandler : NSObject


- (void) bindVisibleChannelParam;

- (void) unregisterCanvasDuringEvent;

@end

NS_ASSUME_NONNULL_END
        