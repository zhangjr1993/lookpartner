#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GlobalCustomListener : NSObject

@property (nonatomic) NSMutableDictionary * adaptiveGraphName;

+ (instancetype) globalCustomListenerWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) textWithoutProcess;

- (NSMutableDictionary *) interactorContainScope;

- (int) mediumTextInset;

- (NSMutableSet *) paddingOutsideState;

- (NSMutableArray *) semanticApertureBehavior;

@end

NS_ASSUME_NONNULL_END
        