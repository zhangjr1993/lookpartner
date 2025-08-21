#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InvokeTaskObserver : NSObject

@property (nonatomic) NSMutableDictionary * concurrentUnaryFrequency;

+ (instancetype) invokeTaskObserverWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) capacitiesAsProxy;

- (NSMutableDictionary *) metadataModeState;

- (int) overlayProxyStatus;

- (NSMutableSet *) storeExceptStrategy;

- (NSMutableArray *) exceptionActionPosition;

@end

NS_ASSUME_NONNULL_END
        