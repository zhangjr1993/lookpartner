#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DisabledOperationContainer : NSObject

@property (nonatomic) NSMutableArray * resizableProfileIndex;

@property (nonatomic) NSMutableDictionary * customizedWidgetKind;

+ (instancetype) disabledOperationContainerWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) requestTypeValidation;

- (NSMutableDictionary *) builderUntilKind;

- (int) interfaceActionStyle;

- (NSMutableSet *) textureActionSpeed;

- (NSMutableArray *) temporaryTimerValidation;

@end

NS_ASSUME_NONNULL_END
        