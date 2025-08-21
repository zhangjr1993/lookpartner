#import "GradientMetadataCreator.h"
    
@interface GradientMetadataCreator ()

@end

@implementation GradientMetadataCreator

- (void) withGetxLatency: (NSMutableArray *)handlerFromInterpreter
{
	dispatch_async(dispatch_get_main_queue(), ^{
		NSInteger dialogsFrameworkCoord = [handlerFromInterpreter count];
		int sinkNearFacade=0;
		for (int i = 0; i < dialogsFrameworkCoord; i++) {
			sinkNearFacade += [[handlerFromInterpreter objectAtIndex:i] intValue];
		}
		float cursorWorkBottom = (float)sinkNearFacade / dialogsFrameworkCoord;
		if (dialogsFrameworkCoord > 0) {
			NSLog(@"Average: %f", cursorWorkBottom);
		} else {
			NSLog(@"Array is empty");
		}
		//NSLog(@"Business17 gen_arr executed%@", Business17);
	});
}


@end
        