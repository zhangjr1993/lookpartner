#import "CharacterPreviewCreator.h"
#import "EndCompositionInfo.h"
#import "InflateDelegateInstance.h"
#import "NibInteractorImplement.h"

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ConcatenateContractionPreview : NSObject


- (void) moveCompositionNearAnimator;

- (void) computeGestureAgainstModel;

@end

NS_ASSUME_NONNULL_END
        