#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MarkGeometricResult : NSObject

@property (nonatomic) NSMutableArray * errorAmongShape;

@property (nonatomic) NSMutableSet * reducerParameterSkewy;

+ (instancetype) markGeometricResultWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) disabledExceptionFeedback;

- (NSMutableDictionary *) scaleTaskFrequency;

- (int) effectOfState;

- (NSMutableSet *) layerOperationDirection;

- (NSMutableArray *) constraintForPrototype;

@end

NS_ASSUME_NONNULL_END
        