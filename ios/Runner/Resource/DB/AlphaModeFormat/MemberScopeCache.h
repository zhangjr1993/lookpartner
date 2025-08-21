#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MemberScopeCache : NSObject

@property (nonatomic) NSMutableSet * hardMenuInteraction;

+ (instancetype) memberScopeCacheWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) tappableListviewSpacing;

- (NSMutableDictionary *) directAllocatorFlags;

- (int) capsuleCycleMode;

- (NSMutableSet *) prevProgressbarFlags;

- (NSMutableArray *) deferredMapLocation;

@end

NS_ASSUME_NONNULL_END
        