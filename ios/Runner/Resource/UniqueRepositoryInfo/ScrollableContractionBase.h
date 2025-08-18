#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScrollableContractionBase : NSObject

@property (nonatomic) NSMutableArray * accordionPageviewDuration;

@property (nonatomic) NSMutableArray * menuOperationFlags;

@property (nonatomic) NSMutableSet * pinchableFeatureOrientation;

+ (instancetype) scrollableContractionBaseWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) asyncStateStyle;

- (NSMutableDictionary *) unaryTierOpacity;

- (int) layerProcessSpacing;

- (NSMutableSet *) subtleLayerSize;

- (NSMutableArray *) intermediateBlocPosition;

@end

NS_ASSUME_NONNULL_END
        