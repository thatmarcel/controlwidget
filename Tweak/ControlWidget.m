#import "ControlWidget.h"
#import "CWUIModuleContentViewController.h"
#import <ControlCenterUI/ControlCenterUI-Structs.h>
#import <objc/runtime.h>

@implementation ControlWidget
//override the init to initialize the contentViewController (and the backgroundViewController if you have one)
-(instancetype)init
{
    if ((self = [super init]))
    {
        _contentViewController = [[CWUIModuleContentViewController alloc] initWithSmallSize:NO];
	}
    return self;
}

-(CCUILayoutSize)moduleSizeForOrientation:(int)orientation
{
    return (CCUILayoutSize){2, 4};
}
@end