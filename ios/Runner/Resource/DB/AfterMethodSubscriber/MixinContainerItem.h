#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MixinContainerItem : NSObject

@property (nonatomic) NSMutableArray * requiredLogMargin;

+ (instancetype) mixinContainerItemWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) cupertinoStageTail;

- (NSMutableDictionary *) draggableUsageBehavior;

- (int) lastAnchorTag;

- (NSMutableSet *) previewAtNumber;

- (NSMutableArray *) adaptiveApertureFlags;

@end

NS_ASSUME_NONNULL_END
        