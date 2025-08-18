#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DisplayThreadDecorator : NSObject

@property (nonatomic) NSMutableArray * iconPatternType;

+ (instancetype) displayThreaddecoratorWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) independentSpineName;

- (NSMutableDictionary *) stateBeyondAction;

- (int) activeScrollHead;

- (NSMutableSet *) errorDecoratorCenter;

- (NSMutableArray *) controllerActivityState;

@end

NS_ASSUME_NONNULL_END
        