#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ControllerBinderBase : NSObject

@property (nonatomic) NSMutableDictionary * menuCompositeBehavior;

+ (instancetype) controllerBinderBaseWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) compositionMementoAppearance;

- (NSMutableDictionary *) framePatternColor;

- (int) plateBridgeColor;

- (NSMutableSet *) sizeWithoutAction;

- (NSMutableArray *) hierarchicalBlocLocation;

@end

NS_ASSUME_NONNULL_END
        