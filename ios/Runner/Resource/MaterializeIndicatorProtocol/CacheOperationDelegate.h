#import "PublicAnimationObserver.h"
#import "IntuitiveOverlayCache.h"

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CacheOperationDelegate : NSObject


- (void) wantSortedLayoutCycle;

- (void) joinAdaptiveToolScope;

@end

NS_ASSUME_NONNULL_END
        