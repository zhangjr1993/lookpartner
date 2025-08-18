#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MobileDispatcherGroup : NSObject


- (void) skipMultiAwait;

- (void) animateGateExceptDependency: (NSMutableDictionary *)usecaseMediatorEdge;

@end

NS_ASSUME_NONNULL_END
        