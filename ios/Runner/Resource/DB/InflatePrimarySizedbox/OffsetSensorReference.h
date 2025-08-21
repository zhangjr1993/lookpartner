#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OffsetSensorReference : NSObject

@property (nonatomic) NSString * momentumVariableSpeed;

@property (nonatomic) int significantHistogramVisible;

@property (nonatomic) int iterativeProgressbarSpeed;

@property (nonatomic) NSMutableArray * rapidQueryStyle;

+ (instancetype) offsetSensorReferenceWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) referenceAsVariable;

- (NSMutableDictionary *) textAtParameter;

- (int) reductionAlongObserver;

- (NSMutableSet *) positionModeName;

- (NSMutableArray *) anchorVersusCycle;

@end

NS_ASSUME_NONNULL_END
        