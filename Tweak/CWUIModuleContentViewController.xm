#import "CWUIModuleContentViewController.h"
#import "WGHeaders.h"

@interface UIView (ControlWidgetCCBundle)
-(void)setOverrideUserInterfaceStyle:(NSInteger)style;
@end

@implementation CWUIModuleContentViewController
    -(instancetype)initWithSmallSize:(BOOL)small {
        _small = small;
        return [self init];
    }

    // This is where you initialize any controllers for objects from ControlCenterUIKit
    -(instancetype)initWithNibName:(NSString*)name bundle:(NSBundle*)bundle {
        self = [super initWithNibName:name bundle:bundle];
        if (self) {
            [self loadWidget];
            [self.view addSubview: self.platterView];
        }

        return self;
    }

    -(void)loadWidget {
        HBPreferences *preferences = [[HBPreferences alloc] initWithIdentifier:@"com.thatmarcel.tweaks.controlwidget.hbprefs"];
        [preferences registerDefaults:@{
            @"usedarkmode": @YES
	    }];

        if (@available(iOS 13, *)) {
            if ([preferences boolForKey:@"usedarkmode"] == YES) {
                [self setOverrideUserInterfaceStyle:2];
            } else {
                [self setOverrideUserInterfaceStyle:1];
            }
        }
        

        self.view.clipsToBounds = YES;
	        
        NSString *identifier = [preferences objectForKey:@"cwWidgetIdentifier"];
        if (identifier == nil) {
            identifier = @"com.apple.BatteryCenter.BatteryWidget";
        }

        NSError *error;
	    NSExtension *extension = [NSExtension extensionWithIdentifier:identifier error:&error];

	    WGWidgetInfo *widgetInfo = [[NSClassFromString(@"WGWidgetInfo") alloc] initWithExtension:extension];
	    WGWidgetHostingViewController *widgetHost = [[NSClassFromString(@"WGWidgetHostingViewController") alloc] initWithWidgetInfo:widgetInfo delegate:nil host:nil];

	    self.platterView = [[NSClassFromString(@"WGWidgetPlatterView") alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];

	    if ([identifier isEqualToString:@"com.apple.UpNextWidget.extension"] || [identifier isEqualToString:@"com.apple.mobilecal.widget"]) {
		    WGCalendarWidgetInfo *widgetInfoCal = [[NSClassFromString(@"WGCalendarWidgetInfo") alloc] initWithExtension:extension];
		    NSDate *now = [NSDate date];
		    [widgetInfoCal setValue:now forKey:@"_date"];
		    [self.platterView setWidgetHost:[[NSClassFromString(@"WGWidgetHostingViewController") alloc] initWithWidgetInfo:widgetInfoCal delegate:nil host:nil]];
	    } else {
		    [self.platterView setWidgetHost:widgetHost];
	    }

        // Remove widget header in dark mode
        if (@available(iOS 13.0, *)) {
		    MTMaterialView *header = MSHookIvar<MTMaterialView *>(self.platterView, "_headerBackgroundView");
		    [header removeFromSuperview];
	    }
    }

    -(void)viewDidLoad {
        [super viewDidLoad];
    
        // Calculate expanded size
        _preferredExpandedContentWidth = [UIScreen mainScreen].bounds.size.width * 0.856;
        _preferredExpandedContentHeight = 150;
    }

    -(void)viewWillAppear:(BOOL)animated {
        [super viewWillAppear:animated];

        CGRect pFrame = self.platterView.frame;
        pFrame.size.width = self.view.frame.size.width;
        pFrame.size.height = self.view.frame.size.height;
        self.platterView.frame = pFrame;
    }

    -(void)controlCenterWillPresent {
        // [self loadWidget];
        [self.platterView removeFromSuperview];
        [self loadWidget];
        [self.view addSubview: self.platterView];
    }

    -(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
        [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

        [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            CGRect pFrame = self.platterView.frame;
            pFrame.size.width = size.width;
            pFrame.size.height = size.height;
            self.platterView.frame = pFrame;

            // Force animated constraint updates:
            [self.view layoutIfNeeded];
        } completion:nil];
    }

    -(BOOL)_canShowWhileLocked {
	    return YES;
    }
@end