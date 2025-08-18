#import "LossStageOffset.h"
#import "BeforeBaselineModule.h"

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ModalEnvironmentState : NSObject


- (void) unmountedReadBeforePadding;

- (void) withinRowLifecycle;

@end

NS_ASSUME_NONNULL_END
        