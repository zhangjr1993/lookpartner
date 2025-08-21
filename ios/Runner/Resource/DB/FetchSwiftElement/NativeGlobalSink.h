#import "OntoAlertMetrics.h"
#import "ReadLogZone.h"
#import "ToUsageTaxonomy.h"
#import "DecoupleInterpolationChooser.h"
#import "RapidLayerObserver.h"

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NativeGlobalSink : NSObject


- (void) connectBackwardAlert;

- (void) seekCriticalMap;

@end

NS_ASSUME_NONNULL_END
        