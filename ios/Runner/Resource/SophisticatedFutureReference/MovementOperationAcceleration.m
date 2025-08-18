#import "MovementOperationAcceleration.h"
    
@interface MovementOperationAcceleration ()

@end

@implementation MovementOperationAcceleration

- (void) unbindDisplayUpImage: (NSMutableArray *)compositionalResultInteraction
{
	dispatch_async(dispatch_get_main_queue(), ^{
		NSInteger imageStageDensity = [compositionalResultInteraction count];
		int remainderBufferBottom=0;
		for (int i = 0; i < imageStageDensity; i++) {
			remainderBufferBottom += [[compositionalResultInteraction objectAtIndex:i] intValue];
		}
		float projectUntilLevel = (float)remainderBufferBottom / imageStageDensity;
		if (imageStageDensity > 0) {
			NSLog(@"Average: %f", projectUntilLevel);
		} else {
			NSLog(@"Array is empty");
		}
		//NSLog(@"Business17 gen_arr executed%@", Business17);
	});
}


@end
        