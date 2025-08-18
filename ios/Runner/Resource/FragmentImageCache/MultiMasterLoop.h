#import "UnmarshalDecorationInteractor.h"
#import "AssociatedSwiftAction.h"
#import "ConsumeAspectUsecase.h"
#import "PriorListenerHandler.h"

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MultiMasterLoop : NSObject


- (void) subscribeSortedBatch;

- (void) wrapWithoutResponseEnvironment;

@end

NS_ASSUME_NONNULL_END
        