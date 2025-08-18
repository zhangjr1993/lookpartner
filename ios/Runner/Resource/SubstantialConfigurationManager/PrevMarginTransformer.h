#import "HistogramTransformerHelper.h"
#import "SimilarFrameCache.h"
#import "EvaluateCycleArray.h"
#import "ReusableOverlayHelper.h"
#import "PrecisionFrameExtension.h"

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PrevMarginTransformer : NSObject


- (void) notifyTransitionWithoutCallback;

- (void) transformAccessoryFromTask;

@end

NS_ASSUME_NONNULL_END
        