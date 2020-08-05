#import <UIKit/UIViewController.h>
#import <ControlCenterUIKit/CCUIContentModuleContentViewController-Protocol.h>
#import <Cephei/HBPreferences.h>
#import "WGHeaders.h"

@interface CWUIModuleContentViewController : UIViewController <CCUIContentModuleContentViewController>

@property (nonatomic,readonly) CGFloat preferredExpandedContentHeight;
@property (nonatomic,readonly) CGFloat preferredExpandedContentWidth;
@property (nonatomic,readonly) BOOL providesOwnPlatter;

@property (nonatomic, readonly) BOOL small;

@property (nonatomic) WGWidgetPlatterView *platterView;

-(instancetype)initWithSmallSize:(BOOL)small;

-(void)loadWidget;

-(void)controlCenterWillPresent;

@end