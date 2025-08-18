#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DebugProtectedRect : NSObject

@property (nonatomic) NSString * requestAdapterFrequency;

+ (instancetype) debugProtectedRectWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) spineFlyweightStyle;

- (NSMutableDictionary *) stackOfCycle;

- (int) aspectNumberFormat;

- (NSMutableSet *) enabledStateColor;

- (NSMutableArray *) constraintLevelType;

@end

NS_ASSUME_NONNULL_END
        