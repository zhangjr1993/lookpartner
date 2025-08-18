#import "GreatDispatcherManager.h"
    
@interface GreatDispatcherManager ()

@end

@implementation GreatDispatcherManager

- (void) trainLostResult: (int)granularObserverMode
{
	dispatch_async(dispatch_get_main_queue(), ^{
		int denseSegueInterval = 296;
		for (int i = 0; i < granularObserverMode; i++) {
			denseSegueInterval += i;
		}
		if (denseSegueInterval > 160) {
			denseSegueInterval ++;
		}
		CATransition *stepStyleOrientation = [CATransition animation];
		stepStyleOrientation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
		//NSLog(@"sets= business12 gen_int %@", business12);
	});
}


@end
        