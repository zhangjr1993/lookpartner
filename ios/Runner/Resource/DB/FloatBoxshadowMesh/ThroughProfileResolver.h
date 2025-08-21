#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ThroughProfileResolver : NSObject

@property (nonatomic) int workflowOperationPosition;

@property (nonatomic) int overlayTaskStyle;

+ (instancetype) throughProfileResolverWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) specifyAccessoryColor;

- (NSMutableDictionary *) accordionTableAppearance;

- (int) secondResourceBrightness;

- (NSMutableSet *) activityCompositeRotation;

- (NSMutableArray *) graphMediatorSpacing;

@end

NS_ASSUME_NONNULL_END
        