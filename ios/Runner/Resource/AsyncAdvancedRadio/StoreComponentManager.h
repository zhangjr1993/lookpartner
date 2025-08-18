#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StoreComponentManager : NSObject

@property (nonatomic) int layoutPrototypeTheme;

+ (instancetype) storeComponentManagerWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) layerByDecorator;

- (NSMutableDictionary *) materialFlyweightOpacity;

- (int) alphaAboutPlatform;

- (NSMutableSet *) unsortedQueryInterval;

- (NSMutableArray *) cubitFlyweightOffset;

@end

NS_ASSUME_NONNULL_END
        