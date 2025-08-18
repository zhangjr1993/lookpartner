#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KeepAnimationButton : NSObject

@property (nonatomic) NSMutableArray * listenerExceptOperation;

+ (instancetype) keepAnimationButtonWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) pinchableLayerHue;

- (NSMutableDictionary *) hashOfPlatform;

- (int) loopMementoOrientation;

- (NSMutableSet *) oldPlaybackVelocity;

- (NSMutableArray *) containerTypeDuration;

@end

NS_ASSUME_NONNULL_END
        