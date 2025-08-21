#import "TransformerShapeState.h"
#import "UnderFrameJoiner.h"

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AfterDescriptionPublisher : NSObject


- (void) delegateIntoChapterChain;

- (void) disconnectWithSymbolVisitor;

@end

NS_ASSUME_NONNULL_END
        