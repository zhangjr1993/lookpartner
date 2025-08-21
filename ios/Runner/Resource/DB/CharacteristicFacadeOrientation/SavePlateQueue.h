#import "ParseConcreteEvent.h"
#import "AccessibleOpaqueCell.h"
#import "GlobalSeamlessMap.h"

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SavePlateQueue : NSObject


- (void) deserializeToChecklistPhase;

- (void) createPrevCompleter;

@end

NS_ASSUME_NONNULL_END
        