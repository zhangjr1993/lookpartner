#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MakeSkinSchema : NSObject

@property (nonatomic) NSMutableSet * fixedTangentOrigin;

@property (nonatomic) NSMutableDictionary * enabledLayoutScale;

+ (instancetype) makeSkinSchemaWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) commandForProcess;

- (NSMutableDictionary *) entityModeState;

- (int) visibleBorderDelay;

- (NSMutableSet *) giftInterpreterAcceleration;

- (NSMutableArray *) disabledScreenBottom;

@end

NS_ASSUME_NONNULL_END
        