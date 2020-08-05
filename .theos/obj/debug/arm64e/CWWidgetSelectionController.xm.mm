#line 1 "CWWidgetSelectionController.xm"
#import "CWWidgetSelectionController.h"
#import "WGWidgetDiscoveryController.h"
#import "CWHeaders.h"


#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class WGWidgetHostingViewController; 

static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$WGWidgetHostingViewController(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("WGWidgetHostingViewController"); } return _klass; }
#line 5 "CWWidgetSelectionController.xm"
@implementation CWWidgetSelectionController

- (void)viewDidLoad {
	[super viewDidLoad];

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];

	self.widgets = [self getAllWidgetIdentifiers];
    self.displayNames = [self getWidgetNamesForIdentifiers:self.widgets];
    self.tableView.dataSource = self;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
	return [self.widgets count];
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CWWidgetCell"];

	cell.textLabel.text = self.displayNames[self.widgets[indexPath.row]][@"name"];
    cell.imageView.layer.cornerRadius = 7;
	cell.imageView.clipsToBounds = YES;
    
	if (self.displayNames[self.widgets[indexPath.row]][@"image"]) {
		cell.imageView.image = [UIImage imageWithData:self.displayNames[self.widgets[indexPath.row]][@"image"]];
	} else {
		cell.imageView.image = NULL;
	}

	return cell;
}

- (NSArray *)getAllWidgetIdentifiers {
	WGWidgetDiscoveryController *wdc = [[NSClassFromString(@"WGWidgetDiscoveryController") alloc] init];
	[wdc beginDiscovery];

	return [[wdc disabledWidgetIdentifiers] arrayByAddingObjectsFromArray:[wdc enabledWidgetIdentifiersForAllGroups]];
}

-(NSMutableDictionary*)getWidgetNamesForIdentifiers:(NSArray*)args {	
	NSMutableDictionary *allIdentifiers = [NSMutableDictionary new];

	for(NSString *identifier in args) {
		NSError *error;
		NSExtension *extension = [NSExtension extensionWithIdentifier:identifier error:&error];
		WGWidgetInfo *widgetInfo = [[NSClassFromString(@"WGWidgetInfo") alloc] initWithExtension:extension];
		WGWidgetHostingViewController *host	= [[_logos_static_class_lookup$WGWidgetHostingViewController() alloc] initWithWidgetInfo:widgetInfo delegate:nil host:nil];

		if(!host.appBundleID) {
			[allIdentifiers setValue:@{@"name":[widgetInfo displayName]} forKey:identifier];
		} else {
			UIImage *image = [UIImage _applicationIconImageForBundleIdentifier:host.appBundleID format:2 scale:1];
			if(image) {
				[allIdentifiers setValue:@{@"name":[widgetInfo displayName], @"image": UIImagePNGRepresentation(image)} forKey:identifier];
			} else {
				[allIdentifiers setValue:@{@"name":[widgetInfo displayName]} forKey:identifier];
			}
		}
	}

	return allIdentifiers;
}

@end
#line 70 "CWWidgetSelectionController.xm"
