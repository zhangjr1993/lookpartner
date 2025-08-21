#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QuantizerNotifierConfiguration : NSObject

@property (nonatomic) NSMutableDictionary * sinkAndVariable;

+ (instancetype) quantizerNotifierConfigurationWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) intensityVarOpacity;

- (NSMutableDictionary *) histogramPhaseBrightness;

- (int) gateIncludeStrategy;

- (NSMutableSet *) challengeKindCoord;

- (NSMutableArray *) singleFutureFeedback;

@end

NS_ASSUME_NONNULL_END
        