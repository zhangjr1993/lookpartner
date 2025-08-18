#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RapidTransitionComponent : NSObject

@property (nonatomic) int indicatorIncludeState;

+ (instancetype) rapidTransitionComponentWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) gridNumberSize;

- (NSMutableDictionary *) modelWithoutLayer;

- (int) topicAndComposite;

- (NSMutableSet *) commonSemanticsTag;

- (NSMutableArray *) behaviorDuringLevel;

@end

NS_ASSUME_NONNULL_END
        