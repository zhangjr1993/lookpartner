#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SignAnalyzerManager : NSObject

@property (nonatomic) NSMutableArray * backwardDurationTint;

+ (instancetype) signAnalyzerManagerWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) bulletVarValidation;

- (NSMutableDictionary *) visibleAppbarDirection;

- (int) effectAsNumber;

- (NSMutableSet *) nativeStreamRotation;

- (NSMutableArray *) gestureCompositeSpeed;

@end

NS_ASSUME_NONNULL_END
        