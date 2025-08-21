#import "ObserverReplicaContainer.h"
#import "FixedSinkSplitter.h"

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HierarchicalStreamManager : NSObject


- (void) listenMaterializeBelowDocument;

- (void) bindOriginalPointLevel;

@end

NS_ASSUME_NONNULL_END
        