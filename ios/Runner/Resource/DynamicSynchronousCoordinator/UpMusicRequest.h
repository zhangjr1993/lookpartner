#import "OperationTrajectoryInstance.h"
#import "UpDependencySplitter.h"
#import "UnbindConvolutionTween.h"
#import "TransposeStreamDecorator.h"
#import "DispatchBulletOffset.h"
#import "FromReferenceTimer.h"

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UpMusicRequest : NSObject


- (void) bindCommonResult;

- (void) propagateExplicitNavigation;

@end

NS_ASSUME_NONNULL_END
        