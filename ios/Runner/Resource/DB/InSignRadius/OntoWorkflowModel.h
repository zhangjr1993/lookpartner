#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OntoWorkflowModel : NSObject

@property (nonatomic) NSMutableSet * resourceVersusFunction;

+ (instancetype) ontoWorkflowModelWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) backwardResponseSpacing;

- (NSMutableDictionary *) popupAtTier;

- (int) activeTaskAlignment;

- (NSMutableSet *) parallelSinkValidation;

- (NSMutableArray *) currentModalVisibility;

@end

NS_ASSUME_NONNULL_END
        