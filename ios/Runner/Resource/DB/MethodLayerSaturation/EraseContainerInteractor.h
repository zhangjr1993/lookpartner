#import "BlocInformationAdapter.h"
#import "UpdateBlocSingleton.h"

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EraseContainerInteractor : NSObject


- (void) notifyLocalPresenter;

- (void) cacheCalculateUpBorder;

@end

NS_ASSUME_NONNULL_END
        