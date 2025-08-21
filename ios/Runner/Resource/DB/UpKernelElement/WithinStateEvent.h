#import "NativeReferenceAnimator.h"
#import "CollectionVariableInset.h"

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WithinStateEvent : NSObject


- (void) transitionOldLayer;

- (void) dismissDelegateOnBatch;

@end

NS_ASSUME_NONNULL_END
        