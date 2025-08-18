#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LayoutPublisherDecorator : NSObject

@property (nonatomic) NSString * standaloneProviderFormat;

+ (instancetype) layoutPublisherDecoratorWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) featureMementoInset;

- (NSMutableDictionary *) listenerContainLayer;

- (int) resizableImageStyle;

- (NSMutableSet *) dialogsWithoutFacade;

- (NSMutableArray *) tensorPriorityDuration;

@end

NS_ASSUME_NONNULL_END
        