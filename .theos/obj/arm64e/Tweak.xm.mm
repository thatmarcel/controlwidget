#line 1 "Tweak.xm"
#import "Tweak.h"


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
#line 3 "Tweak.xm"
@implementation CWIPCServer {
    MRYIPCCenter* _center;
}

+(void)load {
	[self sharedInstance];
}

+(instancetype)sharedInstance {
	static dispatch_once_t onceToken = 0;
	__strong static CWIPCServer* sharedInstance = nil;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[self alloc] init];
	});
	return sharedInstance;
}

-(instancetype)init {
	if ((self = [super init]))
	{
		_center = [MRYIPCCenter centerNamed:@"com.thatmarcel.tweaks.controlwidget.ipcserver"];
		[_center addTarget:self action:@selector(getAllIdentifiers:)];
		[_center addTarget:self action:@selector(getWidgetNamesForIdentifiers:)];
	}
	return self;
}

-(NSArray*)getAllIdentifiers:(NSDictionary*)args {
	WGWidgetDiscoveryController *wdc = [[NSClassFromString(@"WGWidgetDiscoveryController") alloc] init];
	[wdc beginDiscovery];

	return [[wdc disabledWidgetIdentifiers] arrayByAddingObjectsFromArray:[wdc enabledWidgetIdentifiersForAllGroups]];
}

-(NSMutableDictionary*)getWidgetNamesForIdentifiers:(NSDictionary*)args {	
	NSMutableDictionary *allIdentifiers = [NSMutableDictionary new];

	for(NSString *identifier in args[@"identifiers"]) {
		NSError *error;
		NSExtension *extension = [NSExtension extensionWithIdentifier:identifier error:&error];

		if (!(error == NULL || error == nil) || extension == NULL || extension == nil) {
			continue;
		}

		WGWidgetInfo *widgetInfo = [[NSClassFromString(@"WGWidgetInfo") alloc] initWithExtension:extension];

		if (widgetInfo == NULL || widgetInfo == nil || [widgetInfo displayName] == NULL || [widgetInfo displayName] == nil) {
			continue;
		}


		WGWidgetHostingViewController *host	= [[_logos_static_class_lookup$WGWidgetHostingViewController() alloc] initWithWidgetInfo:widgetInfo delegate:nil host:nil];

		if (host == NULL || host == nil) {
			continue;
		}

		if(!host.appBundleID) {
			[allIdentifiers setValue:@{@"name":[widgetInfo displayName]} forKey:identifier];
		} else {
			UIImage *image = [UIImage _applicationIconImageForBundleIdentifier:host.appBundleID format:1];
			NSData *dataImage;
			if(image) {
				dataImage = UIImagePNGRepresentation(image);
			}

			if(dataImage) {
				[allIdentifiers setValue:@{@"name":[widgetInfo displayName], @"image": dataImage} forKey:identifier];
			} else {
				[allIdentifiers setValue:@{@"name":[widgetInfo displayName]} forKey:identifier];
			}
		}
	}

	return allIdentifiers;
}
@end
#line 81 "Tweak.xm"
