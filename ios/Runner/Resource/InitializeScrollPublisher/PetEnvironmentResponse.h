#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PetEnvironmentResponse : NSObject

@property (nonatomic) NSMutableDictionary * sensorViaBuffer;

@property (nonatomic) NSMutableArray * liteSensorBrightness;

@property (nonatomic) int capacitiesNumberVisibility;

+ (instancetype) petEnvironmentResponseWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) dialogsAtCommand;

- (NSMutableDictionary *) completerAroundPattern;

- (int) firstAppbarRotation;

- (NSMutableSet *) musicIncludeComposite;

- (NSMutableArray *) eventParamTag;

@end

NS_ASSUME_NONNULL_END
        