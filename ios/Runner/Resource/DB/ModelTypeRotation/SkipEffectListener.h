#import "FirstTriggerGroup.h"
#import "RelationalScaffoldDescription.h"
#import "IntoOptimizerTicker.h"

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SkipEffectListener : NSObject


- (void) keepRequiredRowWork;

- (void) awaitSessionAgainstCombiner;

@end

NS_ASSUME_NONNULL_END
        