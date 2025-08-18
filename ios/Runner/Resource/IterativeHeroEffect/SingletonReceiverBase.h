#import "FinishNibInstance.h"
#import "ConstUniformView.h"

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SingletonReceiverBase : NSObject


- (void) disconnectTaskAndLayer;

- (void) awaitUnderPlaybackBuffer;

@end

NS_ASSUME_NONNULL_END
        