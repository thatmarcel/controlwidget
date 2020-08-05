#import "Tweak.h"

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


		WGWidgetHostingViewController *host	= [[%c(WGWidgetHostingViewController) alloc] initWithWidgetInfo:widgetInfo delegate:nil host:nil];

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