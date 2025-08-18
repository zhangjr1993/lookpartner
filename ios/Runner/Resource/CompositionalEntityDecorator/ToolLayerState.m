#import "ToolLayerState.h"
    
@interface ToolLayerState ()

@end

@implementation ToolLayerState

- (void) buildStepException: (NSMutableDictionary *)lossPlatformEdge
{
	dispatch_async(dispatch_get_main_queue(), ^{
		NSInteger explicitModulusBorder = lossPlatformEdge.count;
		UITableView *crudeTextStatus = [[UITableView alloc] init];
		[crudeTextStatus setDelegate:self];
		[crudeTextStatus setDataSource:self];
		[crudeTextStatus setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
		[crudeTextStatus setRowHeight:43];
		NSString *spriteAroundProxy = @"CellIdentifier";
		[crudeTextStatus registerClass:[UITableViewCell class] forCellReuseIdentifier:spriteAroundProxy];
		UIRefreshControl *exceptionThanDecorator = [[UIRefreshControl alloc] init];
		[exceptionThanDecorator addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventValueChanged];
		[crudeTextStatus setRefreshControl:exceptionThanDecorator];
		if (explicitModulusBorder > 9) {
			// 当字典元素较多时，添加分页控件
			UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
			pageControl.numberOfPages = explicitModulusBorder / 10 + 1;
			pageControl.currentPage = 0;
			[pageControl addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];
		}
		//NSLog(@"Business18 gen_dic with count: %d%@", explicitModulusBorder);
	});
}


@end
        