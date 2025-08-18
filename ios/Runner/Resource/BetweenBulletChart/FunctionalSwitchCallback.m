#import "FunctionalSwitchCallback.h"
    
@interface FunctionalSwitchCallback ()

@end

@implementation FunctionalSwitchCallback

- (void) rebuildNextMonster: (int)firstScenePressure
{
	dispatch_async(dispatch_get_main_queue(), ^{
		UIActivityIndicatorView *errorOperationForce = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
		[errorOperationForce setFrame:CGRectMake(firstScenePressure, 313, 556, 558)];
		errorOperationForce.hidesWhenStopped = YES;
		if (errorOperationForce.animating) {
			[errorOperationForce stopAnimating];
		}
		CALayer * boxshadowAsType = [[CALayer alloc] init];
		boxshadowAsType.borderColor = [UIColor orangeColor].CGColor;
		boxshadowAsType.position = CGPointMake(114, 15);
		//NSLog(@"sets= business14 gen_int %@", business14);
	});
}


@end
        