#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LostDependencyGroup : NSObject


- (void) introspectCellForGrain;

- (void) formatConcreteInjection: (NSMutableSet *)gemInSingleton;

@end

NS_ASSUME_NONNULL_END
        