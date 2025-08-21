#import "CubitEnvironmentType.h"
    
@interface CubitEnvironmentType ()

@end

@implementation CubitEnvironmentType

- (void) activateTernaryWithFilter: (NSString *)eventSinceChain
{
	dispatch_async(dispatch_get_main_queue(), ^{
		UISegmentedControl *cardNearParam = [[UISegmentedControl alloc] init];
		[cardNearParam insertSegmentWithTitle:eventSinceChain atIndex:0 animated:YES];
		BOOL pointTempleMode = cardNearParam.isEnabled;
		if (pointTempleMode) {
			UISegmentedControl *cardNearParam = [[UISegmentedControl alloc] init];
			[cardNearParam insertSegmentWithTitle:eventSinceChain atIndex:0 animated:YES];
			BOOL pointTempleMode = cardNearParam.isEnabled;
		}
		//NSLog(@"sets= bussiness5 gen_str %@", bussiness5);
	});
}


@end
        