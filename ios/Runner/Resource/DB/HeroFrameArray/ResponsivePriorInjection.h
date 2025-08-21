#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ResponsivePriorInjection : NSObject

@property (nonatomic) NSString * originalMetadataDirection;

+ (instancetype) responsivePriorInjectionWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) desktopAxisBorder;

- (NSMutableDictionary *) textAgainstEnvironment;

- (int) mobileFlexTint;

- (NSMutableSet *) paddingInsideLevel;

- (NSMutableArray *) lazyPreviewResponse;

@end

NS_ASSUME_NONNULL_END
        