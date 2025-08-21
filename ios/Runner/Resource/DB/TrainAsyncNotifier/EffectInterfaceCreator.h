#import "MendFlyweightBrightness.h"
#import "WidgetReliabilityProtocol.h"
#import "InflateProjectionRenderer.h"
#import "ConcurrentSwiftManager.h"

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EffectInterfaceCreator : NSObject


- (void) skipConcurrentGate;

- (void) renderPriorityInAnimation;

@end

NS_ASSUME_NONNULL_END
        