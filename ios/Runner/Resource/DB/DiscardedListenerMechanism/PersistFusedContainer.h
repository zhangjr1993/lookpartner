#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PersistFusedContainer : NSObject

@property (nonatomic) NSString * blocShapeMargin;

+ (instancetype) persistFusedContainerWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) shaderProxyLocation;

- (NSMutableDictionary *) iconAsFramework;

- (int) completerMediatorVisibility;

- (NSMutableSet *) activeStampType;

- (NSMutableArray *) sensorContextSpacing;

@end

NS_ASSUME_NONNULL_END
        