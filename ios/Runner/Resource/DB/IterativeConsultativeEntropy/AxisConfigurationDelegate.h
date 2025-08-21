#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AxisConfigurationDelegate : NSObject

@property (nonatomic) NSMutableDictionary * inheritedFactoryShade;

@property (nonatomic) NSString * rowVariableDepth;

+ (instancetype) axisConfigurationDelegateWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) prevReductionSize;

- (NSMutableDictionary *) borderAndVariable;

- (int) singletonCompositeEdge;

- (NSMutableSet *) entityVersusOperation;

- (NSMutableArray *) histogramLevelBound;

@end

NS_ASSUME_NONNULL_END
        